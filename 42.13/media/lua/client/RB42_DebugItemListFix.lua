-- B42: Debug Items List can crash when scriptItem:getItemType() is nil.
-- This patch waits until ISTemsListTable exists, then monkey-patches safely.
-- Client-side only. MP-safe.

local function safeItemTypeString(scriptItem)
    if not scriptItem or not scriptItem.getItemType then return nil end
    local ok, it = pcall(function() return scriptItem:getItemType() end)
    if not ok or it == nil then return nil end
    local ok2, s = pcall(function() return it:toString() end)
    if not ok2 then return nil end
    return s
end

local function installPatch()
    if not ISTemsListTable then return false end
    if ISTemsListTable.__rb42Patched then return true end

    -- Patch filterCategory (this is where your original crash was)
    local oldFilterCategory = ISTemsListTable.filterCategory
    function ISTemsListTable:filterCategory(widget, scriptItem)
        -- Preserve vanilla "Any category"
        if widget and widget.selected == 1 then return true end

        local itemTypeStr = safeItemTypeString(scriptItem)
        if itemTypeStr == nil then
            -- If ItemType is nil, it can't match a specific category; just hide it.
            return false
        end

        local opt = widget and widget.getOptionText and widget:getOptionText(widget.selected) or nil
        return itemTypeStr == opt
    end

    -- Patch initList (some builds crash while building the category list)
    local oldInitList = ISTemsListTable.initList
    function ISTemsListTable:initList(module)
        -- Call vanilla, but guard the risky parts by temporarily wrapping getItemType
        -- We can't change the Java side, so we just keep initList from crashing.
        local ok = pcall(function()
            return oldInitList(self, module)
        end)

        if not ok then
            -- Fallback: rebuild list without touching getItemType
            self.totalResult = 0
            for _, v in ipairs(module or {}) do
                self.data:addItem(v:getDisplayName(), v)
                self.totalResult = self.totalResult + 1
            end
        end
    end

    ISTemsListTable.__rb42Patched = true
    print("[RB42] Debug Items List crash guard installed.")
    return true
end

-- Wait until after UI scripts are loaded
Events.OnGameStart.Add(function()
    local attempts = 0
    Events.OnTick.Add(function()
        attempts = attempts + 1
        if installPatch() or attempts > 600 then -- ~10s at 60fps
            Events.OnTick.Remove(this)
        end
    end)
end)
