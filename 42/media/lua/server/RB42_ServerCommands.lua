require "RB42_RollerbladesShared"

print("[RB42 ServerCommands] ===== SERVER addXp() VERSION - FEB 18 2026 =====")

local function getPlayerByOnlineID(id)
  for i=0,getNumActivePlayers()-1 do
    local p = getSpecificPlayer(i)
    if p and p:getOnlineID() == id then return p end
  end
  return nil
end

local function findItemByIdInInventory(inv, id)
  -- searches inventory recursively for item with matching ID
  local items = inv:getItems()
  for i=0, items:size()-1 do
    local it = items:get(i)
    if it and it.getID and it:getID() == id then return it end
    if it and it.getInventory and it:getInventory() then
      local sub = findItemByIdInInventory(it:getInventory(), id)
      if sub then return sub end
    end
  end
  return nil
end

local function findItemById(playerObj, id)
  -- First check main inventory by ID
  local inv = playerObj:getInventory()
  local item = findItemByIdInInventory(inv, id)
  if item then return item end

  -- Check worn items by ID
  local worn = playerObj:getWornItems()
  if worn then
    for i = 0, worn:size() - 1 do
      local it = worn:get(i):getItem()
      if it and it.getID and it:getID() == id then return it end
    end
  end

  -- Fallback: Find by type (in case item IDs don't match between client/server)
  -- Check inventory first
  local rbInInv = inv:getFirstTypeRecurse("Rollerblades42.Rollerblades")
  if rbInInv then
    print("[RB42 ServerCommands] Found rollerblades by type in inventory (ID fallback)")
    return rbInInv
  end

  -- Check worn items by type
  if worn then
    for i = 0, worn:size() - 1 do
      local it = worn:get(i):getItem()
      if it and it:getFullType() == "Rollerblades42.Rollerblades" then
        print("[RB42 ServerCommands] Found rollerblades by type in worn items (ID fallback)")
        return it
      end
    end
  end

  return nil
end

local function consumeOne(inv, fullType)
  local it = inv:FindAndReturn(fullType)
  if it then inv:Remove(it) return true end
  return false
end

local function onClientCommand(module, command, playerObj, args)
  print("[RB42 ServerCommands] onClientCommand called - module: " .. tostring(module) .. ", command: " .. tostring(command))
  if module ~= "RB42" then return end
  if not playerObj then return end

  -- Handle RequestXP command - use vanilla addXp() on server (MP authoritative)
  if command == "RequestXP" then
    if args then
      local fitnessXp = args.fitnessXp or 0
      local nimbleXp = args.nimbleXp or 0

      print("[RB42 ServerCommands] Using addXp() on SERVER - fitness: " .. tostring(fitnessXp) .. ", nimble: " .. tostring(nimbleXp))

      -- addXp() is the vanilla global function used in shared code
      -- It handles MP sync via AddXp network packet
      if fitnessXp > 0 then
        addXp(playerObj, Perks.Fitness, fitnessXp)
        -- print("[RB42 ServerCommands] Server addXp() Fitness: " .. tostring(fitnessXp))
      end
      if nimbleXp > 0 then
        addXp(playerObj, Perks.Nimble, nimbleXp)
        -- print("[RB42 ServerCommands] Server addXp() Nimble: " .. tostring(nimbleXp))
      end
    end
    return
  end

  -- Handle UpdateWear command - apply durability wear on server (MP authoritative)
  if command == "UpdateWear" then
    if args and args.rbId then
      local rb = findItemById(playerObj, args.rbId)
      if rb then
        local md = RB42.GetOrInitDurability(rb)
        local wheelWear = args.wheelWear or 0
        local bootWear = args.bootWear or 0

        -- print("[RB42 ServerCommands] UpdateWear on SERVER - wheels: " .. tostring(wheelWear) .. ", boots: " .. tostring(bootWear))

        md.rb_wheels = RB42.Clamp((md.rb_wheels or RB42.Config.WheelsMax) - wheelWear, 0, RB42.Config.WheelsMax)
        md.rb_boots = RB42.Clamp((md.rb_boots or RB42.Config.BootsMax) - bootWear, 0, RB42.Config.BootsMax)

        -- print("[RB42 ServerCommands] New durability - wheels: " .. tostring(md.rb_wheels) .. ", boots: " .. tostring(md.rb_boots))
      end
    end
    return
  end

  -- Commands below require rbId
  if not args or not args.rbId then
    return
  end

  -- print("[RB42 ServerCommands] Processing command for rbId: " .. tostring(args.rbId))

  local inv = playerObj:getInventory()
  local rb = findItemById(playerObj, args.rbId)
  if not rb then
    print("[RB42 ServerCommands] Could not find item with ID: " .. tostring(args.rbId))
    return
  end
  -- print("[RB42 ServerCommands] Found item: " .. tostring(rb:getFullType()))

  -- init durability
  local md = RB42.GetOrInitDurability(rb)

  if command == "ReplaceWheels" then
    -- print("[RB42] ReplaceWheels command received for item ID: " .. tostring(args.rbId))
    -- print("[RB42] Current wheel durability: " .. tostring(md.rb_wheels))

    if inv:getCountTypeRecurse("Base.Screwdriver") <= 0 then
      print("[RB42] No screwdriver found")
      return
    end
    if inv:getCountTypeRecurse("Rollerblades42.RollerbladeWheels") <= 0 then
      print("[RB42] No wheels found")
      return
    end

    local consumed = consumeOne(inv, "Rollerblades42.RollerbladeWheels")
    -- print("[RB42] Wheel item consumed: " .. tostring(consumed))

    md.rb_wheels = RB42.Config.WheelsMax
    -- print("[RB42] Set wheel durability to: " .. tostring(md.rb_wheels))

    -- print("[RB42] Wheels replaced! Final durability: " .. tostring(rb:getModData().rb_wheels))
    playerObj:Say("Replaced rollerblade wheels!")
    return
  end

  if command == "CleanWheels" then
    -- print("[RB42] CleanWheels command received for item ID: " .. tostring(args.rbId))
    -- print("[RB42] Current wheel durability: " .. tostring(md.rb_wheels))

    if inv:getCountTypeRecurse("Base.Screwdriver") <= 0 then
      print("[RB42] No screwdriver found")
      return
    end
    if inv:getCountTypeRecurse("Base.Toothbrush") <= 0 then
      print("[RB42] No toothbrush found")
      return
    end
    if inv:getCountTypeRecurse("Base.AlcoholWipes") <= 0 then
      print("[RB42] No alcohol wipes found")
      return
    end

    -- Consume AlcoholWipes (used up), keep Screwdriver and Toothbrush
    local consumed = consumeOne(inv, "Base.AlcoholWipes")
    -- print("[RB42] AlcoholWipes consumed: " .. tostring(consumed))

    -- Cleaning restores some wheels durability
    md.rb_wheels = math.min(RB42.Config.WheelsMax, (md.rb_wheels or RB42.Config.WheelsMax) + 8)
    -- print("[RB42] Set wheel durability to: " .. tostring(md.rb_wheels))

    -- print("[RB42] Wheels cleaned! Final durability: " .. tostring(rb:getModData().rb_wheels))
    playerObj:Say("Cleaned rollerblade wheels!")
    return
  end
end

Events.OnClientCommand.Add(onClientCommand)

print("[RB42 ServerCommands] Loaded and registered OnClientCommand handler")
