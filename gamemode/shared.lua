--[[
        © PumpStaff 2026.
        This script was created from the developers of the PumpStaff Staff.
        You can get more information from one of the links below:
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

AddCSLuaFile()

GM.Name = "GM-Arbitrage"
GM.Author = "Selenter | Volcraft31"

local gamemode_table = {
	"base",
	"sandbox"
}

for _, v in ipairs(gamemode_table) do
	DeriveGamemode(v)
end

Arbitrage = Arbitrage or {}
Arbitrage.version = "0.165p (24.05.2026)"
Arbitrage.GM = GM

include("dev.lua")
AddCSLuaFile("dev.lua")

include("config.lua")
AddCSLuaFile("config.lua")

include("framework/sh_batch.lua")
AddCSLuaFile("framework/sh_batch.lua")