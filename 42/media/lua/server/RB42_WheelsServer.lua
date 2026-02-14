require "RB42_RollerbladesShared"

function RB42_OnReplaceWheels(items, result, player)
    if not result then return end
    local md = RB42.GetOrInitDurability(result)

    -- Full replacement -> wheels to max
    md.rb_wheels = RB42.Config.WheelsMax

    -- Optional: tiny wear on boots/bindings from reassembly
    md.rb_boots = RB42.Clamp(md.rb_boots - 0.5, 0, RB42.Config.BootsMax)
end
