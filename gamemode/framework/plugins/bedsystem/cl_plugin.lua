--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


hook("NetworkEntityCreated", function(entity)
    local model = entity:GetModel()
    if !model then return end

    model = entity:GetModel():lower()
    if !BedSystem.allowBed[model] then return end

    entity.Tooltip = function(this, tooltip)
        tooltip:SetTitle("#bed_tooltip_title")
        tooltip:SetDescription("#bed_tooltip_desc")
        tooltip:SetIcon("asterion/academy/ui/tooltip/bed.png")
    end
end)


local players_hook = {}
local function create_hook()
    hook.Add("CalcMainActivity", "BedSystem:CalcMainActivity", function(client)
        if !players_hook[client] then return end

        return -1, client:LookupSequence(BedSystem.animation)
    end)
end

local function remove_hook()
    players_hook = {}

    hook.Remove("CalcMainActivity", "BedSystem:CalcMainActivity")
end

local function update_hook()
    local count = 0
    for client in pairs(players_hook) do
        if IsValid(client) then
            count = count + 1
        end
    end

    if count <= 0 then
        remove_hook()
    end
end

netstream.Hook("BedSystem:LayDownBed", function(client, entity, eyePos, eyeAng)
    if client == true or client == LocalPlayer() then
        if IsValid(BedSystem.panel) then
            BedSystem.panel:Remove()
        end

        local panel = vgui.Create("BedSystem:Menu")
        panel:SetBedData(entity, eyePos, eyeAng)

        BedSystem.panel = panel
    end

    if !isbool(client) and IsValid(client) then
        players_hook[client] = true
        create_hook()
    end
end)

netstream.Hook("BedSystem:GetUpBed", function(client)
    if (client == true or client == LocalPlayer()) and IsValid(BedSystem.panel) then
        BedSystem.panel.bClose = true
        BedSystem.panel:SetBedData(nil)
        BedSystem.panel:AlphaTo(0, 5, 0, function()
            BedSystem.panel:Remove()
        end)
    end

    if !isbool(client) and IsValid(client) then
        players_hook[client] = nil
        update_hook()
    end

    timer.Simple(1, function()
        RunConsoleCommand("arb_camerafix") -- исправление ломание позиции камеры (может возникнуть из-за кривого положения кровати)
    end)
end)