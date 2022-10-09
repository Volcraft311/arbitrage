--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN
Character = PLUGIN
Character.sendRequest = false -- запрашивать информацию с сайта
Character.APIRequest = "https://api.asterion.games"

Arbitrage.base.Include("meta/sh_emoji.lua")
Arbitrage.base.Include("meta/sh_category.lua")
Arbitrage.base.Include("meta/sh_team.lua")

Arbitrage.base.Include("sh_emoji.lua")
Arbitrage.base.Include("sh_category.lua")
Arbitrage.base.Include("sh_team.lua")

Character.category:Init(function()
    -- Персонаж администратора
    TEAM_ADMIN = Character.team:Create({
        name = "Администратор",
        color = Color(87, 211, 132),
        model = "models/editor/camera.mdl",
        weapons = {"gmod_tool", "weapon_physgun"}
    })

    -- Персонаж не выбранного персонажа
    TEAM_NOTCHARACTER = Character.team:Create({
        name = "Персонаж не выбран",
        color = Color(211, 87, 87)
    })

    -- Персонаж наблюдателя
    TEAM_SPECTATE = Character.team:Create({
        name = "Наблюдатель",
        color = Color(255, 255, 255),
        OnChange = function(client)
            client:SetNoDraw(true)
            client:SetNotSolid(true)
            client:DrawWorldModel(false)
            client:DrawShadow(false)
            client:GodEnable()
            client:SetNoTarget(true)
            client:StripWeapons()
            client:StripAmmo()

            client:Freeze(false)

            client:Spectate(OBS_MODE_CHASE)
            for k, v in SortedPairs(player.GetAll()) do
                if v:Alive() and v:IsPlaying() and v != client then
                    client:SpectateEntity(v)
                    break
                end
            end
        end
    })

    Character.team:Init()
end)