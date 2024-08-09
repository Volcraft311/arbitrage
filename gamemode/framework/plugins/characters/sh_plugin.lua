--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN
Character = PLUGIN
Character.sendRequest = false -- запрашивать информацию с сайта
Character.APIRequest = "https://api.asterion.games"

Character.creation = Character.creation or {team = {}, emoji = {}, category = {}} -- хранилище net персонажей

Arbitrage.base.Include("meta/sh_emoji.lua")
Arbitrage.base.Include("meta/sh_category.lua")
Arbitrage.base.Include("meta/sh_team.lua")

local keyData = {
    ["team"] = {
        reg = function(uniqueID, info)
            info.isCreation = true

            Character.team:Create(info)

            if SERVER then
                netstream.Start(nil, "Character:CreationRegisterKeys", "team", uniqueID, info)
            end
        end,
        edit = function(uniqueID, info)
            info.isCreation = true

            local faction = Character.team:GetByUniqueID(uniqueID)
            if !faction then return end

            for k, v in pairs(info) do
                faction[k] = v
            end

            if SERVER then
                netstream.Start(nil, "Character:CreationEditKeys", "team", uniqueID, info)
            end
        end,
        remove = function(uniqueID)
            for k, v in pairs(Character.team.instances) do
                if v.isCreation and string.lower(v.uniqueID) == string.lower(uniqueID) then
                    Character.team.instances[k] = nil
                end
            end

            if SERVER then
                netstream.Start(nil, "Character:CreationRemoveKeys", "team", uniqueID)
            end
        end
    },
    ["emoji"] = {
        reg = function(uniqueID, info)
            Character.emoji:Register(uniqueID, info)
            Character.emoji.instances[uniqueID].isCreation = true

            if SERVER then
                netstream.Start(nil, "Character:CreationRegisterKeys", "emoji", uniqueID, info)
            end
        end,
        edit = function(uniqueID, info)
            Character.emoji.instances[uniqueID] = nil
            Character.emoji.data[uniqueID] = nil

            Character.emoji:Register(uniqueID, info)
            Character.emoji.instances[uniqueID].isCreation = true

            if SERVER then
                netstream.Start(nil, "Character:CreationEditKeys", "emoji", uniqueID, info)
            end
        end,
        remove = function(uniqueID)
            Character.emoji.instances[uniqueID] = nil
            Character.emoji.data[uniqueID] = nil

            if SERVER then
                netstream.Start(nil, "Character:CreationRemoveKeys", "emoji", uniqueID)
            end
        end
    },
    ["category"] = {
        reg = function(uniqueID, info)
            info.isCreation = true

            Character.category:Register(uniqueID, info)

            if SERVER then
                netstream.Start(nil, "Character:CreationRegisterKeys", "category", uniqueID, info)
            end
        end,
        edit = function(uniqueID, info)
            info.isCreation = true

            local category = Character.category:GetByUniqueID(uniqueID)
            if !category then return end

            for k, v in pairs(info) do
                category[k] = v
            end

            if SERVER then
                netstream.Start(nil, "Character:CreationEditKeys", "category", uniqueID, info)
            end
        end,
        remove = function(uniqueID)
            for k, v in pairs(Character.category.instances) do
                if v.isCreation and string.lower(v.uniqueID) == string.lower(uniqueID) then
                    Character.category.instances[k] = nil
                end
            end

            if SERVER then
                netstream.Start(nil, "Character:CreationRemoveKeys", "category", uniqueID)
            end
        end
    },
}

function Character.CreationRegisterKeys(key, uniqueID, info)
    keyData[key].reg(uniqueID, info)
    Character.creation[key][uniqueID] = info
end

function Character.CreationEditKeys(key, uniqueID, info)
    keyData[key].edit(uniqueID, info)
    Character.creation[key][uniqueID] = info
end

function Character.CreationRemoveKeys(key, uniqueID)
    keyData[key].remove(uniqueID)
    Character.creation[key][uniqueID] = nil
end

-- я ненавижу JSON Гарика, который string-и автоматически в number-ы переводит
function Character.FixArray(array)
    local data = {}
    for k, v in pairs(array) do
        -- if isnumber(k) then
        --     print(k)
        -- end

        data[tostring(k)] = v
    end

    return data
end

Arbitrage.base.Include("sh_emoji.lua")
Arbitrage.base.Include("sh_category.lua")
Arbitrage.base.Include("sh_team.lua")

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")

Character.category:Init(function()
    -- Персонаж администратора
    TEAM_ADMIN = Character.team:Create({
        name = "Администратор",
        health = 9999999,
        color = Color(87, 211, 132),
        model = "models/editor/camera.mdl",
        weapons = {"gmod_tool", "weapon_physgun"}
    })

    -- Персонаж не выбранного персонажа
    TEAM_NOTCHARACTER = Character.team:Create({
        name = "Персонаж не выбран",
        health = 9999999,
        color = Color(211, 87, 87)
    })

    -- Персонаж наблюдателя
    TEAM_SPECTATE = Character.team:Create({
        name = "Наблюдатель",
        health = 9999999,
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

            local first_player = 1
            local alive_players = {}

            for k, v in ipairs(player.GetAll()) do
                if Arbitrage.players[v:SteamID()] and v:Alive() and !v:IsHost() then
                    alive_players[#alive_players + 1] = v
                end
            end

            if IsValid(alive_players[first_player]) then
                client.spectateplayer = first_player
                client:SpectateEntity(alive_players[first_player])
                client.spectateent = alive_players[first_player]
                client:SetNetVar("spectate", alive_players[first_player])
            end
        end
    })

    Character.team:Init()
end)