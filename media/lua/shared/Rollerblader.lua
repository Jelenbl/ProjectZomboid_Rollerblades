-- we need our registry to check for the trait

local function addItemOnSpawn(player)
    -- check for the trait using the registry key
    if player:hasTrait(RB42.CharacterTrait.Rollerblader) then
        -- add rollerblades to the player's inventory
        player:getInventory():AddItem("Rollerblades42.Rollerblades")
        player:getInventory():AddItem("Rollerblades42.RollerbladeWheels")
    end
end

-- run our function when the OnNewGame event is triggered
--  contrary to the name, this event is triggered any time you create a new character, not just in new worlds
Events.OnNewGame.Add(addItemOnSpawn)