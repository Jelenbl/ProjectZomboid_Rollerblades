require "RB42_RollerbladesShared"

local function getWornRollerblades(playerObj)
    local worn = playerObj:getWornItems()
    if not worn then return nil end
    for i=0, worn:size()-1 do
        local w = worn:get(i)
        local it = w and w:getItem()
        if it and it.getFullType and it:getFullType() == "Rollerblades42.Rollerblades" then
            return it
        end
    end
    return nil
end

-- Server-side tracking - just maintain durability and sync state
-- Speed is handled client-side in RB42_SpeedClient.lua
Events.EveryOneMinute.Add(function()
    for i=0, getNumActivePlayers()-1 do
        local p = getSpecificPlayer(i)
        if p then
            local rb = getWornRollerblades(p)
            if rb then
                -- Initialize durability if needed
                RB42.GetOrInitDurability(rb)
                
                -- Mark that player is wearing rollerblades (for potential server-side logic)
                local pmd = p:getModData()
                pmd.rb42_wearing = true
            else
                local pmd = p:getModData()
                pmd.rb42_wearing = false
            end
        end
    end
end)
