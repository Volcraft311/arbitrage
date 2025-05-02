local function getFontSize()
	return SETTINGS.options.Get("chatbox_size")
end

local PLUGIN = PLUGIN

local PANEL = {}
PANEL.limit = 0

function PANEL:Init()
	self:SetDrawLanguageID(false)
	self:SetUpdateOnType(true)
end

function PANEL:AllowInput(char)
	local text = F(self:GetValue())

	if text and text != "" and self:get_limit() != 0 and utf8.len(text) >= self:get_limit() then
		surface.PlaySound("common/talk.wav")

		return true
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

PANEL = {}

AccessorFunc(PANEL, "fadeDelay", "FadeDelay", FORCE_NUMBER)
AccessorFunc(PANEL, "fadeDuration", "FadeDuration", FORCE_NUMBER)

function PANEL:Init()
	self:SetText("")

	self.text = ""
	self.alpha = 1
	self.animation = 0
	self.fadeDelay = 15
	self.fadeDuration = 5

	self.copys = {}
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
		if !IsValid(self) then return end

		self:CreateAnimation(self.fadeDuration, {
			index = 3,
			target = {alpha = 0}
		})
	end)
end

function PANEL:PerformLayout(width, height)
	if (IsValid(Arbitrage.gui.chat) and Arbitrage.gui.chat.bSizing) or width == self.markup:GetWidth() then
		return
	end

	self.markup = asterionlib.markup.Parse(self.text, width - tall)
	self.markup.onDrawText = PaintMarkupOverride

	self:SetTall(self.markup:GetHeight() + tall)
end

local copyTextStored = {
	[1] = "#chat_copy_double_copied",
	[2] = "#chat_copy_triple_copied",
	[3] = "#chat_copy_domination",
	[4] = "#chat_copy_madness",
	[5] = "#chat_copy_megacopying",
	[6] = "#chat_copy_cant_be_stopped",
	[7] = "#chat_copy_totally_awesome",
	[8] = "#chat_copy_phenomenal",
	[9] = "#chat_copy_divine",
	[10] = "#chat_copy_just_space"
}

function PANEL:Paint(width, height)
	local ft = FrameTime()
	local chatbox = Arbitrage.gui.chat

	local newAlpha
	if Arbitrage.gui.chat:GetActive() then
		newAlpha = math.max(Arbitrage.gui.chat.alpha, self.alpha)
	else
		newAlpha = self.alpha
	end

	if newAlpha < 1 then
		return
	end

	self.animated = self.animated or -50

	if self.animated < 0 then
		self.animated = Lerp(ft * 4, self.animated + 0.1, 0)
	end

	surface.SetDrawColor(0, 0, 0, newAlpha * 0.6 - chatbox:GetAlpha() * 0.6)
	surface.DrawRect(1, 1, self.markup:GetWidth() - 2 + wide, height - 2)

	if Arbitrage.gui.chat:GetActive() and self:IsHovered() then
		surface.SetDrawColor(0, 0, 0, 100)
		surface.DrawRect(1, 1, width - 2, height - 2)
	end

	self.markup:draw(wide / 2, tall / 1.5 + self.animated, nil, nil, newAlpha)

	local old = DisableClipping(true)
		for k, v in ipairs(self.copys) do
			v.y = v.y - ft * 25
			v.alpha = Lerp(ft * 10, v.alpha, v.deadTime > RealTime() and 255 or 0)

			if RealTime() - 2 > v.deadTime then
				table.remove(self.copys, k)
			end

			draw.SimpleText(L(copyTextStored[v.copyNum] or "#chat_copy_copied"), "arb.Font_FuturaPTBook_6", v.x, v.y, Color(255, 255, 255, v.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	DisableClipping(old)
end

local copyText = ""
local copyID = -1
function PANEL:CopyText()
	local texts = ""
	local blocks = self.markup.blocks
	for i = 2, #blocks do
		local block = blocks[i]

		local text = block.text
		if text then
			texts = texts .. text
		end
	end

	texts = string.Trim(texts)

	if copyText == texts then
		copyID = copyID + 1
	else
		copyID = 0
	end

	SetClipboardText(texts)
	copyText = texts

	local x, y = self:LocalCursorPos()
	self.copys[#self.copys + 1] = {
		x = x,
		y = y,
		alpha = 0,
		deadTime = RealTime() + 1,
		copyNum = copyID
	}
end

function PANEL:DoClick()
	if !Arbitrage.gui.chat:GetActive() then return end

	self:CopyText()
end

function PANEL:DoRightClick()
	if !Arbitrage.gui.chat:GetActive() then return end

	self:CopyText()
end

vgui.Register("arbChatMessage", PANEL, "DButton")

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
	self.buttons:SetTall(draw.GetFontHeight("arb.Font_FuturaPTDemi_11"))
	self.buttons:DockPadding(1, 1, 0, 0)
	self.buttons.OnMousePressed = PLUGIN.Bind(Arbitrage.gui.chat, Arbitrage.gui.chat.OnMousePressed)
	self.buttons.OnMouseReleased = PLUGIN.Bind(Arbitrage.gui.chat, Arbitrage.gui.chat.OnMouseReleased)

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

	local text = L(id)

	local font = "arb.Font_FuturaPTBook_9"
	local x = W(50)
	surface.SetFont(font)
	local width = surface.GetTextSize(text)

	button:SetWide(width + x)
	button.alpha = 0.1
	button.alpha2 = 0
	button.Paint = function(_, w, h)
		if Arbitrage.gui.chat:GetAlpha() <= 1 then return end

		local selected = self.activeTab == id

		_.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or _.unread) and 1 or 0.1)
	    _.alpha2 = Lerp(FrameTime() * 10, _.alpha2, selected and 1 or -0.1)

	    Arbitrage.DrawTextBlur(text, font, w / 2 - x * 0.17, H(3), Color(255, 238, 177, 255 * _.alpha2), TEXT_ALIGN_CENTER)

	    if !selected then
	        draw.DrawText(text, font, w / 2 - x * 0.17, H(3), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
	    end

		draw.DrawText("/", font, w - x * 0.25, H(3), Color(255, 255, 255, 10), TEXT_ALIGN_CENTER)
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

	tab:GetButton().unread = false

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
	local alpha = Arbitrage.gui.chat:GetAlpha()
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
	local bScroll = !Arbitrage.gui.chat:GetActive() or bar.Scroll == bar.CanvasSize

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
		"<font=arb.Font_FuturaPTBook_" .. getFontSize() .. ">"
	}

	buffer[#buffer + 1] = "<color=150,150,150>("
	buffer[#buffer + 1] = os.date("%H:%M")
	buffer[#buffer + 1] = ")<color=255,255,255> "

	for _, v in ipairs(elements) do
		if type(v) == "IMaterial" then
			local texture = v:GetName()

			if texture then
				local a2 = v:Width()
	            local b2 = v:Height()

	            if texture:find("danganronpa/evidence/") then
					local height = draw.GetFontHeight("arb.Font_FuturaPTBook_" .. getFontSize())
					local maxW = height * 1.3
		            local maxH = height * 1.3

		            local _w = v:Width()
		            local _h = v:Height()

		            local a = _h < _w and maxW / _w or maxH / _h

		            a2 = _w * a
		            b2 = _h * a
		        elseif texture:find("asterion/academy/ui/icons/rank_") then
		        	local height = draw.GetFontHeight("arb.Font_FuturaPTBook_" .. getFontSize())
					local maxW = height * 0.9
		            local maxH = height * 0.9

		            local _w = v:Width()
		            local _h = v:Height()

		            local a = _h < _w and maxW / _w or maxH / _h

		            a2 = _w * a
		            b2 = _h * a
	        	end

				buffer[#buffer + 1] = ("<img=%s,%dx%d> "):format(texture, a2, b2)
			end
		elseif istable(v) and v.r and v.g and v.b then
			buffer[#buffer + 1] = ("<color=%d,%d,%d>"):format(v.r, v.g, v.b)
		elseif type(v) == "Player" then
			local color = team.GetColor(v:Team())

			buffer[#buffer + 1] = ("<color=%d,%d,%d>%s"):format(color.r, color.g, color.b, v:GetName():gsub("<", "&lt;"):gsub(">", "&gt;"))
		else
			buffer[#buffer + 1] = tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("%b**", function(value)
				local inner = utf8.sub(value, 2, -2)

				if (inner:find("%S")) then
					return "<font=arb.Font_FuturaPTBookItalic_" .. getFontSize() - 1 .. ">" .. "*" .. utf8.sub(value, 2, -2) .. "*" .. "</font>"
				end
			end):gsub("%b||", function(value)
				local inner = utf8.sub(value, 2, -2)
				local str = ""

				for i = 1, utf8.len(inner) do
					local color = HSVToColor(i * 5 % 360, 1, 1 )

					str = str .. "<color=%" .. color.r .. ",%" .. color.g .. ",%" .. color.b .. ">" .. utf8.sub(inner, i, i) .. "</color>"
				end

				return str
			end)
		end
	end

	local panel = self:Add("arbChatMessage")
	panel:Dock(TOP)
	panel:InvalidateParent(true)
	panel:SetMarkup(table.concat(buffer))

	if #self.entries >= maxChatEntries then
		local oldPanel = table.remove(self.entries, 1)

		if IsValid(oldPanel) then
			oldPanel:Remove()
		end
	end

	self.entries[#self.entries + 1] = panel
	return panel
end

vgui.Register("arbChatboxHistory", PANEL, "DScrollPanel")

PANEL = {}

AccessorFunc(PANEL, "bActive", "Active", FORCE_BOOL)

function PANEL:Init()
	Arbitrage.gui.chat = self

	self:SetZPos(32000)
	self:SetSize(self:GetDefaultSize())
	self:SetPos(self:GetDefaultPosition())

	local entryPanel = self:Add("Panel")
	entryPanel:SetZPos(1)
	entryPanel:SetTall(draw.GetFontHeight("arb.Font_FuturaPTBook_7"))
	entryPanel:Dock(BOTTOM)

	local say_panel = entryPanel:Add("DLabel")
	say_panel:SetText(L("#chat_chatbox_say"))
	say_panel:SetContentAlignment(5)
	say_panel:SetWide(W(106))
	say_panel:SetFont("arb.Font_FuturaPTBook_7")
	say_panel:Dock(LEFT)
	say_panel.Paint = function(_, w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)
	end
	say_panel:SizeToContents()
	say_panel:SetWide(say_panel:GetWide() + 20)

	self.entry = entryPanel:Add("arbChatBoxFixed")
	self.entry:SetText("")
	self.entry:SetPlaceholderText(L("#chat_chatbox_enter_something"))
	self.entry:SetTextColor(Color(255,255,255))
	self.entry:SetDrawBackground(false)
	self.entry:SetFont("arb.Font_FuturaPTBook_7")
	self.entry:Dock(FILL)
	self.entry:set_limit(1024)
	self.entry.history = {}
	self.entry.last_index = 0
	self.entry.OnValueChange = PLUGIN.Bind(self, self.OnTextChanged)
	self.entry.PaintOver = function(_, w, h)
		surface.SetDrawColor(color_black)
		surface.DrawOutlinedRect(0, 0, w, h, 2)

		if _.autocomplete.index > 0 and #_.autocomplete.commands > 0 then
			local text = string.format("%d/%d", _.autocomplete.index, #_.autocomplete.commands)
			draw.SimpleText(text, "arb.Font_FuturaPTBook_7", w - 5, h / 2, Color(255, 255, 255, 150), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end
	end
	self.entry.autocomplete = {
		commands = {},
		index = 0,
		prefix = "",
		bCheck = false
	}

	self.commandsPanel = self:Add("DPanel")
	self.commandsPanel:SetPos(0, 0)
	self.commandsPanel:SetAlpha(0)
	self.commandsPanel:SetSize(self:GetWide(), self:GetTall() - draw.GetFontHeight("arb.Font_FuturaPTDemi_7"))
	self.commandsPanel.stored = {}
	self.commandsPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 240)
		surface.DrawRect(0, 0, w, h)
	end

	self.entry.OnEnter = function(entry)
		local value = entry:GetValue()
		if entry.history[1] != value then
			table.insert(entry.history, 1, value)
			entry.last_index = 1
		end

		self:OnMessageSent(entry)
	end

	self.entry.OnKeyCodeTyped = function(entry, code)
		local should_set = false

		if code == KEY_ENTER then
			entry:OnEnter()
			entry.autocomplete.index = 0
			return true
		elseif code == KEY_TAB then
			if !entry.autocomplete.bCheck then
				entry.autocomplete.bCheck = true

				local text = entry:GetText()
				if text:utf8sub(1, 1) == "." then
					text = Arbitrage.commands.ConvertRusToEng(text)
				end

				local prefix = text:utf8sub(2, text:utf8len())

				entry.autocomplete.prefix = prefix

				entry.autocomplete.commands = {}
				for cmd, _ in pairs(Arbitrage.commands.stored) do
					if cmd:utf8lower():find(prefix:utf8lower()) then
						table.insert(entry.autocomplete.commands, cmd)
					end
				end
			end

			if #entry.autocomplete.commands > 0 then
				entry.autocomplete.index = entry.autocomplete.index + 1

				if entry.autocomplete.index > #entry.autocomplete.commands then
					entry.autocomplete.index = 1
				end

				local cmd = entry.autocomplete.commands[entry.autocomplete.index]
				local message = "/" .. cmd .. " "

				entry:SetText(message)
				entry:SetCaretPos(message:utf8len())

				return true
			end
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
		else
			if code != KEY_LSHIFT and code != KEY_RSHIFT and code != KEY_LCONTROL and code != KEY_RCONTROL then
				entry.autocomplete.commands = {}
				entry.autocomplete.index = 0
				entry.autocomplete.prefix = ""
				entry.autocomplete.bCheck = false
			end
		end

		local history_entry = entry.history[entry.last_index]

		if history_entry and history_entry != "" and should_set then
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
	close_button:SetWide(self.tabs.buttons:GetTall())
	close_button.alpha = 50
	close_button.DoClick = function()
		Arbitrage.gui.chat:SetActive(false)
	end
	close_button.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 50)
		draw.DrawText("x", "arb.Font_FuturaPTBook_10", w / 2 - W(10), 0, Color( 255, 255, 255, _.alpha), TEXT_ALIGN_CENTER)
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

	return (mouseX > screenX + self:GetWide() - sizingBorder and mouseY > screenY + self:GetTall() - sizingBorder) and (mouseX < screenX + self:GetWide() + sizingBorder and mouseY < screenY + self:GetTall() + sizingBorder)
end

function PANEL:DraggingInBounds()
	local _, screenY = self:LocalToScreen(0, 0)
	local mouseY = gui.MouseY()

	return mouseY > screenY and mouseY < screenY + self.tabs.buttons:GetTall()
end

function PANEL:SetActive(bActive)
	if bActive then
		self:SetAlpha(255)
		self:MakePopup()
		self.entry:RequestFocus()

		input.SetCursorPos(self:LocalToScreen(-1, -1))

		hook.Run("StartChat")
	else
		if self.bSizing or self.DragOffset then
			self:OnMouseReleased(MOUSE_LEFT)
		end

		self:SetAlpha(0)
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)

		self.entry.last_index = 0
		self.entry.autocomplete.index = 0
		self.entry.autocomplete.prefix = ""

		CloseDermaMenus()
		gui.EnableScreenClicker(false)

		hook.Run("FinishChat")
	end

	local tab = self.tabs:GetActiveTab()
	if tab then
		tab:ScrollToBottom()
	end

	self.bActive = tobool(bActive)
end

function PANEL:SetupTabs(tabs)
	self.tabs:AddTab("#chat_chatbox_tab_general", {})
	self.tabs:SetActiveTab("#chat_chatbox_tab_general")

	self.tabs:AddTab("#chat_chatbox_tab_rp", {})
	self.tabs:AddTab("#chat_chatbox_tab_nonrp", {})
	self.tabs:AddTab("#chat_chatbox_tab_personal", {})
	self.tabs:AddTab("#chat_chatbox_tab_admin", {})
end

function PANEL:SetupPosition(info)
	local x, y, width, height

	if !istable(info) then
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
	if self:SizingInBounds() then
		self.bSizing = true
		self:MouseCapture(true)
	elseif self:DraggingInBounds() then
		local mouseX, mouseY = self:ScreenToLocal(gui.MousePos())

		self.DragOffset = {mouseX, mouseY}
		self:MouseCapture(true)
	end
end

function PANEL:OnMouseReleased()
	self:MouseCapture(false)
	self:SetCursor("arrow")

	if self.bSizing or self.DragOffset then
		self.bSizing = nil
		self.DragOffset = nil

		self:InvalidateChildren(true)
		self.commandsPanel:SetSize(self:GetWide(), self:GetTall() - H(30))

		local x, y = self:GetPos()
		local width, height = self:GetSize()

		hook.Run("ChatboxPositionChanged", x, y, width, height)
	end
end

function PANEL:Think()
	if !self.bActive then
		return
	end

	if gui.IsGameUIVisible() then
		self:SetActive(input.IsKeyDown(KEY_BACKQUOTE))
		gui.HideGameUI()

		return
	end

	if input.IsKeyDown(KEY_ESCAPE) then
		self:SetActive(false)
		self.closeCD = RealTime() + 0.25
	end

	local mouseX = math.Clamp(gui.MouseX(), 0, ScrW())
	local mouseY = math.Clamp(gui.MouseY(), 0, ScrH())

	self:MouseCapture(false)

	if self.DragOffset then
		local x = math.Clamp(mouseX - self.DragOffset[1], 0, ScrW() - self:GetWide())
		local y = math.Clamp(mouseY - self.DragOffset[2], 0, ScrH() - self:GetTall())

		self:SetPos(x, y)
	elseif self:SizingInBounds() or self.bSizing then
		self:SetCursor("sizenwse")
		self:MouseCapture(true)

		local press = input.IsMouseDown(MOUSE_LEFT)
		if press then
			local x, y = self:GetPos()
			local width = math.Clamp(mouseX - x, chatBorder, ScrW() - chatBorder * 2)
			local height = math.Clamp(mouseY - y, chatBorder, ScrH() - chatBorder * 2)

			self:SetSize(width, height)
			self:SetCursor("sizenwse")
			self.bSizing = true
		end
	elseif self:DraggingInBounds() then
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

	if tab then
		surface.SetAlphaMultiplier(1)
			tab:PaintManual()
		surface.SetAlphaMultiplier(alpha / 255)
	end
end

function utf8_left(str, num)
	return string.utf8sub(str, 1, num)
end

local function GetAllCommands(text, originalText)
	local data = {}

	for command, stored in pairs(Arbitrage.commands.stored) do
		if command:utf8lower():find(text:utf8lower(), nil, true) then
			data[command] = {
				stored.arguments or {},
				stored.optionalArguments or {},
				stored.help,
				stored.bAdminOnly
			}
		end
	end

	local commandPrefix = utf8_left(originalText, 2):utf8lower()

	if (commandPrefix == "[[" or commandPrefix == "хх") or (commandPrefix == "./" or commandPrefix == "ю.") then
		local command = "looc"
		local stored = Arbitrage.commands.stored[command]

		data[command] = {
			stored.arguments or {},
			stored.optionalArguments or {},
			stored.help,
			stored.bAdminOnly
		}
	end

	if (commandPrefix == "//" or commandPrefix == "..") and utf8_left(originalText, 3) != "..." then
		local command = "ooc"
		local stored = Arbitrage.commands.stored[command]

		data[command] = {
			stored.arguments or {},
			stored.optionalArguments or {},
			stored.help,
			stored.bAdminOnly
		}
	end

	return data
end

local function isSelect(arguments, id, numSel, bHaveOptional)
	if numSel == id then
		return true
	end

	if !bHaveOptional and id - 1 == arguments and numSel >= id then
		return true
	end

	return false
end

local function GetChatType(value)
	for k, v in ipairs(PLUGIN.typesData) do
		local message = utf8_left(value:utf8lower(), v:utf8len() + 2)
		local prefix = message:utf8sub(1, 1)
		if prefix == "/" or prefix == "!" or prefix == "." then
			local command = message:utf8sub(2, message:utf8len())
			if prefix == "." then
				command = Arbitrage.commands.ConvertRusToEng(command)
			end

			if v:utf8lower() .. " " == command:utf8lower() then
				return k
			end
		end
	end

	local utf1sum = utf8_left(value, 1)
	local utf2sum = utf8_left(value, 2):utf8lower()
	local utf3sum = utf8_left(value, 3)

	if (utf2sum == "[[" or utf2sum == "хх") or (utf2sum == "./" or utf2sum == "ю.") then
		return 10
	end

	if (utf2sum == "//" or utf2sum == "..") and utf3sum != "..." then
		return 11
	end

	if (utf1sum == "/" or utf1sum == "!" or utf1sum == ".") and value:utf8len() > 1 then
		local explode = string.Explode(" ", value)

		if #explode > 1 then
			return 13
		end
	end

	return nil
end

local padding = 5
function PANEL:OnTextChanged(text)
	self.inputExplode = Arbitrage:ExtractArgs(text)

	hook.Run("ChatTextChanged", text)

	local commandPrefix = utf8_left(text, 2):utf8lower()
	local abbreviatedCommand = (commandPrefix == "[[" or commandPrefix == "хх") or (commandPrefix == "./" or commandPrefix == "ю.") or (commandPrefix == "//" or commandPrefix == "..")

	local prefix = text:utf8sub(1, 1)
	if (prefix == "/" or prefix == "!" or prefix == "." or abbreviatedCommand) and text:utf8sub(1, 3) != "..." then
		local inputCommand = text:utf8sub(2, text:utf8len())

		if prefix == "." then
			inputCommand = Arbitrage.commands.ConvertRusToEng(inputCommand)
		end

		local explode = string.Explode(" ", inputCommand)
		inputCommand = explode[1]
		self._numEx = #explode

		local commands = GetAllCommands(inputCommand, text)

		local useCommand = nil
		if #explode > 1 and !abbreviatedCommand then
			useCommand = explode[1]
		end

		if useCommand then
			local command = commands[useCommand]
			if command then
				commands = {
					[useCommand] = commands[useCommand]
				}
			else
				commands = {}
			end
		end

		for k, v in pairs(self.commandsPanel.stored) do
			local isFind = false

			if !useCommand then
				for k2, v2 in pairs(commands) do
					if k == k2 then
						isFind = true
						break
					end
				end
			else
				if k == useCommand then
					isFind = true
				end
			end

			if !isFind then
				if IsValid(v) then
					v:SizeTo(0, 0, 0.2, 0, -1, function()
						v:Remove()
					end)
				end

				self.commandsPanel.stored[k] = nil
			end
		end

		local sizeCommand = draw.GetFontHeight("arb.Font_FuturaPTDemi_7")

		for command, data in pairs(commands) do
			local arguments = data[1]
			local optionalArguments = data[2]
			local description = L(data[3])

			if !IsValid(self.commandsPanel.stored[command]) then
				local panel = self.commandsPanel:Add("DPanel")
				panel:SetTall(0)
				panel:Dock(BOTTOM)
				panel:SizeTo(0, sizeCommand, 0.2)
				panel.Paint = function(_, w, h)
					local x = 10

					do
						local _x, _ = draw.SimpleText("/" .. command, "arb.Font_FuturaPTDemi_7", x, 0, Color(255, 61, 96), TEXT_ALIGN_LEFT)
						x = x + _x + padding
					end

					do
						for k, v in ipairs(arguments) do
							local bSelect = isSelect(#arguments, k + 1, self._numEx, #optionalArguments > 0)
							local col = bSelect and Color(255, 61, 96) or Color(255, 234, 238)

							local _x, _w = draw.SimpleText("<" .. v .. ">", "arb.Font_FuturaPTBook_7", x, 0, col, TEXT_ALIGN_LEFT)

							if self._numEx > 1 and v == "player" then
								local argument = self.inputExplode[k + 1]
								local target = argument and Arbitrage.commands:FindPlayer(argument)

								local old = DisableClipping(true)
									draw.SimpleText(IsValid(target) and target:FullName(true) or L("#chat_chatbox_unknown_player"), "arb.Font_FuturaPTBook_7", x, -_w, color_white, TEXT_ALIGN_LEFT)
								DisableClipping(old)
							end

							x = x + _x + padding
						end
					end

					do
						for k, v in ipairs(optionalArguments) do
							local col = isSelect(#optionalArguments + #arguments, #arguments + k + 1, self._numEx, false) and Color(255, 61, 96) or Color(255, 234, 238)

							local _x, _ = draw.SimpleText("[" .. v .. "]", "arb.Font_FuturaPTBook_7", x, 0, col, TEXT_ALIGN_LEFT)
							x = x + _x + padding
						end
					end

					draw.SimpleText(" — " .. description, "arb.Font_FuturaPTBook_7", x, 0, Color(255, 234, 238, 180), TEXT_ALIGN_LEFT)
				end

				self.commandsPanel.stored[command] = panel
			end
		end

		self.commandsPanel:AlphaTo(255, 0.2)
	else
		self.commandsPanel:AlphaTo(0, 0.2, 0, function()
			for k, v in pairs(self.commandsPanel.stored) do
				if IsValid(v) then
					v:Remove()
				end

				self.commandsPanel.stored[k] = nil
			end
		end)

		self._numEx = 0
	end

	local oldChatType = LocalPlayer():GetNetVar("arb.chattype")
	local var = GetChatType(text)
	local ChatType = PLUGIN.typesData[var]

	if oldChatType != ChatType then
		netstream.Start("arb.SetChatType", var)
	end
end

DEFINE_BASECLASS("DTextEntry")

function PANEL:OnMessageSent()
	local text = self.entry:GetText()

	if text:find("%S") then
		local lastEntry = PLUGIN.chat.history[#PLUGIN.chat.history]

		if lastEntry != text then
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

	self.commandsPanel:AlphaTo(0, 0.2, 0, function()
		for k, v in pairs(self.commandsPanel.stored) do
			if IsValid(v) then
				v:Remove()
			end

			self.commandsPanel.stored[k] = nil
		end
	end)

	self._numEx = 0

	self:SetActive(false)
end

function PANEL:OnTabChanged(panel)
	panel:InvalidateLayout(true)
	panel:ScrollToBottom()
end

function PANEL:OnTabUpdated(id, filter, newID)
	local tab = self.tabs:GetTabs()[id]

	if !tab then
		return
	end

	tab:SetFilter(filter)

	self.tabs:RenameTab(id, newID)
end

local tabFilters = {
	["#chat_chatbox_tab_general"] = function(data)
		return true
	end,
	["#chat_chatbox_tab_rp"] = function(data)
		local rpTypes = {
			L("#chat_lnrp_type"),
			L("#chat_gnrp_type"),
			L("#chat_pm_type"),
			L("#chat_help_type"),
			L("#chat_admin_type")
		}

		for _, s_type in ipairs(rpTypes) do
			if data[2] == s_type .. " " or data[3] == s_type .. " " then
				return false
			end
		end
		return true
	end,
	["#chat_chatbox_tab_nonrp"] = function(data)
		local nonRpTypes = {
			L("#chat_lnrp_type"),
			L("#chat_gnrp_type")
		}

		for _, s_type in ipairs(nonRpTypes) do
			if data[2] == s_type .. " " or data[3] == s_type .. " " then
				return true
			end
		end
		return false
	end,
	["#chat_chatbox_tab_personal"] = function(data)
		local pmType = L("#chat_pm_type")
		return data[2] == pmType .. " " or data[3] == pmType .. " "
	end,
	["#chat_chatbox_tab_admin"] = function(data)
		local adminTypes = {
			L("#chat_help_type"),
			L("#chat_admin_type")
		}

		for _, s_type in ipairs(adminTypes) do
			if data[2] == s_type .. " " or data[3] == s_type .. " " then
				return true
			end
		end
		return false
	end
}

function PANEL:AddMessage(...)
	local activeTab = self.tabs:GetActiveTab()

	for _, tab in pairs(self.tabs:GetTabs()) do
		local id = tab:GetID()
		local filter = tabFilters[id]

		if filter and filter({...}) then
			tab:AddLine({...})

			if activeTab and id != activeTab:GetID() then
				tab:GetButton().unread = true
			end
		end
	end

	chat.PlaySound()
end

vgui.Register("arbChatbox", PANEL, "EditablePanel")