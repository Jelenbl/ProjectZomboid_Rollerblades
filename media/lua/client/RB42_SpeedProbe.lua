Events.OnGameStart.Add(function()
    local p = getPlayer()
    if not p then return end
    local st = p:getStats()
    if not st then
        print("[RB42] SpeedProbe: getStats() is nil")
        return
    end

    local names = {
        "setSpeedModifier",
        "setMoveSpeed",
        "setMovementSpeed",
        "setEnduranceSpeedMod",
        "setFatigueSpeedMod",
        "setFitnessSpeedMod",
        "setPanicSpeedMod",
        "setSneakSpeedMod",
        "setRunSpeedMod",
        "setWalkSpeedMod",
    }

    print("[RB42] --- Stats speed probe ---")
    for _, n in ipairs(names) do
        print("[RB42] Stats." .. n .. " = " .. tostring(type(st[n]) == "function"))
    end
end)
