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

local TEAM = {}
TEAM.name = "Наблюдатели"
TEAM.color = Color(255, 255, 255)

function TEAM.OnChange(client)
	client:SetNoDraw(true)
	client:SetNotSolid(true)
	client:DrawWorldModel(false)
	client:DrawShadow(false)
	client:GodEnable()
	client:SetNoTarget(true)
	client:StripWeapons()
	client:StripAmmo()

	client:Freeze(false)

	client:Spectate(OBS_MODE_CHASE)
	for k, v in SortedPairs(player.GetAll()) do
		if v:Alive() and v:IsPlaying() and v != client then
			client:SpectateEntity(v)
			break
		end
	end
end

TEAM_SPECTATE = Arbitrage.teams.Create(TEAM)