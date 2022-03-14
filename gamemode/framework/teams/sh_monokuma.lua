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

local TEAM = {emodjiList = {}}

TEAM.name = "Монокума"
TEAM.description = "Директор Абсолютного Отчаяния"
TEAM.admin = true
TEAM.weapons = {"gmod_tool", "weapon_physgun"}
TEAM.model = "models/player/yourtoast4/danganronpa/monokuma.mdl"
TEAM.path = "danganronpa/characters/monokuma"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 1
TEAM.staminaSpeed = 0.5
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.3
TEAM.hungerSpeed = 10000
TEAM.thirstSpeed = 10000
TEAM.sleepSpeed = 10000
TEAM.max = 10

TEAM.monokuma = true

for i = 1, 35 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_MONOKUMA = Arbitrage.teams.Create(TEAM)