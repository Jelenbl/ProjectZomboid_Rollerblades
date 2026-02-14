require "RB42_RollerbladesShared"

local function lerp(a, b, t) return a + (b - a) * t end

local function chance(p)
    return ZombRandFloat(0.0, 1.0) < p
end

local function refundItem(player, fullType, count)
    local inv = player and player:getInventory()
    if not inv then return end
    for _ = 1, (count or 1) do
        inv:AddItem(fullType)
    end
end

-- Called by: OnCreate:RB42_OnCleanWheels
function RB42_OnCleanWheels(items, result, player)
    if not result or not player then return end

    local md = RB42.GetOrInitDurability(result)

    -- Maintenance 0..10
    local maint = player:getPerkLevel(Perks.Maintenance) or 0
    local t = RB42.Clamp(maint / 10.0, 0.0, 1.0)

    -- ===== Wheels restoration (skill-scaled) =====
    local minPct = lerp(RB42.Config.Repair.WheelsMinPctAt0,  RB42.Config.Repair.WheelsMinPctAt10,  t)
    local maxPct = lerp(RB42.Config.Repair.WheelsMaxPctAt0,  RB42.Config.Repair.WheelsMaxPctAt10,  t)
    if maxPct < minPct then maxPct = minPct end

    local restoredPct = ZombRandFloat(minPct, maxPct)
    local restoreAmount = RB42.Config.WheelsMax * restoredPct
    md.rb_wheels = RB42.Clamp(md.rb_wheels + restoreAmount, 0, RB42.Config.WheelsMax)

    -- Small boots/bindings tune-up
    local bootsBonus = ZombRandFloat(RB42.Config.Repair.BootsBonusMin, RB42.Config.Repair.BootsBonusMax)
    md.rb_boots = RB42.Clamp(md.rb_boots + bootsBonus, 0, RB42.Config.BootsMax)

    -- ===== Skill-based refund of consumables =====
    local cr = RB42.Config.Repair.ConsumeRefund

    local toothbrushRefund = lerp(cr.ToothbrushRefundAt0, cr.ToothbrushRefundAt10, t)
    local greaseRefund     = lerp(cr.GreaseRefundAt0,     cr.GreaseRefundAt10,     t)
    local alcoholRefund    = lerp(cr.AlcoholRefundAt0,    cr.AlcoholRefundAt10,    t)

    -- Refund means: you used it but didn’t “consume it” (kept enough / didn’t waste it)
    if chance(toothbrushRefund) then refundItem(player, "Base.Toothbrush", 1) end
    if chance(greaseRefund) then     refundItem(player, "Base.Grease", 1) end
    if chance(alcoholRefund) then    refundItem(player, "Base.AlcoholWipes", 1) end
end
