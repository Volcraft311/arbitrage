local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:SetDrawOnTop(true)
	self:SetZPos(30000)

	self:SetAlpha(0)
	self:AlphaTo(255, 1, 0, function()
		timer.Simple(0.5, function()
			if self.callback then
				self.callback()
			end
		end)

		timer.Simple(1, function()
			self:AlphaTo(0, 2, 0, function()
				self:Remove()
			end)
		end)
	end)
end

function PANEL:Callback(callback)
	self.callback = callback
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.Blackout", PANEL, "EditablePanel")