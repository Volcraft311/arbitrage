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

TEAM.name = "Нагито Комаэда"
TEAM.description = "Абсолютный Везунчик"
TEAM.category = "GOODBYE DESPAIR"
TEAM.model = "models/player/dewobedil/nagito_komaeda/default_p.mdl"
TEAM.path = "danganronpa/characters/nagito"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.6
TEAM.staminaSpeed = 1
TEAM.walkSpeed = 1
TEAM.runSpeed = 1
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 33
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 27 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_NAGITO = Arbitrage.teams.Create(TEAM)
