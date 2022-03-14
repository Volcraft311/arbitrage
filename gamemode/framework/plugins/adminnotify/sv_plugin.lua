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

local PLUGIN = PLUGIN

function PLUGIN:SendNotify(notify, ...)
    if !self.notifyList[notify] then return end

    for k, v in pairs(player.GetAll()) do
        if self:HasAccess(v) then
            netstream.Start(v, "ixAdminNotify", notify, ...)
        end
    end
end

gameevent.Listen("player_connect")
function PLUGIN:player_connect(data)
    local name = data.name
    local steamid = data.networkid

    self:SendNotify("connect", name, steamid)
end

function PLUGIN:PlayerInitial(client)
    self:SendNotify("join", client:Name() .. " (" .. client:SteamID() .. ")")
end

function PLUGIN:PlayerDisconnected(client)
    self:SendNotify("disconnect", client:Name() .. " [" .. client:SteamName() .. "] (" .. client:SteamID() .. ")")
end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
    local weapon = attacker:IsPlayer() and attacker:GetActiveWeapon()

    self:SendNotify("killed", attacker:GetName() ~= "" and attacker:GetName() .. " (" .. attacker:SteamName() .. ")" or attacker:GetClass(), client:Name() .. " (" .. client:SteamName() .. ")", IsValid(weapon) and weapon:GetClass())
end

function PLUGIN:PlayerSpawn(client)
    self:SendNotify("spawn", client:Name() .. " (" .. client:SteamName() .. ")")
end

function PLUGIN:SelectCharacter(client, data)
    local factionData = Arbitrage.teams.Get(data)
    local faction = factionData and factionData.name or "НЕИЗВЕСТНО"

    self:SendNotify("joincharacter", client:Name() .. " (" .. client:SteamName() .. ")", data .. "(" .. faction .. ")")
end