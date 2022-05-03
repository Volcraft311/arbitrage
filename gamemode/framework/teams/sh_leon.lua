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

TEAM.name = "Леон Кувата"
TEAM.description = "Абсолютный Бейсболист"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/player/yourtoast4/danganronpa/leon_kuwata.mdl"
TEAM.path = "danganronpa/characters/leon"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.6
TEAM.staminaSpeed = 0.9
TEAM.walkSpeed = 1
TEAM.runSpeed = 1.1
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 26
TEAM.sleepSpeed = 30
TEAM.max = 1

for i = 1, 15 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_LEON = Arbitrage.teams.Create(TEAM)