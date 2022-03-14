--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
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
	if !data then return end

	local client = player.GetBySteamID(data.steamid)
	if !IsValid(client) then return end

	if client:IsPlaying() and client:Alive() then
		self:Remove()
	end
end