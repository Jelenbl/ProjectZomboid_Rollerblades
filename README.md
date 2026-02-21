# Rollerblades Mod for Project Zomboid Build 42

A fully-featured mod that adds functional rollerblades to Project Zomboid with terrain-based speed mechanics, skill progression, and maintenance systems.

**Workshop ID:** 3665841859  
**Mod ID:** Rollerblades42

## Features

### Rollerblader Trait (NEW!)
A 3-point positive trait that gives you a head start on skating:
- **25% less endurance drain** while skating
- **50% less fall chance** on stairs and while attacking
- **20% slower durability loss** on wheels and boots
- **10% XP boost** to Fitness and Nimble while skating
- **Start with Rollerblades** — no need to find them!

### Dynamic Speed System
- **Hard surfaces** (concrete, asphalt, indoor floors, streets): _+25% speed boost_
- **Soft surfaces** (grass, vegetation, carpet): _25% speed_
- **Stairs**: _-70% speed_ (dangerous!)
- **Blocked** (trees, bushes, hedges): _-70% speed_ — pushing through vegetation is brutal

### Stairs Danger System
- **Fall risk:** 2% chance per second on stairs (12% when running)
- **Minor injuries:** 1-4 damage to limbs, rare fractures (2% chance)
- **Nimble skill reduces falls:** Each level reduces fall chance by 0.20% (max 2% reduction)
- **Heavy inventory:** (+5% fall chance when carrying >20 weight)

### Attack System
- **Fall risk:** 10% chance per Attack
- **Mitigation:** 1% reduction per nimble level

### Fall Injury System
- **Number of Injuries:** 1-2
- **Wound Severity:** 1-4
- **Fracture Chance:** 2%
- **Bleeding Chance:** 20%
- **Scratch Chance:** 40%

### Skill Progression
- **Fitness XP:** Gain +12 XP per minute of skating (any terrain)
- **Nimble XP:** Gain +4.8 XP per minute of skating on stairs
- **Trait XP Boost:** +10% XP if you have the Rollerblader trait
- **Only while moving** — standing still doesn't grant XP

### Endurance System
- **Increased endurance drain** while skating:
  - Walking: 0.0075 drain per tick (significantly more than normal)
  - Running: 0.005 drain per tick (very exhausting)
  - Stairs: additional 1.75x multiplier on top
  - Blocked terrain: additional 2.5x multiplier on top

### Noise System
Rollerblades now generate realistic movement noise that attracts nearby zombies. Noise scales with your speed and the surface you're skating on. Hard surfaces like concrete and asphalt are louder, while grass and dirt dampen the sound. Sneaking on wheels is possible but still noisier than regular footwear — plan your routes carefully.


| Movement | Normal | Rollerblade |
| -------- | ------ | ----------- |
| Walking  |   ~7   |      10     |
| Running  |   ~8   |      13     |
| Sprinting  |   ~11   |      15     |
| Sneaking  |   ~3   |      6     |
| Stairs  |   -   |      14     |
| Blocked  |   -   |      8     |


### Maintenance System
Actions are instant!
- **Replace Wheels:** Right-click → Requires Screwdriver + Rollerblade Wheels
- **Clean Wheels:** (25%) Right-click → Requires Toothbrush + Alcohol Wipes + Screwdriver

### Visual Feedback
- **Context menu info:** Speed boost information tooltip
- **Character says:** "Replaced rollerblade wheels!" / "Cleaned rollerblade wheels!"

## Items

### Rollerblades
- **Type:** Clothing (Shoes slot)
- **Weight:** 1.3
- **Speed Modifier:** +25% run speed (base, on hard terrain)
- **Protection:** 100 scratch defense, 100 bite defense
- **Durability:** Boots (60 max), Wheels (30 max)

### Rollerblade Wheels
- **Type:** Crafting item
- **Weight:** 0.3
- **Use:** Replace worn wheels on rollerblades

## How to Use

### Getting Started
1. **Find rollerblades naturally:**
   - **Sport stores** (most common)
   - **Clothing stores** (shoes section)
   - **Homes** (wardrobes, closets, especially kid's rooms)
   - **Garages/sheds** (rare, old rollerblades)
   - **Gym lockers**
2. **OR spawn them:** `/additem Rollerblades42.Rollerblades`
3. **Equip them** in your Shoes slot
4. **Skate around!** Speed varies by terrain

### Finding Wheels
- **Sport stores** (accessories section)
- **Hardware stores** (replacement parts)
- **Garages** (spare parts)
- **Closets** (sports equipment storage)

### Skating Tips
- **Best on:** Roads, parking lots, indoor floors, sidewalks
- **Slower on:** Grass, dirt, carpet
- **Avoid:** Trees and bushes (nearly impassable!)
- **Dangerous on:** Stairs (high fall risk!)

### Maintenance
1. Right-click rollerblades in inventory
2. Replace Wheels: Use when worn (needs Screwdriver + Wheels)
3. Clean Wheels: Restores some durability [25%] (needs Toothbrush + Screwdriver + Alcohol Wipes)

## Loot Locations

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

### Terrain Detection
1. **Blocked:** Objects with tree/bush/hedge in name (word-boundary matched — won't false-positive on "street")
2. **Stairs:** square:HasStairs()
3. **Soft:** Vegetation sprite properties/names, carpet/rug floor tiles
4. **Hard** (default): Everything else (concrete, asphalt, indoor floors, streets)

## Known Issues / TODO
- Custom 3D rollerblade models
- Designed for MP - untested though
- Complete Animation

## Known Limitations
- **Visual:** Rollerblades currently appear as trainers (vanilla shoe model)
- **Multiplayer:** Tested in single-player; multiplayer should work via server commands
- **Performance:** Updates every frame, optimized but monitor FPS

## Credits
- **Mod by:** GingerVitis55
- **Build:** Project Zomboid Build 42
- **Animation Assistance:** RedChili

---

**Version:** 1.3.1
**Build:** 42+
**Multiplayer:** Should work
**Last Updated:** February 20, 2026

---

## Changelog

### v1.3
- Added **Rollerblader Trait** (3 points):
  - 25% less endurance drain while skating
  - 50% less fall chance on stairs and while attacking
  - 20% slower durability loss on wheels and boots
  - 10% XP boost to Fitness and Nimble
  - Start with Rollerblades
- Removed "WIP" from mod name
- Decreased Fall Chance on stairs
- Added texture to strapped shoes (actual rollerblades to come)
- Added Animation of Skating while "Running" - to be improved upon
- Added Fall Chance While Attacking
- Added Noise Levels
- Fix Repair and Clean Wheels for MP
- Fix XP System for MP

### v1.3.1
- Added Animation
- Added Sandbox Config
- Removed logs
- Adjusted speed to account for animation

