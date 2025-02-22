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

local addMat = Material("danganronpa/monopad/add.png")
local noteMat = Material("danganronpa/monopad/note.png")
local editMat = Material("danganronpa/monopad/edit.png")
local deleteMat = Material("danganronpa/ui/delete.png")
function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	ui:BackButton(self, function()
		local historyID = ui:GetActiveHistoryID()
		if historyID then
			local monopad = MonoPad:GetObject()
			table.remove(monopad.history, historyID)
		end

		ui:Rebuild()
		asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
	end)

	local leftPanel = self:Add("Panel")
	leftPanel:SetPos(50, 18)
	leftPanel:SetSize(230, 518)
	MonoPad:StartRegisterMeta(leftPanel)

	local addButton = leftPanel:Add("DPanel")
	addButton:Dock(BOTTOM)
	addButton:DockMargin(0, 10, 0, 0)
	addButton:SetTall(42)
	addButton.alpha = 0.05
	addButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)

		local size = 18
		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(addMat)
		surface.DrawTexturedRect(25, h / 2 - size / 2, size, size)

		draw.SimpleText("#monopad_notes_createnew", MonoPad:GetFont("notes_title"), 52, 9, Color(255, 255, 255, 255 * _.alpha), TEXT_ALIGN_LEFT)
	end
	addButton.DoClick = function()
		DermaStringRequest = Derma_StringRequest("#monopad_notes_createnote", "#monopad_notes_setnotename", "", function(text)
			netstream.Start("MonoPad:CreateNotes", text)

			timer.Simple(0.5, function()
				self:Rebuild()
			end)

			Arbitrage.notify.NotifyChat("#monopad_notes_success")
		end, nil, "#monopad_notes_create", "#monopad_notes_cancel")
		DermaStringRequest.startTime = SysTime()
		DermaStringRequest:SetAlpha(0)
		DermaStringRequest:AlphaTo(255, 0.3)

	    DermaStringRequest.Paint = function(_, w, h)
	        Derma_DrawBackgroundBlur(_, _.startTime)

	        surface.SetDrawColor(41, 22, 25)
	        surface.DrawRect(0, 0, w, h)

	        surface.SetDrawColor(255, 61, 96, 165.75)
	        surface.DrawOutlinedRect(0, 0, w, h, 2)

	        surface.SetDrawColor(255, 61, 96, 165.75)
	        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

	        surface.SetDrawColor(255, 61, 96, 20)
	        surface.DrawRect(0, 0, w, H(23))
	    end

	    DermaStringRequest:GetChildren()[4]:SetTextColor(Color(255, 255, 255))
	    DermaStringRequest:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(255, 255, 255))

	    asterionlib.EmitSound(MonoPad.sounds.message_sent)
	end

	self.scrollPanel = leftPanel:Add("DScrollPanel")
	self.scrollPanel:Dock(FILL)
	self.scrollPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end

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
	MonoPad:StartRegisterMeta(self.scrollPanel)


	local rightPanel = self:Add("Panel")
	rightPanel:SetPos(290, 18)
	rightPanel:SetSize(590, 518)
	rightPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end
	MonoPad:StartRegisterMeta(rightPanel)

	self.title = rightPanel:Add("DPanel")
	self.title:SetAlpha(0)
	self.title.text = nil
	self.title:Dock(TOP)
	self.title:SetTall(60)
	self.title.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(16, h - 1, w - 32, 1)

		if _.text then
			local size = 42
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(noteMat)
			surface.DrawTexturedRect(16, h / 2 - size / 2, size, size)

			draw.SimpleText(_.text, MonoPad:GetFont("notes_title2"), w / 2, 11, color_white, TEXT_ALIGN_CENTER)
		end
	end
	MonoPad:StartRegisterMeta(self.title)

	local editButton = self.title:Add("DButton")
	editButton:SetText("")
	editButton:SetPos(512.2, 19.5)
	editButton:SetSize(19, 19)
	editButton.alpha = 0.05
	editButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)

		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(editMat)
		surface.DrawTexturedRect(0, 0, h, h)
	end
	editButton.DoClick = function(_, w, h)
		if !self.selectID then return end

		local panel = vgui.Create("MonoPad:NotesSub")
		panel:SetData(self.selectID, self.title.text, self.description.text, function(title, description)
			self.title.text = title
			self.description.text = description
			self.description.scroll = 0
			self.description.data = asterionlib.WrapText(description, self.description:GetWide(), MonoPad:GetFont("notes_description"), true)

			ui:EditHistory(ui:GetActiveHistoryID(), {
				"notes",
				title,
				MonoPad.icons.notes,
				{self.selectID, title}
			})

			self:Rebuild()
		end)

		DermaStringRequest = panel

		asterionlib.EmitSound(MonoPad.sounds.message_sent)
	end

	local removeButton = self.title:Add("DButton")
	removeButton:SetText("")
	removeButton:SetPos(552.2, 19.5)
	removeButton:SetSize(19, 19)
	removeButton.alpha = 0.05
	removeButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)

		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(deleteMat)
		surface.DrawTexturedRect(0, 0, h, h)
	end
	removeButton.DoClick = function(_, w, h)
		if !self.selectID then return end

		netstream.Start("MonoPad:RemoveNotes", self.selectID)

		self.title:SetAlpha(0)
		self.description:SetAlpha(0)

		timer.Simple(0.5, function()
			self:Rebuild()
		end)

		asterionlib.EmitSound(MonoPad.sounds.message_sent)
		Arbitrage.notify.NotifyChat("#monopad_notes_deleted")
	end

	local font = MonoPad:GetFont("notes_description")
	local fontHeight = draw.GetFontHeight(font)
	self.description = rightPanel:Add("DPanel")
	self.description:SetAlpha(0)
	self.description:Dock(FILL)
	self.description:DockMargin(16, 0, 16, 0)
	self.description.text = nil
	self.description.data = {}
	self.description.scroll = 0
	self.description.GetScroll = function(this)
		return this.scroll
	end
	self.description.SetScroll = function(this, value)
		local data = asterionlib.WrapText(this.text or "", this:GetWide(), font, true)
		local size = 0
		for k, v in ipairs(data) do
			size = size + fontHeight
		end

		if size < this:GetTall() then return end
		this.scroll = math.Clamp(value, 0, size - (this:GetTall() * 0.8))
	end
	self.description.Paint = function(this, w, h)
		if !this.text then return end

		local y = -this:GetScroll()
		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, 0, w, h)
	    end, function()
	        for k, v in ipairs(this.data or {}) do
				draw.SimpleText(v, font, 0, y, color_white, TEXT_ALIGN_LEFT)
				y = y + fontHeight
			end
	    end)
	end

	self:Rebuild()
end

function PANEL:Rebuild()
	self.scrollPanel:Clear()

	netstream.Request("MonoPad:GetNotes", nil, function(data)
		for id, title in pairs(data or {}) do
			self:AddNotes(id, title)
		end
	end)
end

function PANEL:OpenNote(id, title)
	self.description.text = ""
	self.description.data = {}

	self.selectID = id

	self.title:SetAlpha(0)
	self.title:AlphaTo(255, 0.2)
	self.title.text = title

	self.description:SetAlpha(0)
	self.description:AlphaTo(255, 0.2)
	self.description.scroll = 0

	netstream.Request("MonoPad:GetNoteDescription", id, function(description)
		self.description.text = description
		self.description.data = asterionlib.WrapText(description, self.description:GetWide(), MonoPad:GetFont("notes_description"), true)
	end)
end

function PANEL:AddNotes(id, title)
	local button = self.scrollPanel:Add("DButton")
	button.id = self.count
	button:SetText("")
	button:Dock(TOP)
	button:SetTall(45)
	button.alpha = 0.05
	button.Paint = function(this, w, h)
		this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or self.selectID == id) and 1 or 0.05)

		local _, y = self.scrollPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.scrollPanel:GetTall() - y)

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
		    surface.SetDrawColor(255, 255, 255, 10)
			surface.DrawRect(14, h - 1, w - 28, 1)

			local size = 22
			surface.SetDrawColor(255, 255, 255, 255 * this.alpha)
			surface.SetMaterial(noteMat)
			surface.DrawTexturedRect(15, h / 2 - size / 2, size, size)

			draw.SimpleText("№" .. id .. " " .. title, MonoPad:GetFont("notes_title"), 44, 11, Color(255, 255, 255, 255 * this.alpha), TEXT_ALIGN_LEFT)
	    end)
	end
	button.DoClick = function(this)
		local _, y = self.scrollPanel:GetChildPosition(this)
		if y < -this:GetTall() or y > self.scrollPanel:GetTall() then return end

		self:OpenNote(id, title)

		local ui = MonoPad:GetUI()
		ui:EditHistory(ui:GetActiveHistoryID(), {
			"notes",
			title,
			MonoPad.icons.notes,
			{id, title}
		})

		asterionlib.EmitSound(MonoPad.sounds.planshet_beep)
	end
end

vgui.Register("MonoPad:Notes", PANEL, "Panel")


local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()


    local t = H(375)
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

        draw.DrawText("#monopad_notes_addnew", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_notes_setname", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_notesexample_name", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monopad_notes_setdesc", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monopad_notesexample_create", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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

    self.titleEntry = self.main:Add("DTextEntry")
    self.titleEntry:SetPos(W(5), H(75))
    self.titleEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.titleEntry:SetPlaceholderText("#monopad_notes_name")
    self.titleEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descriptionEntry = self.main:Add("DTextEntry")
    self.descriptionEntry:SetVerticalScrollbarEnabled(true)
    self.descriptionEntry:SetMultiline(true)
    self.descriptionEntry:SetPos(W(5), H(155))
    self.descriptionEntry:SetSize(self.main:GetWide() - W(10), H(150))
    self.descriptionEntry:SetPlaceholderText("#monopad_notes_desc")
    self.descriptionEntry:SetFont("arb.Font_FuturaPTBook_8")

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("#monopad_notes_add", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        local a, b = self.titleEntry:GetValue(), self.descriptionEntry:GetValue()

        netstream.Start("MonoPad:EditNotes", self.id, a, b)

        local cb = self.callback
        timer.Simple(0.5, function()
	        if cb then
	        	cb(a, b)
	        end
    	end)

        Arbitrage.notify.NotifyChat("#monopad_notes_edited")
    end
end

function PANEL:SetData(id, title, description, callback)
	self.id = id
	self.callback = callback

	self.titleEntry:SetValue(title)
	self.descriptionEntry:SetValue(description)
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("MonoPad:NotesSub", PANEL, "EditablePanel")