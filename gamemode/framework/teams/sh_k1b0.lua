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

TEAM.name = "K1-B0"
TEAM.description = "Абсолютный Робот"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player_kiibo.mdl"
TEAM.path = "danganronpa/characters/k1b0"
TEAM.weapons = {"nightvision"}

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.6
TEAM.staminaSpeed = 0.5
TEAM.walkSpeed = 1
TEAM.runSpeed = 1
TEAM.hungerSpeed = 10000
TEAM.thirstSpeed = 10000
TEAM.sleepSpeed = 30
TEAM.max = 1

for i = 1, 26 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_K1B0 = Arbitrage.teams.Create(TEAM)