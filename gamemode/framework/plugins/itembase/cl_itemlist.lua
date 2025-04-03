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


local PLUGIN = PLUGIN

local icons = {
    ["#item_category_ammo"] = "attach",
    ["#item_category_food"] = "cake",
    ["#item_category_medical"] = "heart_add",
    ["#item_category_backpacks"] = "package",
    ["#item_category_other"] = "box",
    ["#item_category_library"] = "report",
    ["#item_category_lockpicks"] = "connect",
    ["#item_category_unique"] = "bug",
    ["#item_category_gun"] = "gun",
    ["#item_category_gun_melee"] = "gun",
    ["#item_category_gun_pistol"] = "gun",
    ["#item_category_gun_submachine"] = "gun",
    ["#item_category_gun_other"] = "gun",
    ["#item_category_gun_css"] = "gun",
    ["#item_category_gun_css_alt"] = "gun",
    ["#item_category_handcuffs"] = "pilcrow"
}

spawnmenu.AddContentType("Item", function(container, item)
    local name = item:GetName()
    if !name then return end

    local uniqueID = item.uniqueID

    local icon = vgui.Create("ContentIcon", container)
    icon:SetName(L(name))
    icon:SetContentType("Item")
    icon:SetSpawnName(uniqueID)
    icon:SetMaterial(item.icon)

    if string.isURL(item.icon) then
        asterionlib.downloader:Image(item.icon, function(mat, path)
            if !path then return end

            icon:SetMaterial(path)
        end)
    else
        icon:SetMaterial(item.icon)
    end

    icon.DoClick = function()
        netstream.Start("ItemBase:SpawnItem", uniqueID)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    icon.OpenMenu = function()
        local Menu = DermaMenu()

        local _ = Menu:AddOption(L("#itemlist_copy_id"), function()
            SetClipboardText(uniqueID)
        end)
        _:SetIcon("icon16/brick_link.png")

        local _ = Menu:AddOption(L("#itemlist_give_me"), function()
            netstream.Start("ItemBase:GiveItem", LocalPlayer(), uniqueID)
        end)
        _:SetIcon("icon16/accept.png")

        local subMenu, parentMenuOption = Menu:AddSubMenu(L("#itemlist_give_player"))
        parentMenuOption:SetIcon("icon16/status_online.png")

        for k, v in ipairs(player.GetAll()) do
            if v == LocalPlayer() then continue end

            local _ = subMenu:AddOption(v:FullName(), function()
                netstream.Start("ItemBase:GiveItem", v, uniqueID)
            end)

            local iconC = Arbitrage.chat:GetIcon(v)
            if iconC then
                _:SetIcon(iconC:GetName() .. ".png")
            end
        end

        Menu:Open()
    end

    if IsValid(container) then
        container:Add(icon)
    end
end)

timer.Simple(0, function()
    Arbitrage.language:AddCreationTab("#items_title")

    spawnmenu.AddCreationTab(L("#items_title"), function()
        local base = vgui.Create("SpawnmenuContentPanel")
        local tree = base.ContentNavBar.Tree
        local categories = {}

        local searchPanel = vgui.Create("DPanel", base.ContentNavBar)
        searchPanel:Dock(TOP)
        searchPanel:SetTall(30)
        searchPanel:DockMargin(0, 0, 0, 5)
        searchPanel.Paint = function() end

        local searchEntry = vgui.Create("DTextEntry", searchPanel)
        searchEntry:Dock(FILL)
        searchEntry:SetPlaceholderText(L("#itemlist_search"))
        searchEntry.OnEnter = function(this)
            base:SearchItems(this:GetText())
        end

        local icon = Material("icon16/magnifier.png")
        local icon_size = 0.5
        local searchButton = vgui.Create("DButton", searchPanel)
        searchButton:Dock(RIGHT)
        searchButton:SetWide(30)
        searchButton:SetText("")
        searchButton.DoClick = function()
            base:SearchItems(searchEntry:GetText())
        end
        searchButton.Paint = function(_, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))

            surface.SetDrawColor(color_white)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(w / 2 - h * icon_size / 2, h / 2 - h * icon_size / 2, h * icon_size, h * icon_size)
        end

        function base:SearchItems(searchText)
            searchText = searchText:utf8lower():Trim()

            if !IsValid(self.searchResultsContainer) then
                self.searchResultsContainer = vgui.Create("ContentContainer", base)
                self.searchResultsContainer:SetVisible(false)
                self.searchResultsContainer:SetTriggerSpawnlistChange(false)
            else
                self.searchResultsContainer:Clear()
            end

            if searchText == "" then
                if IsValid(self.searchResultsContainer) then
                    self.searchResultsContainer:SetVisible(false)
                end

                if IsValid(tree:Root():GetChildNode(0)) then
                    tree:Root():GetChildNode(0):InternalDoClick()
                end

                return
            end

            for k, v in pairs(ItemBase.list) do
                if v:GetCategory() == "Converter" then continue end

                local itemName = L(v:GetName()):utf8lower():Trim()
                if itemName:find(searchText, 1, true) then
                    spawnmenu.CreateContentIcon("Item", self.searchResultsContainer, v)
                end
            end

            base:SwitchPanel(self.searchResultsContainer)
        end

        for k, v in SortedPairsByMemberValue(ItemBase.list, "category") do
            if v:GetCategory() == "Converter" then continue end
            if categories[v:GetCategory()] then continue end

            local category = v:GetCategory()
            local node = tree:AddNode(L(category), icons[category] and ("icon16/" .. icons[category] .. ".png") or "icon16/brick.png")

            node.DoPopulate = function(this)
                if this.Container then return end

                this.Container = vgui.Create("ContentContainer", base)
                this.Container:SetVisible(false)
                this.Container:SetTriggerSpawnlistChange(false)

                for k2, v2 in pairs(ItemBase.list) do
                    if v:GetCategory() == v2:GetCategory() then
                        spawnmenu.CreateContentIcon("Item", this.Container, v2)
                    end
                end
            end

            node.DoClick = function(this)
                this:DoPopulate()
                base:SwitchPanel(this.Container)
            end

            categories[v:GetCategory()] = node
        end

        local FirstNode = tree:Root():GetChildNode(0)
        if IsValid(FirstNode) then
            FirstNode:InternalDoClick()
        end

        return base
    end, "icon16/book_addresses.png")
end)