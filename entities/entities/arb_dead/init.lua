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

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel("models/bh/props/dead.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
end

function ENT:SetCharacter(data)
	self:SetNetVar("character", {
		steamid = data.steamid or nil,
		faction = data.faction or nil
	})
end

function ENT:Think()
	local data = self:GetCharacter()
	if data then
		local client = player.GetBySteamID(data.steamid)
		if IsValid(client) then
			if client:IsPlaying() and client:Alive() then
				return self:Remove()
			end
		else
			self:NextThink(CurTime() + 30)

			return true
		end
	end

	self:NextThink(CurTime() + 5)

	return true
end