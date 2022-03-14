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

TEAM.name = "Кайто Момота"
TEAM.description = "Абсолютный Астронавт"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl"
TEAM.path = "danganronpa/characters/kaito"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.3
TEAM.staminaSpeed = 1.3
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.1
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 36
TEAM.sleepSpeed = 38
TEAM.max = 1

for i = 1, 45 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_KAITO = Arbitrage.teams.Create(TEAM)