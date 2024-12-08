local TRIGGER = {}
TRIGGER.__index = TRIGGER
TRIGGER.id = 0
TRIGGER.type = nil
TRIGGER.name = "undefined_" .. TRIGGER.id
TRIGGER.points = {vector_origin,Vector(5,5,5)}
TRIGGER.isLocalPlayerInside = false
TRIGGER.actionList = {}



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
end

function TRIGGER:GetPoints()
    return self.points
end

function TRIGGER:IsPlayerInside(client)
    if CLIENT and !client then
        client = LocalPlayer()
    end
    local _, _max = client:GetHull()

    local _playerpos = client:GetPos()
    _playerpos.z = _playerpos.z + _max.z / 2
    return _playerpos:WithinAABox(self.points[1],self.points[2])
end

function TRIGGER:PlayerEntered(client)
    client = client or LocalPlayer()
    netstream.Start("Trigger:PlayerEntered",self.id)
    self.isLocalPlayerInside = true
    Trigger.typeList[self.type].OnEnter(client)

end

function TRIGGER:PlayerExited(client)
    client = client or LocalPlayer()
    netstream.Start("Trigger:PlayerExited",self.id)
    self.isLocalPlayerInside = false
    Trigger.typeList[self.type].OnExit(client)
end



if SERVER then
    function TRIGGER:Sync(clients)
        netstream.Start(clients,"Trigger:Sync",self)
    end

else
    function TRIGGER:Draw()
        render.SetColorMaterial()
        render.DrawBox(vector_origin,angle_zero,self.points[1],self.points[2],box_color2)
        render.DrawWireframeBox(Vector(0,0,0),angle_zero,self.points[1],self.points[2],box_color1)
        --render.DrawBox(LocalPlayer():GetPos() + TRIGGER.playerTriggerOffset,angle_zero,Vector(5,5,5),Vector(-5,-5,-5),Color(255,255,255))
    end
end


Trigger.meta = TRIGGER


