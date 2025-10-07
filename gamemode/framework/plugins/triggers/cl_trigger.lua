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
Trigger.files = {
    tool = "academy_triggertool",
    config = "academy_triggertool_configs",
    map = "academy_triggertool_configs/" .. game.GetMap()
}

local selected_trigger_color = Color(255, 247, 0, 39)


file.CreateDir(Trigger.files.config)
file.CreateDir(Trigger.files.map)


hook.Add("OnTriggerUpdate", "UpdateTriggerUI", function()
    pcall(Trigger.UpdateTriggerList, Trigger)
    pcall(Trigger.UpdateActionList, Trigger)
end)

hook.Add("PostDrawTranslucentRenderables","DrawTriggers", function()
    if !Trigger.drawTriggers then return end
    render.DepthRange(0, 0)
    
    Trigger:DrawAll()

    local trigger = Trigger:GetSelected()
    if !trigger then return end

    trigger:Draw(selected_trigger_color)
end)

function Trigger:DrawAll()
    for _, trigger in pairs(self.instances) do
        trigger:Draw()
    end
end

function Trigger:GetSelected()
    return self:GetByID(self.selectedID)
end


function Trigger:UpdateActionLists()
    local tr = self:GetSelected()

    if !tr then return end
    for _act, _list in pairs(self.ActionLists) do
        if !IsValid(_list) then continue end

        _list:Clear()

        for k, v in pairs(tr.ActionList[_act]) do
            local act = self:ActionByID(v.action)
            local _line = _list:AddLine(tostring(act.name), tostring(v.name))

            _line.thisActionID = v.action
            _line.thisActionName = v.name
        end
    end
end

function Trigger:UpdateTriggerList()
    local tl = self.TriggerList
    if !IsValid(tl) then return end

    tl:ClearSelection()
    tl:Clear()

    local triggers = self.instances
    for id, data in pairs(triggers) do
        tl:AddLine(tostring(data.name), tostring(id))
    end
end

function Trigger:Save(name)
    local save_data = {}
    for k, v in pairs(Trigger.instances) do
        save_data[#save_data + 1] = v:GetSaveData()
    end
    file.Write(self.files.map .. "/" .. name .. ".txt", util.TableToJSON(save_data))
end

function Trigger:Load(name)
    local data = util.JSONToTable(file.Read(self.files.map .. "/" .. name, "DATA"))
    if !data then
        chat.AddText("Файл сохранения повреждён.")
        return
    end
    netstream.Heavy("Trigger:LoadConfig", data)
end


function Trigger:PlayerBindPress(client, bind, pressed)
    if bind != "+use" then return end
    if !pressed then return end

    local collect = self:FindInTraceLine(client)
    for trigger in pairs(collect) do
        trigger:PlayerInteracted()
    end
end


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


netstream.Hook("Trigger:Sync", function(id, data)
    Trigger:Create(data, id)
    hook.Call("OnTriggerUpdate")
end)

netstream.Hook("Trigger:SyncAllTriggers", function(info)
    Trigger:RemoveAll()

    for id, data in pairs(info) do
        Trigger:Create(data, id)
    end
    hook.Call("OnTriggerUpdate")
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

    hook.Call("OnTriggerUpdate")
end)

netstream.Hook("Trigger:RemoveAll", function()
    Trigger:RemoveAll()
    hook.Call("OnTriggerUpdate")
end)