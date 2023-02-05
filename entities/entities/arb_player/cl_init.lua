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

include("shared.lua");

function ENT:Draw()
	self:DrawModel();
end

function ENT:Think()
	if ((self.nextAnimCheck or 0) < CurTime()) then
		local anim = self:GetSequenceName(self:GetSequence())

		if anim != self.animation then
			self:SetAnim(self.animation)
		end

		self.nextAnimCheck = CurTime() + 5
	end
end