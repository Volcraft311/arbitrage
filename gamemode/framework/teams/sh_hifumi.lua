--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local TEAM = {emodjiList = {}}

TEAM.name = "Хифуми Ямада"
TEAM.description = "Абсолютный Автор Фанфиков"
TEAM.category = "TRIGGER HAPPY HAVOC"
TEAM.model = "models/player/yourtoast4/danganronpa/hifumi_yamada.mdl"
TEAM.path = "danganronpa/characters/hifumi"

TEAM.color = Color(240, 201, 73)
TEAM.evidenceVisibility = 0.4
TEAM.staminaSpeed = 4
TEAM.walkSpeed = 0.8
TEAM.runSpeed = 0.8
TEAM.hungerSpeed = 50
TEAM.thirstSpeed = 46
TEAM.sleepSpeed = 40
TEAM.max = 1

for i = 1, 22 do
	TEAM.emodjiList[#TEAM.emodjiList + 1] = TEAM.path .. "/emoji/" .. i .. ".png"
end

TEAM_HIFUMI = Arbitrage.teams.Create(TEAM)