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
TRIGGER.bOneShot = false
TRIGGER.entity = nil
TRIGGER.ActionList = {Enter = {}, Exit = {}, Interact = {}}
TRIGGER.EnteredList = {}
TRIGGER.ExitedList = {}
TRIGGER.InteractedList = {}

-- Энумираторы
ACTION_ENTER = "Enter"
ACTION_EXIT = "Exit"
ACTION_INTERACT = "Interact"

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

function TRIGGER:AddAction(actionEnum, actionID, args, name)
    table.insert(self.ActionList[actionEnum], {
        action = actionID,
        args = args,
        name = name
    })
end

function TRIGGER:EditAction(actionEnum, number, args, name)
    self.ActionList[actionEnum][number].args = args
    self.ActionList[actionEnum][number].name = name
end

function TRIGGER:RemoveAction(actionEnum, number)
    table.remove(self.ActionList[actionEnum], number)
end

function TRIGGER:SetOneShot(bOneShot)
    self.bOneShot = bOneShot
end

function TRIGGER:GetOneShot()
    return self.bOneShot
end

function TRIGGER:IsPlayerInside(client)
    client = client or LocalPlayer()

    if client:GetMoveType() == MOVETYPE_NOCLIP or client:IsRagdolling() then
        return false
    end

    local _, max = client:GetHull()
    local pos = client:GetPos()
    pos.z = pos.z + max.z / 2

    return self:IsVectorInside(pos)
end

function TRIGGER:IsVectorInside(vector) -- Используется в проверках - нажатия, нахождения игрока внутри.
    return vector:WithinAABox(self.points[1], self.points[2])
end

function TRIGGER:PlayerEntered(client)
    if !self:GetActive() then return end

    client = client or LocalPlayer()

    if self.bOneShot then
        if self.EnteredList[client] then
            return
        end

        self.EnteredList[client] = true
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

    if self.bOneShot then
        if self.ExitedList[client] then
            return
        end

        self.ExitedList[client] = true
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

function TRIGGER:PlayerInteracted(client)
    if !self:GetActive() then return end

    client = client or LocalPlayer()

    if self.bOneShot then
        if self.InteractedList[client] then
            return
        end

        self.InteractedList[client] = true
    end

    if CLIENT then
        netstream.Start("Trigger:PlayerInteracted", self.id)
    end

    for _, v in pairs(self.ActionList.Interact) do
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
            entity.bNoNetSend = true
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

function TRIGGER:GetSaveData()
    return {
        name = self.name,
        points = self.points,
        ActionList = self.ActionList,
        bIsActive = self.bIsActive,
        bOneShot = self.bOneShot,
    }
end

function TRIGGER:GetSyncData()
    local data = self:GetSaveData()
    data.EnteredList = self.EnteredList
    data.ExitedList = self.ExitedList
    data.InteractedList = self.InteractedList

    return data
end

function TRIGGER:ResetEnteredList()
    self.EnteredList = {}
end

function TRIGGER:ResetExitedList()
    self.ExitedList = {}
end

function TRIGGER:ResetInteractedList()
    self.InteractedList = {}
end

function TRIGGER:MoveAction(actionEnum, number, direction)
    local actionList = self.ActionList[actionEnum]
    local action = actionList[number]

    local idx = number + direction
    if idx > 0 and idx <= #actionList then
        if direction < 0 then
            table.remove(actionList, number)
            table.insert(actionList, idx, action)
        else
            table.remove(actionList, number)
            table.insert(actionList, idx, action)
        end
    end
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