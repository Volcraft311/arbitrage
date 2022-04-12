local PLUGIN = PLUGIN

local icons = {
    ["Боеприпасы"] = "attach",
    ["Одежда"] = "user_suit",
    ["Коммуникация"] = "transmit",
    ["Продукты"] = "cake",
    ["Мусор"] = "bin_closed",
    ["Ингредиенты"] = "package_add",
    ["Литература"] = "book",
    ["Медикаменты"] = "heart_add",
    ["Остальное"] = "box",
    ["Библиотека"] = "report",
    ["Хранилище"] = "briefcase",
    ["Инструменты"] = "wrench_orange",
    ["Оружие"] = "gun"
}

spawnmenu.AddContentType("Item", function(container, item)
    local name = item:GetName()
    local uniqueID = item.uniqueID

    if !name then return end

    local icon = vgui.Create("ContentIcon", container)
    icon:SetContentType("Item")
    icon:SetSpawnName(uniqueID)
    icon:SetName(name)

    icon.DoClick = function()
        netstream.Start("ItemBase:SpawnItem", uniqueID)

        surface.PlaySound("ui/buttonclickrelease.wav")
    end

    icon.OpenMenu = function()
        local Menu = DermaMenu()

        Menu:AddOption("Скопировать ID", function()
            SetClipboardText(uniqueID)
        end)

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

    for k, v in pairs(ItemBase.list) do
        if categories[v.category] then continue end

        local node = tree:AddNode(v.category, icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png")

        node.DoPopulate = function(this)
            if (this.Container) then return end

            this.Container = vgui.Create("ContentContainer", base)
            this.Container:SetVisible(false)
            this.Container:SetTriggerSpawnlistChange(false)

            for k2, v2 in pairs(ItemBase.list) do
                if v.category == v2.category then
                    spawnmenu.CreateContentIcon("Item", this.Container, v2)
                end
            end
        end

        node.DoClick = function(this)
            this:DoPopulate()
            base:SwitchPanel(this.Container)
        end

        categories[v.category] = node
    end

    local FirstNode = tree:Root():GetChildNode(0)

    if (IsValid(FirstNode)) then
        FirstNode:InternalDoClick()
    end

    return base
end, "icon16/book_addresses.png")


timer.Simple(0, function()
    RunConsoleCommand("spawnmenu_reload")
end)