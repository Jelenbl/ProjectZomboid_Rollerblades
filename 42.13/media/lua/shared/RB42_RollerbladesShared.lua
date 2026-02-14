RB42 = RB42 or {}

RB42.Config = {
    TickSeconds = 0.01,

    -- Speed multipliers (used by our built-in fallback too)
    SpeedHard = 1.25,
    SpeedSoft = 1.00,
    SpeedStairs = 0.50,
    SpeedBlocked = 0.30,  -- Pushing through bushes/trees (70% slower!)

    -- Carpet detection: floor sprite name contains any of these
    CarpetKeywords = { "carpet", "rug", "mat" },

    -- Durability pools (0..Max)
    BootsMax = 60,
    WheelsMax = 30,

    -- Wear per tick (per 0.25s by default)
    Wear = {
        HardWheels = 0.003,    -- was 0.006
        SoftWheels = 0.006,    -- was 0.012
        StairsWheels = 0.009,  -- was 0.018
        BlockedWheels = 0.012, -- was 0.024

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

    -- XP
    NimbleXpPerStairsTick = 0.4,
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
