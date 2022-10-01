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

TEAM.name = "Джатаро Кемури"
TEAM.description = "Юный Абсолютный Художник"
TEAM.category = "ULTRA DESPAIR GIRLS"
TEAM.model = "models/player/jataro.mdl"
TEAM.path = "danganronpa/characters/jataro"
TEAM.uniqueID = "jataro"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.6
TEAM.staminaSpeed = 1.1
TEAM.walkSpeed = 0.9
TEAM.runSpeed = 1
TEAM.hungerSpeed = 32
TEAM.thirstSpeed = 36
TEAM.sleepSpeed = 42
TEAM.max = 1

for i = 1, 16 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_JATARO = Arbitrage.teams.Create(TEAM)