# Rollerblades Mod for Project Zomboid Build 42

A fully-featured mod that adds functional rollerblades to Project Zomboid with terrain-based speed mechanics, skill progression, and maintenance systems.

## Features

### Dynamic Speed System
- **Hard surfaces** (concrete, asphalt, indoor floors, streets): **+25% speed boost**
- **Soft surfaces** (grass, vegetation, carpet): **Normal speed**
- **Stairs**: **-50% speed** (dangerous!)
- **Blocked** (trees, bushes, hedges): **-70% speed** — pushing through vegetation is brutal

### Stairs Danger System
- **Fall risk**: 8% chance per second on stairs (20% when running)
- **Minor injuries**: 1-4 damage to limbs, rare fractures (2% chance)
- **Nimble skill reduces falls**: Each level reduces fall chance by 1% (max 10% reduction)
- **Heavy inventory** (+5% fall chance when carrying >20 weight)

### Skill Progression
- **Fitness XP**: Gain +0.25 XP per minute of skating (any terrain)
- **Nimble XP**: Gain +1 XP per minute of skating on stairs
- **Only while moving** — standing still doesn't grant XP

### Fatigue System
- **Increased fatigue** while skating:
  - Walking: 0.01 drain per tick (significantly more than normal)
  - Running: 0.015 drain per tick (very exhausting)
  - Stairs: additional 1.75x multiplier on top
  - Blocked terrain: additional 2.5x multiplier on top

### Maintenance System
- **Replace Wheels**: Right-click → Requires Screwdriver + Rollerblade Wheels
- **Clean Wheels**: (25%) Right-click → Requires Toothbrush + Water Bottle + Dish Cloth + Screwdriver

### Visual Feedback
- **Context menu info**: Speed boost information tooltip
- **Character says**: "Replaced rollerblade wheels!" / "Cleaned rollerblade wheels!"

## Items

### Rollerblades
- **Type**: Clothing (Shoes slot)
- **Weight**: 1.3
- **Speed Modifier**: +25% run speed (base, on hard terrain)
- **Protection**: 100 scratch defense, 100 bite defense
- **Durability**: Boots (60 max), Wheels (30 max)

### Rollerblade Wheels
- **Type**: Crafting item
- **Weight**: 0.3
- **Use**: Replace worn wheels on rollerblades

## How to Use

### Getting Started
1. **Find rollerblades naturally**:
   - **Sport stores** (most common)
   - **Clothing stores** (shoes section)
   - **Homes** (wardrobes, closets, especially kid's rooms)
   - **Garages/sheds** (rare, old rollerblades)
   - **Gym lockers**
2. **OR spawn them**: `/additem Rollerblades42.Rollerblades`
3. **Equip them** in your Shoes slot
4. **Skate around!** Speed varies by terrain

### Finding Wheels
- **Sport stores** (accessories section)
- **Hardware stores** (replacement parts)
- **Garages** (spare parts)
- **Closets** (sports equipment storage)

### Skating Tips
- **Best on**: Roads, parking lots, indoor floors, sidewalks
- **Slower on**: Grass, dirt, carpet
- **Avoid**: Trees and bushes (nearly impassable!)
- **Dangerous on**: Stairs (high fall risk!)

### Maintenance
1. **Right-click** rollerblades in inventory
2. **Replace Wheels**: Use when worn (needs Screwdriver + Wheels)
3. **Clean Wheels**: Restores some durability (needs Toothbrush + Water + Cloth)

### Loot Locations

**Rollerblades** can be found in:
- 🏅 **Sport stores** (shoes section) — Most common (8-10% spawn rate)
- 👕 **Clothing stores** (shoes/sneakers) — Common (2-4%)
- 🏠 **Homes** — Uncommon:
  - Wardrobes (0.8%, kids wardrobes 1.5%)
  - Sports closets (2%)
  - Shoe closets (0.5%)
- 🏋️ **Gym lockers** — Uncommon (2%)
- 🔧 **Garages/sheds** — Rare (0.2-0.3%)

**Rollerblade Wheels** can be found in:
- 🏅 **Sport stores** (accessories) — Most common (6-10%)
- 🔨 **Hardware stores** (accessories/misc) — Common (2-3%)
- 🔧 **Garages** (tools/mechanics) — Uncommon (1.5-2%)
- 📦 **Sports closets/crates** — Uncommon (2-3%)
- 🏚️ **Sheds** — Rare (1.5%)

## Technical Details

### Animation System
Uses custom animation XMLs (`walk_rollerblades.xml`, `run_rollerblades.xml`) with speed driven through `m_Scalar`:
- `RollerbladesActive` (bool) — Enables/disables custom rollerblade animations
- `RollerbladesSpeed` (float) — Speed multiplier applied per-frame via `m_Scalar`

### Terrain Detection
Client-side detection in priority order:
1. **Blocked**: Objects with tree/bush/hedge in name (word-boundary matched — won't false-positive on "street")
2. **Stairs**: `square:HasStairs()`
3. **Soft**: Vegetation sprite properties/names, carpet/rug floor tiles
4. **Hard** (default): Everything else (concrete, asphalt, indoor floors, streets)

### B42 API Notes
- Stats use **direct field access** (`stats.Fatigue`, `stats.Stress`, `stats.Panic`) — not getter/setter methods
- Speed is driven through animation `m_Scalar` (read per-frame) rather than `m_SpeedScale` (read on state entry)

## File Structure

```
Rollerblades42/
  42/
    mod.info                                    # Mod metadata
    media/
      AnimSets/player/
        movement/walk_rollerblades.xml          # Walk animation with speed scalar
        run/run_rollerblades.xml                # Run animation with speed scalar
      clothing/clothingItems/
        Shoes_Rollerblades.xml                  # Clothing visual definition
      lua/
        client/
          RB42_ContextMenu.lua                  # Right-click menu (Replace/Clean wheels)
          RB42_SpeedClient.lua                  # Terrain detection, speed, falls, XP, fatigue
          RB42_DebugDisplay.lua                 # Debug HUD overlay
          RB42_DebugItemListFix.lua             # B42 item list crash patch
        server/
          RB42_Distributions.lua                # Loot table entries
          RB42_RecipesServer.lua                # Clean wheels recipe callback
          RB42_RollerbladesServer.lua           # Server initialization
          RB42_ServerCommands.lua               # MP command handlers
          RB42_WheelsServer.lua                 # Replace wheels recipe callback
          RB42_WornTick.lua                     # Periodic durability init
        shared/
          RB42_RollerbladesShared.lua            # Config & shared utilities
      scripts/
        RB42_Items.txt                          # Item definitions
        RB42_Recipes.txt                        # Crafting recipes
      textures/ClothingItems/                   # Rollerblade textures
  README.md                                     # This file
```

## Configuration

Edit `42/media/lua/shared/RB42_RollerbladesShared.lua`:

```lua
RB42.Config = {
    SpeedHard    = 1.25,   -- Hard surfaces: 25% faster
    SpeedSoft    = 1.00,   -- Soft surfaces: normal speed
    SpeedStairs  = 0.50,   -- Stairs: 50% slower
    SpeedBlocked = 0.30,   -- Vegetation: 70% slower

    BootsMax  = 60,        -- Max boot durability
    WheelsMax = 30,        -- Max wheel durability
}
```

## Known Issues / TODO

- [ ] **`ClothingItem = Shoes_TrainerTINT`** in item script may skip custom `Shoes_Rollerblades.xml`
- [ ] Custom 3D rollerblade models

## Known Limitations

1. **Visual**: Rollerblades currently appear as trainers (vanilla shoe model)
2. **Multiplayer**: Tested in single-player; multiplayer should work via server commands
3. **Performance**: Updates every frame, optimized but monitor FPS

## Credits

- **Mod by**: GingerVitis55/bjelen; 
- **Build**: Project Zomboid Build 42

## License

Free to use and modify. Give credit if redistributing.

---

**Version**: 1.1
**Build**: 42+
**Multiplayer**: Should work
**Last Updated**: February 13, 2026
