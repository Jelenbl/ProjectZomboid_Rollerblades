[b][u]Rollerblades Mod for Project Zomboid Build 42[/u][/b]

A fully-featured mod that adds functional rollerblades to Project Zomboid with terrain-based speed mechanics, skill progression, and maintenance systems.

[b]Workshop ID:[/b] 3665841859
[b]Mod ID:[/b] Rollerblades42

[h1]Features[/h1]

[b]Rollerblader Trait (NEW!)[/b]
A 3-point positive trait that gives you a head start on skating:
[list]
[*][b]25% less fatigue drain[/b] while skating
[*][b]50% less fall chance[/b] on stairs and while attacking
[*][b]20% slower durability loss[/b] on wheels and boots
[*][b]10% XP boost[/b] to Fitness and Nimble while skating
[*][b]Start with Rollerblades[/b] — no need to find them!
[/list]

[b]Dynamic Speed System[/b]
[list]
[*][b]Hard surfaces[/b] (concrete, asphalt, indoor floors, streets): [color=green]+50% speed boost[/color]
[*][b]Soft surfaces[/b] (grass, vegetation, carpet): [color=orange]25% speed[/color]
[*][b]Stairs[/b]: [color=red]-70% speed[/color] (dangerous!)
[*][b]Blocked[/b] (trees, bushes, hedges): [color=red]-70% speed[/color] — pushing through vegetation is brutal
[/list]

[b]Stairs Danger System[/b]
[list]
[*][b]Fall risk[/b]: 2% chance per second on stairs (12% when running)
[*][b]Minor injuries[/b]: 1-4 damage to limbs, rare fractures (2% chance)
[*][b]Nimble skill reduces falls[/b]: Each level reduces fall chance by 0.20% (max 2% reduction)
[*][b]Heavy inventory[/b] (+5% fall chance when carrying >20 weight)
[/list]

[b]Attack System[/b]
[list]
[*][b]Fall risk[/b]: 10% chance per Attack
[*][b]Mitigation[/b]: 1% reduction per nimble level
[/list]

[b]Fall Injury System[/b]
[list]
[*][b]Number of Injuries[/b]: 1-2
[*][b]Wound Severity[/b]: 1-4
[*][b]Fracture Chance[/b]: 2%
[*][b]Bleeding Chance[/b]: 20%
[*][b]Scratch Chance[/b]: 40%
[/list]

[b]Skill Progression[/b]
[list]
[*][b]Fitness XP[/b]: Gain +0.25 XP per minute of skating (any terrain)
[*][b]Nimble XP[/b]: Gain +1 XP per minute of skating on stairs
[*][b]Trait XP Boost[/b]: +10% XP if you have the Rollerblader trait
[*][b]Only while moving[/b] — standing still doesn't grant XP
[/list]

[b]Fatigue System[/b]
[list]
[*][b]Increased fatigue[/b] while skating:
[list]
[*]Walking: 0.01 drain per tick (significantly more than normal)
[*]Running: 0.015 drain per tick (very exhausting)
[*]Stairs: additional 1.75x multiplier on top
[*]Blocked terrain: additional 2.5x multiplier on top
[/list]
[/list]


[b]Noise System[/b]

Rollerblades now generate realistic movement noise that attracts nearby zombies. 
Noise scales with your speed and the surface you're skating on. 
Hard surfaces like concrete and asphalt are louder, while grass and dirt dampen the sound. 
Sneaking on wheels is possible but still noisier than regular footwear — plan your routes carefully.


[table]
    [tr]
        [th]Movement[/th]
        [th]Normal[/th]
        [th]Rollerblade[/th]
    [/tr]
    [tr]
        [td]Walking[/td]
        [td]~7[/td]
        [td]10[/td]
    [/tr]
    [tr]
        [td]Running[/td]
        [td]~8[/td]
        [td]13[/td]
    [/tr]
    [tr]
        [td]Sprinting[/td]
        [td]~11[/td]
        [td]17[/td]
    [/tr]
    [tr]
        [td]Sneaking[/td]
        [td]~3[/td]
        [td]6[/td]
    [/tr]
    [tr]
        [td]Stairs[/td]
        [td]-[/td]
        [td]14[/td]
    [/tr]
    [tr]
        [td]Blocked[/td]
        [td]-[/td]
        [td]8[/td]
    [/tr]
[/table]



[b]Maintenance System[/b]

Actions are instant!

[list]
[*][b]Replace Wheels[/b]: Right-click → Requires Screwdriver + Rollerblade Wheels
[*][b]Clean Wheels[/b]: (25%) Right-click → Requires Toothbrush + Alcohol Wipes + Screwdriver
[/list]

[b]Visual Feedback[/b]
[list]
[*][b]Context menu info[/b]: Speed boost information tooltip
[*][b]Character says[/b]: "Replaced rollerblade wheels!" / "Cleaned rollerblade wheels!"
[/list]

[h1]Items[/h1]

[b]Rollerblades[/b]
[list]
[*][b]Type[/b]: Clothing (Shoes slot)
[*][b]Weight[/b]: 1.3
[*][b]Speed Modifier[/b]: +25% run speed (base, on hard terrain)
[*][b]Protection[/b]: 100 scratch defense, 100 bite defense
[*][b]Durability[/b]: Boots (60 max), Wheels (30 max)
[/list]

[b]Rollerblade Wheels[/b]
[list]
[*][b]Type[/b]: Crafting item
[*][b]Weight[/b]: 0.3
[*][b]Use[/b]: Replace worn wheels on rollerblades
[/list]

[h1]How to Use[/h1]

[b]Getting Started[/b]
[list=1]
[*][b]Find rollerblades naturally[/b]:
[list]
[*][b]Sport stores[/b] (most common)
[*][b]Clothing stores[/b] (shoes section)
[*][b]Homes[/b] (wardrobes, closets, especially kid's rooms)
[*][b]Garages/sheds[/b] (rare, old rollerblades)
[*][b]Gym lockers[/b]
[/list]
[*][b]OR spawn them[/b]: /additem Rollerblades42.Rollerblades
[*][b]Equip them[/b] in your Shoes slot
[*][b]Skate around![/b] Speed varies by terrain
[/list]

[b]Finding Wheels[/b]
[list]
[*][b]Sport stores[/b] (accessories section)
[*][b]Hardware stores[/b] (replacement parts)
[*][b]Garages[/b] (spare parts)
[*][b]Closets[/b] (sports equipment storage)
[/list]

[b]Skating Tips[/b]
[list]
[*][b]Best on[/b]: Roads, parking lots, indoor floors, sidewalks
[*][b]Slower on[/b]: Grass, dirt, carpet
[*][b]Avoid[/b]: Trees and bushes (nearly impassable!)
[*][b]Dangerous on[/b]: Stairs (high fall risk!)
[/list]

[b]Maintenance[/b]
[list=1]
[*]Right-click rollerblades in inventory
[*]Replace Wheels: Use when worn (needs Screwdriver + Wheels)
[*]Clean Wheels: Restores some durability[25%] (needs Toothbrush + Screwdriver + Alcohol Wipes)
[/list]

[h1]Loot Locations[/h1]

[b]Rollerblades[/b] can be found in:
[list]
[*]🏅 [b]Sport stores[/b] (shoes section) — Most common (8-10% spawn rate)
[*]👕 [b]Clothing stores[/b] (shoes/sneakers) — Common (2-4%)
[*]🏠 [b]Homes[/b] — Uncommon:
[list]
[*]Wardrobes (0.8%, kids wardrobes 1.5%)
[*]Sports closets (2%)
[*]Shoe closets (0.5%)
[/list]
[*]🏋️ [b]Gym lockers[/b] — Uncommon (2%)
[*]🔧 [b]Garages/sheds[/b] — Rare (0.2-0.3%)
[/list]

[b]Rollerblade Wheels[/b] can be found in:
[list]
[*]🏅 [b]Sport stores[/b] (accessories) — Most common (6-10%)
[*]🔨 [b]Hardware stores[/b] (accessories/misc) — Common (2-3%)
[*]🔧 [b]Garages[/b] (tools/mechanics) — Uncommon (1.5-2%)
[*]📦 [b]Sports closets/crates[/b] — Uncommon (2-3%)
[*]🏚️ [b]Sheds[/b] — Rare (1.5%)
[/list]

[h1]Technical Details[/h1]

[b]Animation System[/b]
[list]
[*]Uses custom animation XMLs (walk_rollerblades.xml, run_rollerblades.xml) with speed driven through m_Scalar
[*]RollerbladesActive (bool) — Enables/disables custom rollerblade animations
[*]RollerbladesSpeed (float) — Speed multiplier applied per-frame via m_Scalar
[/list]

[b]Terrain Detection[/b]
[list=1]
[*][b]Blocked[/b]: Objects with tree/bush/hedge in name (word-boundary matched — won't false-positive on "street")
[*][b]Stairs[/b]: square:HasStairs()
[*][b]Soft[/b]: Vegetation sprite properties/names, carpet/rug floor tiles
[*][b]Hard[/b] (default): Everything else (concrete, asphalt, indoor floors, streets)
[/list]

[b]B42 API Notes[/b]
[list]
[*]Stats use direct field access (stats.Fatigue, stats.Stress, stats.Panic) — not getter/setter methods
[*]Speed is driven through animation m_Scalar (read per-frame) rather than m_SpeedScale (read on state entry)
[/list]

[h1]Configuration[/h1]
Edit [i]42/media/lua/shared/RB42_RollerbladesShared.lua[/i]:
[code]
RB42.Config = {
    SpeedHard    = 1.50,   -- Hard surfaces: 50% faster
    SpeedSoft    = 0.75,   -- Soft surfaces: 25% slower of skating speed
    SpeedStairs  = 0.30,   -- Stairs: 50% slower
    SpeedBlocked = 0.30,   -- Vegetation: 70% slower

    -- Speed multipliers (used by our built-in fallback too)
    SpeedHard = 1.50,
    SpeedSoft = 0.75,
    SpeedStairs = 0.30,  -- Going up/down stairs (70% slower!)
    SpeedBlocked = 0.30,  -- Pushing through bushes/trees (70% slower!)

    -- Nimble System
    fallChanceOnStairsCheck = 2.0,  -- Base 2% chance to fall on stairs check
    attackFallChancePerAttack = 10,  -- 10% increased fall chance per attack
    reductionPerNimbleLevelForAttack = 1,     -- 1% reduction in fall chance per nimble level for an Attack
    reductionPerNimbleLevelForStairs = 0.20,     -- 2% reduction in fall chance per nimble level on stairs
}
[/code]

[h1]Known Issues / TODO[/h1]
[list]
[*][b]ClothingItem = Shoes_TrainerTINT[/b] in item script may skip custom Shoes_Rollerblades.xml
[*]Custom 3D rollerblade models
[*]Designed for MP - untested though
[/list]

[h1]Known Limitations[/h1]
[list]
[*][b]Visual[/b]: Rollerblades currently appear as trainers (vanilla shoe model)
[*][b]Multiplayer[/b]: Tested in single-player; multiplayer should work via server commands
[*][b]Performance[/b]: Updates every frame, optimized but monitor FPS
[/list]

[h1]Credits[/h1]
[list]
[*][b]Mod by[/b]: GingerVitis55
[*][b]Build[/b]: Project Zomboid Build 42
[*][b]Animation Assitance[/b]: RedChili
[/list]

[h1]License[/h1]
Free to use and modify. Give credit if redistributing.

---------------------------------------------------------

[b]Version[/b]: 1.3
[b]Build[/b]: 42+
[b]Multiplayer[/b]: Should work
[b]Last Updated[/b]: February 17, 2026

---------------------------------------------------------

[h1]Changelog[/h1]

[b]v1.3[/b]
[list]
[*]Added [b]Rollerblader Trait[/b] (3 points):
[list]
[*]25% less fatigue drain while skating
[*]50% less fall chance on stairs and while attacking
[*]20% slower durability loss on wheels and boots
[*]10% XP boost to Fitness and Nimble
[*]Start with Rollerblades
[/list]
[*]Removed "WIP" from mod name
[/list]

[b]v1.2[/b]
[list]
[*]Decreased Fall Chance on stairs
[*]Added texture to strapped shoes (actual rollerblades to come)
[*]Added Animation of Skating while "Running" - to be improved upon
[*]Added Fall Chance While Attacking
[*]Added Noise Levels
[/list]