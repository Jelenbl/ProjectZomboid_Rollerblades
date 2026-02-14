require "RB42_RollerbladesShared"

print("[RB42 ServerCommands] Starting to load...")

local function getPlayerByOnlineID(id)
  for i=0,getNumActivePlayers()-1 do
    local p = getSpecificPlayer(i)
    if p and p:getOnlineID() == id then return p end
  end
  return nil
end

local function findItemById(inv, id)
  -- searches inventory recursively for item with matching ID
  local items = inv:getItems()
  for i=0, items:size()-1 do
    local it = items:get(i)
    if it and it.getID and it:getID() == id then return it end
    if it and it.getInventory and it:getInventory() then
      local sub = findItemById(it:getInventory(), id)
      if sub then return sub end
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
  
  if module ~= "RB42" then 
    print("[RB42 ServerCommands] Module mismatch, ignoring")
    return 
  end
  
  if not playerObj or not args or not args.rbId then 
    print("[RB42 ServerCommands] Missing playerObj or args.rbId")
    return 
  end

  print("[RB42 ServerCommands] Processing command for rbId: " .. tostring(args.rbId))

  local inv = playerObj:getInventory()
  local rb = findItemById(inv, args.rbId)
  if not rb then return end

  -- init durability
  local md = RB42.GetOrInitDurability(rb)

  if command == "ReplaceWheels" then
    print("[RB42] ReplaceWheels command received for item ID: " .. tostring(args.rbId))
    
    if inv:getCountTypeRecurse("Base.Screwdriver") <= 0 then 
      print("[RB42] No screwdriver found")
      return 
    end
    if inv:getCountTypeRecurse("Rollerblades42.RollerbladeWheels") <= 0 then 
      print("[RB42] No wheels found")
      return 
    end

    consumeOne(inv, "Rollerblades42.RollerbladeWheels")
    md.rb_wheels = RB42.Config.WheelsMax
    
    print("[RB42] Wheels replaced! New durability: " .. md.rb_wheels)
    playerObj:Say("Replaced rollerblade wheels!")
    return
  end

  if command == "CleanWheels" then
    print("[RB42] CleanWheels command received for item ID: " .. tostring(args.rbId))
    
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
    consumeOne(inv, "Base.AlcoholWipes")

    -- Cleaning restores some wheels durability
    md.rb_wheels = math.min(RB42.Config.WheelsMax, (md.rb_wheels or RB42.Config.WheelsMax) + 8)
    
    print("[RB42] Wheels cleaned! New durability: " .. md.rb_wheels)
    playerObj:Say("Cleaned rollerblade wheels!")
    return
  end
end

Events.OnClientCommand.Add(onClientCommand)

print("[RB42 ServerCommands] Loaded and registered OnClientCommand handler")
