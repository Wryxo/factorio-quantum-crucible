local kvantumPrototype = {
  base_color = {
    b = 0.6,
    g = 0,
    r = 0.34000000000000004
  },
  default_temperature = 42,
  flow_color = {
    b = 0.7,
    g = 0.7,
    r = 0.7
  },
  heat_capacity = "0.2KJ",
  icon = "__qc-quantum-crucible__/graphics/icons/kvantum.png",
  icon_mipmaps = 4,
  icon_size = 64,
  max_temperature = 42,
  name = "kvantum",
  order = "a[fluid]-a[kvantum]",
  type = "fluid"
}

data:extend{kvantumPrototype}

local function generate_crucible_create_recipe(item, fluid, amount)
  local recipe =
  {
    type = "recipe",
    name = "qc-create-" .. item.name,
    -- localised_name = {"recipe-name.fill-barrel", fluid.localised_name or {"fluid-name." .. fluid.name}},
    category = "qc-crucible-output",
    energy_required = 0.002,
    -- subgroup = "fill-barrel",
    -- order = "b[fill-" .. item.name .. "]",
    enabled = true,
    hide_from_player_crafting = true,
    -- icons = generate_barrel_recipe_icons(fluid, barrel_fill_icon, barrel_fill_side_mask, barrel_fill_top_mask, {-8, -8}),
    -- icon_size = 64, icon_mipmaps = 4,
    ingredients =
    {
      {type = "fluid", name = fluid.name, amount = amount, catalyst_amount = amount},
    },
    results=
    {
      {type = "item", name = item.name, amount = 1, catalyst_amount = 1}
    }
  }

  data:extend({recipe})
  return recipe
end

local function generate_crucible_destroy_recipe(item, fluid, amount)
  local recipe =
  {
    type = "recipe",
    name = "qc-destroy-" .. item.name,
    -- localised_name = {"recipe-name.empty-filled-barrel", fluid.localised_name or {"fluid-name." .. fluid.name}},
    category = "qc-crucible-input",
    energy_required = 0.002,
    -- subgroup = "empty-barrel",
    -- order = "c[empty-" .. item.name .. "]",
    enabled = true,
    hide_from_player_crafting = true,
    -- icons = generate_barrel_recipe_icons(fluid, barrel_empty_icon, barrel_empty_side_mask, barrel_empty_top_mask, {7, 8}),
    -- icon_size = 64, icon_mipmaps = 4,
    ingredients =
    {
      {type = "item", name = item.name, amount = 1, catalyst_amount = 1}
    },
    results=
    {
      {type = "fluid", name = fluid.name, amount = amount, catalyst_amount = amount},
    }
  }

  data:extend({recipe})
  return recipe
end

local function generate_crucible_recipes(items)
  if not items then
    return
  end

  for _, item in pairs(items) do
    generate_crucible_create_recipe(item, kvantumPrototype, 1)
    generate_crucible_destroy_recipe(item, kvantumPrototype, 1)
  end
end

generate_crucible_recipes(data.raw["item"])
