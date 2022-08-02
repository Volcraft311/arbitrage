--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
PLUGIN.invpanels = PLUGIN.invpanels or {}

function InventoryBase:CreateInfoPanel(panel, x, y, wide)
    local infoPanel = panel:Add("Panel")
    infoPanel:SetPos(x, y)
    infoPanel:SetSize(wide, panel:GetTall() - infoPanel:GetY())

    do
        local line = infoPanel:Add("Panel")
        line:Dock(TOP)
        line:SetTall(2)
        line.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 10)
            surface.DrawRect(0, 0, w, h)
        end
    end

    local itemName = infoPanel:Add("DLabel")
    itemName:SetFont("arb.Font_FuturaPTDemi_12")
    itemName:SetText("")
    itemName:Dock(TOP)
    itemName:DockMargin(0, H(20), 0, 0)
    itemName:SizeToContents()

    local itemCategory = infoPanel:Add("DPanel")
    itemCategory:Dock(TOP)
    itemCategory:SetTall(H(30))
    itemCategory:DockMargin(0, H(5), 0, 0)
    itemCategory.value = ""
    itemCategory.Paint = function(_, w, h)
        Arbitrage.DrawTextBlur(_.value, "arb.Font_FuturaPTDemi_9", 2, 2, Color(255, 238, 177, 255), TEXT_ALIGN_LEFT)
    end
    itemCategory.SetText = function(_, data)
        _.value = data
    end

    do
        local line = infoPanel:Add("Panel")
        line:Dock(TOP)
        line:DockMargin(0, H(10), 0, 0)
        line:SetAlpha(0)
        line:SetTall(2)
        line.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 10)
            surface.DrawRect(0, 0, w, h)
        end

        panel.line = line
    end

    local descFont = "arb.Font_FuturaPTBook_8"
    local descHeight = draw.GetFontHeight(descFont)

    local descPanel = infoPanel:Add("DPanel")
    descPanel:Dock(FILL)
    descPanel:DockMargin(0, H(30), 0, 0)
    descPanel.Paint = function(_, w, h)
        if !panel.item then return end

        local descriptionText = asterionlib.WrapText(panel.item:GetDescription(), w, descFont)
        for i in pairs(descriptionText) do
            local text = descriptionText[i]
            local y = (i - 1) * descHeight

            if descriptionText[i]:sub(1, 1) == " " then
                text = descriptionText[i]:gsub(" ", "", 1)
            end

            draw.SimpleText(text, descFont, 0, y, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end
    end

    panel.infoPanel = infoPanel
    panel.itemName = itemName
    panel.itemCategory = itemCategory
end

function InventoryBase:UpdateInventory(id)
    if id then
        local invPanel = InventoryBase.invpanels[id]
        if IsValid(invPanel) then
            invPanel:InitInventory()
        end
    end

    local menuPanel = Arbitrage.gui.fastSlots
    if IsValid(menuPanel) then
        menuPanel:InitSlots()
    end
end

netstream.Hook("InventoryBase:SyncInventory", function(id, w, h, invData, itemsData, owner)
    local inventory = InventoryBase:New(id, w, h)
    inventory:SetOwner(owner)
    inventory.slots = {} -- чистим слоты

    for itemID, value in pairs(itemsData or {}) do
        local uniqueID = value[1]
        local data = value[2]

        ItemBase:New(uniqueID, itemID)
        ItemBase.data[itemID] = data
    end

    for x = 1, w do
        inventory.slots[x] = inventory.slots[x] or {}

        for y = 1, h do
            local itemID = invData[x][y]

            if isnumber(itemID) then
                local item = ItemBase.instances[itemID]
                if !item then continue end

                inventory.slots[x][y] = item
            end
        end
    end

    InventoryBase:UpdateInventory(id)
end)

netstream.Hook("InventoryBase:UpdateInventory", function(id)
    InventoryBase:UpdateInventory(id)
end)

netstream.Hook("InventoryBase:OpenInventory", function(id, name)
    local ran = SysTime() + math.random(1, 9999)
    local uniqueID = "InventoryBase:ValidTimer_" .. ran

    timer.Create(uniqueID, 0.01, 500, function() -- Если инвентарь не успет синхронизироваться
        local inventory = InventoryBase.instances[id]
        if !inventory then return end

        timer.Remove(uniqueID)

        local container = vgui.Create("InventoryBase:Container")
        container:SetContainerInv(inventory, name)
    end)
end)

netstream.Hook("InventoryBase:OpenActions", function(itemID, data)
    local Menu = DermaMenu()

    for k, v in ipairs(data) do
        local option = Menu:AddOption(v, function()
            netstream.Start("ItemBase:SendAction", itemID, v)
        end)

        option.alpha = 0.15
        option:SetFont("arb.Font_FuturaPTBook_12")
        option:SetTextColor(Color(0, 0, 0, 0))
        option.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.15)

            surface.SetDrawColor(15, 5, 6, 255)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(95, 28, 39, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.SimpleText(v, "arb.Font_FuturaPTBook_9", w / 2, -H(3), Color(255, 255, 255, 255 * _.alpha), TEXT_ALIGN_CENTER)
        end
    end

    Menu.Paint = function() end

    Menu:Open()

    Menu:SetAlpha(0)
    Menu:AlphaTo(255, 0.3)
end)