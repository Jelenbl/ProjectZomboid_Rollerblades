require "ISUI/ISInventoryPaneContextMenu"
require "RB42_RollerbladesShared"
require "RB42_WheelActions"

local function isRB(item)
  return item and item.getFullType and item:getFullType() == "Rollerblades42.Rollerblades"
end

local function countItem(inv, fullType)
  return inv:getCountTypeRecurse(fullType)
end

local function doReplaceWheels(playerObj, rbItem)
  print("[RB42] Replace wheels - queuing TimedAction")
  ISTimedActionQueue.add(ISReplaceRollerbladesWheels:new(playerObj, rbItem, 50))
end

local function doCleanWheels(playerObj, rbItem)
  print("[RB42] Clean wheels - queuing TimedAction")
  ISTimedActionQueue.add(ISCleanRollerbladesWheels:new(playerObj, rbItem, 50))
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
  local opt1 = context:addOption("Replace Rollerblade Wheels", playerObj, doReplaceWheels, rbItem)
  opt1.notAvailable = not (hasWheels and hasScrewdriver)
  local replaceTooltip = ISToolTip:new()
  replaceTooltip:initialise()
  replaceTooltip.description = "<b>Requires:</b>\n- Rollerblade Wheels (consumed)\n- Screwdriver (kept)"
  opt1.toolTip = replaceTooltip

  local hasToothbrush = countItem(inv, "Base.Toothbrush") > 0
  local hasAlcoholWipes = countItem(inv, "Base.AlcoholWipes") > 0
  local opt2 = context:addOption("Clean Rollerblade Wheels", playerObj, doCleanWheels, rbItem)
  opt2.notAvailable = not (hasScrewdriver and hasToothbrush and hasAlcoholWipes)
  local cleanTooltip = ISToolTip:new()
  cleanTooltip:initialise()
  cleanTooltip.description = "<b>Requires:</b>\n- Screwdriver (kept)\n- Toothbrush (kept)\n- AlcoholWipes (consumed)"
  opt2.toolTip = cleanTooltip
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)