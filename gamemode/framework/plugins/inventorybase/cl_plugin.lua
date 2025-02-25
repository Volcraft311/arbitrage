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

        local descriptionText = asterionlib.WrapText(F(panel.item:GetDescription()), w, descFont)
        for i in pairs(descriptionText) do
            local text = descriptionText[i]
            local y = (i - 1) * descHeight

            draw.SimpleText(text, descFont, 0, y, color_white, TEXT_ALIGN_LEFT)
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


local cornerRadius = 5
local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(255, 61, 96, 165.75))
        draw.RoundedBox(cornerRadius, 2, 2, w - 4, h - 4, Color(41, 22, 25))
    end
end

local function paintOption(panel)
    panel:SetFont("arb.Font_FuturaPTBook_6")
    panel.Paint = function(_, w, h)
        local alpha = 130

        if _:IsHovered() and _:IsEnabled() then
            surface.SetDrawColor(27, 10, 13, 200)
            surface.DrawRect(2, 2, w - 4, h - 4)

            alpha = 255
        end

        if !_:IsEnabled() then
            surface.SetDrawColor(255, 0, 0, 20)
            surface.DrawRect(2, 0, w - 4, h)

            alpha = 255
        end

        panel:SetTextColor(Color(240, 240, 240, alpha))
    end
end

local barMargin = 23
local function paintBar(panel)
    local children = panel:GetChildren()
    local bar = children[2]
    if !IsValid(bar) then return end

    bar:SetWide(30)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(barMargin, 30, w - barMargin - 4, h - 60)
    end
    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(barMargin, 0, w - barMargin - 4, h)
    end
end

netstream.Hook("InventoryBase:OpenActions", function(itemID, data)
    local Menu = DermaMenu()
    paintMenu(Menu)

    for k, v in SortedPairsByMemberValue(data, 1) do
        local panel = Menu:AddOption(v[1], function()
            netstream.Start("ItemBase:SendAction", itemID, v[1])
        end)

        paintOption(panel)

        if v[2] then
            panel:SetImage(v[2])
        end
    end

    Menu:Open()

    Menu:SetAlpha(0)
    Menu:AlphaTo(255, 0.3)
end)