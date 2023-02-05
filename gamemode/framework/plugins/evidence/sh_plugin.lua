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
Evidence = PLUGIN

PLUGIN.list = PLUGIN.list or {}
PLUGIN.icons = {}
PLUGIN.ribbons = {}

function PLUGIN:AddIcon(file)
    self.icons[#self.icons + 1] = "danganronpa/evidence/" .. file
end

function PLUGIN:AddRibbon(file, name, color)
    self.ribbons[#self.ribbons + 1] = {"danganronpa/ribbon/" .. file, name, color}
end

function PLUGIN:GetEvidence(idx)
    return self.list[idx]
end

function PLUGIN:GetToolData(client)
    if !client:IsUsesTool("Evidence Tool") then return end

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
    local evidenceRibbon = tool:GetClientInfo("ribbon")
    local evidenceFactionData = (SERVER and client.EvidenceFactionData or EvidenceFactionData) or {}

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
        ribbon = evidenceRibbon,
        factiondata = evidenceFactionData,
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
    local monopad = MonoPad:FindMonoPad(self)
    if monopad then
        local object = monopad.stored

        if object then
            return object.evidences
        end
    end

    return {}
end

function PLAYER:HasEvidence(idx)
    local data = self:GetEvidences()

    return data[idx]
end



do
    PLUGIN:AddIcon("test.png")
    PLUGIN:AddIcon("camera.png")
    PLUGIN:AddIcon("Pistol.png")
    PLUGIN:AddIcon("Documents.png")
    PLUGIN:AddIcon("antiquebook.png")
    PLUGIN:AddIcon("knife.png")
    PLUGIN:AddIcon("papers.png")
    PLUGIN:AddIcon("deadbody.png")
end

do
    PLUGIN:AddRibbon("blue.png", "Информационные носители", Color(89, 118, 224))
    PLUGIN:AddRibbon("green.png", "Медицина", Color(106, 224, 89))
    PLUGIN:AddRibbon("orange.png", "Физические носители", Color(220, 124, 61))
    PLUGIN:AddRibbon("red.png", "Орудия убийства", Color(221, 61, 61))
    PLUGIN:AddRibbon("violet.png", "Химические материалы", Color(141, 61, 220))
    PLUGIN:AddRibbon("white.png", "Ключевые материалы", Color(197, 206, 247))
    PLUGIN:AddRibbon("pink.png", "Мед. экспертиза", Color(253, 177, 255))
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")
