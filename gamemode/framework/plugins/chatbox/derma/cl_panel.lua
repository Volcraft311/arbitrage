local PLUGIN = PLUGIN

local PANEL = {}
PANEL.limit = 0

function PANEL:Init()
	self:SetDrawLanguageID(false)
	self:SetUpdateOnType(true)
end

function PANEL:AllowInput(char)
	local text = self:GetValue()

	if text and text ~= "" then
		if self:get_limit() ~= 0 and utf8.len(text) >= self:get_limit() then
			return true
		end
	end
end

function PANEL:set_limit(limit)
	self.limit = math.abs(limit or 0)
end

function PANEL:get_limit()
	return self.limit or 0
end

vgui.Register("arbChatBoxFixed", PANEL, "DTextEntry")




local animationTime = 0.5
local chatBorder = 32
local sizingBorder = 20
local maxChatEntries = 100


local function PaintMarkupOverride(text, font, x, y, color, alignX, alignY, alpha)
	alpha = alpha or 255

	surface.SetTextPos(x + 1, y + 1)
	surface.SetTextColor(0, 0, 0, alpha)
	surface.SetFont(font)
	surface.DrawText(text)

	surface.SetTextPos(x, y)
	surface.SetTextColor(color.r, color.g, color.b, alpha)
	surface.SetFont(font)
	surface.DrawText(text)
end





local PANEL = {}

AccessorFunc(PANEL, "fadeDelay", "FadeDelay", FORCE_NUMBER)
AccessorFunc(PANEL, "fadeDuration", "FadeDuration", FORCE_NUMBER)

function PANEL:Init()
	self.text = ""
	self.alpha = 1
	self.fadeDelay = 15
	self.fadeDuration = 5
end

local wide = 16
local tall = 10

function PANEL:SetMarkup(text)
	self.text = text

	self.markup = asterionlib.markup.Parse(self.text, self:GetWide() - wide)
	self.markup.onDrawText = PaintMarkupOverride

	self:SetTall(self.markup:GetHeight() + tall)

	self:CreateAnimation(1, {
		index = 3,
		target = {alpha = 255}
	})

	timer.Simple(self.fadeDelay, function()
		if (not IsValid(self)) then
			return
		end

		self:CreateAnimation(self.fadeDuration, {
			index = 3,
			target = {alpha = 0}
		})
	end)
end

function PANEL:PerformLayout(width, height)
	if ((IsValid(PLUGIN.gui.chat) and PLUGIN.gui.chat.bSizing) or width == self.markup:GetWidth()) then
		return
	end

	self.markup = asterionlib.markup.Parse(self.text, width - tall)
	self.markup.onDrawText = PaintMarkupOverride

	self:SetTall(self.markup:GetHeight() + tall)
end

function PANEL:Paint(width, height)
	local chatbox = PLUGIN.gui.chat

	local newAlpha

	if (PLUGIN.gui.chat:GetActive()) then
		newAlpha = math.max(PLUGIN.gui.chat.alpha, self.alpha)
	else
		newAlpha = self.alpha
	end

	if (newAlpha < 1) then
		return
	end

	self.animated = self.animated or -50

	if self.animated < 0 then
		self.animated = Lerp(FrameTime() * 10, self.animated + 0.1, 0)
	end

	surface.SetDrawColor(0, 0, 0, newAlpha * 0.6 - chatbox:GetAlpha() * 0.6)
	surface.DrawRect(1, 1, self.markup:GetWidth() - 2 + wide, height - 2)

	self.markup:draw(wide / 2, tall / 1.5 + self.animated, nil, nil, newAlpha)
end

vgui.Register("arbChatMessage", PANEL, "Panel")






PANEL = {}

AccessorFunc(PANEL, "bActive", "Active", FORCE_BOOL)
AccessorFunc(PANEL, "bUnread", "Unread", FORCE_BOOL)

function PANEL:Init()
	self:SetFont("arb.Font_FuturaPTBook_8")
	self:SetContentAlignment(5)

	self.unreadAlpha = 0
end

function PANEL:SetUnread(bValue)
	self.bUnread = bValue

	self:CreateAnimation(animationTime, {
		index = 4,
		target = {unreadAlpha = bValue and 1 or 0},
		easing = "outQuint"
	})
end

function PANEL:SizeToContents()
	local width, height = self:GetContentSize()
	self:SetSize(width + 12, height + 6)
end

vgui.Register("arbChatboxTabButton", PANEL, "DButton")




PANEL = {}

function PANEL:Init()
	self.buttons = self:Add("Panel")
	self.buttons:Dock(TOP)
	self.buttons:SetTall(H(48))
	self.buttons:DockPadding(1, 1, 0, 0)
	self.buttons.OnMousePressed = PLUGIN.Bind(PLUGIN.gui.chat, PLUGIN.gui.chat.OnMousePressed)
	self.buttons.OnMouseReleased = PLUGIN.Bind(PLUGIN.gui.chat, PLUGIN.gui.chat.OnMouseReleased)

	self.buttons.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)
	end

	self.tabs = {}
end

function PANEL:GetTabs()
	return self.tabs
end

function PANEL:AddTab(id, filter)
	local button = self.buttons:Add("arbChatboxTabButton")
	button:Dock(LEFT)
	button:SetText("")
	button:SetActive(false)
	button:SetMouseInputEnabled(true)

	local x = W(110)
	surface.SetFont("arb.Font_FuturaPTBook_12")
	local width = surface.GetTextSize(id)

	button:SetWide(width + x)
	button.Paint = function(_, w, h)
		if Arbitrage.gui.chat:GetAlpha() <= 1 then return end

		Arbitrage.DrawTextBlur(id, "arb.Font_FuturaPTBook_12", w / 2 - x * 0.125, H(3), Color(255, 238, 177, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("/", "arb.Font_FuturaPTBook_12", w - x * 0.25, H(3), Color(255, 255, 255, 10), TEXT_ALIGN_CENTER)
	end

	button.DoClick = function(this)
		self:SetActiveTab(id)
	end

	local panel = self:Add("arbChatboxHistory")
	panel:SetButton(button)
	panel:SetID(id)
	panel:Dock(FILL)
	panel:SetVisible(false)
	panel:SetFilter(filter or {})

	self.tabs[id] = panel
	return panel
end

function PANEL:RemoveTab(id)
	local tab = self.tabs[id]

	if (!tab) then
		return
	end

	tab:GetButton():Remove()
	tab:Remove()

	self.tabs[id] = nil

	if (table.IsEmpty(self.tabs)) then
		self:AddTab("Общий чат", {})
		self:SetActiveTab("Общий чат")
	elseif (id == self:GetActiveTabID()) then
		self:SetActiveTab(next(self.tabs))
	end
end

function PANEL:RenameTab(id, newID)
	local tab = self.tabs[id]

	if (!tab) then
		return
	end

	tab:GetButton():SetText(newID)
	tab:GetButton():SizeToContents()

	self.tabs[id] = nil
	self.tabs[newID] = tab
end

function PANEL:SetActiveTab(id)
	local tab = self.tabs[id]

	for _, v in ipairs(self.buttons:GetChildren()) do
		if v:GetName() == "arbChatboxTabButton" then
			v:SetActive(v:GetText() == id)
		end
	end

	for _, v in pairs(self.tabs) do
		v:SetVisible(v:GetID() == id)
	end

	tab:GetButton():SetUnread(false)

	self.activeTab = id
	self:OnTabChanged(tab)
end

function PANEL:GetActiveTabID()
	return self.activeTab
end

function PANEL:GetActiveTab()
	return self.tabs[self.activeTab]
end

function PANEL:OnTabChanged(panel)
end

vgui.Register("arbChatboxTabs", PANEL, "EditablePanel")








PANEL = {}

AccessorFunc(PANEL, "filter", "Filter")
AccessorFunc(PANEL, "id", "ID", FORCE_STRING)
AccessorFunc(PANEL, "button", "Button")

function PANEL:Init()
	self:DockMargin(26, 2, 16, 4)
	self:SetPaintedManually(true)

	local bar = self:GetVBar()
	bar:SetWide(3)

	bar.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255, 3)
		surface.DrawRect(0, 10, w, h - 20)
	end
	bar.btnUp.Paint = function(_, w, h) end
	bar.btnDown.Paint = function(_, w, h) end
	bar.btnGrip.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 10, w, h - 20)
	end

	self.entries = {}
	self.filter = {}
end

function PANEL:Paint(_, w, h)
	local alpha = PLUGIN.gui.chat:GetAlpha()
	local bar = self:GetVBar()

	bar:SetAlpha(alpha)
end

DEFINE_BASECLASS("Panel")
function PANEL:SetVisible(bState)
	self:GetCanvas():SetVisible(bState)
	BaseClass.SetVisible(self, bState)
end

DEFINE_BASECLASS("DScrollPanel")
function PANEL:PerformLayoutInternal()
	local bar = self:GetVBar()
	local bScroll = !PLUGIN.gui.chat:GetActive() or bar.Scroll == bar.CanvasSize

	BaseClass.PerformLayoutInternal(self)

	if (bScroll) then
		self:ScrollToBottom()
	end
end

function PANEL:ScrollToBottom()
	local bar = self:GetVBar()
	bar:SetScroll(bar.CanvasSize)
end

function PANEL:AddLine(elements, bShouldScroll)
	local buffer = {
		"<font=arb.Font_FuturaPTBook_8>"
	}

	for _, v in ipairs(elements) do
		if (type(v) == "IMaterial") then
			local texture = v:GetName()

			if (texture) then
				buffer[#buffer + 1] = string.format("<img=%s,%dx%d> ", texture, v:Width(), v:Height())
			end
		elseif (istable(v) and v.r and v.g and v.b) then
			buffer[#buffer + 1] = string.format("<color=%d,%d,%d>", v.r, v.g, v.b)
		elseif (type(v) == "Player") then
			local color = team.GetColor(v:Team())

			buffer[#buffer + 1] = string.format("<color=%d,%d,%d>%s", color.r, color.g, color.b,
				v:GetName():gsub("<", "&lt;"):gsub(">", "&gt;"))
		else
			buffer[#buffer + 1] = tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("%b**", function(value)
				local inner = utf8.sub(value, 2, -2)

				if (inner:find("%S")) then
					return "<font=arb.Font_FuturaPTBookItalic_8>" .. utf8.sub(value, 2, -2) .. "</font>"
				end
			end)
		end
	end

	local panel = self:Add("arbChatMessage")
	panel:Dock(TOP)
	panel:InvalidateParent(true)
	panel:SetMarkup(table.concat(buffer))

	if (#self.entries >= maxChatEntries) then
		local oldPanel = table.remove(self.entries, 1)

		if (IsValid(oldPanel)) then
			oldPanel:Remove()
		end
	end

	self.entries[#self.entries + 1] = panel
	return panel
end

vgui.Register("arbChatboxHistory", PANEL, "DScrollPanel")

PANEL = {}
DEFINE_BASECLASS("DTextEntry")

function PANEL:Init()
	self:SetFont("arb.Font_FuturaPTBook_8")
	self:SetUpdateOnType(true)
	self:SetHistoryEnabled(true)

	self.History = PLUGIN.chat.history
	self.m_bLoseFocusOnClickAway = false
end

function PANEL:SetFont(font)
	BaseClass.SetFont(self, font)

	surface.SetFont(font)
	local _, height = surface.GetTextSize("W@")

	self:SetTall(height + 8)
end

function PANEL:AllowInput(newCharacter)
	local text = self:GetText()
	local maxLength = 1024

	if (string.len(text .. newCharacter) > maxLength) then
		surface.PlaySound("common/talk.wav")
		return true
	end
end

function PANEL:Think()
	local text = self:GetText()
	local maxLength = 1024

	if (utf8.len(text) > maxLength) then
		local newText = utf8.sub(text, 0, maxLength)

		self:SetText(newText)
		self:SetCaretPos(utf8.len(newText))
	end
end

vgui.Register("arbChatboxEntry", PANEL, "DTextEntry")







PANEL = {}

AccessorFunc(PANEL, "bActive", "Active", FORCE_BOOL)

function PANEL:Init()
	PLUGIN.gui.chat = self
	Arbitrage.gui.chat = self

	self:SetSize(self:GetDefaultSize())
	self:SetPos(self:GetDefaultPosition())

	local entryPanel = self:Add("Panel")
	entryPanel:SetZPos(1)
	entryPanel:SetTall(H(30))
	entryPanel:Dock(BOTTOM)

	local say_panel = entryPanel:Add("DLabel")
	say_panel:SetText("Написать")
	say_panel:SetContentAlignment(5)
	say_panel:SetWide(W(106))
	say_panel:SetFont("arb.Font_FuturaPTBook_7")
	say_panel:Dock(LEFT)
	say_panel.Paint = function(_, w, h)
		surface.SetDrawColor(Color(0, 0, 0))
		surface.DrawRect(0, 0, w, h)
	end
	say_panel:SetWide(say_panel:GetWide() + 10)

	self.entry = entryPanel:Add("arbChatBoxFixed")
	self.entry:SetText("")
	self.entry:SetPlaceholderText("введите что-либо...")
	self.entry:SetTextColor(Color(255,255,255))
	self.entry:SetDrawBackground(false)
	self.entry:SetFont("arb.Font_FuturaPTBook_7")
	self.entry:Dock(FILL)
	self.entry:set_limit(1024)
	self.entry.history = {}
	self.entry.last_index = 0
	self.entry.OnValueChange = PLUGIN.Bind(self, self.OnTextChanged)
	self.entry.PaintOver = function(_, w, h)
		surface.SetDrawColor(Color(0, 0, 0))
		surface.DrawOutlinedRect(0, 0, w, h, 2)
	end

	self.entry.OnEnter = function(entry)
		local value = entry:GetValue()
		if entry.history[1] ~= value then
			table.insert(entry.history, 1, value)
			entry.last_index = 1
		end

		self:OnMessageSent(entry)
	end

	self.entry.OnKeyCodeTyped = function(entry, code)
		local should_set = false

		if code == KEY_ENTER then
			entry:OnEnter()
			return true
		elseif code == KEY_DOWN then
			if entry.last_index == 1 then
				entry.last_index = #entry.history
			else
				entry.last_index = math.Clamp(entry.last_index - 1, 1, #entry.history)
			end
			should_set = true
		elseif code == KEY_UP then
			if entry.last_index == #entry.history then
				entry.last_index = 1
			else
				entry.last_index = math.Clamp(entry.last_index + 1, 1, #entry.history)
			end
			should_set = true
		end

		local history_entry = entry.history[entry.last_index]

		if history_entry and history_entry ~= "" and should_set then
			entry:SetText(history_entry)
			entry:SetCaretPos(utf8.len(history_entry))
			entry:OnValueChange(history_entry)
			return true
		end
	end

	self.tabs = self:Add("arbChatboxTabs")
	self.tabs:Dock(FILL)
	self.tabs.OnTabChanged = PLUGIN.Bind(self, self.OnTabChanged)

	self.alpha = 0
	self:SetActive(false)

	chat.GetChatBoxPos = function()
		return self:GetPos()
	end

	chat.GetChatBoxSize = function()
		return self:GetSize()
	end

	local close_button = self.tabs.buttons:Add("DButton")
	close_button:SetText("")
	close_button:SetContentAlignment(5)
	close_button:Dock(RIGHT)
	close_button:SetWide(W(32))
	close_button.alpha = 50
	close_button.DoClick = function()
		PLUGIN.gui.chat:SetActive(false)
	end
	close_button.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 50)
		draw.DrawText("x", "arb.Font_FuturaPTBook_10", w / 2 - W(10), H(3), Color( 255, 255, 255, _.alpha), TEXT_ALIGN_CENTER)
	end
end

function PANEL:GetDefaultSize()
	return ScrW() * 0.4, ScrH() * 0.375
end

function PANEL:GetDefaultPosition()
	return chatBorder, ScrH() - self:GetTall() - chatBorder
end

DEFINE_BASECLASS("Panel")
function PANEL:SetAlpha(amount, duration)
	self:CreateAnimation(duration or animationTime, {
		index = 1,
		target = {alpha = amount},
		easing = "outQuint",

		Think = function(animation, panel)
			BaseClass.SetAlpha(panel, panel.alpha)
		end
	})
end

function PANEL:SizingInBounds()
	local screenX, screenY = self:LocalToScreen(0, 0)
	local mouseX, mouseY = gui.MousePos()

	return mouseX > screenX + self:GetWide() - sizingBorder and mouseY > screenY + self:GetTall() - sizingBorder
end

function PANEL:DraggingInBounds()
	local _, screenY = self:LocalToScreen(0, 0)
	local mouseY = gui.MouseY()

	return mouseY > screenY and mouseY < screenY + self.tabs.buttons:GetTall()
end

function PANEL:SetActive(bActive)
	if (bActive) then
		self:SetAlpha(255)
		self:MakePopup()
		self.entry:RequestFocus()

		input.SetCursorPos(self:LocalToScreen(-1, -1))

		hook.Run("StartChat")
	else
		if (self.bSizing or self.DragOffset) then
			self:OnMouseReleased(MOUSE_LEFT)
		end

		self:SetAlpha(0)
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)

		--self.entry:SetText("")
		self.entry.last_index = 0

		CloseDermaMenus()
		gui.EnableScreenClicker(false)

		hook.Run("FinishChat")
	end

	local tab = self.tabs:GetActiveTab()

	if (tab) then
		tab:ScrollToBottom()
	end

	self.bActive = tobool(bActive)
end

function PANEL:SetupTabs(tabs)
	self.tabs:AddTab("Общий чат", {})
	self.tabs:SetActiveTab("Общий чат")
end

function PANEL:SetupPosition(info)
	local x, y, width, height

	if (!istable(info)) then
		x, y = self:GetDefaultPosition()
		width, height = self:GetDefaultSize()
	else
		width = math.Clamp(info[3], 32, ScrW() - chatBorder * 2)
		height = math.Clamp(info[4], 32, ScrH() - chatBorder * 2)
		x = math.Clamp(info[1], 0, ScrW() - width)
		y = math.Clamp(info[2], 0, ScrH() - height)
	end

	self:SetSize(width, height)
	self:SetPos(x, y)
end

function PANEL:OnMousePressed(key)
	if (self:SizingInBounds()) then
		self.bSizing = true
		self:MouseCapture(true)
	elseif (self:DraggingInBounds()) then
		local mouseX, mouseY = self:ScreenToLocal(gui.MousePos())

		self.DragOffset = {mouseX, mouseY}
		self:MouseCapture(true)
	end
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self:SetCursor("arrow")

	if (self.bSizing or self.DragOffset) then
		self.bSizing = nil
		self.DragOffset = nil

		self:InvalidateChildren(true)

		local x, y = self:GetPos()
		local width, height = self:GetSize()

		hook.Run("ChatboxPositionChanged", x, y, width, height)
	end
end

function PANEL:Think()
	if (!self.bActive) then
		return
	end

	if (gui.IsGameUIVisible()) then
		self:SetActive(false)
		gui.HideGameUI()

		return
	end

	local mouseX = math.Clamp(gui.MouseX(), 0, ScrW())
	local mouseY = math.Clamp(gui.MouseY(), 0, ScrH())

	if (self.bSizing) then
		local x, y = self:GetPos()
		local width = math.Clamp(mouseX - x, chatBorder, ScrW() - chatBorder * 2)
		local height = math.Clamp(mouseY - y, chatBorder, ScrH() - chatBorder * 2)

		self:SetSize(width, height)
		self:SetCursor("sizenwse")
	elseif (self.DragOffset) then
		local x = math.Clamp(mouseX - self.DragOffset[1], 0, ScrW() - self:GetWide())
		local y = math.Clamp(mouseY - self.DragOffset[2], 0, ScrH() - self:GetTall())

		self:SetPos(x, y)
	elseif (self:SizingInBounds()) then
		self:SetCursor("sizenwse")
	elseif (self:DraggingInBounds()) then
		self.tabs.buttons:SetCursor("sizeall")
	else
		self:SetCursor("arrow")
	end
end

function PANEL:Paint(width, height)
	local tab = self.tabs:GetActiveTab()
	local alpha = self:GetAlpha()

	if Arbitrage and asterionlib.DrawBlur and alpha > 0 then
		asterionlib.DrawBlur(self, 5)
	end

	surface.SetDrawColor(0, 0, 0, 240)
	surface.DrawRect(0, 0, width, height)

	if (tab) then
		surface.SetAlphaMultiplier(1)
			tab:PaintManual()
		surface.SetAlphaMultiplier(alpha / 255)
	end

	if (alpha > 0) then
		hook.Run("PostChatboxDraw", width, height, self:GetAlpha())
	end
end

function PANEL:OnTextChanged(text)
	hook.Run("ChatTextChanged", text)
end

DEFINE_BASECLASS("DTextEntry")

function PANEL:OnMessageSent()
	local text = self.entry:GetText()

	if (text:find("%S")) then
		local lastEntry = PLUGIN.chat.history[#PLUGIN.chat.history]

		if (lastEntry != text) then
			if (#PLUGIN.chat.history >= 20) then
				table.remove(PLUGIN.chat.history, 1)
			end

			PLUGIN.chat.history[#PLUGIN.chat.history + 1] = text
		end

		self.entry:SetText("")

		net.Start("arb.ChatMessage")
			net.WriteString(text)
		net.SendToServer()
	end

	self:SetActive(false)
end

function PANEL:OnTabChanged(panel)
	panel:InvalidateLayout(true)
	panel:ScrollToBottom()
end

function PANEL:OnTabUpdated(id, filter, newID)
	local tab = self.tabs:GetTabs()[id]

	if (!tab) then
		return
	end

	tab:SetFilter(filter)
	self.tabs:RenameTab(id, newID)
end

function PANEL:AddMessage(...)
	local class = CHAT_CLASS and CHAT_CLASS.uniqueID or "notice"
	local activeTab = self.tabs:GetActiveTab()

	local bShown = false

	if (activeTab and !activeTab:GetFilter()[class]) then
		activeTab:AddLine({...}, true)
		bShown = true
	end

	for _, v in pairs(self.tabs:GetTabs()) do
		if (v:GetID() == activeTab:GetID()) then
			continue
		end

		if (!v:GetFilter()[class]) then
			v:AddLine({...}, true)

			if (!bShown) then
				v:GetButton():SetUnread(true)
			end
		end
	end

	if (bShown) then
		chat.PlaySound()
	end
end

vgui.Register("arbChatbox", PANEL, "EditablePanel")
