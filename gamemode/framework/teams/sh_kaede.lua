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

TEAM.name = "Каэде Акамацу"
TEAM.description = "Абсолютная Пианистка"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/kaede_akamatsu/default_p.mdl"
TEAM.path = "danganronpa/characters/kaede"
TEAM.uniqueID = "kaede"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 1
TEAM.staminaSpeed = 1
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 33
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 47 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_KAEDE = Arbitrage.teams.Create(TEAM)