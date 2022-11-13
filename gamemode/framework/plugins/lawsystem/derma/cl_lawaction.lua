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

local function createCategory(panel, name)
	local category = panel:Add("Panel")
	category:Dock(TOP)
	category:DockMargin(0, 0, 0, H(5))
	category.Paint = function(_, w, h)
		surface.SetDrawColor(255, 61, 96, 50)
	    surface.DrawOutlinedRect(0, 0, w, h, 1)
	end

	local title = category:Add("Panel")
	title:Dock(TOP)
	title:DockMargin(0, 0, 0, H(3))
	title:SetTall(H(20))
	title.Paint = function(_, w, h)
		surface.SetDrawColor(255, 61, 96, 50)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(name, "arb.Font_FuturaPTBook_6", 5, 0, color_white, TEXT_ALIGN_LEFT)
	end

    local button = title:Add("DButton")
    button:SetText("")
    button:Dock(FILL)
    button.alpha = 0
    button.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, category.isHide and 200 or 0)

        surface.SetDrawColor(0, 0, 0, _.alpha)
        surface.DrawRect(0, 0, w, h)
    end
    button.DoClick = function()
        category.isHide = !category.isHide

        category:SizeTo(category:GetWide(), category.isHide and H(20) or category.normalTall, 0.25, 0, -1)
    end

	category.PerformLayout = function(_, w, h)
        if !category.c then
    		category:SizeToChildren(false, true)

            category.normalTall = category:GetTall()

            category.c = true
        end
	end

	return category
end

local function isURL(url)
    return string.Left(url, 8) == "https://" or string.Left(url, 7) == "http://"
end

local function createItemButton(panel, id, path, name, data)
    local icon = nil
    if isURL(path) then
        asterionlib.DownloadImage(path, function(mat)
            icon = mat
        end)
    else
        icon = Material(path)
    end

	local showText = Arbitrage.gui.lawaction.items[id] and "Предъвил: " .. Arbitrage.gui.lawaction.items[id] or "Вы не показывали этот предмет!"

	local itemButton = panel:Add("DButton")
	itemButton:SetText("")
	itemButton:Dock(TOP)
	itemButton:DockMargin(W(3), 0, W(3), H(3))
	itemButton:SetTall(H(40))
	itemButton.alpha = 0
	itemButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

		surface.SetDrawColor(255, 61, 96, _.alpha)
	    surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 61, 96, 50)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

        if icon then
    		surface.SetDrawColor(255, 255, 255)
    		surface.SetMaterial(icon)
    		surface.DrawTexturedRect(0, 0, h, h)
        end

		draw.SimpleText(name, "arb.Font_FuturaPTBook_6", h + 5, 0, color_white, TEXT_ALIGN_LEFT)
		draw.SimpleText(showText, "arb.Font_FuturaPTBook_6", h + 5, H(18), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT)
	end
	itemButton.DoClick = function()
	    local x = 0
	    local y = ScrH() * 0.25
	    local wide = W(620)

	    local evidence = vgui.Create("arb.EvidenceMenuSub")
	    evidence:SetEvidence(data)
	    evidence:SetPos(x + wide * 1.05, y)
	end

	local iconPresent = Material("danganronpa/ui/info_3.png")
	local present = itemButton:Add("DButton")
	present:SetText("")
	present:Dock(RIGHT)
	present:DockMargin(0, H(10), W(5), H(10))
	present:SetWide(H(20))
	present.alpha = 30
	present.size = 0.8
	present.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
		_.size = Lerp(FrameTime() * 10, _.size, _:IsHovered() and 1 or 0.8)

		local w_size, h_size = w * _.size, h * _.size

		surface.SetDrawColor(255, 255, 255, _.alpha)
		surface.SetMaterial(iconPresent)
		surface.DrawTexturedRect(w / 2 - w_size / 2, h / 2 - h_size / 2, w_size, h_size)
	end
	present.DoClick = function()
	    netstream.Start("arb.ShowItem", id)
	end

	local item = ItemBase.instances[id]
	if item and item.lawInspect then
		local iconInspect = Material("danganronpa/ui/info_4.png")
		local inspect = itemButton:Add("DButton")
		inspect:SetText("")
		inspect:Dock(RIGHT)
		inspect:DockMargin(0, H(10), W(5), H(10))
		inspect:SetWide(H(20))
		inspect.alpha = 30
		inspect.size = 0.8
		inspect.Paint = function(_, w, h)
			_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
			_.size = Lerp(FrameTime() * 10, _.size, _:IsHovered() and 1 or 0.8)

			local w_size, h_size = w * _.size, h * _.size

			surface.SetDrawColor(255, 255, 255, _.alpha)
			surface.SetMaterial(iconInspect)
			surface.DrawTexturedRect(w / 2 - w_size / 2, h / 2 - h_size / 2, w_size, h_size)
		end
		inspect.DoClick = function()
	        netstream.Start("arb.InspectItem", id)
	    end
	end
end

local function getEvidence(id)
    local data = Evidence:GetEvidence(id)
    if !data then return end

    local dEvidence = Evidence.icons
    local evidenceMat = Material(dEvidence[data.image])

    local dRibbon = Evidence.ribbons
    local ribbonMat = Material(dRibbon[data.ribbon][1])

    local description = data.name
    if utf8.len(description) > 30 then
        description = description:utf8sub(1, 27) .. "..."
    end

    return evidenceMat, ribbonMat, description, data
end

local function createEvidenceButton(panel, id, time)
    if !Evidence:GetEvidence(id) then return end
    local evidenceMat, ribbonMat, name, data = getEvidence(id)

    local showText = "Никто не показывал эту улику!"
    local timeText = "Найдено в " .. Arbitrage.FormatTime(time)

    local evidencesList = Arbitrage.GetShowEvidences()
    if evidencesList[id] then
        showText = "Предъявил: " .. evidencesList[id][2]
    end

	local evidenceButton = panel:Add("DButton")
	evidenceButton:SetText("")
	evidenceButton:Dock(TOP)
	evidenceButton:DockMargin(W(3), 0, W(3), H(3))
	evidenceButton:SetTall(H(58))
	evidenceButton.alpha = 0
	evidenceButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

		surface.SetDrawColor(255, 61, 96, _.alpha)
	    surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 61, 96, 50)
		surface.DrawOutlinedRect(0, 0, w, h, 1)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(evidenceMat)
		surface.DrawTexturedRect(0, 0, h, h)

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(ribbonMat)
        surface.DrawTexturedRect(0, 0, h, h)

		draw.SimpleText(name, "arb.Font_FuturaPTBook_6", h + 5, 0, color_white, TEXT_ALIGN_LEFT)
		draw.SimpleText(timeText, "arb.Font_FuturaPTBook_6", h + 5, H(18), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT)
        draw.SimpleText(showText, "arb.Font_FuturaPTBook_6", h + 5, H(36), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT)
	end
	evidenceButton.DoClick = function()
	    local x = 0
	    local y = ScrH() * 0.25
	    local wide = W(620)

	    local evidence = vgui.Create("arb.EvidenceMenuSub")
	    evidence:SetEvidence(data)
	    evidence:SetPos(x + wide * 1.05, y)
	end

	local iconPresent = Material("danganronpa/ui/info_3.png")
	local present = evidenceButton:Add("DButton")
	present:SetText("")
	present:Dock(RIGHT)
	present:DockMargin(0, H(19), W(5), H(19))
	present:SetWide(H(20))
	present.alpha = 30
	present.size = 0.8
	present.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
		_.size = Lerp(FrameTime() * 10, _.size, _:IsHovered() and 1 or 0.8)

		local w_size, h_size = w * _.size, h * _.size

		surface.SetDrawColor(255, 255, 255, _.alpha)
		surface.SetMaterial(iconPresent)
		surface.DrawTexturedRect(w / 2 - w_size / 2, h / 2 - h_size / 2, w_size, h_size)
	end
	present.DoClick = function()
	    netstream.Start("arb.ShowEvidence", id)
	end
end

local PLUGIN = PLUGIN

local categoryData = {
    {
        name = "Эмоции",
        icon = "icon16/emoticon_grin.png",
        data = function(client, panel)
            local faction = Character.team:GetByID(client:Team())
            if !faction then return end

            local emoji = Character.emoji:GetByUniqueID(faction:GetUniqueID())
            if !emoji then return end

            client.selectedEmoji = client.selectedEmoji or 1

            for category, stored in pairs(emoji:GetData()) do
                local c = createCategory(panel, category)
                local List = c:Add("DIconLayout")
                List:Dock(FILL)
                List:SetSpaceY(W(5))
                List:SetSpaceX(H(5))

                local index, count = 0, 1
                for id, path in pairs(stored.min) do
                    local mat = Material(path)

                    local ListItem = List:Add("DButton")
                    ListItem:SetText("")
                    ListItem:SetSize(W(100), H(140))
                    ListItem.alpha = 0
                    ListItem.Paint = function(_, w, h)
                        local isSelect = client.selectedEmoji == id and true or false

                        _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or isSelect) and 20 or 0)

                        surface.SetDrawColor(255, 61, 96, _.alpha)
                        surface.DrawRect(0, 0, w, h)

                        surface.SetDrawColor(255, 255, 255)
                        surface.SetMaterial(mat)
                        surface.DrawTexturedRect(0, 0, w, h)

                        surface.SetDrawColor(255, 61, 96, 50)
                        surface.DrawOutlinedRect(0, 0, w, h, 1)
                    end

                    ListItem.DoClick = function()
                        client.selectedEmoji = id
                        netstream.Start("arb.ChangeEmoji", id)
                    end

                    if index >= 3 then
                        count = count + 1
                        index = 1
                    else
                        index = index + 1
                    end
                end

                c:SetTall(c:GetTall() + count * H(140) + count * H(5))
            end
        end
    },
    {
        name = "Улики",
        icon = "icon16/image.png",
        data = function(client, panel)
            local showEvidencePanel = createCategory(panel, "Показанные улики")
            local yourEvidencePanel = createCategory(panel, "Ваши улики")

            for id, stored in pairs(Arbitrage.GetShowEvidences()) do
                if Evidence:GetEvidence(id) then
                    createEvidenceButton(showEvidencePanel, id, stored[1])
                end
            end

            for id, time in pairs(client:GetEvidences()) do
                createEvidenceButton(yourEvidencePanel, id, time)
            end
        end
    },
    {
    	name = "Предметы",
    	icon = "icon16/package.png",
        data = function(client, panel)
    		local showItemsPanel = createCategory(panel, "Показанные предметы")
    		local yourItemsPanel = createCategory(panel, "Ваши предметы")

            local inventory = client:GetInventory()
            local items = {}

            if inventory then
                for _, item in ipairs(inventory:GetItems()) do
                    local id = item:GetID()

                    items[id] = true
                end
            end

            for id in pairs(Arbitrage.gui.lawaction.items) do
                items[id] = true
            end

            for id in pairs(items) do
                local item = ItemBase.instances[id]
                if !item then continue end

                local name = item:GetName()
                local icon = item:GetIcon()
                local data = {
                    name = name,
                    description = item:GetDescription()
                }

                local l_item = Arbitrage.gui.lawaction.items[id]
                if l_item then
                    createItemButton(showItemsPanel, id, icon, name, data)
                end

                if inventory and inventory:HasItem(id) then
                    createItemButton(yourItemsPanel, id, icon, name, data)
                end
            end
        end
    }
}

local function isActiveRS()
    local rs_panel = Arbitrage.gui.RebuttalShowdowns
    if IsValid(rs_panel) and rs_panel.players[LocalPlayer()] then
        return true
    end

    return false
end

local PANEL = {}

function PANEL:Init()
    if IsValid(Arbitrage.gui.lawaction) then Arbitrage.gui.lawaction:Remove() end

    Arbitrage.gui.lawaction = self

    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetPos(5, 5)
    self:SetSize(W(360), H(500))
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetZPos(30000)
    self:MakePopup()
    self.select = 0

    self.focusSizeMax = 0
    self.focusSize = RealTime()
    self.interruptionSizeMax = 0
    self.interruptionSize = RealTime()

    self:SetKeyboardInputEnabled(false)

    self.topPanel = self:Add("Panel")
    self.topPanel:SetTall(H(27))
    self.topPanel:Dock(TOP)
    self.topPanel:DockMargin(0, H(5), 0, 0)

    self.mainPanel = self:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(W(5), H(2), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local interruptionButton = self:Add("DButton")
    interruptionButton:SetText("")
    interruptionButton:SetTall(H(25))
    interruptionButton:Dock(BOTTOM)
    interruptionButton:DockMargin(0, H(2), 0, 0)
    interruptionButton.alpha = 0.1
    interruptionButton.Paint = function(panel, w, h)
        panel.alpha = Lerp(FrameTime() * 10, panel.alpha, (panel:IsHovered() and panel:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        local t = (self.interruptionSize or 0) - RealTime()
        local c = Color(99, 17, 32)
        local text = "Опровергнуть"

        if !Arbitrage.OffRebuttalShowdown() then
            if !self.green then
                if isActiveRS() then
                    text = "Остановить Rebuttal Showdowns"

                    if LocalPlayer():GetLocalVar("rs_stopvoting") then
                        text = "Ожидаем второго участника"

                        surface.SetDrawColor(ColorAlpha(Color(111, 191, 83), 255 / 2))
                        surface.DrawRect(0, 0, w, h)
                    end
                end
            else
                text = "Rebuttal Showdowns"
                c = Color(111, 191, 83)
            end
        end

        surface.SetDrawColor(ColorAlpha(c, 255 / 2))
        surface.DrawRect(0, 0, t * (w / self.interruptionSizeMax), h)

        surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.DrawText(text, "arb.Font_FuturaPTBook_7", w / 2, H(1), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
    end
    interruptionButton.DoClick = function()
        if isActiveRS() and !Arbitrage.OffRebuttalShowdown() then
            return netstream.Start("arb.StopRebuttalShowdowns")
        end

        netstream.Start("arb.LawInterruption")
    end

    local focusButton = self:Add("DButton")
    focusButton:SetText("")
    focusButton:SetTall(H(25))
    focusButton:Dock(BOTTOM)
    focusButton.alpha = 0.1
    focusButton.Paint = function(panel, w, h)
        panel.alpha = Lerp(FrameTime() * 10, panel.alpha, (panel:IsHovered() and panel:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        local t = (self.focusSize or 0) - RealTime()
        surface.SetDrawColor(99, 17, 32, 255 / 2)
        surface.DrawRect(0, 0, t * (w / self.focusSizeMax), h)

        surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.DrawText("Сфокусировать камеру на себя", "arb.Font_FuturaPTBook_7", w / 2, H(1), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
    end
    focusButton.DoClick = function()
        netstream.Start("arb.LawFocus")
    end

    self.topPanel.PerformLayout = function(_, w, h)
        self.topPanel.PerformLayout = nil

        self:InitCategory()
    end

    self.items = {}
end

function PANEL:InitCategory()
    self.panels = {}

    for k, v in pairs(categoryData) do
        local s = self.topPanel:GetTall()

        local parsed = asterionlib.markup.Parse("<font=arb.Font_FuturaPTBook_6><colour=255,255,255><img=materials/" .. v.icon .. ", " .. s / 2 .. "x" .. s / 2 .. ", 255, 255, 255> " .. v.name .. "</colour></font>")

        local category = self.topPanel:Add("DButton")
        category:SetText("")
        category:Dock(LEFT)
        category:SetWide(self.topPanel:GetWide() / #categoryData)
        category.alpha = 0
        category.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.1, h - 6, w - w * 0.2, 2)

            if self.select == k then
                surface.SetDrawColor(255, 61, 96, 50)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            parsed:draw(w / 2, h / 2 - H(10), TEXT_ALIGN_CENTER)
        end

        category.DoClick = function()
            self.select = k

            if IsValid(self.inPanel) then self.inPanel:Remove() end

            self.inPanel = self.mainPanel:Add("DScrollPanel")
            self.inPanel:Dock(FILL)
            self.inPanel:SetAlpha(0)
            self.inPanel:AlphaTo(255, 0.3)

            local bar = self.inPanel:GetVBar()
            bar.Paint = function(_, w, h)
                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
            end

            bar.btnUp.Paint = zero
            bar.btnDown.Paint = zero

            bar.btnGrip.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
            end

            bar:SetWide(W(15))

            v.data(LocalPlayer(), self.inPanel)
        end

        self.panels[k] = category
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    draw.DrawText("Меню классного суда", "arb.Font_FuturaPTBook_9", 10, 0, color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("arb.LawAction", PANEL, "DFrame")


concommand.Add("arb_close_lawaction", function(client, cmd, args)
    if IsValid(Arbitrage.gui.lawaction) then
        Arbitrage.gui.lawaction:Remove()
    end
end)