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
Arbitrage.version = "0.163 (23.05.2026)"
Arbitrage.GM = GM

include("dev.lua")
AddCSLuaFile("dev.lua")

include("config.lua")
AddCSLuaFile("config.lua")

include("framework/sh_batch.lua")
AddCSLuaFile("framework/sh_batch.lua")