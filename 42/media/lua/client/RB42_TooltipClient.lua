-- RB42_TooltipClient.lua
-- Adds wheel and boot durability info to the rollerblade item tooltip on hover

require "RB42_RollerbladesShared"

local function isRollerblades(item)
    return item and item.getFullType and item:getFullType() == "Rollerblades42.Rollerblades"
end

-- Hook into ISToolTipInv to add durability info on hover
local function initTooltipHook()
    if not ISToolTipInv then return false end
    
    local originalRender = ISToolTipInv.render
    if not originalRender then return false end
    
    function ISToolTipInv:render()
        -- Call original render first
        originalRender(self)
        
        -- Only modify for rollerblades
        local ok, _ = pcall(function()
            local item = self.item
            if not item or not isRollerblades(item) then return end
            
            -- Get durability data
            local md = item:getModData()
            if not md then return end
            
            -- Initialize if needed
            if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
            if md.rb_boots == nil then md.rb_boots = RB42.Config.BootsMax end
            
            local wheelsPct = math.floor((md.rb_wheels / RB42.Config.WheelsMax) * 100)
            local bootsPct = math.floor((md.rb_boots / RB42.Config.BootsMax) * 100)
            
            -- Draw durability info directly using drawText
            -- Position below the existing tooltip content
            local x = self:getAbsoluteX() + 12
            local y = self:getAbsoluteY() + self:getHeight() - 4
            local lineH = 16
            
            -- Header
            self:drawText("Rollerblade Condition:", x, y, 0.8, 0.8, 1.0, 1.0, UIFont.Small)
            y = y + lineH
            
            -- Wheels line with color
            local wr, wg, wb = 0.4, 1.0, 0.4  -- green
            local wheelsLabel = "  Wheels: " .. wheelsPct .. "%"
            if wheelsPct <= 0 then
                wr, wg, wb = 0.6, 0.6, 0.6
                wheelsLabel = "  Wheels: DESTROYED"
            elseif wheelsPct <= 30 then
                wr, wg, wb = 1.0, 0.4, 0.4  -- red
            elseif wheelsPct <= 60 then
                wr, wg, wb = 1.0, 1.0, 0.4  -- yellow
            end
            self:drawText(wheelsLabel, x, y, wr, wg, wb, 1.0, UIFont.Small)
            y = y + lineH
            
            -- Boots line with color
            local br, bg, bb = 0.4, 1.0, 0.4
            local bootsLabel = "  Boots: " .. bootsPct .. "%"
            if bootsPct <= 0 then
                br, bg, bb = 0.6, 0.6, 0.6
                bootsLabel = "  Boots: DESTROYED"
            elseif bootsPct <= 30 then
                br, bg, bb = 1.0, 0.4, 0.4
            elseif bootsPct <= 60 then
                br, bg, bb = 1.0, 1.0, 0.4
            end
            self:drawText(bootsLabel, x, y, br, bg, bb, 1.0, UIFont.Small)
            y = y + lineH
            
            -- Destroyed warning
            if wheelsPct <= 0 then
                y = y + 4
                self:drawText("No speed bonus with broken wheels!", x, y, 1.0, 0.3, 0.3, 1.0, UIFont.Small)
            end
        end)
    end
    
    print("[RB42 Tooltip] Hooked ISToolTipInv.render")
    return true
end

-- Try to hook on game start (ISToolTipInv may not exist immediately)
local hookAttempts = 0
local function tryHook()
    if initTooltipHook() then
        Events.OnTick.Remove(tryHook)
        return
    end
    hookAttempts = hookAttempts + 1
    if hookAttempts > 600 then  -- Give up after ~10 seconds
        Events.OnTick.Remove(tryHook)
        print("[RB42 Tooltip] Could not find ISToolTipInv after 600 ticks, giving up")
    end
end

Events.OnGameStart.Add(function()
    if not initTooltipHook() then
        Events.OnTick.Add(tryHook)
    end
end)

print("[RB42 Tooltip] Module loaded")
