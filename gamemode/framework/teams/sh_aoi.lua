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

TEAM.name = "Аой Асахина"
TEAM.description = "Абсолютный Пловец"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/custom/aoi_asahina.mdl"
TEAM.path = "danganronpa/characters/aoi"
TEAM.uniqueID = "aoi"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 0.8
TEAM.walkSpeed = 1.02
TEAM.runSpeed = 1.2
TEAM.hungerSpeed = 22
TEAM.thirstSpeed = 30
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 24 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_AOI = Arbitrage.teams.Create(TEAM)