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
    ["Патроны"] = "attach",
    ["Одежда"] = "user_suit",
    ["Коммуникация"] = "transmit",
    ["Продукты"] = "cake",
    ["Мусор"] = "bin_closed",
    ["Ингредиенты"] = "package_add",
    ["Литература"] = "book",
    ["Медикаменты"] = "heart_add",
    ["Рюкзаки"] = "package",
    ["Остальное"] = "box",
    ["Библиотека"] = "report",
    ["Хранилище"] = "briefcase",
    ["Инструменты"] = "wrench_orange",
    ["Отмычки"] = "connect",
    ["Уникальные"] = "bug",
    ["Оружие"] = "gun",
    ["Оружие - Ближнее"] = "gun",
    ["Оружие - Пистолеты"] = "gun",
    ["Оружие - ПП/Автоматы"] = "gun",
    ["Оружие - Остальное"] = "gun",
    ["Оружие - CSS"] = "gun",
    ["Оружие - CSS Alt"] = "gun"
}

spawnmenu.AddContentType("Item", function(container, item)
    local name = item:GetName()
    if !name then return end

    local uniqueID = item.uniqueID

    local icon = vgui.Create("ContentIcon", container)
    icon:SetName(name)
    icon:SetContentType("Item")
    icon:SetSpawnName(uniqueID)
    icon:SetMaterial(item.icon)

    local path = item.icon
    if string.isURL(path) then
        asterionlib.downloader:Image(path, function(_, imagePath)
            icon:SetMaterial(imagePath)
        end)
    else
        icon:SetMaterial(path)
    end

    icon.DoClick = function()
        netstream.Start("ItemBase:SpawnItem", uniqueID)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    icon.OpenMenu = function()
        local Menu = DermaMenu()

        local _ = Menu:AddOption("Скопировать ID", function()
            SetClipboardText(uniqueID)
        end)
        _:SetIcon("icon16/brick_link.png")

        local _ = Menu:AddOption("Выдать себе", function()
            netstream.Start("ItemBase:GiveItem", LocalPlayer(), uniqueID)
        end)
        _:SetIcon("icon16/accept.png")

        local subMenu, parentMenuOption = Menu:AddSubMenu("Выдать игроку")
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

spawnmenu.AddCreationTab("Предметы", function()
    local base = vgui.Create("SpawnmenuContentPanel")
    local tree = base.ContentNavBar.Tree
    local categories = {}

    for k, v in SortedPairsByMemberValue(ItemBase.list, "category") do
        if v:GetCategory() == "Converter" then continue end
        if categories[v:GetCategory()] then continue end

        local node = tree:AddNode(v:GetCategory(), icons[v:GetCategory()] and ("icon16/" .. icons[v:GetCategory()] .. ".png") or "icon16/brick.png")

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


timer.Simple(0, function()
    RunConsoleCommand("spawnmenu_reload")
end)