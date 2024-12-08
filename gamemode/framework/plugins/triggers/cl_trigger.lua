Trigger.instances = {}
Trigger.drawTriggers = false
Trigger.selectedID = 1

netstream.Hook("Trigger:Sync",function(data)
    local id = data.id
    Trigger:Create(data,id)
    Trigger:UpdateToolPanel()
end)

timer.Create("Trigger:IsPlayerInside",0.1,0,function()
    for k,v in pairs(Trigger.instances) do
        if v.isLocalPlayerInside == false then
            if v:IsPlayerInside() then
                v:PlayerEntered()
            end
        elseif v.isLocalPlayerInside == true then
            if !v:IsPlayerInside() then
                v:PlayerExited()
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
    local tl = Trigger.TriggerList
    if tl == nil or !tl:IsValid() then return false end
    tl:ClearSelection()
    local lines = tl:GetLines()
    local triggers = Trigger.instances

    for i, _ in ipairs(lines) do
        Trigger.TriggerList:RemoveLine(i)
    end

    for _, v in pairs(triggers) do
        Trigger.TriggerList:AddLine(tostring(v.name),tostring(v.id))
    end
end