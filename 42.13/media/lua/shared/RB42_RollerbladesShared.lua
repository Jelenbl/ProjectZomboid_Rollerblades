RB42 = RB42 or {}

RB42.Config = {
    TickSeconds = 0.25,

    noiseMultiplier = 1.2,  -- Base noise multiplier at 0 durability (150% noise)

    -- Speed multipliers (used by our built-in fallback too)
    SpeedHard = 1.50,
    SpeedSoft = 0.75,
    SpeedStairs = 0.30,  -- Going up/down stairs (70% slower!)
    SpeedBlocked = 0.30,  -- Pushing through bushes/trees (70% slower!)

    -- Nimble System
    fallChanceOnStairsCheck = 2.0,  -- Base 2% chance to fall on stairs check
    attackFallChancePerAttack = 10,  -- Base 10% increased fall chance per attack
    reductionPerNimbleLevelForAttack = 1,     -- 1% reduction in fall chance per nimble level for an Attack
    reductionPerNimbleLevelForStairs = 0.20,     -- 2% reduction in fall chance per nimble level on stairs
    
    -- XP System
    FitnessXpPerTick = 0.05,  -- XP per tick while moving on rollerblades (any terrain)
    NimbleXpPerStairsTick = 0.02,  -- XP per tick while on stairs (balance training)
    TraitXpBoost = 1.1,  -- 10% XP boost for Rollerblader trait

    -- Carpet detection: floor sprite name contains any of these
    CarpetKeywords = { "carpet", "rug", "mat" },

    -- Durability pools (0..Max)
    BootsMax = 60,
    WheelsMax = 30,

    -- Noise System (radius in tiles)
    -- For reference: normal footsteps ~7 walk, ~8 run, ~11 sprint, ~3 sneak
    -- Rollerblades are roughly 2x louder due to hard wheels
    NoiseWalking    = 10,   -- Hard wheels rolling at walking pace
    NoiseRunning    = 13,   -- Fast skating, very audible
    NoiseSneaking   = 6,    -- Can't really sneak on wheels
    NoiseSprinting  = 15,   -- Full speed, wheels screaming
    NoiseStairs     = 14,   -- Clunking up/down stairs (overrides movement type)
    NoiseBlocked    = 8,    -- Pushing through brush, slow but crunchy
    NoiseTerrainHard = 1.2, -- Multiplier: louder on concrete/asphalt
    NoiseTerrainSoft = 0.7, -- Multiplier: quieter on grass/dirt
    NoiseVolumeRatio = 0.6, -- Volume = radius * this (lower = less attractive to zombies)

    -- Wear per tick (per 0.25s by default)
    Wear = {
        HardWheels = 0.0015,
        SoftWheels = 0.003,
        StairsWheels = 0.0045,
        BlockedWheels = 0.006,

        HardBoots = 0.001,
        SoftBoots = 0.002,
        StairsBoots = 0.003,
        BlockedBoots = 0.004,
    },

    -- Trip config
    Trip = {
        BaseChance = 0.025,
        NimbleReductionPerLevel = 0.06,
        MinMultiplier = 0.35,
    },
}

RB42.Config.Repair = {
    WheelsMinPctAt0 = 0.20,
    WheelsMaxPctAt0 = 0.35,

    WheelsMinPctAt10 = 0.70,
    WheelsMaxPctAt10 = 0.90,

    BootsBonusMin = 0.5,
    BootsBonusMax = 2.0,
}

RB42.Config.Repair.ConsumeRefund = {
    ToothbrushRefundAt0 = 0.10,
    ToothbrushRefundAt10 = 0.60,

    GreaseRefundAt0 = 0.05,
    GreaseRefundAt10 = 0.55,

    AlcoholRefundAt0 = 0.10,
    AlcoholRefundAt10 = 0.70,
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