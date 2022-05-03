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

TEAM.name = "Чихиро Фуджисаки"
TEAM.description = "Абсолютный Программист"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/player/dewobedil/danganronpa/chihiro/default_p.mdl"
TEAM.path = "danganronpa/characters/chihiro"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 1.1
TEAM.staminaSpeed = 1.5
TEAM.walkSpeed = 0.7
TEAM.runSpeed = 0.8
TEAM.hungerSpeed = 33
TEAM.thirstSpeed = 33
TEAM.sleepSpeed = 33
TEAM.max = 1

for i = 1, 16 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_CHIHIRO = Arbitrage.teams.Create(TEAM)