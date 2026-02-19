RB42 = RB42 or {}

-- Helper function to get sandbox value with fallback
local function getSandboxValue(key, default)
    if SandboxVars and SandboxVars.Rollerblades42 and SandboxVars.Rollerblades42[key] ~= nil then
        return SandboxVars.Rollerblades42[key]
    end
    return default
end

RB42.Config = {
    TickSeconds = 0.25,

    noiseMultiplier = getSandboxValue("NoiseMultiplier", 1.2),  -- Base noise multiplier at 0 durability

    -- Speed multipliers (used by our built-in fallback too)
    SpeedHard = getSandboxValue("SpeedHard", 1.50),
    SpeedSoft = getSandboxValue("SpeedSoft", 0.75),
    SpeedStairs = getSandboxValue("SpeedStairs", 0.30),  -- Going up/down stairs (70% slower!)
    SpeedBlocked = getSandboxValue("SpeedBlocked", 0.30),  -- Pushing through bushes/trees (70% slower!)

    -- Nimble System
    fallChanceOnStairsCheck = getSandboxValue("FallChanceStairs", 2.0),  -- Base 2% chance to fall on stairs check
    attackFallChancePerAttack = getSandboxValue("FallChanceAttack", 10),  -- Base 10% increased fall chance per attack
    reductionPerNimbleLevelForAttack = getSandboxValue("NimbleReductionAttack", 1),     -- 1% reduction in fall chance per nimble level for an Attack
    reductionPerNimbleLevelForStairs = getSandboxValue("NimbleReductionStairs", 0.20),     -- 0.2% reduction in fall chance per nimble level on stairs

    -- XP System
    FitnessXpPerTick = getSandboxValue("FitnessXpPerTick", 0.05),  -- XP per tick while moving on rollerblades (any terrain)
    NimbleXpPerStairsTick = getSandboxValue("NimbleXpPerStairsTick", 0.02),  -- XP per tick while on stairs (balance training)
    TraitXpBoost = getSandboxValue("TraitXpBoost", 1.1),  -- 10% XP boost for Rollerblader trait

    -- Carpet detection: floor sprite name contains any of these
    CarpetKeywords = { "carpet", "rug", "mat" },

    -- Durability pools (0..Max)
    BootsMax = getSandboxValue("BootsMax", 60),
    WheelsMax = getSandboxValue("WheelsMax", 30),

    -- Noise System (radius in tiles)
    -- For reference: normal footsteps ~7 walk, ~8 run, ~11 sprint, ~3 sneak
    -- Rollerblades are roughly 2x louder due to hard wheels
    NoiseWalking    = getSandboxValue("NoiseWalking", 10),   -- Hard wheels rolling at walking pace
    NoiseRunning    = getSandboxValue("NoiseRunning", 13),   -- Fast skating, very audible
    NoiseSneaking   = getSandboxValue("NoiseSneaking", 6),    -- Can't really sneak on wheels
    NoiseSprinting  = getSandboxValue("NoiseSprinting", 15),   -- Full speed, wheels screaming
    NoiseStairs     = getSandboxValue("NoiseStairs", 14),   -- Clunking up/down stairs (overrides movement type)
    NoiseBlocked    = getSandboxValue("NoiseBlocked", 8),    -- Pushing through brush, slow but crunchy
    NoiseTerrainHard = getSandboxValue("NoiseTerrainHard", 1.2), -- Multiplier: louder on concrete/asphalt
    NoiseTerrainSoft = getSandboxValue("NoiseTerrainSoft", 0.7), -- Multiplier: quieter on grass/dirt
    NoiseVolumeRatio = getSandboxValue("NoiseVolumeRatio", 0.6), -- Volume = radius * this (lower = less attractive to zombies)

    -- Wear per tick (per 0.25s by default)
    Wear = {
        HardWheels = getSandboxValue("WearHardWheels", 0.0015),
        SoftWheels = getSandboxValue("WearSoftWheels", 0.003),
        StairsWheels = getSandboxValue("WearStairsWheels", 0.0045),
        BlockedWheels = getSandboxValue("WearBlockedWheels", 0.006),

        HardBoots = getSandboxValue("WearHardBoots", 0.001),
        SoftBoots = getSandboxValue("WearSoftBoots", 0.002),
        StairsBoots = getSandboxValue("WearStairsBoots", 0.003),
        BlockedBoots = getSandboxValue("WearBlockedBoots", 0.004),
    },

    -- Trip config
    Trip = {
        BaseChance = getSandboxValue("TripBaseChance", 0.025),
        NimbleReductionPerLevel = getSandboxValue("TripNimbleReduction", 0.06),
        MinMultiplier = getSandboxValue("TripMinMultiplier", 0.35),
    },

    -- Endurance
    walkEnduranceDrain = getSandboxValue("WalkEnduranceDrain", 0.0075),
    runEnduranceDrain = getSandboxValue("RunEnduranceDrain", 0.005),
    stairsEnduranceMultiplier = getSandboxValue("StairsEnduranceMultiplier", 1.75),
    blockedEnduranceMultiplier = getSandboxValue("BlockedEnduranceMultiplier", 2.5),
    traitEnduranceReduction = getSandboxValue("TraitEnduranceReduction", 0.25),  -- 25% endurance reduction with Rollerblader trait
}

RB42.Config.Repair = {
    WheelsMinPctAt0 = getSandboxValue("WheelsMinPctAt0", 0.20),
    WheelsMaxPctAt0 = getSandboxValue("WheelsMaxPctAt0", 0.35),

    WheelsMinPctAt10 = getSandboxValue("WheelsMinPctAt10", 0.70),
    WheelsMaxPctAt10 = getSandboxValue("WheelsMaxPctAt10", 0.90),

    BootsBonusMin = getSandboxValue("BootsBonusMin", 0.5),
    BootsBonusMax = getSandboxValue("BootsBonusMax", 2.0),
}

RB42.Config.Repair.ConsumeRefund = {
    ToothbrushRefundAt0 = getSandboxValue("ToothbrushRefundAt0", 0.10),
    ToothbrushRefundAt10 = getSandboxValue("ToothbrushRefundAt10", 0.60),

    GreaseRefundAt0 = getSandboxValue("GreaseRefundAt0", 0.05),
    GreaseRefundAt10 = getSandboxValue("GreaseRefundAt10", 0.55),

    AlcoholRefundAt0 = getSandboxValue("AlcoholRefundAt0", 0.10),
    AlcoholRefundAt10 = getSandboxValue("AlcoholRefundAt10", 0.70),
}

function RB42.Clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function RB42.GetOrInitDurability(item)
    local md = item:getModData()
    if md.rb_boots == nil then md.rb_boots = RB42.Config.BootsMax end
    if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
    return md
end
