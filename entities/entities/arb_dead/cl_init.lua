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

include("shared.lua");

local sizeX = 160
local sizeY = 180

function ENT:Draw()
	self:DrawModel()

	local position, angles = self:GetPos(), self:GetAngles()
	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 270)

	local data = self:GetCharacter()
	if !data then return end

	local faction = Arbitrage.teams.Get(data.faction)
	if !faction then return end
	if !faction.dead then return end

	local mat = Arbitrage.GetMaterial(faction.dead)

	cam.Start3D2D(position + self:GetForward() * 0.91 + self:GetRight() * 7.7 + self:GetUp() * 77, angles, 0.1)
		render.PushFilterMin(TEXFILTER.NONE)
		render.PushFilterMag(TEXFILTER.NONE)

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0, 0, sizeX, sizeY)

		render.PopFilterMin()
		render.PopFilterMag()
	cam.End3D2D()
end