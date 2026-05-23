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
Recognize = PLUGIN

Recognize.max_description_length = 30

local function isAdminMode()
    local client = LocalPlayer()
    if !IsValid(client) then return false end

    return client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP
end

function Recognize:GetRealName(client)
    -- Это не фейковое имя, а новое установленное ГМом. Уже не помню почему так параметр назвал...
    local fakeName = client:GetNetVar("fakename")
    if fakeName then
        return fakeName
    end

    local id = client:Team()
    local character = Character.team:GetByID(id)
    if character and client:IsPlaying() then
        local name = character:GetName()

        if SERVER then
            return L("ru", name)
        end

        return L(name)
    end

    return client:SteamName()
end

function Recognize:GetDescription(client)
    local description = client:GetNetVar("description", nil)
    if description and description:utf8len() > self.max_description_length then
        description = description:utf8sub(1, self.max_description_length - 3) .. "..."
    end

    if !description then
        local forced_description = client:GetNetVar("forced_description", nil)

        if forced_description then
            if forced_description:utf8len() > self.max_description_length then
                forced_description = forced_description:utf8sub(1, self.max_description_length - 3) .. "..."
            end

            description = forced_description
        end
    end

    return description
end

function Recognize:GetPlayerName(target, client)
    if !Arbitrage.IsStartGame() then
        return target:SteamName()
    end

    if !client and CLIENT then
        client = LocalPlayer()
    end

    local realName = self:GetRealName(target)

    local bKnowledgeEveryone = self:IsKnowledgeEveryone(client)
    if bKnowledgeEveryone then
        return realName
    end

    local bKnowledge = self:IsKnowledgePlayer(client, target)
    if !bKnowledge then
        local description = self:GetDescription(target)

        return "Вы не узнаете этого человека", description and "[" .. description .. "]"
    end

    local recognizeName = self:GetRecognizeName(target)
    if recognizeName then
        return recognizeName
    end

    return realName
end

function Recognize:GetRecognizeName(client)
    local recognizeName = client:GetNetVar("recognizeName", nil)

    return recognizeName
end

function Recognize:IsDisclosed(client)
    local bDisclosed = client:GetNetVar("recognizeDisclosed", false)

    return bDisclosed
end

function Recognize:IsKnowledgePlayer(client, target)
    if !IsValid(client) then return false end
    if !IsValid(target) then return false end

    -- Локальный игрок знает себя...
    if client == target then
        return true
    end

    -- У игрока раскрыта личность
    local bDisclosed = self:IsDisclosed(target)
    if bDisclosed then
        return true
    end

    -- Игрок знаком с игроком
    local data = client:GetNetVar("recognizeData", {})
    local steamid = target:SteamID()

    return data[steamid]
end

function Recognize:IsKnowledgeEveryone(client)
    -- Система отключена
    if Arbitrage.OnRecognizeDisable() then
        return true
    end

    if !IsValid(client) then return false end

    -- Является ведущим
    if client:IsHost() then
        return true
    end

    -- Флажок на знание всех
    local bKnowledgeAll = client:GetNetVar("recognizeKnowledgeAll", false)
    if bKnowledgeAll then
        return true
    end

    -- Вход в ноуклип
    if CLIENT and isAdminMode() then
        return true
    end

    return false
end


local PLAYER = FindMetaTable("Player")

function PLAYER:GetName(client)
    return Recognize:GetPlayerName(self, client)
end

PLAYER.Nick = PLAYER.GetName
PLAYER.Name = PLAYER.GetName

function PLAYER:RealName()
    return Recognize:GetRealName(self)
end

function PLAYER:RecognizeName()
    return Recognize:GetRecognizeName(self)
end

function PLAYER:IsRecognize(target)
    return Recognize:IsKnowledgePlayer(client, target)
end


Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")