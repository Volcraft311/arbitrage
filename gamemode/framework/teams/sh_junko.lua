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

TEAM.name = "Джунко Эношима"
TEAM.description = "Абсолютная Модница"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/player/dewobedil/danganronpa/junko_enoshima/default_p.mdl"
TEAM.path = "danganronpa/characters/junko"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.6
TEAM.staminaSpeed = 0.9
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.1
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 30
TEAM.sleepSpeed = 37
TEAM.max = 1

for i = 1, 19 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_JUNKO = Arbitrage.teams.Create(TEAM)
