--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

ENT.Type = "anim"
ENT.Author = "Selenter"
ENT.PrintName = "Записка"
ENT.Category = "Bullet Of Hope"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:HasAccess(arr, data)
    if !arr then return false end

    if IsValid(data) and data:IsPlayer() then
        data = data:SteamID()
    end

    return arr[data] and true or false
end


NOTE_MAX_EDITORS = 30
NOTE_MAX_PAGES = 15
NOTE_SIZE_TITLE = 32
NOTE_SIZE_TEXT = 5000

NOTE_FONTS = {
    [1] = {
        name = "Baskerville WGL4 BT",
        font = "arb.Font_BaskervilleWGL4BT_"
    },
    [2] = {
        name = "Open Sans",
        font = "arb.Font_OpenSansLight_"
    },
    [3] = {
        name = "Futura PT Book",
        font = "arb.Font_FuturaPTBook_"
    },
    [4] = {
        name = "Futura PT Demi",
        font = "arb.Font_FuturaPTDemi_"
    },
    [5] = {
        name = "Roboto",
        font = "arb.Font_Roboto_"
    }
}