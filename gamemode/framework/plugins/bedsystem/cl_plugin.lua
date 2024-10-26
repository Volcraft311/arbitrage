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

netstream.Hook("BedSystem:LayDownBed", function(entity, eyePos, eyeAng)
    if IsValid(BedSystem.panel) then
        BedSystem.panel:Remove()
    end

    local panel = vgui.Create("BedSystem:Menu")
    panel:SetBedData(entity, eyePos, eyeAng)

    BedSystem.panel = panel
end)

netstream.Hook("BedSystem:GetUpBed", function()
    if !IsValid(BedSystem.panel) then return end

    BedSystem.panel.bClose = true
    BedSystem.panel:SetBedData(nil)
    BedSystem.panel:AlphaTo(0, 5, 0, function()
        BedSystem.panel:Remove()
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
    end

    icon.Image = icon:Add("DModelPanel")
    icon.Image:SetPos(3, 3)
    icon.Image:SetSize(128 - 6, 128 - 6 - 22)
    icon.Image:SetModel(model)
    icon.Image.DoClick = function()
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