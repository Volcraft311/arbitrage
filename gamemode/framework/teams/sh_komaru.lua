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

TEAM.name = "Комару Наэги"
TEAM.description = "Абсолютная Младшая Сестра Надежды"
TEAM.category = "ULTRA DESPAIR GIRLS"
TEAM.model = "models/player/someguy/komaru_p.mdl"
TEAM.path = "danganronpa/characters/komaru"
TEAM.uniqueID = "komaru"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 1
TEAM.walkSpeed = 1
TEAM.runSpeed = 1
TEAM.hungerSpeed = 36
TEAM.thirstSpeed = 36
TEAM.sleepSpeed = 36
TEAM.max = 1

for i = 1, 32 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_KOMARU = Arbitrage.teams.Create(TEAM)