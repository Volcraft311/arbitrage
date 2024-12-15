local TRIGGER = {}
TRIGGER.__index = TRIGGER
TRIGGER.id = 0
TRIGGER.name = "undefined_" .. TRIGGER.id
TRIGGER.points = {vector_origin,Vector(5,5,5)}
TRIGGER.isLocalPlayerInside = false
TRIGGER.EnterActionList = {}
TRIGGER.ExitActionList = {}
TRIGGER.delay = 0.5


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


function TRIGGER:AddEnterAction(actionID,args)
    table.insert(self.EnterActionList, {action = actionID,args = args})
end

function TRIGGER:RemoveEnterAction(number)
    table.remove(self.EnterActionList,number)
end

function TRIGGER:EditEnterAction(number, args)
    self.EnterActionList[number].args = args
end


function TRIGGER:AddExitAction(actionID,args)
    table.insert(self.ExitActionList, {action = actionID,args = args})
end

function TRIGGER:RemoveExitAction(number)
    table.remove(self.ExitActionList,number)
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
    for k, v in pairs(self.EnterActionList) do
        Trigger:ActionByID(v.action).run(self, v.args)
    end
end

function TRIGGER:PlayerExited(client)
    client = client or LocalPlayer()
    netstream.Start("Trigger:PlayerExited",self.id)
    self.isLocalPlayerInside = false
    --Trigger.typeList[self.type].OnExit(client)
end



if SERVER then
    function TRIGGER:Sync(clients)
        netstream.Start(clients,"Trigger:Sync",self)
    end

else
    function TRIGGER:Draw(color)
        render.SetColorMaterial()
        render.DrawBox(vector_origin,angle_zero,self.points[1],self.points[2],color or box_color2)
        render.DrawWireframeBox(Vector(0,0,0),angle_zero,self.points[1],self.points[2],box_color1)
        --render.DrawBox(LocalPlayer():GetPos() + TRIGGER.playerTriggerOffset,angle_zero,Vector(5,5,5),Vector(-5,-5,-5),Color(255,255,255))
    end
end


Trigger.meta = TRIGGER


