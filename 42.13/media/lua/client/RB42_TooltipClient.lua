-- RB42_TooltipClient.lua
-- Adds separate wheels and boots condition bars to rollerblades tooltip

require "RB42_RollerbladesShared"

local function isRollerblades(item)
    return item and item.getFullType and item:getFullType() == "Rollerblades42.Rollerblades"
end

-- Hook into ISToolTipInv to add custom rendering
local function initTooltipHook()
    if not ISToolTipInv then return false end

    -- Store original render function
    local originalRender = ISToolTipInv.render
    if not originalRender then return false end

    -- Override render to add custom condition bars for rollerblades
    ISToolTipInv.render = function(self)
        -- Call original render first
        originalRender(self)

        -- Only customize if this is rollerblades
        local item = self.item
        if not item or not isRollerblades(item) then return end

        pcall(function()
            local md = item:getModData()
            if not md then return end

            -- Initialize durability if needed
            if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
            if md.rb_boots == nil then md.rb_boots = RB42.Config.BootsMax end

            -- Calculate percentages
            local wheelsPct = md.rb_wheels / RB42.Config.WheelsMax
            local bootsPct = md.rb_boots / RB42.Config.BootsMax
            if wheelsPct < 0 then wheelsPct = 0 elseif wheelsPct > 1 then wheelsPct = 1 end
            if bootsPct < 0 then bootsPct = 0 elseif bootsPct > 1 then bootsPct = 1 end

            -- Get font height for positioning
            local fontHgt = getTextManager():getFontHeight(UIFont.Small)

            -- Position bars directly under the tooltip
            local barStartY = self:getHeight() + 4  -- Start 4 pixels below tooltip
            local barSpacing = fontHgt + 6

            -- Bar dimensions
            local barWidth = self:getWidth() - 16
            local barHeight = 5
            local barX = 8
            local labelPadding = 2

            -- Render wheels condition
            self:drawText(" Wheels Condition:", barX, barStartY, 1, 1, 1, 1, UIFont.Small)
            local wheelsBarY = barStartY + fontHgt + labelPadding
            local wheelsColor = {
                r = 1.0 - wheelsPct,
                g = wheelsPct,
                b = 0.0,
                a = 1.0
            }
            self:drawProgressBar(barX, wheelsBarY, barWidth, barHeight, wheelsPct, wheelsColor)

            -- Render boots condition
            local bootsTextY = wheelsBarY + barHeight + 4
            self:drawText(" Boots Condition:", barX, bootsTextY, 1, 1, 1, 1, UIFont.Small)
            local bootsBarY = bootsTextY + fontHgt + labelPadding
            local bootsColor = {
                r = 1.0 - bootsPct,
                g = bootsPct,
                b = 0.0,
                a = 1.0
            }
            self:drawProgressBar(barX, bootsBarY, barWidth, barHeight, bootsPct, bootsColor)
        end)
    end

    print("[RB42 Tooltip] Hooked ISToolTipInv.render for custom condition bars")
    return true
end

-- Try to hook on game start
local hookAttempts = 0
local function tryHook()
    if initTooltipHook() then
        Events.OnTick.Remove(tryHook)
        return
    end
    hookAttempts = hookAttempts + 1
    if hookAttempts > 600 then
        Events.OnTick.Remove(tryHook)
        print("[RB42 Tooltip] Could not find ISToolTipInv after 600 ticks")
    end
end

Events.OnGameStart.Add(function()
    if not initTooltipHook() then
        Events.OnTick.Add(tryHook)
    end
end)

print("[RB42 Tooltip] Module loaded")
