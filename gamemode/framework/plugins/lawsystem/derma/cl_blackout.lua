local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:SetDrawOnTop(true)
	self:SetZPos(30000)
	self.time = 0.5
	self.speed = 1

	self:SetAlpha(0)
	self:AlphaTo(255, self.speed, 0, function()
		timer.Simple(self.time, function()
			if self.callback then
				self.callback()
			end

			timer.Simple(0.5, function()
				self:AlphaTo(0, self.speed * 2, 0, function()
					self:Remove()
				end)
			end)
		end)
	end)
end

function PANEL:Callback(callback, time, speed)
	self.callback = callback

	if tonumber(time) then
		self.time = tonumber(time)
	end

	if tonumber(speed) then
		self.speed = tonumber(speed)
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.Blackout", PANEL, "EditablePanel")


netstream.Hook("arb.Blackout", function(time, speed)
	vgui.Create("arb.Blackout"):Callback(nil, time, speed)
end)