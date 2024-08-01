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

Evidence.list = Evidence.list or {}
Evidence.icons = {}
Evidence.ribbons = {}

function Evidence:AddIcon(file)
    self.icons[#self.icons + 1] = "danganronpa/evidence/" .. file
end

function Evidence:AddRibbon(file, name, color)
    self.ribbons[#self.ribbons + 1] = {"danganronpa/ribbon/" .. file, name, color}
end

function Evidence:GetEvidence(idx)
    return self.list[idx]
end

function Evidence:GetToolData(client)
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
    Evidence:AddIcon("test.png")
    Evidence:AddIcon("camera.png")
    Evidence:AddIcon("Pistol.png")
    Evidence:AddIcon("Documents.png")
    Evidence:AddIcon("antiquebook.png")
    Evidence:AddIcon("knife.png")
    Evidence:AddIcon("papers.png")
    Evidence:AddIcon("deadbody.png")
end

do
    Evidence:AddRibbon("blue.png", "Информационные носители", Color(89, 118, 224))
    Evidence:AddRibbon("green.png", "Медицина", Color(106, 224, 89))
    Evidence:AddRibbon("orange.png", "Физические носители", Color(220, 124, 61))
    Evidence:AddRibbon("red.png", "Орудия убийства", Color(221, 61, 61))
    Evidence:AddRibbon("violet.png", "Химические материалы", Color(141, 61, 220))
    Evidence:AddRibbon("white.png", "Ключевые материалы", Color(197, 206, 247))
    Evidence:AddRibbon("pink.png", "Мед. экспертиза", Color(253, 177, 255))
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")
