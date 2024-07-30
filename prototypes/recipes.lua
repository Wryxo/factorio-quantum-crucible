-- Setup Kvantum and recipe to make kvantum out of kvantum
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
  auto_barrel = false,
  name = "kvantum",
  order = "a[fluid]-a[kvantum]",
  type = "fluid"
}

data:extend{kvantumPrototype}

local kvantumToKvantum =
{
  type = "recipe",
  name = "qc-input-kvantum",
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
    {type = "fluid", name = "kvantum", amount = 1, catalyst_amount = 1},
  },
  results=
  {
    {type = "fluid", name = "kvantum", amount = 1, catalyst_amount = 1},
  }
}

data:extend({kvantumToKvantum})


-- Setup kvantum recipes for raw resources
local kvantumCosts = {}

-- Recreate all recipes with kvantum as ingredient

local recipeTechnologyModifiers = {}

local function calculateRecipeTechnologyModifiers(technologies)
  for _, t in pairs(technologies) do
    local unlocksRecipes = {}

    if t.effects == nil then
      goto continue
    end

    for _, e in pairs(t.effects) do
      if e.type == "unlock-recipe" then
        table.insert(unlocksRecipes, e.recipe)
      end
    end

    if #unlocksRecipes == 0 then
      goto continue
    end

    for _, r in pairs(unlocksRecipes) do
      if recipeTechnologyModifiers[r] == nil then
        recipeTechnologyModifiers[r] = {
          technology = t.name,
          modifier = (t.prerequisites and (#t.unit.ingredients * #t.prerequisites)) or #t.unit.ingredients
        }
      end
    end

    ::continue::
  end
end


local function generate_crucible_output_recipe(ingType, ingName, ingAmount, resType, resName, resAmount, enabled)
  local recipe =
  {
    type = "recipe",
    name = "qc-output-" .. resName,
    category = "qc-crucible-output",
    energy_required = 0.002,
    enabled = enabled,
    hide_from_player_crafting = true,
    ingredients =
    {
      {type = ingType, name = ingName, amount = ingAmount},
    },
    results=
    {
      {type = resType, name = resName, amount = resAmount},
    }
  }

  data:extend({recipe})
  return recipe
end

local function generate_crucible_input_recipe(ingType, ingName, ingAmount, resType, resName, resAmount, enabled)
  local recipe =
  {
    type = "recipe",
    name = "qc-input-" .. ingName,
    category = "qc-crucible-input",
    energy_required = 0.002,
    enabled = enabled,
    hide_from_player_crafting = true,
    ingredients =
    {
      {type = ingType, name = ingName, amount = ingAmount}
    },
    results=
    {
      {type = resType, name = resName, amount = resAmount},
    }
  }

  data:extend({recipe})
  return recipe
end

local function getProducts(recipe)
  local result = {}
  if recipe.normal ~= nil then
    recipe.result = recipe.normal.result
    recipe.results = recipe.normal.results
  end
  if recipe.results == nil then
    if recipe.result == nil then
      return result
    end

    table.insert(result, {
      name = recipe.result,
      count = recipe.result_count or 1,
      type = "item"
    })
    return result
  end

  for _, r in pairs(recipe.results) do
    if r.name ~= nil then
      table.insert(result, {
        name = r.name,
        count = (r.probability and r.amount*r.probability) or r.amount,
        type = r.type
      })
    else
      table.insert(result, {
        name = r[1],
        count = r[2],
        type = "item"
      })
    end
  end
  return result
end

local function getRecipe(item)
  if data.raw.recipe[item] ~= nil then
    return data.raw.recipe[item]
  end

  for _, r in pairs(data.raw.recipe) do
    if r.results == nil then
      goto continue
    end

    for _, result in pairs(r.results) do
      if result.name == item then
        return r
      end
    end

    ::continue::
  end
end

local function generate_crucible_recipe(recipe)
  local products = getProducts(recipe)
  
  for _, product in pairs(products) do
    if recipe.normal ~= nil then
      recipe.ingredients = recipe.normal.ingredients
      recipe.enabled = recipe.normal.enabled
      recipe.energy_required = recipe.normal.enabled
    end

    local costMultiplier = (1 / product.count) * (recipe.energy_required or 1)
    local cost = 0

    if kvantumCosts[product.name] ~= nil then
      kvantumAmount = kvantumCosts[product.name]
      goto continue
    end
  
    
    for _, i in pairs(recipe.ingredients) do
      if i.name == nil then
        i.name = i[1]
        i.amount = i[2]
      end
      if kvantumCosts[i.name] == nil then
        generate_crucible_recipe(getRecipe(i.name))
      end
      cost = cost + (kvantumCosts[i.name]* i.amount)
    end
    kvantumAmount = cost * costMultiplier * ((recipeTechnologyModifiers[recipe.name] and recipeTechnologyModifiers[recipe.name].modifier) or 1)
    kvantumCosts[product.name] = kvantumAmount
    ::continue::

    local outputRecipe = generate_crucible_output_recipe(kvantumPrototype.type, kvantumPrototype.name, kvantumAmount, product.type, product.name, 1, recipe.enabled)
    local inputRecipe = generate_crucible_input_recipe(product.type, product.name, 1, kvantumPrototype.type, kvantumPrototype.name, kvantumAmount, recipe.enabled)

    local recipeModifier = recipeTechnologyModifiers[recipe.name]
    if recipeModifier ~= nil then
      table.insert(data.raw.technology[recipeModifier.technology].effects, {
        type = "unlock-recipe",
        recipe = outputRecipe.name
      })
      table.insert(data.raw.technology[recipeModifier.technology].effects, {
        type = "unlock-recipe",
        recipe = inputRecipe.name
      })
    end
  end
end

local function generateBaseResources()
  generate_crucible_recipe({
    type = "recipe",
    name = "water",
    enabled = true,
    ingredients =
    {
      {"kvantum", 6},
    },
    results = {{type="fluid", name="water", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "raw-fish",
    enabled = true,
    ingredients =
    {
      {"kvantum", 12},
    },
    results = {{type="item", name="raw-fish", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "wood",
    enabled = true,
    ingredients =
    {
      {"kvantum", 12},
    },
    results = {{type="item", name="wood", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "steam",
    enabled = true,
    ingredients =
    {
      {"kvantum", 24},
    },
    results = {{type="fluid", name="steam", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "stone",
    enabled = true,
    ingredients =
    {
      {"kvantum", 24},
    },
    results = {{type="item", name="stone", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "iron-ore",
    enabled = true,
    ingredients =
    {
      {"kvantum", 24},
    },
    results = {{type="item", name="iron-ore", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "copper-ore",
    enabled = true,
    ingredients =
    {
      {"kvantum", 24},
    },
    results = {{type="item", name="copper-ore", amount=1}}
  })
  generate_crucible_recipe({
    type = "recipe",
    name = "coal",
    enabled = true,
    ingredients =
    {
      {"kvantum", 64},
    },
    results = {{type="item", name="coal", amount=1}}
  })
  recipeTechnologyModifiers["crude-oil"] = {
    technology = "oil-processing",
    modifier = 2
  }
  generate_crucible_recipe({
    type = "recipe",
    name = "crude-oil",
    enabled = false,
    ingredients =
    {
      {"kvantum", 128},
    },
    results = {{type="fluid", name="crude-oil", amount=1}}
  })
  recipeTechnologyModifiers["uranium-ore"] = {
    technology = "uranium-processing",
    modifier = 6
  }
  generate_crucible_recipe({
    type = "recipe",
    name = "uranium-ore",
    enabled = false,
    ingredients =
    {
      {"kvantum", 256},
    },
    results = {{type="item", name="uranium-ore", amount=1}}
  })
  recipeTechnologyModifiers["used-up-uranium-fuel-cell"] = {
    technology = "nuclear-power",
    modifier = 3
  }
  generate_crucible_recipe({
    type = "recipe",
    name = "used-up-uranium-fuel-cell",
    enabled = false,
    ingredients =
    {
      {"kvantum", 512},
    },
    results = {{type="item", name="used-up-uranium-fuel-cell", amount=1}}
  })
end

local function generate_crucible_recipes(recipes)
  if not recipes then
    return
  end

  kvantumCosts["kvantum"] = 1
  generateBaseResources()

  for _, recipe in pairs(recipes) do
    if recipe.name ~= "electric-energy-interface" then
      generate_crucible_recipe(recipe)
    end
  end
end

calculateRecipeTechnologyModifiers(data.raw["technology"])
generate_crucible_recipes(data.raw["recipe"])
