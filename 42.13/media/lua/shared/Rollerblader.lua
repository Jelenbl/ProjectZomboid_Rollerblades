-- we need our registry to check for the trait

local function addItemOnSpawn(player)
    -- only run on server side to prevent duplicates in multiplayer
    if not isServer() then return end

    -- check for the trait using the registry key
    if player:hasTrait(RB42.CharacterTrait.Rollerblader) then
        -- add rollerblades to the player's inventory
        player:getInventory():AddItem("Rollerblades42.Rollerblades")
        player:getInventory():AddItem("Rollerblades42.RollerbladeWheels")
    end
end

-- run our function when a player is created (including after death in existing worlds)
Events.OnCreatePlayer.Add(addItemOnSpawn)