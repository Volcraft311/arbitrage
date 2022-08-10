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

TEAM.name = "Мичиру Мидзуно"
TEAM.description = "Абсолютный Стилист"
TEAM.category = ""
TEAM.admin = true
TEAM.weapons = {"gmod_tool", "weapon_physgun"}
TEAM.model = "models/player/yourtoast4/danganronpa/monokuma.mdl"
TEAM.path = "danganronpa/characters/michiru"
TEAM.uniqueID = "michiru"

TEAM.color = Color(135, 1, 1)
TEAM.evidenceVisibility = 3
TEAM.staminaSpeed = 1
TEAM.walkSpeed = 1.2
TEAM.runSpeed = 1.6
TEAM.hungerSpeed = 30
TEAM.thirstSpeed = 35
TEAM.sleepSpeed = 50
TEAM.max = 1

for i = 1, 18 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_MICHIRU = Arbitrage.teams.Create(TEAM)
