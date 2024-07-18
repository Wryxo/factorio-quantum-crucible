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