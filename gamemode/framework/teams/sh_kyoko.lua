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

TEAM.name = "Кёко Киригири"
TEAM.description = "Абсолютный Детектив"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/kyoko_kirigiri_yoru/danganronpa/rstar/kyoko_kirigiri_yoru/kyoko_kirigiri_yoru.mdl"
TEAM.path = "danganronpa/characters/kyoko"
TEAM.uniqueID = "kyoko"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 1
TEAM.staminaSpeed = 0.98
TEAM.walkSpeed = 0.95
TEAM.runSpeed = 0.95
TEAM.hungerSpeed = 37
TEAM.thirstSpeed = 34
TEAM.sleepSpeed = 50
TEAM.max = 1

for i = 1, 18 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_KYOKO = Arbitrage.teams.Create(TEAM)
