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

file.CreateDir(Trigger.files.config)
file.CreateDir(Trigger.files.map)


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
    if !self.drawTriggers then return end

    self:DrawAll()

    local trigger = self:GetSelected()
    if !trigger then return end

    trigger:Draw(selected_trigger_color)
end


function Trigger:PlayerBindPress(client, bind, pressed)
    if bind != "+use" then return end

    local trigger = self:FindInTraceLine(client)
    if !trigger then return end

    trigger:PlayerInteracted()
end


function Trigger:DrawAll()
    for _, trigger in pairs(self.instances) do
        trigger:Draw()
    end
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
    -------- Вырезать позже
    if Trigger:IsOutdated(data) then
        file.Delete(self.files.map .. "/" .. name, "DATA")
        return chat.AddText("Файл сохранения устарел и был удалён.")
    end
    --------
    netstream.Heavy("Trigger:LoadConfig", data)
end


---------------------------------------------------------------------------------- Старый формат(Вырезать позже)

function Trigger:IsOutdated(data)
    if data[1][1] then return true end
    return false
end
----------------------------------------------------------------------------------


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