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


Trigger.drawTriggers = Trigger.drawTriggers or false
Trigger.selectedID = 0
Trigger.ActionLists = {}
Trigger.PlayerInside = {}

netstream.Hook("Trigger:Sync", function(id, data)
    Trigger:Create(data, id)

    Trigger:UpdateActionLists()
    Trigger:UpdateTriggerList()
end)

netstream.Hook("Trigger:SyncAll", function(info)
    Trigger:RemoveAll()

    for id, data in pairs(info) do
        Trigger:Create(data, id)
    end

    Trigger:UpdateActionLists()
    Trigger:UpdateTriggerList()
end)

netstream.Hook("Trigger:SelectTool", function(id)
    timer.Simple(0, function() -- sync create...
        local trigger = Trigger:GetByID(id)
        if !trigger then return end

        trigger:SelectTool()
    end)
end)

netstream.Hook("Trigger:Remove", function(id)
    Trigger.selectedID = 0

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:Remove()

    Trigger:UpdateActionLists()
    Trigger:UpdateTriggerList()
end)

netstream.Hook("Trigger:RemoveAll", function()
    Trigger:RemoveAll()

    Trigger:UpdateActionLists()
    Trigger:UpdateTriggerList()
end)

timer.Create("Trigger:IsPlayerInside", 0.05, 0, function()
    local client = LocalPlayer()

    for _, trigger in pairs(Trigger.instances) do
        if trigger.isLocalPlayerInside then
            if !trigger:IsPlayerInside(client) then
                trigger:PlayerExited(client)
            end
        else
            if trigger:IsPlayerInside(client) then
                trigger:PlayerEntered(client)
            end
        end
    end
end)

local selected_trigger_color = Color(255, 247, 0, 100)
function Trigger:PostDrawTranslucentRenderables()
    if !Trigger.drawTriggers then return end

    Trigger:DrawAll()

    local trigger = Trigger:GetSelected()
    if !trigger then return end

    trigger:Draw(selected_trigger_color)
end

function Trigger:DrawAll()
    for _, trigger in pairs(Trigger.instances) do
        trigger:Draw()
    end
end

function Trigger:UpdateActionLists()
    local tr = Trigger:GetSelected()
    if !tr then return end

    for _act, _list in pairs(Trigger.ActionLists) do
        if !IsValid(_list) then continue end

        _list:Clear()

        for k, v in pairs(tr.ActionList[_act]) do
            local act = Trigger:ActionByID(v.action)
            local _line = _list:AddLine(tostring(act.name), tostring(v.name))

            _line.thisActionID = v.action
            _line.thisActionName = v.name
        end
    end
end

function Trigger:UpdateTriggerList()
    local tl = Trigger.TriggerList
    if !IsValid(tl) then return end

    tl:ClearSelection()
    tl:Clear()

    local triggers = Trigger.instances
    for id, data in pairs(triggers) do
        tl:AddLine(tostring(data.name), tostring(id))
    end
end