-- RB42_SpeedClient.lua
-- Client-side speed modification for rollerblades using animation system
-- This file detects terrain and sets animation speed variables that the XML files read

print("[RB42 SpeedClient] ===== VERSION WITH NOISE SYSTEM - FEB 16 2026 =====")

require "RB42_RollerbladesShared"

print("[RB42 SpeedClient] Shared config loaded")

-- ============================================================
-- State tracking variables
-- ============================================================
local wasWearing = false
local lastTerrain = nil
local lastSpeedMult = nil
local stairsTimer = 0
local lastFallCheck = 0
local xpAccumulator = 0
local wearAccumulator = 0
local noiseAccumulator = 0
local wheelsBlown = false
local isAttacking = false

-- ============================================================
-- Utility: Check if player is wearing rollerblades
-- ============================================================
local function getWornRollerblades(player)
    local worn = player:getWornItems()
    if not worn then return nil end
    for i = 0, worn:size() - 1 do
        local item = worn:get(i):getItem()
        if item and item:getFullType() == "Rollerblades42.Rollerblades" then
            return item
        end
    end
    return nil
end

-- ============================================================
-- Utility: Detect terrain type under player
-- Returns: "blocked", "stairs", "soft", or "hard"
-- ============================================================
local function getTerrainType(player)
    if not player then return "hard" end

    local square = player:getCurrentSquare()
    if not square then return "hard" end

    -- Priority 0: Vegetation objects (trees, bushes) = blocked
    local objects = square:getObjects()
    if objects and objects:size() > 0 then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj then
                if obj.getObjectName then
                    local objName = tostring(obj:getObjectName()):lower()
                    if (objName:find("%f[%a]tree%f[%A]") or objName:find("%f[%a]tree$"))
                    or objName:find("bush") or objName:find("hedge") or objName:find("plant") then
                        return "blocked"
                    end
                end

                if obj.getSprite then
                    local sprite = obj:getSprite()
                    if sprite and sprite.getName then
                        local spriteName = tostring(sprite:getName()):lower()
                        if (spriteName:find("%f[%a]tree%f[%A]") or spriteName:find("%f[%a]tree$"))
                        or spriteName:find("bush") or spriteName:find("hedge") or spriteName:find("vegetation") then
                            return "blocked"
                        end
                    end
                end

                if obj.getTextureName then
                    local texName = tostring(obj:getTextureName()):lower()
                    if (texName:find("%f[%a]tree%f[%A]") or texName:find("%f[%a]tree$"))
                    or texName:find("bush") or texName:find("hedge") then
                        return "blocked"
                    end
                end
            end
        end
    end

    -- Priority 1: Stairs
    if square.HasStairs and square:HasStairs() then
        return "stairs"
    end

    -- Priority 2: Ground vegetation objects
    objects = square:getObjects()
    if objects and objects:size() > 0 then
        for i = 0, objects:size() - 1 do
            local obj = objects:get(i)
            if obj and obj.getSprite then
                local sprite = obj:getSprite()
                if sprite and sprite.getProperties then
                    local props = sprite:getProperties()
                    if props and props.Is then
                        if props:Is("vegitation") or props:Is("vegetation") then
                            return "soft"
                        end
                    end
                end

                if sprite and sprite.getName then
                    local name = tostring(sprite:getName()):lower()
                    if name:find("grass") or name:find("plant") or name:find("bush")
                    or name:find("vegetation") or name:find("natural") or name:find("helmock") then
                        return "soft"
                    end
                end
            end
        end
    end

    -- Priority 3: Floor tile
    if square.getFloor then
        local floor = square:getFloor()
        if floor and floor.getSprite then
            local sprite = floor:getSprite()
            if sprite and sprite.getName then
                local name = tostring(sprite:getName()):lower()

                if name:find("blends_natural") or name:find("natural") or name:find("grass") or name:find("dirt") then
                    return "soft"
                end

                if name:find("blends_street") or name:find("street") or name:find("asphalt") or name:find("concrete") then
                    return "hard"
                end

                if name:find("carpet") or name:find("rug") then
                    return "soft"
                end
            end
        end
    end

    return "hard"
end

-- ============================================================
-- Fall / injury system
-- (Defined BEFORE the functions that call it)
-- ============================================================
local function fallOnStairs(player)
    if not player then return end

    local bodyDamage = player:getBodyDamage()
    if not bodyDamage then return end

    player:getEmitter():playSound("PZ_Stumble")

    if player.setVariable then
        player:setVariable("BumpFallType", "pushedFront")
    end
    if player.setBumpType then
        player:setBumpType("stagger")
    end

    local bodyParts = {
        BodyPartType.ForeArm_L,
        BodyPartType.ForeArm_R,
        BodyPartType.Hand_L,
        BodyPartType.Hand_R,
        BodyPartType.UpperLeg_L,
        BodyPartType.UpperLeg_R,
        BodyPartType.LowerLeg_L,
        BodyPartType.LowerLeg_R,
        BodyPartType.Head
    }

    local numInjuries = ZombRand(1, 2)

    for i = 1, numInjuries do
        local randomPart = bodyParts[ZombRand(#bodyParts) + 1]
        local bodyPart = bodyDamage:getBodyPart(randomPart)

        if bodyPart then
            local woundSeverity = ZombRand(1, 4)
            bodyPart:AddDamage(woundSeverity)

            if ZombRand(100) < 2 then
                bodyPart:setFractureTime(ZombRand(30, 45))
            end

            if ZombRand(100) < 10 then
                bodyPart:setBleeding(true)
            end

            if ZombRand(100) < 40 then
                bodyPart:setScratched(true, false)
            end
        end
    end

    bodyDamage:setPainReduction(bodyDamage:getPainReduction() + ZombRand(2, 8))

    local stats = player:getStats()
    if stats then
        if stats.Stress ~= nil then
            stats.Stress = stats.Stress + 0.05
        end
        if stats.Panic ~= nil then
            stats.Panic = stats.Panic + 10
        end
    end
end

-- ============================================================
-- Subsystem: Stair fall chance
-- Uses outer stairsTimer/lastFallCheck via closure
-- ============================================================
local function checkStairFall(player)
    local fallChance = RB42.Config.fallChanceOnStairsCheck
    local nimbleLevel = player:getPerkLevel(Perks.Nimble)
    local nimbleReduction = math.min(nimbleLevel, 10) * RB42.Config.reductionPerNimbleLevelForStairs
    fallChance = fallChance - nimbleReduction

    if player:isRunning() then
        fallChance = fallChance + 12
    end

    local inventory = player:getInventory()
    if inventory and inventory:getCapacityWeight() > 20 then
        fallChance = fallChance + 5
    end

    if ZombRand(100) < fallChance then
        fallOnStairs(player)
        stairsTimer = 0
        lastFallCheck = 0
    end
end

-- ============================================================
-- Subsystem: Attack fall chance
-- ============================================================
local function checkAttackFall(player)
    local fallChance = RB42.Config.attackFallChancePerAttack
    local nimbleLevel = player:getPerkLevel(Perks.Nimble)
    local nimbleReduction = math.min(nimbleLevel, 10) * RB42.Config.reductionPerNimbleLevelForAttack
    fallChance = fallChance - nimbleReduction

    if ZombRand(100) < fallChance then
        fallOnStairs(player)
    end
end

-- ============================================================
-- Subsystem: XP gains
-- Uses outer xpAccumulator via closure
-- ============================================================
local function updateXP(player, terrain)
    xpAccumulator = xpAccumulator + 0.25

    if xpAccumulator >= 60.0 then
        local xpSystem = player:getXp()
        if not xpSystem then return end

        xpSystem:AddXP(Perks.Fitness, RB42.Config.FitnessXpPerTick)

        if terrain == "stairs" then
            xpSystem:AddXP(Perks.Nimble, RB42.Config.NimbleXpPerStairsTick)
        end

        xpAccumulator = 0
    end
end

-- ============================================================
-- Subsystem: Noise emission
-- Uses outer noiseAccumulator via closure
-- ============================================================
local function updateNoise(player, terrain)
    noiseAccumulator = noiseAccumulator + 0.25

    if noiseAccumulator >= 1.0 then
        -- Base noise from movement type
        local noiseRadius = RB42.Config.NoiseWalking

        if terrain == "stairs" then
            noiseRadius = RB42.Config.NoiseStairs
        elseif terrain == "blocked" then
            noiseRadius = RB42.Config.NoiseBlocked
        elseif player:isSprinting() then
            noiseRadius = RB42.Config.NoiseSprinting
        elseif player:isRunning() then
            noiseRadius = RB42.Config.NoiseRunning
        elseif player:isSneaking() then
            noiseRadius = RB42.Config.NoiseSneaking
        end

        -- Terrain surface modifier
        if terrain == "hard" then
            noiseRadius = noiseRadius * RB42.Config.NoiseTerrainHard
        elseif terrain == "soft" then
            noiseRadius = noiseRadius * RB42.Config.NoiseTerrainSoft
        end

        local noiseVolume = noiseRadius * RB42.Config.NoiseVolumeRatio

        player:addWorldSoundUnlessInvisible(
            math.floor(noiseRadius),
            math.floor(noiseVolume),
            false
        )

        noiseAccumulator = 0
    end
end

-- ============================================================
-- Subsystem: Durability wear
-- Uses outer wearAccumulator/wheelsBlown via closure
-- ============================================================
local function updateWear(player, rbItem, terrain)
    wearAccumulator = wearAccumulator + 0.25

    if wearAccumulator >= 10.0 then
        local md = rbItem:getModData()
        if md then
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
                wheelWear = RB42.Config.Wear.BlockedWheels
                bootWear = RB42.Config.Wear.BlockedBoots
            end

            md.rb_wheels = RB42.Clamp((md.rb_wheels or RB42.Config.WheelsMax) - (wheelWear * 10), 0, RB42.Config.WheelsMax)
            md.rb_boots = RB42.Clamp((md.rb_boots or RB42.Config.BootsMax) - (bootWear * 10), 0, RB42.Config.BootsMax)

            if md.rb_wheels <= 0 and not wheelsBlown then
                wheelsBlown = true
                fallOnStairs(player)
                if player.Say then
                    player:Say("My rollerblade wheels are shot!")
                end
            end
        end

        wearAccumulator = 0
    end
end

-- ============================================================
-- Subsystem: Endurance drain
-- ============================================================
local function updateEndurance(player, terrain)
    local stats = player:getStats()
    if not stats or stats.Fatigue == nil then return end

    local drainAmount = 0

    if player:isRunning() then
        drainAmount = 0.015
    else
        drainAmount = 0.01
    end

    if terrain == "stairs" then
        drainAmount = drainAmount * 1.75
    elseif terrain == "blocked" then
        drainAmount = drainAmount * 2.5
    end

    stats.Fatigue = math.min(1.0, stats.Fatigue + drainAmount)
end

-- ============================================================
-- MAIN UPDATE LOOP
-- ============================================================
Events.OnPlayerUpdate.Add(function(player)
    if not player then return end
    if player:isDead() then return end

    local rbItem = getWornRollerblades(player)

    if rbItem then
        RB42.GetOrInitDurability(rbItem)
        if not player or player:isDead() then return end

        local terrain = getTerrainType(player)
        if not player or player:isDead() then return end

        -- STAIRS FALL CHECK
        if terrain == "stairs" then
            stairsTimer = stairsTimer + 1
            if stairsTimer - lastFallCheck >= 30 then
                lastFallCheck = stairsTimer
                checkStairFall(player)
            end
        else
            stairsTimer = 0
            lastFallCheck = 0
        end

        -- ATTACK FALL CHECK
        if player:isAttacking() and not isAttacking then
            isAttacking = true
            checkAttackFall(player)
        end
        if not player:isAttacking() then
            isAttacking = false
        end

        -- IS PLAYER ACTUALLY MOVING?
        local isActuallyMoving = player:isMoving() and
            (player:getX() ~= player:getLastX() or player:getY() ~= player:getLastY())

        if isActuallyMoving then
            updateXP(player, terrain)
            updateNoise(player, terrain)
            updateWear(player, rbItem, terrain)
            updateEndurance(player, terrain)
        else
            xpAccumulator = 0
            wearAccumulator = 0
            noiseAccumulator = 0
        end

        -- SPEED MULTIPLIER
        local speedMult = 1.0

        local md = rbItem:getModData()
        if md and md.rb_wheels ~= nil and md.rb_wheels <= 0 then
            speedMult = 1.0
        elseif terrain == "blocked" then
            speedMult = RB42.Config.SpeedBlocked
        elseif terrain == "hard" then
            speedMult = RB42.Config.SpeedHard
        elseif terrain == "soft" then
            speedMult = RB42.Config.SpeedSoft
        elseif terrain == "stairs" then
            speedMult = RB42.Config.SpeedStairs
        end

        -- ANIMATION SPEED
        player:setVariable("RollerbladesActive", true)
        player:setVariable("RollerbladesWalkSpeed", speedMult)
        player:setVariable("RollerbladesRunSpeed", speedMult)
        player:setVariable("RollerbladesSpeed", speedMult)

        -- REAL MOVEMENT SPEED
        local pmd = player:getModData()
        if pmd.rb42_baseSpeedMod == nil then
            pmd.rb42_baseSpeedMod = player:getSpeedMod()
        end
        player:setSpeedMod(pmd.rb42_baseSpeedMod * speedMult)

        if speedMult ~= lastSpeedMult or not wasWearing then
            lastSpeedMult = speedMult
        end

        if terrain ~= lastTerrain then
            lastTerrain = terrain
        end

        if not wasWearing then
            wasWearing = true
        end
    else
        -- NOT WEARING ROLLERBLADES
        player:setVariable("RollerbladesActive", false)
        player:setVariable("RollerbladesWalkSpeed", 1.0)
        player:setVariable("RollerbladesRunSpeed", 1.0)
        player:setVariable("RollerbladesSpeed", 1.0)

        if wasWearing then
            wasWearing = false
            lastTerrain = nil
            lastSpeedMult = nil
            stairsTimer = 0
            lastFallCheck = 0
            xpAccumulator = 0
            wearAccumulator = 0
            noiseAccumulator = 0
            wheelsBlown = false
            isAttacking = false
        end
    end
end)

print("[RB42 SpeedClient] Loaded with terrain detection, stairs fall system, and noise system")