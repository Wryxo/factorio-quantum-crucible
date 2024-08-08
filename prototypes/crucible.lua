local qcQuantumCrucible = table.deepcopy(data.raw["roboport"]["roboport"])

qcQuantumCrucible.name = "qc-quantum-crucible"
qcQuantumCrucible.icons = {
    {
        icon = qcQuantumCrucible.icon,
        icon_size = qcQuantumCrucible.icon_size,
        tint = {r=0,g=0.7,b=0.7,a=0.3}
    },
}
qcQuantumCrucible.minable = nil
qcQuantumCrucible.flags = {"placeable-player", "not-deconstructable", "not-blueprintable", "not-flammable", "not-upgradable", "player-creation"}
qcQuantumCrucible.collision_box = {{-1.3, -1.3}, {1.3, 1.3}}
qcQuantumCrucible.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
qcQuantumCrucible.energy_source = { type = "void" }
qcQuantumCrucible.recharge_minimum = "0MJ"
qcQuantumCrucible.energy_usage = "0kW"
qcQuantumCrucible.charging_energy = "0kW"
qcQuantumCrucible.logistics_radius = 10
qcQuantumCrucible.construction_radius = 0
qcQuantumCrucible.robot_slots_count = 0
qcQuantumCrucible.material_slots_count = 0

local qcCrucibleIO = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
qcCrucibleIO.name = "qc-quantum-crucible-io"
qcCrucibleIO.render_not_in_network_icon = false
qcCrucibleIO.minable = nil
qcCrucibleIO.flags = {"placeable-player", "not-deconstructable", "not-blueprintable", "not-flammable", "not-upgradable", "player-creation"}
qcCrucibleIO.max_logistic_slots = 10


data:extend{qcCrucibleIO
, qcQuantumCrucible
}