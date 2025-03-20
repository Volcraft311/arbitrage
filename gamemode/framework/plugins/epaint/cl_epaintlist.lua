--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


spawnmenu.AddContentType("EPaint", function(container, model)
    local icon = vgui.Create("ContentIcon", container)
    icon:SetName(model)
    icon:SetContentType("EPaint")
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

    icon.DModelPanel = icon:Add("DModelPanel")
    icon.DModelPanel:SetPos(3, 3)
    icon.DModelPanel:SetSize(128 - 6, 128 - 6 - 22)
    icon.DModelPanel:SetModel(model)
    icon.DModelPanel.DoClick = function()
        RunConsoleCommand("gm_spawn", model)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    if IsValid(container) then
        container:Add(icon)
    end
end)

timer.Simple(0, function()
    Arbitrage.language:AddCreationTab("#epaint_title")

    spawnmenu.AddCreationTab(L("#epaint_title"), function()
        local base = vgui.Create("SpawnmenuContentPanel")
        local tree = base.ContentNavBar.Tree

        local node = tree:AddNode(L("#epaint_objects"), "icon16/brick.png")
        node.DoPopulate = function(this)
            if this.Container then return end

            this.Container = vgui.Create("ContentContainer", base)
            this.Container:SetVisible(false)
            this.Container:SetTriggerSpawnlistChange(false)

            for k, v in pairs(EPaint.allowModels) do
                spawnmenu.CreateContentIcon("EPaint", this.Container, k)
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
    end, "icon16/palette.png")
end)