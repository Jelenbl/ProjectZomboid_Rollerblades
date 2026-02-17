-- RB42 = RB42 or {}
-- -- Rollerblader.lua
-- -- Gives rollerblades to players with the Rollerblader trait on character creation

-- local function addItemOnSpawn(player)
--     -- Check for the Rollerblader trait using pcall to prevent crash if trait not registered
--     -- local success, hasTrait = pcall(function()
--     --     return player:hasTrait(RB42.Rollerblader)
--     -- end)
--     if player:hasTrait(RB42.Rollerblader) then
--         player:getInventory():AddItem("Rollerblades42.Rollerblades")
--     end
-- end

-- -- OnNewGame triggers when creating a new character (not just new worlds)
-- Events.OnNewGame.Add(addItemOnSpawn)


-- we need our registry to check for the trait
-- local RB42 = require("RB42/Registries")

local function addItemOnSpawn(player)
    -- check for the trait using the registry key
    if player:hasTrait(RB42.CharacterTrait.Rollerblader) then
        -- add rollerblades to the player's inventory
        player:getInventory():AddItem("Rollerblades42.Rollerblades")
    end
end

-- run our function when the OnNewGame event is triggered
--  contrary to the name, this event is triggered any time you create a new character, not just in new worlds
Events.OnNewGame.Add(addItemOnSpawn)