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

TEAM.name = "Лирайя Артриус"
TEAM.description = "Абсолютная Ясновидящая"
TEAM.admin = true
TEAM.weapons = {"gmod_tool", "weapon_physgun"}
TEAM.model = "models/player/yourtoast4/danganronpa/monokuma.mdl"
TEAM.path = "danganronpa/characters/liraia"
TEAM.uniqueID = "liraia"

TEAM.color = Color(255, 0, 0)
TEAM.evidenceVisibility = 1
TEAM.staminaSpeed = 0
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.3
TEAM.hungerSpeed = 10000
TEAM.thirstSpeed = 10000
TEAM.sleepSpeed = 10000
TEAM.max = 10

for i = 1, 16 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_LIRAIA = Arbitrage.teams.Create(TEAM)
