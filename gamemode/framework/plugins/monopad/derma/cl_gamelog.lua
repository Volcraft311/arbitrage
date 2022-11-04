local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		ui:Rebuild()
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self.scrollPanel = self:Add("DScrollPanel")
	self.scrollPanel:SetPos(50, 18)
	self.scrollPanel:SetSize(830, 558)

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
	local _, min = nil, nil

	local inflictorFaction = Character.team:GetByID(inflictorID)
	if inflictorFaction then
		local emoji = Character.emoji:GetByUniqueID(inflictorFaction:GetUniqueID())
		_, min = emoji:GetByIndex(1)
	end

	local stringTime = Arbitrage.FormatTime(time)

	local attackerName = "Неизвестно"
	if attackerID then
		local attackerFaction = Character.team:GetByID(attackerID)

		if attackerFaction then
			attackerName = attackerFaction:GetName()
		end
	end

	local info = MonoPad.chapterTypes[investigationType]

	local button = self.scrollPanel:Add("DButton")
	button:SetText("")
	button:Dock(TOP)
	button:DockMargin(0, 0, 0, 10)
	button:SetTall(160)
	button.Paint = function(this, w, h)
	    local _, y = self.scrollPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.scrollPanel:GetTall() - y)

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
	    	surface.SetDrawColor(0, 0, 0, 240)
		    surface.DrawRect(0, 0, w, h)

		    if min then
		    	-- 158
		    	surface.SetDrawColor(255, 255, 255)
		    	surface.SetMaterial(Material(min))
		    	surface.DrawTexturedRect(0, -10, 400 * 0.395, 560 * 0.395)

		    	local size = 158  * 0.6
		    	surface.SetMaterial(crossMat)
		    	surface.DrawTexturedRect(158 / 2 - size / 2, 158 / 2 - size / 2 + 20, size, size)
		    end

		    draw.SimpleText("Дело №" .. id .. ", " .. (inflictorFaction and inflictorFaction:GetName() or "Неизвестно"), MonoPad:GetFont("gamelog_title"), 176, 14, color_white, TEXT_ALIGN_LEFT)
		    draw.SimpleText("Глава \"" .. chapterTitle .. "\"", MonoPad:GetFont("gamelog_text"), 176, 44, color_white, TEXT_ALIGN_LEFT)

		    do
		    	local _w, _ = draw.SimpleText("Статус: ", MonoPad:GetFont("gamelog_text"), 176, 76, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
		    	MonoPad:DrawTextBlur(info[1], MonoPad:GetFont("gamelog_text"), 176 + _w, 76, info[2], TEXT_ALIGN_LEFT, ColorAlpha(info[2], 100))
			end

			do
				local _w, _ = draw.SimpleText("Виновный: ", MonoPad:GetFont("gamelog_text"), 176, 102, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
				draw.SimpleText(attackerName, MonoPad:GetFont("gamelog_text"), 176 + _w, 102, color_white, TEXT_ALIGN_LEFT)
			end

			do
				local _w, _ = draw.SimpleText("Начато: ", MonoPad:GetFont("gamelog_text"), 176, 126, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
				draw.SimpleText("в " .. stringTime, MonoPad:GetFont("gamelog_text"), 176 + _w, 126, color_white, TEXT_ALIGN_LEFT)
			end

			if investigationType == 1 then
				surface.SetDrawColor(0, 0, 0, 250)
				surface.DrawRect(0, 0, w, h)
			end

		    surface.SetDrawColor(255, 255, 255, 3)
		    surface.DrawOutlinedRect(0, 0, w, h)
		    surface.DrawRect(509, 10, 1, h - 20)
	    end)
	end
end

vgui.Register("MonoPad:GameLog", PANEL, "Panel")