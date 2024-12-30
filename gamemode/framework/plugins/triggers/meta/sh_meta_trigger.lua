local TRIGGER = {}
TRIGGER.__index = TRIGGER
TRIGGER.id = 0
TRIGGER.name = "undefined_" .. TRIGGER.id
TRIGGER.points = {vector_origin,Vector(5,5,5)}
TRIGGER.isLocalPlayerInside = false
TRIGGER.delay = 0.5


TRIGGER.ActionList = {
    Enter = {},
    Exit = {}
}


-- Энумираторы
ACTION_ENTER = "Enter"
ACTION_EXIT = "Exit"


local box_color1 = Color(0,255,55)
local box_color2 = Color(1,63,23,105)


function TRIGGER:__tostring()
    return "Trigger nmbr [" .. self.id .. "]"
end

function TRIGGER:__eq(other)
    return self:GetID() == other:GetID()
end

function TRIGGER:GetID()
    return self.id
end

function TRIGGER:SetPoint(point,vector)
    self.points[point] = vector
    if SERVER then
        Trigger:SyncByID(self.id,player.GetAll())
    end
end

function TRIGGER:GetPoints()
    return self.points
end

function TRIGGER:AddAction(actionEnum, actionID, args)
    table.insert(self.ActionList[actionEnum], {action = actionID,args = args})
end

function TRIGGER:RemoveAction(actionEnum, number)
    table.remove(self.ActionList[actionEnum], number)
end


function TRIGGER:EditAction(actionEnum, number, args)
    self.ActionList[actionEnum][number].args = args
end


function TRIGGER:IsPlayerInside(client)
    if CLIENT and !client then
        client = LocalPlayer()
    end
    if client:GetMoveType() == MOVETYPE_NOCLIP or client:IsRagdoll() or client:IsRagdolling() then return false end
    local _, _max = client:GetHull()

    local _playerpos = client:GetPos()
    _playerpos.z = _playerpos.z + _max.z / 2
    local answer = _playerpos:WithinAABox(self.points[1],self.points[2])
    return answer
end

function TRIGGER:PlayerEntered(client)
    client = client or LocalPlayer()
    if CLIENT then
        netstream.Start("Trigger:PlayerEntered",self.id)
        self.isLocalPlayerInside = true
        Trigger.PlayerInside[self] = true
    end
    for k, v in pairs(self.ActionList.Enter) do
        Trigger:ActionByID(v.action).run(self, v.args, client)
    end
end

function TRIGGER:PlayerExited(client)
    client = client or LocalPlayer()
    if CLIENT then
        netstream.Start("Trigger:PlayerExited",self.id)
        self.isLocalPlayerInside = false
        Trigger.PlayerInside[self] = nil
    end
    for k, v in pairs(self.ActionList.Exit) do
        Trigger:ActionByID(v.action).run(self,v.args, client)
    end
end



if SERVER then
    function TRIGGER:Sync(clients)
        netstream.Start(clients,"Trigger:Sync",self)
    end

else
    function TRIGGER:Draw(color)
        render.SetColorMaterial()
        render.DrawBox(vector_origin,angle_zero,self.points[1],self.points[2],color or box_color2)
        render.DrawWireframeBox(Vector(0,0,0),angle_zero,self.points[1],self.points[2],color or box_color1)
        --render.DrawBox(LocalPlayer():GetPos() + TRIGGER.playerTriggerOffset,angle_zero,Vector(5,5,5),Vector(-5,-5,-5),Color(255,255,255))
    end
end


Trigger.meta = TRIGGER


