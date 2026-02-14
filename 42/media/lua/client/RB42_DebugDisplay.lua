require "RB42_RollerbladesShared"

-- Debug display to show rollerblade status on screen

local function renderDebugInfo()
    local success, err = pcall(function()
        local player = getPlayer()
        if not player then return end
        
        local md = player:getModData()
        if not md then return end
        
        -- Only show if wearing rollerblades
        if not md.rb42_terrain then return end
        
        local y = 10
        local x = 10
        
        -- Draw terrain info
        local terrain = md.rb42_terrain or "none"
        local speedMult = md.rb42_speedMul or 1.0
        
        local text = string.format("[RB42] Terrain: %s | Speed: %.2fx", terrain, speedMult)
        
        -- Draw text on screen
        if TextManager and TextManager.instance and UIFont then
            TextManager.instance:DrawString(UIFont.Small, x, y, text, 1, 1, 1, 1)
        end
    end)
    
    if not success then
        -- Silently fail - don't spam console with render errors
    end
end

Events.OnPostRender.Add(renderDebugInfo)
