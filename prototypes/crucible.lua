local quantumCrucible = table.deepcopy(data.raw["storage-tank"]["storage-tank"])

quantumCrucible.name = "qc-quantum-crucible"
quantumCrucible.icons = {
    {
        icon = quantumCrucible.icon,
        icon_size = quantumCrucible.icon_size,
        tint = {r=0,g=0.7,b=0.7,a=0.3}
    },
}
quantumCrucible.fluid_box =
{
    base_area = 10^12,
    height = 10^12,
    pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      { position = {-1, -2} },
      { position = {0, -2} },
      { position = {1, -2} },
      { position = {2, -1} },
      { position = {2, 0} },
      { position = {2, 1} },
      { position = {1, 2} },
      { position = {0, 2} },
      { position = {-1, 2} },
      { position = {-2, -1} },
      { position = {-2, 0} },
      { position = {-2, 1} }
    }
}
quantumCrucible.flags = {"not-rotatable", "not-deconstructable", "not-blueprintable", "not-flammable", "not-upgradable"}
quantumCrucible.minable = nil
quantumCrucible.hide_connection_info = true

local qcInputMachine = table.deepcopy(data.raw["furnace"]["electric-furnace"])
qcInputMachine.name = "qc-crucible-input"
qcInputMachine.allow_copy_paste = false
qcInputMachine.allowed_effects = {}
qcInputMachine.crafting_categories = { "qc-crucible-input" }
qcInputMachine.crafting_speed = 10000
qcInputMachine.energy_source = { type = "void" }
qcInputMachine.energy_usage = "1W"
qcInputMachine.flags = {"not-rotatable", "not-deconstructable", "not-blueprintable", "not-flammable", "not-upgradable"}
qcInputMachine.minable = nil
qcInputMachine.fast_replaceable_group = "crucible-io"
qcInputMachine.fluid_boxes = {
  {
    base_area = 100,
    base_level = -1,
    pipe_connections = {
      {
        position = {
          0,
          -1
        },
        type = "input"
      }
    },
    pipe_covers = {
      east = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      north = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      south = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      west = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      }
    },
    pipe_picture = {
      east = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-E.png",
        height = 38,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-E.png",
          height = 76,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            -0.765625,
            0.03125
          },
          width = 42
        },
        priority = "extra-high",
        shift = {
          -0.78125,
          0.03125
        },
        width = 20
      },
      north = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-N.png",
        height = 18,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-N.png",
          height = 38,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.0703125,
            0.421875
          },
          width = 71
        },
        priority = "extra-high",
        shift = {
          0.078125,
          0.4375
        },
        width = 35
      },
      south = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-S.png",
        height = 31,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-S.png",
          height = 61,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0,
            -0.9765625
          },
          width = 88
        },
        priority = "extra-high",
        shift = {
          0,
          -0.984375
        },
        width = 44
      },
      west = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-W.png",
        height = 37,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-W.png",
          height = 73,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.8046875,
            0.0390625
          },
          width = 39
        },
        priority = "extra-high",
        shift = {
          0.796875,
          0.046875
        },
        width = 19
      }
    },
    production_type = "input",
    secondary_draw_orders = {
      north = -1
    }
  },
  {
    base_area = 100,
    base_level = 1,
    pipe_connections = {
      {
        position = {
          0,
          1
        },
        type = "output"
      }
    },
    pipe_covers = {
      east = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      north = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      south = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      west = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      }
    },
    pipe_picture = {
      east = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-E.png",
        height = 38,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-E.png",
          height = 76,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            -0.765625,
            0.03125
          },
          width = 42
        },
        priority = "extra-high",
        shift = {
          -0.78125,
          0.03125
        },
        width = 20
      },
      north = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-N.png",
        height = 18,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-N.png",
          height = 38,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.0703125,
            0.421875
          },
          width = 71
        },
        priority = "extra-high",
        shift = {
          0.078125,
          0.4375
        },
        width = 35
      },
      south = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-S.png",
        height = 31,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-S.png",
          height = 61,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0,
            -0.9765625
          },
          width = 88
        },
        priority = "extra-high",
        shift = {
          0,
          -0.984375
        },
        width = 44
      },
      west = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-W.png",
        height = 37,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-W.png",
          height = 73,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.8046875,
            0.0390625
          },
          width = 39
        },
        priority = "extra-high",
        shift = {
          0.796875,
          0.046875
        },
        width = 19
      }
    },
    production_type = "output",
    secondary_draw_orders = {
      north = -1
    }
  },
}
qcInputMachine.module_specification = {}
qcInputMachine.tile_width = 1
qcInputMachine.tile_height = 1
qcInputMachine.collision_box = {
    {
      -0.35,
      -0.35
    },
    {
      0.35,
      0.35
    }
  }
qcInputMachine.selection_box = {
    {
      -0.5,
      -0.5
    },
    {
      0.5,
      0.5
    }
  }
qcInputMachine.next_upgrade = nil
qcInputMachine.animation = {
  layers =
  {
    {
      filename = "__base__/graphics/entity/logistic-chest/logistic-chest-requester.png",
      priority = "extra-high",
      width = 34,
      height = 38,
      frame_count = 7,
      shift = util.by_pixel(0, -2),
      hr_version =
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-requester.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/logistic-chest/logistic-chest-shadow.png",
      priority = "extra-high",
      width = 56,
      height = 24,
      repeat_count = 7,
      shift = util.by_pixel(12, 5),
      draw_as_shadow = true,
      hr_version =
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        repeat_count = 7,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}


local qcOutputMachine = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
qcOutputMachine.name = "qc-crucible-output"
qcOutputMachine.allowed_effects = {}
qcOutputMachine.crafting_categories = { "qc-crucible-output" }
qcOutputMachine.crafting_speed = 10000
qcOutputMachine.energy_source = { type = "void" }
qcOutputMachine.energy_usage = "1W"
qcOutputMachine.flags = {"not-rotatable"
                        , "not-deconstructable"
                        , "not-blueprintable"
                        , "not-flammable"
                        , "not-upgradable"}
qcOutputMachine.minable = nil
qcOutputMachine.fast_replaceable_group = "crucible-io"
qcOutputMachine.fluid_boxes = {
  {
    base_area = 10,
    base_level = -1,
    pipe_connections = {
      {
        position = {
          0,
          1
        },
        type = "input"
      }
    },
    pipe_covers = {
      east = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      north = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      south = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      west = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      }
    },
    pipe_picture = {
      east = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-E.png",
        height = 38,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-E.png",
          height = 76,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            -0.765625,
            0.03125
          },
          width = 42
        },
        priority = "extra-high",
        shift = {
          -0.78125,
          0.03125
        },
        width = 20
      },
      north = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-N.png",
        height = 18,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-N.png",
          height = 38,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.0703125,
            0.421875
          },
          width = 71
        },
        priority = "extra-high",
        shift = {
          0.078125,
          0.4375
        },
        width = 35
      },
      south = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-S.png",
        height = 31,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-S.png",
          height = 61,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0,
            -0.9765625
          },
          width = 88
        },
        priority = "extra-high",
        shift = {
          0,
          -0.984375
        },
        width = 44
      },
      west = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-W.png",
        height = 37,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-W.png",
          height = 73,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.8046875,
            0.0390625
          },
          width = 39
        },
        priority = "extra-high",
        shift = {
          0.796875,
          0.046875
        },
        width = 19
      }
    },
    production_type = "input",
    secondary_draw_orders = {
      north = -1
    }
  },
  {
    base_area = 100,
    base_level = 1,
    pipe_connections = {
      {
        position = {
          0,
          -1
        },
        type = "output"
      }
    },
    pipe_covers = {
      east = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      north = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      south = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      },
      west = {
        layers = {
          {
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west.png",
            height = 64,
            hr_version = {
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          },
          {
            draw_as_shadow = true,
            filename = "__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png",
            height = 64,
            hr_version = {
              draw_as_shadow = true,
              filename = "__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png",
              height = 128,
              priority = "extra-high",
              scale = 0.5,
              width = 128
            },
            priority = "extra-high",
            width = 64
          }
        }
      }
    },
    pipe_picture = {
      east = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-E.png",
        height = 38,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-E.png",
          height = 76,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            -0.765625,
            0.03125
          },
          width = 42
        },
        priority = "extra-high",
        shift = {
          -0.78125,
          0.03125
        },
        width = 20
      },
      north = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-N.png",
        height = 18,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-N.png",
          height = 38,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.0703125,
            0.421875
          },
          width = 71
        },
        priority = "extra-high",
        shift = {
          0.078125,
          0.4375
        },
        width = 35
      },
      south = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-S.png",
        height = 31,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-S.png",
          height = 61,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0,
            -0.9765625
          },
          width = 88
        },
        priority = "extra-high",
        shift = {
          0,
          -0.984375
        },
        width = 44
      },
      west = {
        filename = "__base__/graphics/entity/assembling-machine-2/assembling-machine-2-pipe-W.png",
        height = 37,
        hr_version = {
          filename = "__base__/graphics/entity/assembling-machine-2/hr-assembling-machine-2-pipe-W.png",
          height = 73,
          priority = "extra-high",
          scale = 0.5,
          shift = {
            0.8046875,
            0.0390625
          },
          width = 39
        },
        priority = "extra-high",
        shift = {
          0.796875,
          0.046875
        },
        width = 19
      }
    },
    production_type = "output",
    secondary_draw_orders = {
      north = -1
    }
  },
}
qcOutputMachine.module_specification = {}
qcOutputMachine.tile_width = 1
qcOutputMachine.tile_height = 1
qcOutputMachine.collision_box = {
    {
      -0.35,
      -0.35
    },
    {
      0.35,
      0.35
    }
  }
qcOutputMachine.selection_box = {
    {
      -0.5,
      -0.5
    },
    {
      0.5,
      0.5
    }
  }
qcOutputMachine.next_upgrade = nil
qcOutputMachine.animation = {
  layers =
  {
    {
      filename = "__base__/graphics/entity/logistic-chest/logistic-chest-passive-provider.png",
      priority = "extra-high",
      width = 34,
      height = 38,
      frame_count = 7,
      shift = util.by_pixel(0, -2),
      hr_version =
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-passive-provider.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        frame_count = 7,
        shift = util.by_pixel(0, -2),
        scale = 0.5
      }
    },
    {
      filename = "__base__/graphics/entity/logistic-chest/logistic-chest-shadow.png",
      priority = "extra-high",
      width = 56,
      height = 24,
      repeat_count = 7,
      shift = util.by_pixel(12, 5),
      draw_as_shadow = true,
      hr_version =
      {
        filename = "__base__/graphics/entity/logistic-chest/hr-logistic-chest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        repeat_count = 7,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}


data:extend{qcInputMachine
, qcOutputMachine
, quantumCrucible
}