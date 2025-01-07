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

function BedSystem:NetworkEntityCreated(entity)
    local model = entity:GetModel()
    if !model then return end

    model = entity:GetModel():lower()
    if !BedSystem.allowBed[model] then return end

    entity.Tooltip = function(this, tooltip)
        tooltip:SetTitle("Кровать")
        tooltip:SetDescription("Уютная кровать, обитая мягким материалом. На ней вы можете расслабиться и отдохнуть.")
        tooltip:SetIcon("asterion/academy/ui/tooltip/bed.png")
    end
end

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

spawnmenu.AddContentType("Bed", function(container, model)
    local icon = vgui.Create("ContentIcon", container)
    icon:SetName(model)
    icon:SetContentType("Bed")
    icon:SetSpawnName(model)
    icon.DoClick = function()
        RunConsoleCommand("gm_spawn", model)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    if IsValid(icon.Image) then
        icon.Image:Remove()

        icon.Image = icon:Add("DPanel")
        icon.Image:SetPos(0, 0)
        icon.Image:SetSize(0, 0)
        icon.Image.PaintAt = function() end
    end

    icon.Image2 = icon:Add("DModelPanel")
    icon.Image2:SetPos(3, 3)
    icon.Image2:SetSize(128 - 6, 128 - 6 - 22)
    icon.Image2:SetModel(model)
    icon.Image2.DoClick = function()
        RunConsoleCommand("gm_spawn", model)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    if IsValid(container) then
        container:Add(icon)
    end
end)

spawnmenu.AddCreationTab("Кровати", function()
    local base = vgui.Create("SpawnmenuContentPanel")
    local tree = base.ContentNavBar.Tree

    local node = tree:AddNode("Все объекты", "icon16/brick.png")
    node.DoPopulate = function(this)
        if this.Container then return end

        this.Container = vgui.Create("ContentContainer", base)
        this.Container:SetVisible(false)
        this.Container:SetTriggerSpawnlistChange(false)

        for k, v in pairs(BedSystem.allowBed) do
            spawnmenu.CreateContentIcon("Bed", this.Container, k)
        end
    end

    node.DoClick = function(this)
        this:DoPopulate()
        base:SwitchPanel(this.Container)
    end

    local FirstNode = tree:Root():GetChildNode(0)
    if IsValid(FirstNode) then
        FirstNode:InternalDoClick()
    end

    return base
end, "icon16/photo.png")