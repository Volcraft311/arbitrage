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

local TEAM = {}
TEAM.name = "Администратор"
TEAM.color = Color(87, 211, 132)
TEAM.model = "models/editor/camera.mdl"
TEAM.admin = true
TEAM.weapons = {"gmod_tool", "weapon_physgun"}

TEAM_ADMIN = Arbitrage.teams.Create(TEAM)