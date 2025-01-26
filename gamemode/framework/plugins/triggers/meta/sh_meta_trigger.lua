--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://asterion.games/chancery
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local TRIGGER = {}
TRIGGER.__index = TRIGGER
TRIGGER.id = 0
TRIGGER.name = "undefined"
TRIGGER.points = {Vector(0, 0, 0), Vector(5, 5, 5)}
TRIGGER.isLocalPlayerInside = false
TRIGGER.bIsActive = true
TRIGGER.entity = nil
TRIGGER.ActionList = {Enter = {}, Exit = {}}
TRIGGER.EnteredList = {}
TRIGGER.ExitedList = {}
TRIGGER.isOneShot = false

-- Энумираторы
ACTION_ENTER = "Enter"
ACTION_EXIT = "Exit"

function TRIGGER:__tostring()
    return "Trigger nmbr [" .. self.id .. "]"
end

function TRIGGER:__eq(other)
    return self:GetID() == other:GetID()
end

function TRIGGER:GetID()
    return self.id
end

function TRIGGER:SetName(name)
    self.name = name
end

function TRIGGER:GetName()
    return self.name
end

function TRIGGER:SetPoint(point, vector)
    self.points[point] = vector

    if SERVER then
        local entity = self:GetEntity()
        if IsValid(entity) then
            entity:SetPos(self.points[1])
        end
    end
end

function TRIGGER:GetPoints()
    return self.points
end

function TRIGGER:SetActive(bActive)
    self.bIsActive = bActive
end

function TRIGGER:GetActive()
    return self.bIsActive
end

function TRIGGER:SetEntity(entity)
    entity.trigger = self

    self.entity = entity
end

function TRIGGER:GetEntity()
    return self.entity
end

function TRIGGER:AddAction(actionEnum, actionID, args)
    table.insert(self.ActionList[actionEnum], {
        action = actionID,
        args = args
    })
end

function TRIGGER:IsOneShot()
    return self.isOneShot
end

function TRIGGER:RemoveAction(actionEnum, number)
    table.remove(self.ActionList[actionEnum], number)
end

function TRIGGER:EditAction(actionEnum, number, args)
    self.ActionList[actionEnum][number].args = args
end

function TRIGGER:IsPlayerInside(client)
    client = client or LocalPlayer()

    if client:GetMoveType() == MOVETYPE_NOCLIP or client:IsRagdolling() then
        return false
    end

    local _, max = client:GetHull()
    local pos = client:GetPos()
    pos.z = pos.z + max.z / 2

    return pos:WithinAABox(self.points[1], self.points[2])
end

function TRIGGER:PlayerEntered(client)
    if !self:GetActive() then return end
    client = client or LocalPlayer()
    if self.isOneShot and table.HasValue(self.EnteredList, client) then
        return
    else
        table.insert(self.EnteredList, client)
    end
    if CLIENT then
        self.isLocalPlayerInside = true
        Trigger.PlayerInside[self] = true
        netstream.Start("Trigger:PlayerEntered", self.id)
    end

    for _, v in pairs(self.ActionList.Enter) do
        local action = Trigger:ActionByID(v.action)
        action.run(self, v.args, client)
    end
end

function TRIGGER:PlayerExited(client)
    if !self:GetActive() then return end
    client = client or LocalPlayer()

    if self.isOneShot and table.HasValue(self.ExitedList, client) then
        return
    else
        table.insert(self.ExitedList, client)
    end

    if CLIENT then
        self.isLocalPlayerInside = false
        Trigger.PlayerInside[self] = nil
        netstream.Start("Trigger:PlayerExited", self.id)
    end

    for _, v in pairs(self.ActionList.Exit) do
        local action = Trigger:ActionByID(v.action)
        action.run(self, v.args, client)
    end
end

function TRIGGER:Remove()
    local id = self.id

    Trigger.instances[id] = nil

    if SERVER then
        local entity = self:GetEntity()
        if IsValid(entity) then
            entity.bOnNetSend = true
            entity:Remove()
        end

        netstream.Start(nil, "Trigger:Remove", id)
    end
end

function TRIGGER:SelectTool(receivers)
    if SERVER then
        netstream.Start(receivers, "Trigger:SelectTool", self.id)
    else
        Trigger.selectedID = self.id
    end
end

function TRIGGER:GetSyncData()
    return {
        name = self.name,
        points = self.points,
        ActionList = self.ActionList,
        bIsActive = self.bIsActive,
        isOneShot = self.isOneShot,
        EnteredList = self.EnteredList,
        ExitedList = self.ExitedList
    }
end

function TRIGGER:SetOneShot(bool)
    self.isOneShot = bool
end

function TRIGGER:ResetEnteredList()
    self.EnteredList = {}
end

function TRIGGER:ResetExitedList()
    self.ExitedList = {}
end

if SERVER then
    function TRIGGER:Sync(receivers)
        local data = self:GetSyncData()

        netstream.Start(receivers, "Trigger:Sync", self.id, data)
    end
else
    local box_color1 = Color(0, 255, 55)
    local box_color2 = Color(1, 63, 23, 105)
    local box_color3 = Color(224, 24, 24, 176)

    function TRIGGER:Draw(color)
        local min = self.points[1]
        local max = self.points[2]

        render.SetColorMaterial()

        if self:GetActive() then
            render.DrawBox(vector_origin, angle_zero, min, max, color or box_color2)
        else
            render.DrawBox(vector_origin, angle_zero, min, max, box_color3)
        end

        render.DrawWireframeBox(Vector(0, 0, 0), angle_zero, min, max, color or box_color1)
    end
end


Trigger.meta = TRIGGER