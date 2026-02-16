-- RB42_SpeedClient.lua
-- Client-side speed modification for rollerblades using animation system
-- This file detects terrain and sets animation speed variables that the XML files read

print("[RB42 SpeedClient] ===== VERSION WITH NULL CHECKS LOADING - FEB 13 2026 =====")

require "RB42_RollerbladesShared"

print("[RB42 SpeedClient] Shared config loaded")

-- Function: Check if player is wearing rollerblades
-- Returns: the rollerblade item if equipped, or nil
local function getWornRollerblades(player)
    local worn = player:getWornItems()  -- Get all worn items
    if not worn then return nil end
    for i = 0, worn:size() - 1 do
        local item = worn:get(i):getItem()
        if item and item:getFullType() == "Rollerblades42.Rollerblades" then
            return item
        end
    end
    return nil
end

-- Function: Detect what terrain type the player is standing on
-- Returns: "blocked", "stairs", "soft" (grass/carpet), or "hard" (concrete/road)
local function getTerrainType(player)
    if not player then return "hard" end
    
    local square = player:getCurrentSquare()  -- Get the tile the player is on
    if not square then return "hard" end
    
    -- Priority 0: Check if player is colliding with vegetation objects (trees, bushes)
    -- These block movement and should drastically slow skating
    local objects = square:getObjects()
    if objects and objects:size() > 0 then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj then
                -- Check object name
                if obj.getObjectName then
                    local objName = tostring(obj:getObjectName()):lower()
                    -- ANY tree or bush counts as blocked
                    -- Use patterns so "tree" doesn't match inside "street"
                    if (objName:find("%f[%a]tree%f[%A]") or objName:find("%f[%a]tree$"))
                    or objName:find("bush") or objName:find("hedge") or objName:find("plant") then
                        print("[RB42] BLOCKED by object: " .. objName)
                        return "blocked"
                    end
                end
                
                -- Check sprite name
                if obj.getSprite then
                    local sprite = obj:getSprite()
                    if sprite and sprite.getName then
                        local spriteName = tostring(sprite:getName()):lower()
                        -- ANY tree, bush, or tall vegetation
                        -- Use patterns so "tree" doesn't match inside "street"
                        if (spriteName:find("%f[%a]tree%f[%A]") or spriteName:find("%f[%a]tree$"))
                        or spriteName:find("bush") or spriteName:find("hedge") then
                            print("[RB42] BLOCKED by sprite: " .. spriteName)
                            return "blocked"
                        end
                    end
                end
                
                -- Check texture/material name (some vegetation uses this)
                if obj.getTextureName then
                    local texName = tostring(obj:getTextureName()):lower()
                    -- Use patterns so "tree" doesn't match inside "street"
                    if (texName:find("%f[%a]tree%f[%A]") or texName:find("%f[%a]tree$"))
                    or texName:find("bush") or texName:find("hedge") then
                        print("[RB42] BLOCKED by texture: " .. texName)
                        return "blocked"
                    end
                end
            end
        end
    end
    
    -- Priority 1: Check if on stairs (most specific)
    if square.HasStairs and square:HasStairs() then
        return "stairs"
    end
    
    -- Priority 2: Check for vegetation objects on the ground
    local objects = square:getObjects()
    if objects and objects:size() > 0 then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj and obj.getSprite then
                local sprite = obj:getSprite()
                -- Check sprite properties for vegetation flag
                if sprite and sprite.getProperties then
                    local props = sprite:getProperties()
                    if props and props.Is then
                        if props:Is("vegitation") or props:Is("vegetation") then
                            return "soft"
                        end
                    end
                end
                
                -- Check sprite name for grass/plant keywords
                if sprite and sprite.getName then
                    local name = tostring(sprite:getName()):lower()
                    if name:find("grass") or name:find("plant") or name:find("bush") or name:find("vegetation") or name:find("natural") or name:find("helmock") then
                        return "soft"
                    end
                end
            end
        end
    end
    
    -- Priority 3: Check floor tile for carpet/rugs
    -- if square.getFloor then
    --     local floor = square:getFloor()
    --     if floor and floor.getSprite then
    --         local sprite = floor:getSprite()
    --         if sprite and sprite.getName then
    --             local name = tostring(sprite:getName()):lower()
    --             if name:find("carpet") or name:find("rug") then
    --                 return "soft"
    --             end
    --         end
    --     end
    -- end
    
    -- -- Default: Hard surface (concrete, asphalt, indoor floors)
    -- return "hard"
    -- Priority 3: Check floor tile (this is what your logs are printing)
if square.getFloor then
    local floor = square:getFloor()
    if floor and floor.getSprite then
        local sprite = floor:getSprite()
        if sprite and sprite.getName then
            local name = tostring(sprite:getName()):lower()

            -- GRASS / DIRT / NATURAL
            if name:find("blends_natural") or name:find("natural") or name:find("grass") or name:find("dirt") then
                return "soft"
            end

            -- ROADS / STREETS / ASPHALT / CONCRETE
            if name:find("blends_street") or name:find("street") or name:find("asphalt") or name:find("concrete") then
                return "hard"
            end

            -- CARPET / RUGS (also soft)
            if name:find("carpet") or name:find("rug") then
                return "soft"
            end
        end
    end
end

-- Default: treat unknown as hard
return "hard"

end

-- State tracking variables
local wasWearing = false          -- Was player wearing rollerblades last frame?
local lastTerrain = nil           -- What terrain type were we on last?
local lastSpeedMult = nil         -- What speed multiplier did we last set?
local stairsTimer = 0             -- How long player has been on stairs (frames)
local lastFallCheck = 0           -- Last frame we checked for fall
local xpAccumulator = 0           -- Accumulates time for XP gains (seconds)
local wearAccumulator = 0         -- Accumulates time for durability wear (seconds)
local wheelsBlown = false         -- True when wheels have reached 0 durability
local pendingSpeedMult = nil      -- When set, we deactivated last frame and need to reactivate with this speed

-- Function: Make player fall and injure themselves on stairs
-- Minor stumbles with light injuries
local function fallOnStairs(player)
    if not player then return end
    
    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then return end
    
    -- Play stumble/fall sound and animation
    player:getEmitter():playSound("PZ_Stumble")
    
    -- Trigger fall animation - player stumbles forward
    if player.setVariable then
        player:setVariable("BumpFallType", "pushedFront")
    end
    if player.setBumpType then
        player:setBumpType("stagger")
    end
    
    -- Alternative: Try to trigger bump/stumble animation
    if player.setBumpType then
        player:setBumpType("stagger")
    end
    
    -- Very minor injuries from stairs stumble (just scratches and bruises)
    -- Random body parts get injured (mostly legs and arms)
    local bodyParts = {
        BodyPartType.ForeArm_L,
        BodyPartType.ForeArm_R,
        BodyPartType.Hand_L,
        BodyPartType.Hand_R,
        BodyPartType.UpperLeg_L,
        BodyPartType.UpperLeg_R,
        BodyPartType.LowerLeg_L,
        BodyPartType.LowerLeg_R
    }
    
    -- Number of body parts injured (1 part, maybe 2)
    local numInjuries = ZombRand(1, 2)
    
    for i = 1, numInjuries do
        local randomPart = bodyParts[ZombRand(#bodyParts) + 1]
        local bodyPart = bodyDamage:getBodyPart(randomPart)
        
        if bodyPart then
            -- Very light wounds (minor scratches)
            local woundSeverity = ZombRand(1, 4)  -- 1-4 damage (very light)
            bodyPart:AddDamage(woundSeverity)
            
            -- Very rare chance for fracture (only 2% chance)
            if ZombRand(100) < 2 then
                bodyPart:setFractureTime(ZombRand(30, 45))  -- Short fracture time
                print("[RB42] FRACTURED: " .. tostring(randomPart))
            end
            
            -- Low chance for bleeding (10% chance, stops quickly)
            if ZombRand(100) < 10 then
                bodyPart:setBleeding(true)
            end
            
            -- Chance for scratched (minor road rash)
            if ZombRand(100) < 40 then
                bodyPart:setScratched(true, false)
            end
        end
    end
    
    -- Very minor pain from the fall
    bodyDamage:setPainReduction(bodyDamage:getPainReduction() + ZombRand(2, 8))
    
    -- Mild stress from stumbling
    local stats = player:getStats()
    if stats then
        if stats.Stress ~= nil then
            stats.Stress = stats.Stress + 0.05  -- Very mildly stressful
        end
        if stats.Panic ~= nil then
            stats.Panic = stats.Panic + 10      -- Slight panic from fall
        end
    end
    
    print("[RB42] Stumbled on stairs! Minor injuries.")
end

-- Main update loop - runs every frame
Events.OnPlayerUpdate.Add(function(player)
    -- ULTRA AGGRESSIVE NULL CHECK - catch any invalid player immediately
    if not player then 
        print("[RB42 ERROR] Player is NIL in OnPlayerUpdate!")
        return 
    end
    if player:isDead() then 
        return 
    end
    
    local rbItem = getWornRollerblades(player)
    
    if rbItem then
        -- Initialize durability if needed
        RB42.GetOrInitDurability(rbItem)
        
        -- Additional safety check after function call
        if not player or player:isDead() then return end
        
        -- Player is wearing rollerblades
        local terrain = getTerrainType(player)
        
        -- Safety check after terrain detection
        if not player or player:isDead() then return end
        
        -- DANGER: Check for stairs fall risk
        if terrain == "stairs" then
            stairsTimer = stairsTimer + 1
            
            -- Check for fall every 30 frames (roughly every second)
            if stairsTimer - lastFallCheck >= 30 then
                lastFallCheck = stairsTimer
                
                -- Fall chance calculation
                -- Base 1% chance per check on stairs (frequent stumbles)
                -- Increased by 12% if running
                -- Reduced by Nimble skill (0.1% per level, max -1% at level 10)
                -- Increased by 5% if carrying heavy items
                local fallChance = RB42.Config.fallChanceOnStairsCheck

                -- Nimble skill reduces fall chance (0.1% per level, max 1%)
                if not player or player:isDead() then return end
                local nimbleLevel = player:getPerkLevel(Perks.Nimble)
                local nimbleReduction = math.min(nimbleLevel, 10) * RB42.Config.reductionPerNimbleLevelForStairs  -- Max 2% reduction at level 10
                fallChance = fallChance - nimbleReduction
                if player:isRunning() then
                    fallChance = fallChance + 12  -- 13% base + nimble modifier when running
                end

                local inventory = player:getInventory()
                if inventory and inventory:getCapacityWeight() > 20 then
                    fallChance = fallChance + 5  -- Heavy load = less balance
                end

                -- Roll the dice!
                if ZombRand(100) < fallChance then
                    fallOnStairs(player)
                    stairsTimer = 0  -- Reset timer after fall
                    lastFallCheck = 0
                end
            end
        else
            -- Not on stairs, reset timers
            stairsTimer = 0
            lastFallCheck = 0
        end

        -- Attacking also increases fall chance, even on non-stairs terrain (risk of losing balance)
        fallChance = 0
        if player:isAttacking() then
            fallChance = RB42.Config.attackFallChancePerAttack
            local nimbleLevel = player:getPerkLevel(Perks.Nimble)
            local nimbleReduction = math.min(nimbleLevel, 10) * RB42.Config.reductionPerNimbleLevelForAttack  -- Max 1% reduction at level 10
            fallChance = fallChance - nimbleReduction
        end
        if ZombRand(100) < fallChance then
            fallOnStairs(player)
            stairsTimer = 0  -- Reset timer after fall
            lastFallCheck = 0
            fallChance = 0  -- Reset fall chance after fall
        end
        
        -- XP GAINS SYSTEM
        -- Only grant XP when actually moving (not standing still)
        -- Additional check: player must be truly moving (not just standing/turning)
        local isActuallyMoving = player and not player:isDead() and player:isMoving() and 
                                 (player:getX() ~= player:getLastX() or player:getY() ~= player:getLastY())
        
        if isActuallyMoving then
            xpAccumulator = xpAccumulator + 0.25  -- Each tick is ~0.25 seconds
            
            -- Every 60 seconds of skating, grant XP (very slow progression)
            if xpAccumulator >= 60.0 then
                local xpSystem = player:getXp()
                if not xpSystem then return end
                
                -- Always grant Fitness XP while skating (any terrain)
                -- Moving with weight on your legs = fitness training
                xpSystem:AddXP(Perks.Fitness, 0.25)  -- 0.25 XP per 60 seconds of movement
                
                -- Grant Nimble XP when on stairs (balance training)
                -- Nimble skill reduces fall chance
                if terrain == "stairs" then
                    xpSystem:AddXP(Perks.Nimble, 1)  -- 1 XP per 60 seconds on stairs
                    print("[RB42] XP gained: +0.25 Fitness, +1 Nimble (stairs)")
                else
                    print("[RB42] XP gained: +0.25 Fitness")
                end
                
                xpAccumulator = 0  -- Reset accumulator
            end
        else
            -- Not moving - don't accumulate XP
            xpAccumulator = 0
        end
        
        -- DURABILITY WEAR SYSTEM
        -- Degrade wheels and boots over time based on terrain type
        -- Only while moving; rates are per-second from Config.Wear
        -- Additional check: player must be truly moving (not just standing/turning)
        local isActuallyMoving = player and not player:isDead() and player:isMoving() and 
                                 (player:getX() ~= player:getLastX() or player:getY() ~= player:getLastY())
        
        if isActuallyMoving then
            wearAccumulator = wearAccumulator + 0.25  -- Each tick is ~0.25 seconds
            
            -- Apply wear every 10 seconds of movement
            if wearAccumulator >= 10.0 then
                local md = rbItem:getModData()
                if md then
                    -- Determine wear rates based on terrain
                    local wheelWear = 0
                    local bootWear = 0
                    
                    if terrain == "hard" then
                        wheelWear = RB42.Config.Wear.HardWheels
                        bootWear = RB42.Config.Wear.HardBoots
                    elseif terrain == "soft" then
                        wheelWear = RB42.Config.Wear.SoftWheels
                        bootWear = RB42.Config.Wear.SoftBoots
                    elseif terrain == "stairs" then
                        wheelWear = RB42.Config.Wear.StairsWheels
                        bootWear = RB42.Config.Wear.StairsBoots
                    elseif terrain == "blocked" then
                        -- Blocked terrain is hardest on equipment
                        wheelWear = RB42.Config.Wear.BlockedWheels
                        bootWear = RB42.Config.Wear.BlockedBoots
                    end
                    
                    -- Apply wear (multiply by 10 since we accumulate 10 seconds)
                    md.rb_wheels = RB42.Clamp((md.rb_wheels or RB42.Config.WheelsMax) - (wheelWear * 10), 0, RB42.Config.WheelsMax)
                    md.rb_boots = RB42.Clamp((md.rb_boots or RB42.Config.BootsMax) - (bootWear * 10), 0, RB42.Config.BootsMax)
                    
                    -- Log when durability gets low
                    if md.rb_wheels <= 5 and md.rb_wheels > 0 then
                        print("[RB42] WARNING: Wheels very worn! (" .. string.format("%.1f", md.rb_wheels) .. "/" .. RB42.Config.WheelsMax .. ")")
                    end
                    if md.rb_boots <= 10 then
                        print("[RB42] WARNING: Boots very worn! (" .. string.format("%.1f", md.rb_boots) .. "/" .. RB42.Config.BootsMax .. ")")
                    end
                    
                    -- Wheels completely destroyed!
                    if md.rb_wheels <= 0 and not wheelsBlown then
                        wheelsBlown = true
                        print("[RB42] WHEELS DESTROYED! Falling and reverting to normal speed.")
                        fallOnStairs(player)  -- Dramatic fall
                        if player.Say then
                            player:Say("My rollerblade wheels are shot!")
                        end
                    end
                end
                
                wearAccumulator = 0
            end
        else
            -- Not moving - don't accumulate wear
            wearAccumulator = 0
        end
        
        -- ENDURANCE DRAIN SYSTEM
        -- Skating is more exhausting than normal movement (constant balancing)
        -- B42 uses Fatigue field directly on Stats (0.0 = fresh, 1.0 = exhausted)
        -- Additional check: player must be truly moving (not just standing/turning)
        local isActuallyMoving = player and not player:isDead() and player:isMoving() and 
                                 (player:getX() ~= player:getLastX() or player:getY() ~= player:getLastY())
        
        if isActuallyMoving then
            local stats = player:getStats()
            if stats and stats.Fatigue ~= nil then
                local fatigue = stats.Fatigue
            
                -- Base fatigue drain rates (per tick)
                local drainAmount = 0
            
                if player:isRunning() then
                    -- Running on skates: exhausting!
                    drainAmount = 0.015  -- Noticeably more exhausting than running
                else
                    -- Walking on skates: moderate drain
                    drainAmount = 0.01  -- More exhausting than walking
                end
            
                -- Extra drain on stairs (harder to balance)
                if terrain == "stairs" then
                    drainAmount = drainAmount * 1.75  -- 75% more drain on stairs
                end
            
                -- HEAVY extra drain when pushing through vegetation (very exhausting!)
                if terrain == "blocked" then
                    drainAmount = drainAmount * 2.5  -- 150% more drain pushing through bushes/trees!
                end
            
                -- Apply fatigue increase (higher = more tired)
                stats.Fatigue = math.min(1.0, fatigue + drainAmount)
            end
        end
        
        -- Calculate speed multiplier based on terrain type
        -- These values come from RB42_RollerbladesShared.lua config
        local speedMult = 1.0
        
        -- Check if wheels are destroyed — no speed bonus with busted wheels
        local md = rbItem:getModData()
        if md and md.rb_wheels ~= nil and md.rb_wheels <= 0 then
            speedMult = 1.0  -- Normal speed, wheels are gone
        elseif terrain == "blocked" then
            speedMult = RB42.Config.SpeedBlocked   -- 0.30x (70% slower pushing through bushes/trees!)
        elseif terrain == "hard" then
            speedMult = RB42.Config.SpeedHard      -- 1.25x (25% faster on pavement)
        elseif terrain == "soft" then
            speedMult = RB42.Config.SpeedSoft      -- 1.00x (normal speed on grass)
        elseif terrain == "stairs" then
            speedMult = RB42.Config.SpeedStairs    -- 0.50x (50% slower on stairs)
        end
        
        -- ANIMATION SPEED UPDATE SYSTEM
        -- Set speed variables every frame. The anim XMLs read RollerbladesWalkSpeed
        -- and RollerbladesRunSpeed via m_SpeedScale, and RollerbladesSpeed via m_Scalar.
        -- We update both the per-mode speed AND the base scalar to ensure
        -- the animation system picks up changes whether it reads on entry or per-frame.
        
        player:setVariable("RollerbladesActive", true)
        player:setVariable("RollerbladesWalkSpeed", speedMult)
        player:setVariable("RollerbladesRunSpeed", speedMult)
        player:setVariable("RollerbladesSpeed", speedMult)
        
-- REAL movement speed (not just animation)
local pmd = player:getModData()
if pmd.rb42_baseSpeedMod == nil then
    pmd.rb42_baseSpeedMod = player:getSpeedMod() -- remember what it was before skates
end
player:setSpeedMod(pmd.rb42_baseSpeedMod * speedMult)
-- print("RB42 setSpeedMod ->", player:getSpeedMod())

local square = player:getCurrentSquare()
local floor = square and square:getFloor()
local sprite = floor and floor:getSprite()
local spriteName = sprite and sprite:getName() or "NO_SPRITE"

-- print("RB42 floor=", spriteName, " speedMult=", speedMult)
-- REAL movement speed (not just animation)




        if speedMult ~= lastSpeedMult or not wasWearing then
            lastSpeedMult = speedMult
            print("[RB42] Speed updated to: " .. speedMult .. "x")
        end
        
        -- Log terrain changes for debugging
        if terrain ~= lastTerrain then
            print("[RB42] Terrain: " .. terrain .. " | Speed: " .. speedMult .. "x")
            lastTerrain = terrain
        end
        
        -- First time equipping rollerblades
        if not wasWearing then
            print("[RB42] Rollerblades ON")
            wasWearing = true
        end
    else
        -- Player is NOT wearing rollerblades - reset everything
        player:setVariable("RollerbladesActive", false)
        player:setVariable("RollerbladesWalkSpeed", 1.0)
        player:setVariable("RollerbladesRunSpeed", 1.0)
        player:setVariable("RollerbladesSpeed", 1.0)
        
        -- Just took off rollerblades
        if wasWearing then
            print("[RB42] Rollerblades OFF")
            wasWearing = false
            lastTerrain = nil
            lastSpeedMult = nil
            stairsTimer = 0
            lastFallCheck = 0
            xpAccumulator = 0  -- Reset XP timer
            wearAccumulator = 0  -- Reset wear timer
            wheelsBlown = false  -- Reset wheels state
        end
    end
end)

print("[RB42 SpeedClient] Loaded with terrain detection and stairs fall system")

print("[RB42 SpeedClient] Loaded with terrain detection")


