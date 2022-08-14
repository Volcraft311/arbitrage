--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local TEAM = {emodjiList = {}}

TEAM.name = "Тенко Чабашира"
TEAM.description = "Абсолютный Мастер Айкидо"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/tenko_chabashira/default_p.mdl"
TEAM.path = "danganronpa/characters/tenko"
TEAM.uniqueID = "tenko"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.3
TEAM.staminaSpeed = 0.8
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.1
TEAM.hungerSpeed = 40
TEAM.thirstSpeed = 37
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 33 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_TENKO = Arbitrage.teams.Create(TEAM)