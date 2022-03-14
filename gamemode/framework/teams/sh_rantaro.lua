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

TEAM.name = "Рантаро Амами"
TEAM.description = "Абсолютный Авантюрист"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/rantaro_amami/default_p.mdl"
TEAM.path = "danganronpa/characters/rantaro"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 1
TEAM.walkSpeed = 1
TEAM.runSpeed = 1
TEAM.hungerSpeed = 40
TEAM.thirstSpeed = 37
TEAM.sleepSpeed = 37
TEAM.max = 1

for i = 1, 24 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_RANTARO = Arbitrage.teams.Create(TEAM)