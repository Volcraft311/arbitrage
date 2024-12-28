Trigger.instances = Trigger.instances or {}
Trigger.drawTriggers = false
Trigger.selectedID = 0
Trigger.ActionLists = {}
Trigger.PlayerInside = {}

local selected_trigger_color = Color(255,247,0,100)

netstream.Hook("Trigger:Sync",function(data)
    local id = data.id
    Trigger:Create(data,id)
    Trigger:UpdateTriggerList()
end)

netstream.Hook("Trigger:Remove",function(data)
    local id = data.id
    Trigger:Remove(id)
    Trigger.selectedID = 0
    Trigger:UpdateTriggerList()
end)
netstream.Hook("Trigger:RemoveAll",function(data)
    Trigger:RemoveAll()
end)

timer.Create("Trigger:IsPlayerInside",0.05,0,function()
    for k,v in pairs(Trigger.instances) do
        if v.isLocalPlayerInside == false then
            if v:IsPlayerInside() then
                Trigger.PlayerInside[v] = true
                v:PlayerEntered()
            end
        elseif v.isLocalPlayerInside == true then
            if !v:IsPlayerInside() then
                v:PlayerExited()
                Trigger.PlayerInside[v] = nil
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

-- Обновление интерфейса (Ебал его куда только можно, хуйня ебанная. Я НА НЕГО БЛЯТЬ ТРАЧУ БОЛЬШЕ ВРЕМЕНИ, ЧЕМ НА ВСЁ ОСТАЛЬНОЕ.) - volcraft31


function Trigger.UpdateActionLists()
    local tr = Trigger.GetSelected()
    if tr == nil then return end

    for _act, _list in pairs(Trigger.ActionLists) do
        local lines = _list:GetLines()

        for i, _ in ipairs(lines) do
            _list:RemoveLine(i)
        end

        for k, v in pairs(tr.ActionList[_act]) do
            local act = Trigger:ActionByID(v.action)
            local _line = _list:AddLine(tostring(act.name))
            _line.thisActionID = v.action
        end
    end
end

function Trigger.UpdateTriggerList()
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

