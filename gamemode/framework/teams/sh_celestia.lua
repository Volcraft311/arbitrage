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

TEAM.name = "Селестия Люденберг"
TEAM.description = "Абсолютный Азартный Игрок"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/player/dewobedil/celestia_ludenberg/default_p.mdl"
TEAM.path = "danganronpa/characters/celestia"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 1.2
TEAM.walkSpeed = 0.8
TEAM.runSpeed = 0.8
TEAM.hungerSpeed = 36
TEAM.thirstSpeed = 30
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 23 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_CELESTIA = Arbitrage.teams.Create(TEAM)
