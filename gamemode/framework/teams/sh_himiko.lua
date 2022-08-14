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

TEAM.name = "Химико Юмено"
TEAM.description = "Абсолютная Фокусница"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/himiko_yumeno/default_p.mdl"
TEAM.path = "danganronpa/characters/himiko"
TEAM.uniqueID = "himiko"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.3
TEAM.staminaSpeed = 1.2
TEAM.walkSpeed = 0.85
TEAM.runSpeed = 0.85
TEAM.hungerSpeed = 30
TEAM.thirstSpeed = 27
TEAM.sleepSpeed = 30
TEAM.max = 1

for i = 1, 36 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_HIMIKO = Arbitrage.teams.Create(TEAM)