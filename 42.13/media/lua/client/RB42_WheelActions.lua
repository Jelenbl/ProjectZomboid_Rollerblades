require "TimedActions/ISBaseTimedAction"
require "RB42_RollerbladesShared"

-- ============================================================
-- Replace Wheels Action
-- ============================================================
ISReplaceRollerbladesWheels = ISBaseTimedAction:derive("ISReplaceRollerbladesWheels")

function ISReplaceRollerbladesWheels:isValid()
    return self.character:getInventory():contains(self.rbItem)
        or self.character:isEquipped(self.rbItem)
end

function ISReplaceRollerbladesWheels:start()
    -- No animation needed for inventory item repair
end

function ISReplaceRollerbladesWheels:update()
end

function ISReplaceRollerbladesWheels:stop()
    ISBaseTimedAction.stop(self)
end

function ISReplaceRollerbladesWheels:perform()
    local inv = self.character:getInventory()

    -- Consume the wheel item
    local wheel = inv:FindAndReturn("Rollerblades42.RollerbladeWheels")
    if wheel then
        inv:Remove(wheel)
    end

    -- Set wheels to max
    local md = self.rbItem:getModData()
    md.rb_wheels = RB42.Config.WheelsMax

    ISBaseTimedAction.perform(self)
end

function ISReplaceRollerbladesWheels:new(character, rbItem, time)
    local o = ISBaseTimedAction.new(self, character)
    o.rbItem = rbItem
    o.maxTime = time or 50
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end

-- ============================================================
-- Clean Wheels Action
-- ============================================================
ISCleanRollerbladesWheels = ISBaseTimedAction:derive("ISCleanRollerbladesWheels")

function ISCleanRollerbladesWheels:isValid()
    return self.character:getInventory():contains(self.rbItem)
        or self.character:isEquipped(self.rbItem)
end

function ISCleanRollerbladesWheels:start()
    -- No animation needed for inventory item repair
end

function ISCleanRollerbladesWheels:update()
end

function ISCleanRollerbladesWheels:stop()
    ISBaseTimedAction.stop(self)
end

function ISCleanRollerbladesWheels:perform()
    local inv = self.character:getInventory()

    -- Consume alcohol wipes
    local wipes = inv:FindAndReturn("Base.AlcoholWipes")
    if wipes then
        inv:Remove(wipes)
    end

    -- Restore some wheel durability
    local md = self.rbItem:getModData()
    if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
    md.rb_wheels = math.min(RB42.Config.WheelsMax, md.rb_wheels + 8)

    ISBaseTimedAction.perform(self)
end

function ISCleanRollerbladesWheels:new(character, rbItem, time)
    local o = ISBaseTimedAction.new(self, character)
    o.rbItem = rbItem
    o.maxTime = time or 50
    o.stopOnWalk = true
    o.stopOnRun = true
    return o
end

print("[RB42] Wheel TimedActions loaded")
