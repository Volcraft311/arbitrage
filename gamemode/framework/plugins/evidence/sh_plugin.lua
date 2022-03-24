--[[
        © Asterion Project 2022.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
Evidence = PLUGIN

PLUGIN.list = PLUGIN.list or {}
PLUGIN.icons = {}

function PLUGIN:AddIcon(file)
    self.icons[#self.icons + 1] = "danganronpa/evidence/" .. file
end

function PLUGIN:GetEvidence(idx)
    return self.list[idx]
end

function PLUGIN:IsUsesTool(client)
    if !IsValid(client) then return false end

    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) then return false end

    local class = weapon:GetClass()
    if class != "gmod_tool" then return false end

    local tool = client:GetTool() and client:GetTool().Name or nil
    if tool != "Evidence Tool" then return false end

    return true
end

function PLUGIN:GetToolData(client)
    if !self:IsUsesTool(client) then return end

    local trace = client:GetEyeTrace()
    local position = trace.HitPos
    local entity = trace.Entity
    local angles = trace.HitNormal:Angle()
    angles:RotateAroundAxis(angles:Up(), 90)
    angles:RotateAroundAxis(angles:Forward(), 90)

    local tool = client:GetTool()

    local evidenceName = tool:GetClientInfo("name")
    local evidenceDescription = (SERVER and client.EvidenceDescription or EvidenceDescription) or "Описание улики"
    local evidenceR = tool:GetClientInfo("r")
    local evidenceG = tool:GetClientInfo("g")
    local evidenceB = tool:GetClientInfo("b")
    local evidenceAlpha = tool:GetClientInfo("alpha")
    local evidenceIcon = tool:GetClientInfo("icon")

    if IsValid(entity) and !entity:IsPlayer() and !entity:IsWorld() then
        -- eh...
    else
        entity = NULL
    end

    local data = {
        name = evidenceName,
        description = evidenceDescription,
        entity = entity,
        color = Color(evidenceR, evidenceG, evidenceB),
        alpha = evidenceAlpha,
        position = position + angles:Up() * 0.5,
        image = evidenceIcon,
        angles = angles,
    }

    return data
end


local ENTITY = FindMetaTable("Entity")

function ENTITY:GetEvidence()
    return self:GetNetVar("ev_id", nil)
end


local PLAYER = FindMetaTable("Player")

function PLAYER:GetEvidences()
    local data = self:GetNetVar("ev_list", {})

    return data
end

function PLAYER:HasEvidence(idx)
    local data = self:GetNetVar("ev_list", {})

    return data[idx]
end



do
    PLUGIN:AddIcon("test.png")
    PLUGIN:AddIcon("camera.png")
    PLUGIN:AddIcon("Pistol.png")
    PLUGIN:AddIcon("Documents.png")
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")
