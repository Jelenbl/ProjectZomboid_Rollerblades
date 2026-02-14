require "ISUI/ISInventoryPaneContextMenu"
require "RB42_RollerbladesShared"

local function isRB(item)
  return item and item.getFullType and item:getFullType() == "Rollerblades42.Rollerblades"
end

local function countItem(inv, fullType)
  return inv:getCountTypeRecurse(fullType)
end

local function doReplaceWheels(playerObj, inv, rbItem)
  print("[RB42] Replace wheels called")
  if isClient() then
    sendClientCommand(playerObj, "RB42", "ReplaceWheels", { rbId = rbItem:getID() })
  else
    if countItem(inv, "Base.Screwdriver") <= 0 or countItem(inv, "Rollerblades42.RollerbladeWheels") <= 0 then return end
    local wheel = inv:FindAndReturn("Rollerblades42.RollerbladeWheels")
    if wheel then inv:Remove(wheel) end
    local md = rbItem:getModData()
    if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
    md.rb_wheels = RB42.Config.WheelsMax
    playerObj:Say("Replaced rollerblade wheels!")
  end
end

local function doCleanWheels(playerObj, inv, rbItem)
  print("[RB42] Clean wheels called")
  if isClient() then
    sendClientCommand(playerObj, "RB42", "CleanWheels", { rbId = rbItem:getID() })
  else
    if countItem(inv, "Base.Toothbrush") <= 0 or countItem(inv, "Base.WaterBottle") <= 0 or countItem(inv, "Base.DishCloth") <= 0 then return end
    local cloth = inv:FindAndReturn("Base.DishCloth")
    if cloth then inv:Remove(cloth) end
    local waterBottle = inv:FindAndReturn("Base.WaterBottle")
    if waterBottle and waterBottle.getUsedDelta then
      waterBottle:setUsedDelta(waterBottle:getUsedDelta() - 0.1)
      if waterBottle:getUsedDelta() <= 0 then inv:Remove(waterBottle) end
    end
    local md = rbItem:getModData()
    if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
    md.rb_wheels = math.min(RB42.Config.WheelsMax, md.rb_wheels + 8)
    playerObj:Say("Cleaned rollerblade wheels!")
  end
end

local function onFillInventoryContextMenu(player, context, items)
  local playerObj = getSpecificPlayer(player)
  if not playerObj then return end
  local inv = playerObj:getInventory()
  local rbItem = nil
  for _, v in ipairs(items) do
    local it = v.items and v.items[1] or v
    if it and isRB(it) then rbItem = it break end
  end
  if not rbItem then return end
  local infoOpt = context:addOption("Speed Boost Info", nil, nil)
  infoOpt.notAvailable = true
  local tooltip = ISToolTip:new()
  tooltip:initialise()
  tooltip:setVisible(false)
  
  -- Get durability info
  local md = rbItem:getModData()
  if md.rb_wheels == nil then md.rb_wheels = RB42.Config.WheelsMax end
  if md.rb_boots == nil then md.rb_boots = RB42.Config.BootsMax end
  local wheelsPct = math.floor((md.rb_wheels / RB42.Config.WheelsMax) * 100)
  local bootsPct = math.floor((md.rb_boots / RB42.Config.BootsMax) * 100)
  
  local desc = "Hard surfaces: +25%\nGrass/carpet: Normal\nStairs: -50% (risk of falling!)\nVegetation: -70%"
  desc = desc .. "\n\nWheels: " .. wheelsPct .. "%"
  desc = desc .. "\nBoots: " .. bootsPct .. "%"
  if wheelsPct <= 0 then
      desc = desc .. "\n\n** WHEELS DESTROYED - No speed bonus! **"
  end
  tooltip.description = desc
  infoOpt.toolTip = tooltip
  context:addOption("", nil, nil).notAvailable = true
  local hasWheels = countItem(inv, "Rollerblades42.RollerbladeWheels") > 0
  local hasScrewdriver = countItem(inv, "Base.Screwdriver") > 0
  local opt1 = context:addOption("Replace Rollerblade Wheels", playerObj, doReplaceWheels, inv, rbItem)
  opt1.notAvailable = not (hasWheels and hasScrewdriver)
  local hasToothbrush = countItem(inv, "Base.Toothbrush") > 0
  local hasWaterBottle = countItem(inv, "Base.WaterBottle") > 0
  local hasDishCloth = countItem(inv, "Base.DishCloth") > 0
  local opt2 = context:addOption("Clean Rollerblade Wheels", playerObj, doCleanWheels, inv, rbItem)
  opt2.notAvailable = not (hasToothbrush and hasWaterBottle and hasDishCloth)
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)