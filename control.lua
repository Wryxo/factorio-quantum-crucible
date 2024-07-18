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
  local formatted, k = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted..suffix
end

script.on_init(function()
  local freeplay = remote.interfaces["freeplay"]
  if freeplay then  -- Disable freeplay popup-message
      if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
      if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
  end

  game.forces["player"].technologies["quantum-slots"].researched = true
  global.crucible = game.surfaces[1].create_entity{
      name = "qc-quantum-crucible", position = {5, 10},
      force = game.forces["player"]
    }

  global.crucibleInput = game.surfaces[1].create_entity{
      name = "qc-crucible-input", position = {3, 10}, direction = defines.direction.west,
      force = game.forces["player"]
  }

  global.crucibleOutput = game.surfaces[1].create_entity{
      name = "qc-crucible-output", position = {7, 10}, direction = defines.direction.east,
      force = game.forces["player"], recipe="qc-create-wood"
  }

  global.crucibleRoboport = game.surfaces[1].create_entity{
    name = "roboport", position = {10, 10}, direction = defines.direction.east,
    force = game.forces["player"]
  }

  global.crucible.insert_fluid({name="kvantum", amount="10000"})
end)

local function update_crucible_amount()
  for _, player in pairs(game.connected_players) do
    local progressbar = player.gui.top.kvantumBar
    local current = global.crucible.get_fluid_count("kvantum")
    local max = global.crucible.fluidbox.get_capacity(1)
    progressbar.caption = "Kvantum: " .. format_number(current,true,10^6) .. " / " .. format_number(max, true, 0)
    progressbar.value = current / max
  end
end

local function check_logistic_slots(index, slots, recipes)
  local player = game.players[index]
  -- log(serpent.block(recipes))
  for _, slot in pairs(slots) do
    
    local itemCount = player.get_item_count(slot.name)
    if itemCount >= slot.min then
      goto continue
    end

    local missingCount = slot.min - itemCount
    local recipeKvantum = player.force.recipes["qc-destroy-" .. slot.name].ingredients[1].amount
    local requiredKvantum =  recipeKvantum * missingCount
    local availableKvantum = global.crucible.get_fluid_count("kvantum")
    if requiredKvantum > availableKvantum then
      missingCount = math.floor(availableKvantum / recipeKvantum)
    end

    local insertedItems = player.insert({name=slot.name, count=missingCount})
    requiredKvantum = recipeKvantum * insertedItems
    if requiredKvantum > 0 then
      global.crucible.remove_fluid{name = "kvantum", amount = requiredKvantum}
    end
    ::continue::
  end
end

script.on_event(defines.events.on_player_created, function(event)
    local player = game.players[event.player_index]
    global.players = global.players or {}
    global.players[event.player_index] = { interesting_logistic_slots = {}}
    player.insert({name="wood", amount="100"})

    local progressbar = player.gui.top.add{type="progressbar", name="kvantumBar"}
    progressbar.style.bar_width = 30
    progressbar.style.color = {r=0.7, g=0, b=0.7, a=0.3}
    local current = global.crucible.get_fluid_count("kvantum")
    local max = global.crucible.fluidbox.get_capacity(1)
    progressbar.caption = "Kvantum: " .. format_number(current,true,10^6) .. " / " .. format_number(max, true, 0)
    progressbar.value = current / max
end)

script.on_event(defines.events.on_tick, function(event)
  update_crucible_amount()

  -- local recipes = game.get_filtered_recipe_prototypes({{filter = "category", category="qc-crucible-output"}})
  for index, player in pairs(global.players) do
    if (event.tick + index) % 60 == 0 then
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
  local trashInv = player.get_inventory(defines.inventory.character_trash)
  local items = trashInv.get_contents()
  if table_size(items) == 0 then
    return
  end
  local kvantumGained = 0
  for name, count in pairs(items) do
    kvantumGained = kvantumGained + (player.force.recipes["qc-destroy-" .. name].products[1].amount * count)
  end
  trashInv.clear()
  
  if kvantumGained > 0 then
    global.crucible.insert_fluid({name="kvantum", amount=kvantumGained})
  end
end)