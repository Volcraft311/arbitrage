Trigger.instances = {}
Trigger.drawTriggers = false

netstream.Hook("Trigger:Sync",function(data)
    local id = data.id
    Trigger:Create(data,id)
    Trigger:UpdateToolPanel()
end)

timer.Create("Trigger:IsPlayerInside",0.3,0,function()
    for k,v in pairs(Trigger.instances) do
        if v:IsPlayerInside() then
            if v.isLocalPlayerInside == false then
                v:PlayerEntered(LocalPlayer())
            end
        else
            if v.isLocalPlayerInside == true then
                v:PlayerExited(LocalPlayer())
            end
        end
    end
end)


function Trigger:PostDrawTranslucentRenderables()
    if Trigger.drawTriggers == true then
        Trigger:DrawAll()
    end
end

function Trigger:DrawAll()
    for k, v in pairs(Trigger.instances) do
        v:Draw()
    end
end

function Trigger.UpdateToolPanel()
    local lines = Trigger.TriggerList:GetLines()
    local triggers = Trigger.instances

    for i, _ in ipairs(lines) do
        Trigger.TriggerList:RemoveLine(i)
    end

    for _, v in pairs(triggers) do
        Trigger.TriggerList:AddLine(tostring(v.name),tostring(v.id))
    end
end