Trigger.instances = Trigger.instances or {}
Trigger.drawTriggers = false
Trigger.selectedID = 0


local selected_trigger_color = Color(0,255,100,100)

netstream.Hook("Trigger:Sync",function(data)
    local id = data.id
    Trigger:Create(data,id)
    Trigger:UpdateToolPanel()
end)

netstream.Hook("Trigger:Remove",function(data)
    local id = data.id
    Trigger:Remove(id)
    Trigger.selectedID = 0
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
        local tr = Trigger:GetSelected()
        if tr != nil then
            tr:Draw(selected_trigger_color)
        end
    end
end

function Trigger:DrawAll()
    for k, v in pairs(Trigger.instances) do
        v:Draw()
    end
end

-- Обновление интерфейса (Ебал его куда только можно) 

function Trigger.UpdateActionList()
    local trigger = Trigger.GetSelected()
    if trigger == nil then return false end
    local tl = Trigger.ActionList
    if tl == nil or !tl:IsValid() then return false end
    tl:ClearSelection()
    local lines = tl:GetLines()
    local actions = trigger.EnterActionList


    for i, _ in ipairs(lines) do
        Trigger.ActionList:RemoveLine(i)
    end

    for _, v in pairs(actions) do
        local act = Trigger:ActionByID(v.action)
        Trigger.ActionList:AddLine(tostring(v.action),tostring(act.name),tostring(table.concat(v.args," ") or 0))
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

