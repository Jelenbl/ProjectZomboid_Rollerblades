-- Rollerblades42 Sandbox Options Registration
-- This file registers all mod sandbox options for Project Zomboid Build 42

local SandboxVars = SandboxVars

local function getOption(name, default)
    if SandboxVars and SandboxVars.RB42 and SandboxVars.RB42[name] ~= nil then
        return SandboxVars.RB42[name]
    end
    return default
end

local function RegisterRB42SandboxOptions()
    -- Register all mod options
    SandboxVars.RB42 = SandboxVars.RB42 or {}
    -- Example: set defaults if not present
    SandboxVars.RB42.SpeedHard = getOption("SpeedHard", 1.00)
    SandboxVars.RB42.SpeedSoft = getOption("SpeedSoft", 0.75)
    SandboxVars.RB42.SpeedStairs = getOption("SpeedStairs", 0.3)
    SandboxVars.RB42.SpeedBlocked = getOption("SpeedBlocked", 0.3)
    SandboxVars.RB42.FallChanceStairs = getOption("FallChanceStairs", 2.0)
    SandboxVars.RB42.FallChanceAttack = getOption("FallChanceAttack", 10)
    SandboxVars.RB42.NimbleReductionAttack = getOption("NimbleReductionAttack", 1.0)
    SandboxVars.RB42.NimbleReductionStairs = getOption("NimbleReductionStairs", 0.2)
    SandboxVars.RB42.TripBaseChance = getOption("TripBaseChance", 0.025)
    SandboxVars.RB42.TripNimbleReduction = getOption("TripNimbleReduction", 0.06)
    SandboxVars.RB42.TripMinMultiplier = getOption("TripMinMultiplier", 0.35)
    SandboxVars.RB42.FitnessXpPerTick = getOption("FitnessXpPerTick", 0.05)
    SandboxVars.RB42.NimbleXpPerStairsTick = getOption("NimbleXpPerStairsTick", 0.02)
    SandboxVars.RB42.TraitXpBoost = getOption("TraitXpBoost", 1.1)
    SandboxVars.RB42.BootsMax = getOption("BootsMax", 60)
    SandboxVars.RB42.WheelsMax = getOption("WheelsMax", 30)
    SandboxVars.RB42.NoiseMultiplier = getOption("NoiseMultiplier", 1.2)
end

Events.OnInitWorld.Add(RegisterRB42SandboxOptions)
