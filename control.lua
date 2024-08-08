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
    { name = "nw", position = {-1, -2} },
    { name = "n", position = {0, -2} },
    { name = "ne", position = {1, -2} },
    { name = "en", position = {2, -1} },
    { name = "e", position = {2, 0} },
    { name = "es", position = {2, 1} },
    { name = "se", position = {1, 2} },
    { name = "s", position = {0, 2} },
    { name = "sw", position = {-1, 2} },
    { name = "ws", position = {-2, 1} },
    { name = "w", position = {-2, 0} },
    { name = "wn", position = {-2, -1} }
}

local function build_crucible_io(x, y, pos, io_type)
  local capital_direction = pos.name:sub(1,1)
  local direction = defines.direction.west
  if capital_direction == "n" then
    direction = defines.direction.north
  elseif capital_direction == "e" then
    direction = defines.direction.east
  elseif capital_direction == "s" then
    direction = defines.direction.south
  end

    return game.surfaces[1].create_entity{
    name = "qc-crucible-" .. io_type, position = {x + pos.position[1], y + pos.position[2]}, direction = direction,
    force = game.forces["player"]
    }
end

local function build_crucible(x, y, kvantum)
  local crucible = game.surfaces[1].create_entity{
    name = "qc-quantum-crucible", position = {x, y},
    force = game.forces["player"]
  }
  crucible.insert_fluid({name="kvantum", amount=kvantum})
  local crucibleInfo = {
    position = {x, y},
    crucible = crucible
  }

  next_input = true
  for _, pos in pairs(crucible_io_positions) do
    io_type = next_input and "input" or "output"
    crucibleInfo[pos.name] = build_crucible_io(x, y, pos, io_type)
    next_input = not next_input
  end

  return crucibleInfo

  -- global.crucibleRoboport = game.surfaces[1].create_entity{
  --   name = "roboport", position = {5, 10}, direction = defines.direction.east,
  --   force = game.forces["player"]
  -- }
end

script.on_init(function()
  local freeplay = remote.interfaces["freeplay"]
  if freeplay then  -- Disable freeplay popup-message
      if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
      if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
  end

  game.forces["player"].technologies["quantum-slots"].researched = true
  global.crucibles = {}
  table.insert(global.crucibles, build_crucible(10, 10, 10000))
end)

local kvantumInventories = {
  defines.inventory.assembling_machine_input,
  defines.inventory.furnace_result
}
local itemInventories = {
  defines.inventory.assembling_machine_output,
  defines.inventory.furnace_source
}

script.on_event('qc-flip-io-key',function(e)
  local p = game.players[e.player_index]
  local selected_entity = p.selected
  if selected_entity and (selected_entity.name == 'qc-crucible-input' or selected_entity.name == 'qc-crucible-output') then
    local nearest_distance = 10^16
    local nearest_crucible = nil
    for _, c in pairs(global.crucibles) do
      if util.distance(c.position, selected_entity.position) < nearest_distance then
        nearest_crucible = c 
      end
    end

    local diffPosition = {selected_entity.position['x'] - nearest_crucible.position[1] - 0.5, selected_entity.position['y'] - nearest_crucible.position[2] - 0.5}
    local direction = ""

    for _, pos in pairs(crucible_io_positions) do
      if pos.position[1] == diffPosition[1] then
        if pos.position[2] == diffPosition[2] then
          local p = game.players[e.player_index]
          for _, i in pairs(itemInventories) do
            local inventory = selected_entity.get_inventory(i)
            if inventory ~= nil then
              local contents = inventory.get_contents()
              for item, amount in pairs(contents) do
                p.insert({name=item, count=amount})
              end
            end
          end
          local kvantumGained = selected_entity.get_fluid_count("kvantum")
          if kvantumGained > 0 then
            nearest_crucible.crucible.insert_fluid({name="kvantum", amount=kvantumGained})
          end

          local iotype = selected_entity.name == 'qc-crucible-input' and "output" or "input"
          selected_entity.destroy()
          nearest_crucible[direction] = build_crucible_io(nearest_crucible.position[1], nearest_crucible.position[2], pos, iotype)
        end
      end
    end
    nearest_crucible.crucible.update_connections()
  end
end)

local function update_crucible_amount()
  for _, player in pairs(game.connected_players) do
    local progressbar = player.gui.top.kvantumBar
    local current = global.crucibles[1].crucible.get_fluid_count("kvantum")
    local max = global.crucibles[1].crucible.fluidbox.get_capacity(1)
    -- progressbar.caption = "Kvantum: " .. format_number(current,true,10^6) .. " / " .. format_number(max, true, 0)
    progressbar.caption = format_number(current,true,10^6)
    progressbar.value = current / max
  end
end

local function check_logistic_slots(index, slots, recipes)
  local player = game.players[index]
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
    local availableKvantum = global.crucibles[1].crucible.get_fluid_count("kvantum")
    if requiredKvantum > availableKvantum then
      missingCount = math.floor(availableKvantum / recipeKvantum)
    end

    if missingCount > 0 then
      local insertedItems = player.insert({name=slot.name, count=missingCount})
      requiredKvantum = recipeKvantum * insertedItems
      if requiredKvantum > 0 then
        global.crucibles[1].crucible.remove_fluid{name = "kvantum", amount = requiredKvantum}
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
    progressbar.style.bar_width = 30
    progressbar.style.color = {r=0.7, g=0, b=0.7, a=0.3}
    local current = global.crucibles[1].crucible.get_fluid_count("kvantum")
    local max = global.crucibles[1].crucible.fluidbox.get_capacity(1)
    -- progressbar.caption = "Kvantum: " .. format_number(current,true,10^6) .. " / " .. format_number(max, true, 0)
    progressbar.caption = format_number(current,true,10^6)
    progressbar.value = current / max
  --   local list = {}
  --   for _, recipe in pairs(player.force.recipes) do
  --     if recipe.hidden == false then
  --         list[#list+1] = {
  --             name=recipe.name,
  --             products=recipe.products,
  --             ingredients=recipe.ingredients,
  --             group=recipe.group,
  --             subgroup=recipe.subgroup,
  --             order=recipe.order,
  --             energy=recipe.energy
  --         }
  --     end
  --   end
  -- game.write_file("recipes.json", game.table_to_json(list))
  
end)

script.on_event(defines.events.on_tick, function(event)
  update_crucible_amount()

  -- local recipes = game.get_filtered_recipe_prototypes({{filter = "category", category="qc-crucible-output"}})
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
    global.crucibles[1].crucible.insert_fluid({name="kvantum", amount=kvantumGained})
  end
end)