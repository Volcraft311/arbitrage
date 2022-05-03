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

TEAM.name = "Гонта Гокухара"
TEAM.description = "Абсолютный Энтомолог"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/gonta/default_p.mdl"
TEAM.path = "danganronpa/characters/gonta"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.2
TEAM.staminaSpeed = 0.8
TEAM.walkSpeed = 1
TEAM.runSpeed = 1
TEAM.hungerSpeed = 27
TEAM.thirstSpeed = 30
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 32 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_GONTA = Arbitrage.teams.Create(TEAM)