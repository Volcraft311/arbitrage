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

TEAM.name = "Цумуги Широганэ"
TEAM.description = "Абсолютный Косплеер"
TEAM.category = "KILLING HARMONY"
TEAM.model = "models/player/dewobedil/danganronpa/tsumugi_shirogane/default_p.mdl"
TEAM.path = "danganronpa/characters/tsumugi"
TEAM.uniqueID = "tsumugi"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 1.2
TEAM.walkSpeed = 0.9
TEAM.runSpeed = 0.8
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 30
TEAM.sleepSpeed = 36
TEAM.max = 1

for i = 1, 29 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_TSUMUGI = Arbitrage.teams.Create(TEAM)