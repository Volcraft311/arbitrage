--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local PLAYER = {}
PLAYER.TauntCam = TauntCamera()

function PLAYER:ShouldDrawLocal()
    if (self.TauntCam:ShouldDrawLocalPlayer(self.Player, self.Player:IsPlayingTaunt())) then return true end
end

function PLAYER:CreateMove(cmd)
    if (self.TauntCam:CreateMove(cmd, self.Player, self.Player:IsPlayingTaunt())) then return true end
end

function PLAYER:CalcView(view)
    if (self.TauntCam:CalcView(view, self.Player, self.Player:IsPlayingTaunt())) then return true end
end

hook.Add("PlayerStartTaunt", "PlayerStartTaunt", function(client, act, length)
    client:SetLocalVar("tauntAct", act)
end)

player_manager.RegisterClass("player_arbitrage", PLAYER, "player_default")