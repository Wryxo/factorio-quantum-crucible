require "util"

function format_number(amount, append_suffix, minimum)
  local suffix = ""
  if append_suffix and amount >= minimum then
    local suffix_list =
      {
          Y = 10^24,
          Z = 10^21,
          E = 10^18,
          P = 10^15,
          T = 10^12,
          G = 10^9,
          M = 10^6,
          K = 10^3
      }
    for letter, limit in pairs (suffix_list) do
      if math.abs(amount) >= limit then
        amount = math.floor(amount/(limit/10))/10
        suffix = letter
        break
      end
    end
  end
  local formatted, k = math.floor(amount)
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted..suffix
end

local crucible_io_positions = {
    { name = "dnw", position = {-2, -2} },
    { name = "nw", position = {-1, -2} },
    { name = "n", position = {0, -2} },
    { name = "ne", position = {1, -2} },
    { name = "dne", position = {2, -2} },
    { name = "en", position = {2, -1} },
    { name = "e", position = {2, 0} },
    { name = "es", position = {2, 1} },
    { name = "dse", position = {2, 2} },
    { name = "se", position = {1, 2} },
    { name = "s", position = {0, 2} },
    { name = "sw", position = {-1, 2} },
    { name = "dsw", position = {-2, 2} },
    { name = "ws", position = {-2, 1} },
    { name = "w", position = {-2, 0} },
    { name = "wn", position = {-2, -1} }
}

local function build_crucible_io(x, y, pos)
    return game.surfaces[1].create_entity{
    name = "qc-quantum-crucible-io", position = {x + pos.position[1], y + pos.position[2]}, 
    force = game.forces["player"]
    }
end

local function build_crucible(x, y, kvantum)
  local crucibleRoboport = game.surfaces[1].create_entity{
    name = "qc-quantum-crucible", position = {x, y}, direction = defines.direction.east,
    force = game.forces["player"]
  }

  local crucibleInfo = {
    position = {x, y},
    crucible = crucibleRoboport,
    io = {}
  }

  for _, pos in pairs(crucible_io_positions) do
    crucibleInfo['io'][pos.name] = build_crucible_io(x, y, pos)
  end

  return crucibleInfo
end

script.on_init(function()
  local freeplay = remote.interfaces["freeplay"]
  if freeplay then  -- Disable freeplay popup-message
      if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
      if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
  end

  game.forces["player"].technologies["quantum-slots"].researched = true
  global.kvantum = 10000
  global.kvantum_max = 10^9

  global.crucibles = {}
  table.insert(global.crucibles, build_crucible(10, 10))
end)

local function update_crucible_amount()
  for _, player in pairs(game.connected_players) do
    local progressbar = player.gui.top.kvantumBar
    local current = global.kvantum
    local max = global.kvantum_max
    -- progressbar.caption = "Kvantum: " .. format_number(current,true,10^6) .. " / " .. format_number(max, true, 0)
    progressbar.caption = format_number(current,true,10^6)
    progressbar.value = current / max
  end
end

local function is_within_crucible_range(player)
  if global.crucibles then
    for _, crucible in pairs(global.crucibles) do
      for _, point in pairs(crucible.crucible.logistic_network.provider_points) do
        if point.logistic_member_index > 0  then
          if point.owner.player == player then
            return true
          end
        end
      end
    end
  end

  return false
end

local function check_logistic_slots(index, slots, recipes)
  local player = game.players[index]
  if not player.character_personal_logistic_requests_enabled or not is_within_crucible_range(player) then
    return
  end
  for _, slot in pairs(slots) do
    
    local itemCount = player.get_item_count(slot.name)
    if itemCount >= slot.min then
      goto continue
    end

    if player.force.recipes[slot.name] and not player.force.recipes[slot.name].enabled then
      goto continue
    end

    local missingCount = slot.min - itemCount
    local recipeKvantum = player.force.recipes["qc-output-" .. slot.name].ingredients[1].amount
    local requiredKvantum =  recipeKvantum * missingCount
    if requiredKvantum > global.kvantum then
      missingCount = math.floor(global.kvantum / recipeKvantum)
    end

    if missingCount > 0 then
      local insertedItems = player.insert({name=slot.name, count=missingCount})
      requiredKvantum = recipeKvantum * insertedItems
      if requiredKvantum > 0 then
        global.kvantum = global.kvantum - requiredKvantum
      end
    end
    ::continue::
  end
end

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    global.players = global.players or {}
    global.players[event.player_index] = { interesting_logistic_slots = {}}

    local progressbar = player.gui.top.add{type="progressbar", name="kvantumBar"}
    progressbar.style.horizontal_align = "center"
    progressbar.style.bar_width = 30
    progressbar.style.color = {r=0.7, g=0, b=0.7, a=0.3}
    local current = global.kvantum
    local max = global.kvantum_max
    progressbar.caption = format_number(current,true,10^6)
    progressbar.value = current / max 
end)

script.on_event(defines.events.on_tick, function(event)
  update_crucible_amount()

  for index, player in pairs(global.players) do
    if (event.tick + index) % 10 == 0 then
      check_logistic_slots(index, player.interesting_logistic_slots, game.recipe_prototypes)
    end
  end
end)

script.on_event(defines.events.on_entity_logistic_slot_changed, function(event)
  if event.entity.player == nil then
    return
  end
  local playerIndex = event.player_index or event.entity.player.player_index

  local playerInfo = global.players[playerIndex]
  if playerInfo == nil then
    global.players[entity.player.player_index] = { interesting_logistic_slots = {}}
  end

  local slotInfo = event.entity.get_personal_logistic_slot(event.slot_index)
  if slotInfo.name == nil then
    playerInfo.interesting_logistic_slots[event.slot_index] = nil
  else
    game.print("Changed slot: " .. event.slot_index .. " with item " .. slotInfo.name)
    playerInfo.interesting_logistic_slots[event.slot_index] = {
      name = slotInfo.name,
      min = slotInfo.min
    }
  end
end)

script.on_event(defines.events.on_player_trash_inventory_changed, function(event)
  local player = game.players[event.player_index]
  if not player.character_personal_logistic_requests_enabled or not is_within_crucible_range(player) then
    return
  end
  local trashInv = player.get_inventory(defines.inventory.character_trash)
  local items = trashInv.get_contents()
  if table_size(items) == 0 then
    return
  end
  local kvantumGained = 0
  for name, count in pairs(items) do
    kvantumGained = kvantumGained + (player.force.recipes["qc-input-" .. name].products[1].amount * count)
  end
  trashInv.clear()
  
  if kvantumGained > 0 then
    global.kvantum = global.kvantum + kvantumGained
  end
end)