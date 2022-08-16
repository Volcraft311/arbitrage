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

TEAM.name = "Аканэ Овари"
TEAM.description = "Абсолютная Гимнастка"
TEAM.category = "GOODBYE DESPAIR"
TEAM.model = "models/player/yourtoast4/danganronpa/akane_owari.mdl"
TEAM.path = "danganronpa/characters/akane"
TEAM.uniqueID = "akane"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.3
TEAM.staminaSpeed = 1.2
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.2
TEAM.hungerSpeed = 25
TEAM.thirstSpeed = 36
TEAM.sleepSpeed = 38
TEAM.max = 1

for i = 1, 26 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_AKANE = Arbitrage.teams.Create(TEAM)