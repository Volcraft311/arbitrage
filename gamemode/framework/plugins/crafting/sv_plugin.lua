--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Crafting.stored = Crafting.stored or {}

function Crafting:AddRecipe(uniqueID, data)
    self.stored[uniqueID] = data
end

Crafting:AddRecipe("test", {
    name = "Тест",
    description = "Test",
    items_needed = {
        ammo_pistol = 3
    },
    items_receive = {
        ammo_ar2 = 1
    },
    onCanCreate = function(client)
        return true
    end,
    onCreate = function(client)
        print("succ")
    end
})

function Crafting:RecipeProcessing(client, entity)
    if !IsValid(entity) then return end
    if client:GetPos():Distance(entity:GetPos()) > 500 then return end

    local min, max = entity:CalculateOBB()
    debugoverlay.Box(entity:GetPos(), min, max, 1, color_white)
end