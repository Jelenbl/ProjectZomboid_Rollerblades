require "Items/Distributions"
require "Items/ProceduralDistributions"

-- RB42 Loot Distribution System
-- Adds rollerblades and wheels to various containers in the world

print("[RB42 Distributions] Loading loot tables...")

local function addToDistribution(distTable, containerName, itemType, weight)
    if distTable[containerName] and distTable[containerName].items then
        table.insert(distTable[containerName].items, itemType)
        table.insert(distTable[containerName].items, weight)
    end
end

local function addToProceduralDistribution(listName, itemType, weight)
    if ProceduralDistributions.list[listName] then
        table.insert(ProceduralDistributions.list[listName].items, itemType)
        table.insert(ProceduralDistributions.list[listName].items, weight)
    end
end

-- === ROLLERBLADES SPAWNING ===

-- SPORT STORES (Most Common)
addToDistribution(SuburbsDistributions, "SportStoreShoes", "Rollerblades42.Rollerblades", 8)
addToProceduralDistribution("SportStoreSneakers", "Rollerblades42.Rollerblades", 8)
addToProceduralDistribution("SportStoreShoes", "Rollerblades42.Rollerblades", 10)

-- CLOTHING STORES (Common)
addToProceduralDistribution("ClothingStoresShoes", "Rollerblades42.Rollerblades", 4)
addToProceduralDistribution("ClothingStoresWoman", "Rollerblades42.Rollerblades", 2)
addToProceduralDistribution("ClothingStoresMan", "Rollerblades42.Rollerblades", 2)

-- HOMES - Wardrobes (Uncommon)
addToDistribution(SuburbsDistributions, "WardrobeMan", "Rollerblades42.Rollerblades", 0.8)
addToDistribution(SuburbsDistributions, "WardrobeWoman", "Rollerblades42.Rollerblades", 0.8)
addToDistribution(SuburbsDistributions, "WardrobeChild", "Rollerblades42.Rollerblades", 1.5)
addToProceduralDistribution("WardrobeChild", "Rollerblades42.Rollerblades", 1.5)

-- HOMES - Closets (Uncommon)
addToDistribution(SuburbsDistributions, "ClosetShoes", "Rollerblades42.Rollerblades", 0.5)
addToDistribution(SuburbsDistributions, "ClosetSports", "Rollerblades42.Rollerblades", 2)

-- STORAGE/SHEDS (Rare - old/forgotten rollerblades)
addToDistribution(SuburbsDistributions, "GarageTools", "Rollerblades42.Rollerblades", 0.3)
addToDistribution(SuburbsDistributions, "ShedTools", "Rollerblades42.Rollerblades", 0.2)
addToProceduralDistribution("GarageFireman", "Rollerblades42.Rollerblades", 0.5)
addToProceduralDistribution("CrateSports", "Rollerblades42.Rollerblades", 1)

-- LOCKERS (Uncommon - gym/school lockers)
addToProceduralDistribution("GymLockers", "Rollerblades42.Rollerblades", 2)
addToProceduralDistribution("Locker", "Rollerblades42.Rollerblades", 0.3)

-- STORES - Display/Stock
addToProceduralDistribution("StoreShelfCombo", "Rollerblades42.Rollerblades", 0.1)
addToProceduralDistribution("CrateClothesRandom", "Rollerblades42.Rollerblades", 0.5)


-- === ROLLERBLADE WHEELS SPAWNING ===

-- SPORT STORES (Most Common)
addToDistribution(SuburbsDistributions, "SportStoreAccessories", "Rollerblades42.RollerbladeWheels", 10)
addToProceduralDistribution("SportStoreSneakers", "Rollerblades42.RollerbladeWheels", 6)
addToProceduralDistribution("SportStoreShoes", "Rollerblades42.RollerbladeWheels", 8)

-- HARDWARE STORES (Common - replacement parts)
addToProceduralDistribution("ToolStoreAccessories", "Rollerblades42.RollerbladeWheels", 3)
addToProceduralDistribution("ToolStoreMisc", "Rollerblades42.RollerbladeWheels", 2)

-- GARAGES (Uncommon - spare parts)
addToDistribution(SuburbsDistributions, "GarageTools", "Rollerblades42.RollerbladeWheels", 2)
addToDistribution(SuburbsDistributions, "GarageMechanics", "Rollerblades42.RollerbladeWheels", 1.5)
addToProceduralDistribution("GarageFireman", "Rollerblades42.RollerbladeWheels", 1)

-- CLOSETS/STORAGE (Rare)
addToDistribution(SuburbsDistributions, "ClosetSports", "Rollerblades42.RollerbladeWheels", 3)
addToProceduralDistribution("CrateSports", "Rollerblades42.RollerbladeWheels", 2)

-- SHEDS (Rare)
addToDistribution(SuburbsDistributions, "ShedTools", "Rollerblades42.RollerbladeWheels", 1.5)

-- CRATES (Rare - shipping/stock)
addToProceduralDistribution("CrateTools", "Rollerblades42.RollerbladeWheels", 1)
addToProceduralDistribution("CrateMechanics", "Rollerblades42.RollerbladeWheels", 0.8)

print("[RB42 Distributions] Loot tables loaded successfully!")
print("[RB42 Distributions] Rollerblades will spawn in: Sport stores, clothing stores, homes")
print("[RB42 Distributions] Wheels will spawn in: Sport stores, hardware stores, garages")
