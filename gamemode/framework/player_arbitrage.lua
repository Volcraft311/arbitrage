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

player_manager.RegisterClass("player_arbitrage", PLAYER, "player_default")