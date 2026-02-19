require "Sandbox/SandboxOptions"

local function loadRB42SandboxOptions()
    -- Register a new group for the Rollerblades mod
    SandboxOptions.new("RB42", "Rollerblades42", "Sandbox_RB42_EN")

    -- Speed Options
    SandboxOptions.addOption("RB42", "SpeedHard", 1.5, 0.5, 3.0, 0.05)
    SandboxOptions.addOption("RB42", "SpeedSoft", 0.75, 0.1, 2.0, 0.05)
    SandboxOptions.addOption("RB42", "SpeedStairs", 0.3, 0.05, 1.0, 0.01)
    SandboxOptions.addOption("RB42", "SpeedBlocked", 0.3, 0.05, 1.0, 0.01)

    -- Fall/Trip Options
    SandboxOptions.addOption("RB42", "FallChanceStairs", 2.0, 0.0, 10.0, 0.1)
    SandboxOptions.addOption("RB42", "FallChanceAttack", 10, 0, 50, 1)
    SandboxOptions.addOption("RB42", "NimbleReductionAttack", 1.0, 0.0, 5.0, 0.05)
    SandboxOptions.addOption("RB42", "NimbleReductionStairs", 0.2, 0.0, 2.0, 0.01)
    SandboxOptions.addOption("RB42", "TripBaseChance", 0.025, 0.0, 0.2, 0.001)
    SandboxOptions.addOption("RB42", "TripNimbleReduction", 0.06, 0.0, 0.2, 0.001)
    SandboxOptions.addOption("RB42", "TripMinMultiplier", 0.35, 0.0, 1.0, 0.01)

    -- XP System
    SandboxOptions.addOption("RB42", "FitnessXpPerTick", 0.05, 0.0, 1.0, 0.01)
    SandboxOptions.addOption("RB42", "NimbleXpPerStairsTick", 0.02, 0.0, 1.0, 0.01)
    SandboxOptions.addOption("RB42", "TraitXpBoost", 1.1, 1.0, 2.0, 0.01)

    -- Durability
    SandboxOptions.addOption("RB42", "BootsMax", 60, 1, 200, 1)
    SandboxOptions.addOption("RB42", "WheelsMax", 30, 1, 100, 1)

    -- Noise
    SandboxOptions.addOption("RB42", "NoiseMultiplier", 1.2, 0.1, 5.0, 0.01)
end

Events.OnInitWorld.Add(loadRB42SandboxOptions)


print("[RB42 SandboxOptions] SandboxOptions.lua loaded!")