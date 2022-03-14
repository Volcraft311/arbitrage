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

AddCSLuaFile()

GM.Name = "GM-Arbitrage"
GM.Author = "Selenter"

local gamemode_table = {
	"base",
	"sandbox"
}

for k, v in pairs(gamemode_table) do
	DeriveGamemode(v)
end

Arbitrage = Arbitrage or {}
Arbitrage.version = "1.01.1.070122"
Arbitrage.GM = GM

include("framework/sh_batch.lua")
AddCSLuaFile("framework/sh_batch.lua")