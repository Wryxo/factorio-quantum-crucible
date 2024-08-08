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

data:extend{{ type = "recipe-category", name = "qc-crucible-input" }
, { type = "recipe-category", name = "qc-crucible-output" }}

local quantum_slots = {
    effects = {
      {
        modifier = true,
        type = "character-logistic-requests"
      },
      {
        modifier = 30,
        type = "character-logistic-trash-slots"
      }
    },
    icon = "__base__/graphics/technology/logistic-robotics.png",
    icon_mipmaps = 4,
    icon_size = 256,
    name = "quantum-slots",
    order = "c-k-c",
    prerequisites = {
      "robotics"
    },
    type = "technology",
    unit = {
      count = 1,
      ingredients = {
        {
          "automation-science-pack",
          1
        },
        {
          "logistic-science-pack",
          1
        },
        {
          "chemical-science-pack",
          1
        }
      },
      time = 1
    }
  }

data:extend{quantum_slots}

data:extend{{
  type                = 'custom-input'    ,
  name                = 'qc-flip-io-key'  ,
  linked_game_control = 'rotate'          ,
  key_sequence        = ''                ,
  consuming           =  nil              , 
}}