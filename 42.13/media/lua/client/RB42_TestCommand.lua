-- Simple test to verify rollerblades are working
-- Run by pressing a key or from debug menu

require "RB42_RollerbladesShared"

local function testRollerblades()
    local player = getPlayer()
    if not player then
        print("[RB42 TEST] No player found")
        return
    end
    
    print("[RB42 TEST] === Rollerblade Test ===")
    
    -- Check inventory
    local inv = player:getInventory()
    local hasInInventory = inv:contains("Rollerblades", true)
    print("[RB42 TEST] Has in inventory: " .. tostring(hasInInventory))
    
    -- Check worn items
    local worn = player:getWornItems()
    local wearingRB = false
    if worn then
        for i = 0, worn:size() - 1 do
            local item = worn:get(i):getItem()
            if item then
                local fullType = item:getFullType()
                print("[RB42 TEST] Wearing: " .. tostring(fullType))
                if fullType == "Rollerblades42.Rollerblades" then
                    wearingRB = true
                end
            end
        end
    end
    
    print("[RB42 TEST] Wearing rollerblades: " .. tostring(wearingRB))
    
    -- Check player modData
    local md = player:getModData()
    print("[RB42 TEST] ModData terrain: " .. tostring(md.rb42_terrain))
    print("[RB42 TEST] ModData speedMul: " .. tostring(md.rb42_speedMul))
    
    -- Try to give rollerblades if not in inventory
    if not hasInInventory and not wearingRB then
        print("[RB42 TEST] Adding rollerblades to inventory...")
        player:getInventory():AddItem("Rollerblades42.Rollerblades")
    end
    
    print("[RB42 TEST] === Test Complete ===")
end

-- Run test on game start
Events.OnGameStart.Add(function()
    print("[RB42 TEST] Mod loaded successfully!")
end)
