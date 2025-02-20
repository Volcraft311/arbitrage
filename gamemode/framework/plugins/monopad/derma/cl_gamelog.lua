--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		if self.isOpen then return end

		local historyID = ui:GetActiveHistoryID()
		if historyID then
			local monopad = MonoPad:GetObject()
			table.remove(monopad.history, historyID)
		end

		ui:Rebuild()
		asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self.scrollPanel = self:Add("DScrollPanel")
	self.scrollPanel:SetPos(50, 18)
	self.scrollPanel:SetSize(830, 558)
	MonoPad:StartRegisterMeta(self.scrollPanel)

	do
	    local bar = self.scrollPanel:GetVBar()
	    bar:SetWide(3)
	    bar:DockMargin(0, 0, 0, 0)

	    bar.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255, 3)
	        surface.DrawRect(0, 0, w, h)
	    end
	    bar.btnUp.Paint = function(_, w, h) end
	    bar.btnDown.Paint = function(_, w, h) end
	    bar.btnGrip.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, 0, w, h)
	    end
	end

	self:Rebuild()
end

function PANEL:Rebuild()
	self.scrollPanel:Clear()

	for k, v in SortedPairs(Arbitrage.GetGameLogs(), true) do
		self:AddLogs(k, v[1], v[2], v[3], v[4], v[5])
	end

	local monopad = MonoPad:GetObject()
	monopad.gamelogNotify = nil
end

local crossMat = Material("danganronpa/monopad/cross.png")
function PANEL:AddLogs(id, inflictorID, chapterTitle, investigationType, attackerID, time)
	local monopad = MonoPad:GetObject()
	local caseStored = monopad.caseStored[id] or {}
	local m_inflictor = caseStored[1] or nil

	if !inflictorID then
		inflictorID = m_inflictor
	end

	local _, min = nil, nil
	local inflictorFaction = Character.team:GetByID(inflictorID)
	if inflictorFaction then
		local emoji = Character.emoji:GetByUniqueID(inflictorFaction:GetUniqueID())

		if emoji then
			_, min = emoji:GetByIndex(1)
		end
	end

	local stringTime = Arbitrage.FormatTime(time)

	local attackerName = "#monopad_unknown"
	if attackerID then
		local attackerFaction = Character.team:GetByID(attackerID)

		if attackerFaction then
			attackerName = attackerFaction:GetName()
		end
	end

	local info = MonoPad.chapterTypes[investigationType]

	self.panels = self.panels or {}

	local button = self.scrollPanel:Add("DButton")
	button.min = min
	button.inflictorFaction = inflictorFaction
	button:SetText("")
	button:Dock(TOP)
	button:DockMargin(0, 0, 0, 10)
	button:SetTall(160)
	button.alpha = 1
	button.Paint = function(this, w, h)
		this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 0 or 1)

	    local _, y = self.scrollPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.scrollPanel:GetTall() - y)

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
	    	surface.SetDrawColor(0, 0, 0, 240)
		    surface.DrawRect(0, 0, w, h)

		    if this.min then
		    	-- 158
		    	surface.SetDrawColor(255, 255, 255)
		    	surface.SetMaterial(Material(this.min))
		    	surface.DrawTexturedRect(0, -10, 400 * 0.395, 560 * 0.395)

		    	local size = 158  * 0.6
		    	surface.SetMaterial(crossMat)
		    	surface.DrawTexturedRect(158 / 2 - size / 2, 158 / 2 - size / 2 + 20, size, size)
		    end

		    draw.SimpleText("#monopad_gamelog_casenumber" .. id .. ", " .. (this.inflictorFaction and this.inflictorFaction:GetName() or "#monopad_unknown"), MonoPad:GetFont("gamelog_title"), 176, 14, color_white, TEXT_ALIGN_LEFT)
		    draw.SimpleText("#monopad_gamelog_chapter '" .. chapterTitle .. "'", MonoPad:GetFont("gamelog_text"), 176, 44, color_white, TEXT_ALIGN_LEFT)

		    do
		    	local _w, _ = draw.SimpleText("#monopad_gamelog_status ", MonoPad:GetFont("gamelog_text"), 176, 76, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
		    	MonoPad:DrawTextBlur(info[1], MonoPad:GetFont("gamelog_text"), 176 + _w, 76, info[2], TEXT_ALIGN_LEFT, ColorAlpha(info[2], 100))
			end

			do
				local _w, _ = draw.SimpleText("#monopad_gamelog_culprit ", MonoPad:GetFont("gamelog_text"), 176, 102, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
				draw.SimpleText(attackerName, MonoPad:GetFont("gamelog_text"), 176 + _w, 102, color_white, TEXT_ALIGN_LEFT)
			end

			do
				local _w, _ = draw.SimpleText("#monopad_gamelog_started ", MonoPad:GetFont("gamelog_text"), 176, 126, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
				draw.SimpleText("в " .. stringTime, MonoPad:GetFont("gamelog_text"), 176 + _w, 126, color_white, TEXT_ALIGN_LEFT)
			end

			if investigationType == 1 then
				surface.SetDrawColor(0, 0, 0, 250)
				surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(0, 0, 0, 150 * this.alpha)
				surface.DrawRect(0, 0, w, h)
			end

		    surface.SetDrawColor(255, 255, 255, 3)
		    surface.DrawOutlinedRect(0, 0, w, h)
		    surface.DrawRect(509, 10, 1, h - 20)
	    end)
	end

	button.DoClick = function(_, w, h)
		if self.isOpen then return end
		if investigationType == 1 then return end

		self.isOpen = true
		self.scrollPanel:AlphaTo(0, 0.3)
		self.closeButton:AlphaTo(0, 0.3, 0, function()
			local case = self:Add("MonoPad:GameLogSub")
			case:Dock(FILL)
			case:SetData(id)
		end)

		asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
	end

	self.panels[id] = button
end

vgui.Register("MonoPad:GameLog", PANEL, "Panel")


local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		self:AlphaTo(0, 0.3, 0, function()
			local parent = self:GetParent()

			parent.scrollPanel:AlphaTo(255, 0.3)
			parent.closeButton:AlphaTo(255, 0.3)
			parent.isOpen = nil

			self:Remove()
		end)

		asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
end

function PANEL:AddInformation(title, description, hideLine)
	local font = MonoPad:GetFont("gamelog_title")

	surface.SetFont(font)
	local w1, h1 = surface.GetTextSize(title)

	local function drawing(this, w, h)
		local _, y = self.rightPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.rightPanel:GetTall() - y)

		local sizeY = 0

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
		    local size = w - w1 - 25
			local data = asterionlib.WrapText(description, size, font, true)

			surface.SetDrawColor(0, 0, 0, 240)
		    surface.DrawRect(0, 0, w, h)

		    draw.SimpleText(title, font, 20, 14, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)

		    for k, v in ipairs(data) do
		    	draw.SimpleText(v, font, 20 + w1 + 5, 14 + sizeY, color_white, TEXT_ALIGN_LEFT)

		    	sizeY = sizeY + h1
		    end

		    if !hideLine then
			    surface.SetDrawColor(255, 255, 255, 3)
			    surface.DrawRect(20, h - 1, w - 40, 1)
			end
	    end)

	    return sizeY
	end

	local panel = self.infoPanel:Add("DPanel")
	panel:Dock(TOP)
	panel:SetTall(0)
	panel.Paint = function(this, w, h)
		drawing(this, w, h)
	end
	panel.PerformLayout = function(this, w, h)
		if !this.c then
			this.c = true

			local y = drawing(this, w, h)
			this:SetTall(y + h1)
			self.infoPanel:SetTall(self.infoPanel:GetTall() + this:GetTall())
		end
	end
end

function PANEL:SetData(id)
	if IsValid(self.logo) then self.logo:Remove() end
	if IsValid(self.rightPanel) then self.rightPanel:Remove() end


	local log = Arbitrage.GetGameLogs()[id]
	if !log then return end

	local inflictorID = log[1]

	local monopad = MonoPad:GetObject()
	local caseStored = monopad.caseStored[id] or {}

	local m_inflictor = caseStored[1] or nil
	local m_time = caseStored[2] or "#monopad_gamelog_notspecified"
	local m_reason = caseStored[3] or "#monopad_gamelog_notspecified"
	local m_place = caseStored[4] or "#monopad_gamelog_notspecified"
	local m_found = caseStored[5] or "#monopad_gamelog_notspecified"

	if !inflictorID then
		inflictorID = m_inflictor
	end

	local max, min = nil, nil
	local inflictorFaction = Character.team:GetByID(inflictorID)
	if inflictorFaction then
		local emoji = Character.emoji:GetByUniqueID(inflictorFaction:GetUniqueID())
		max, min = emoji:GetByIndex(1)
	end

	local parent = self:GetParent()
	parent.panels[id].min = min
	parent.panels[id].inflictorFaction = inflictorFaction

	self.logo = self:Add("DPanel")
	self.logo:SetPos(100, 18)
	self.logo:SetSize(350, 558)
	self.logo.Paint = function(_, w, h)
		if max then
			local size = 1300 * 0.5
			local sizeW, sizeH = size, size * 1.575

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
		        surface.DrawRect(0, 0, w, h)
		    end, function()
			    surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material(max))
				surface.DrawTexturedRect(w / 2 - sizeW / 2, h / 2 - sizeH / 2, sizeW, sizeH)
		    end)
		end
	end

	self.rightPanel = self:Add("DScrollPanel")
	self.rightPanel:SetPos(490, 18)
	self.rightPanel:SetSize(410, 558)

	do
	    local bar = self.rightPanel:GetVBar()
	    bar:SetWide(3)
	    bar:DockMargin(0, 0, 0, 0)

	    bar.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255, 3)
	        surface.DrawRect(0, 0, w, h)
	    end
	    bar.btnUp.Paint = function(_, w, h) end
	    bar.btnDown.Paint = function(_, w, h) end
	    bar.btnGrip.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, 0, w, h)
	    end
	end

	self.infoPanel = self.rightPanel:Add("Panel")
	self.infoPanel:Dock(TOP)
	self.infoPanel:DockMargin(0, 0, 10, 10)
	self.infoPanel:SetTall(0)
	MonoPad:StartRegisterMeta(self.infoPanel)

	self:AddInformation("#monopad_gamelog_victim", inflictorFaction and inflictorFaction:GetName() or "#monopad_gamelog_unknown")
	self:AddInformation("#monopad_gamelog_time", m_time)
	self:AddInformation("#monopad_gamelog_cause", m_reason)
	self:AddInformation("#monopad_gamelog_place", m_place)
	self:AddInformation("#monopad_gamelog_discovery", m_found, true)

	local editButton = self.infoPanel:Add("DButton")
	editButton:SetText("")
	editButton:SetPos(349, 18)
	editButton:SetSize(20, 20)
	editButton.alpha = 0.05
	editButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)

		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(Material("danganronpa/monopad/edit.png"))
		surface.DrawTexturedRect(0, 0, h, h)
	end
	editButton.DoClick = function(_, w, h)
		local panel = vgui.Create("MonoPad:GameLogSubEdit")
		panel:SetData(inflictorID, m_time, m_reason, m_place, m_found, function()
			self:SetData(id)
		end, id)

		asterionlib.EmitSound(MonoPad.sounds.message_sent)
	end

	local evidencePanel = self.rightPanel:Add("Panel")
	evidencePanel:Dock(TOP)
	evidencePanel:DockMargin(0, 0, 10, 0)
	evidencePanel:SetTall(120)
	evidencePanel.Paint = function(this, w, h)
		local _, y = self.rightPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.rightPanel:GetTall() - y)

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
		    surface.SetDrawColor(0, 0, 0, 230)
			surface.DrawRect(0, 0, w, h)
	    end)
	end

	local List = evidencePanel:Add("DIconLayout")
	List:Dock(FILL)
	List:DockMargin(20, 20, 20, 20)
	List:SetSpaceX(10)
	List:SetSpaceY(10)
	MonoPad:StartRegisterMeta(List)

	local count = -1
	for eID in pairs(caseStored[6] or {}) do
		local data = Evidence:GetEvidence(eID)
		if !data then continue end

		count = count + 1

		local dEvidence = Evidence.icons
		local evidenceMat = Material(dEvidence[data.image])

		local dRibbon = Evidence.ribbons
		local ribbonMat = Material(dRibbon[data.ribbon][1])
		local time = LocalPlayer():HasEvidence(eID)

		local button = List:Add("DButton")
		button:SetText("")
		button:SetSize(80, 80)
		button.black = 0.6
		button.Paint = function(this, w, h)
			this.black = Lerp(FrameTime() * 10, this.black, this:IsHovered() and 0 or 0.6)

			local _, y = self.rightPanel:GetChildPosition(this)
			local padding = math.max(-y, 0)
			local tall = math.min(h - padding, self.rightPanel:GetTall() - y)

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
		        surface.DrawRect(0, padding, w, tall)
		    end, function()
			    surface.SetDrawColor(0, 0, 0)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(evidenceMat)
				surface.DrawTexturedRect(0, 0, h, h)

			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(ribbonMat)
			    surface.DrawTexturedRect(0, 0, h, h)

			    surface.SetDrawColor(0, 0, 0, 255 * this.black)
			    surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255, 3)
				surface.DrawOutlinedRect(0, 0, w, h)
		    end)
		end

		local ui = MonoPad:GetUI()
		ui:AddTooltip(button, data.name, dRibbon[data.ribbon][2], dRibbon[data.ribbon][3], time, function()
			return !self.isOpen
		end)
	end

	local storey = math.floor(count / 4) + 1
	if count <= -1 then return end

	evidencePanel:SetTall(30 + storey * 80 + storey * 10)
end

vgui.Register("MonoPad:GameLogSub", PANEL, "Panel")


local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = H(470)
    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(W(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, H(23))

        draw.DrawText("#monopad_gledit_case", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_gledit_victim", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_glexample_victim", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_gledit_time", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_glexample_time", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_gledit_cause", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_glexample_cause", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_gledit_place", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_glexample_place", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_gledit_discovery", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80 + 80 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_glexample_discovery", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80 + 80 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - H(70 / 2), 0)
    close:SetSize(H(70 / 2), H(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.inflictorBox = self.main:Add("DComboBox")
    self.inflictorBox:SetFont("arb.Font_FuturaPTBook_8")
    self.inflictorBox:SetPos(W(5), H(75))
    self.inflictorBox:SetSize(self.main:GetWide() - W(10), H(25))
    self.inflictorBox.OnSelect = function(_, index, value, data)
        self.inflictorID = data
    end

    self.timeEntry = self.main:Add("DTextEntry")
    self.timeEntry:SetPos(W(5), H(155))
    self.timeEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.timeEntry:SetPlaceholderText("#monopad_glmain_time")
    self.timeEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.reasonEntry = self.main:Add("DTextEntry")
    self.reasonEntry:SetPos(W(5), H(235))
    self.reasonEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.reasonEntry:SetPlaceholderText("#monopad_glmain_cause")
    self.reasonEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.placeEntry = self.main:Add("DTextEntry")
    self.placeEntry:SetPos(W(5), H(315))
    self.placeEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.placeEntry:SetPlaceholderText("#monopad_glmain_place")
    self.placeEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.foundEntry = self.main:Add("DTextEntry")
    self.foundEntry:SetPos(W(5), H(395))
    self.foundEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.foundEntry:SetPlaceholderText("#monopad_glmain_discovery")
    self.foundEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.inflictorBox:AddChoice("#monopad_unknown", nil, true)
    for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
        if v:GetAssets().pixel then
            self.inflictorBox:AddChoice(v:GetName(), k)
        end
    end

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("#monopad_glmain_edit", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d, e, f = self.inflictorID, self.timeEntry:GetValue(), self.reasonEntry:GetValue(), self.placeEntry:GetValue(), self.foundEntry:GetValue(), self.id

        netstream.Start("MonoPad:EditCase", f, {a, b, c, d, e})

        local cb = self.callback
        timer.Simple(0.5, function()
            if cb then
                cb()
            end
        end)

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end
end

function PANEL:SetData(inflictor, time, reason, place, found, callback, id)
	if inflictor then
		self.inflictorID = inflictor
	    self.inflictorBox:SetValue(Character.team:GetByID(inflictor).name)

	    local log = Arbitrage.GetGameLogs()[id]
	    if log[1] then
	    	self.inflictorBox:SetDisabled(true)
	    end
	else
		self.inflictorBox:SetValue("#monopad_unknown")
	end

	if time then
	    self.timeEntry:SetValue(time)
	end

	if reason then
		self.reasonEntry:SetValue(reason)
	end

	if place then
		self.placeEntry:SetValue(place)
	end

	if found then
		self.foundEntry:SetValue(found)
	end

	self.callback = callback
	self.id = id
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("MonoPad:GameLogSubEdit", PANEL, "EditablePanel")