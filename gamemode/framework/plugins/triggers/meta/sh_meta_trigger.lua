local TRIGGER = {}
TRIGGER.__index = TRIGGER
TRIGGER.id = 0
TRIGGER.type = nil
TRIGGER.points = {Vector(0,0,0),Vector(5,5,5)}
TRIGGER.isLocalPlayerInside = false

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
    return client:GetPos():WithinAABox(self.points[1],self.points[2])
end

function TRIGGER:PlayerEntered(client)
    print("Player entered")
    netstream.Start("Trigger:PlayerEntered",self.id)
end

function TRIGGER:PlayerExited(client)
    print("Player exited")
    netstream.Start("Trigger:PlayerExited",self.id)
end

if SERVER then
    function TRIGGER:Sync(clients)
        netstream.Start(clients,"Trigger:Sync",{id = self.id, points = self.points})
    end

else
    function TRIGGER:Draw()
        render.SetColorMaterial()
        render.DrawBox(Vector(0,0,0),Angle(0,0,0),self.points[1],self.points[2],Color(0,255,0,20))
        render.DrawWireframeBox(Vector(0,0,0),Angle(0,0,0),self.points[1],self.points[2],Color(0,255,0))
    end
end


Trigger.meta = TRIGGER


