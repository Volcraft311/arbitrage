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

Arbitrage.GamemodeStart = os.clock()


Arbitrage.base = Arbitrage.base or {}
Arbitrage.util = Arbitrage.util or {}
Arbitrage.players = Arbitrage.players or {}
Arbitrage.meta = Arbitrage.meta or {}

function Arbitrage.Initialize()
	function Arbitrage.GM:GetGameDescription()
		return "Asterion Academy"
	end

	local commandData = {
		"gm_save","kill"
	}

	for k, v in ipairs(commandData) do
		concommand.Remove(v)
		concommand.Add(v, zero)
	end

	if Arbitrage.util.IsServerSide() then
		-- permission
		local function permissionFunc(_, client) return client:IsAdmin() end
		local funcData = {
			"PlayerSpawnProp", "PlayerGiveSWEP", "PlayerSpawnEffect", "PlayerSpawnNPC", "PlayerSpawnObject",
			"PlayerSpawnRagdoll", "PlayerSpawnSENT", "PlayerSpawnSWEP", "PlayerSpawnVehicle", "CanProperty",
		}

		for k, v in ipairs(funcData) do
			Arbitrage.GM[v] = permissionFunc
		end

		Arbitrage.GM.CanEditVariable = function(_, entity, client)
			return client:IsAdmin()
		end

		Arbitrage.GM.PhysgunPickup = function(_, client, entity)
			if entity.PhysgunDisabled then return false end

			if client:IsAdmin() then
				return true
			end
		end

		Arbitrage.GM.CanTool = function(_, client)
			if client:IsAdmin() then
				return true
			end
		end

		Arbitrage.util.WriteMessage("The gamemode '" .. engine.ActiveGamemode() .. "' was started!")
	end

	timer.Simple(1, function()
		local rcmd = SERVER and asterionlib.RunConsoleCommand or RunConsoleCommand

		rcmd("mp_show_voice_icons", 0)
		rcmd("sbox_godmode", 0)
		rcmd("sbox_playershurtplayers", 1)
		rcmd("sv_voiceenable", 1)
		rcmd("zoom_sensitivity_ratio", 0.5)
		rcmd("r_decals", 999)
		rcmd("mp_falldamage", 1)
	end)

	function Arbitrage.GM:Initialize() end
	function Arbitrage.GM:DoPlayerDeath() end
	function Arbitrage.GM:PlayerDeath() end
	function Arbitrage.GM:CanPlayerSuicide() return false end
	function Arbitrage.GM:AllowPlayerPickup() return false end
	function Arbitrage.GM:PlayerDeathThink() return false end
	function Arbitrage.GM:PlayerDeathSound() return true end
	function Arbitrage.GM:ShowHelp() end

	function Arbitrage.GM:PlayerNoClip(client) return client:IsAdmin() end

	function Arbitrage.GM:OnReloaded()
		if Arbitrage.plugin then
			Arbitrage.plugin.updates = false
			Arbitrage:InitializePlugins()
		end
	end

	if Arbitrage.util.IsClientSide() then
		-- net.Receive("CopiedDupe", function(len, client) end)

		-- delete sandbox shit :/
		local funcData = {
			"ScoreboardShow", "ScoreboardHide", "AddHint", "SuppressHint",
			"HUDItemPickedUp", "HUDPaint", "HUDDrawScoreBoard", "HUDPaintBackground"
		}

		for k, v in ipairs(funcData) do
			Arbitrage.GM[v] = zero
		end

		for k, v in ipairs({"EditingSpawnlistsSave", "ContextClick", "EditingSpawnlists", "OpeningContext", "Annoy2", "Annoy1", "OpeningMenu"}) do
			timer.Remove("HintSystem_" .. v)
		end

		Arbitrage.GM.HUDShouldDraw = function()
			return true
		end
	end

	Arbitrage.util.WriteMessage("BATCH has been successfully loaded!")
	hook.Run("InitializeArbitrage")
end

function Arbitrage.base.Include(fileName, realm)
	if ((realm == "server" or fileName:find("sv_")) and SERVER) then
		return include(fileName)
	elseif (realm == "shared" or fileName:find("shared.lua") or fileName:find("sh_")) then
		if (SERVER) then

			AddCSLuaFile(fileName)
		end

		return include(fileName)
	elseif (realm == "client" or fileName:find("cl_")) then
		if (SERVER) then
			AddCSLuaFile(fileName)
		else
			return include(fileName)
		end
	end

	hook.Run("IncludeFile", fileName)
end

function Arbitrage.base.IncludeDir(directory, bFromLua)
	local baseDir = "arbitrage/gamemode/framework/"

	for _, v in ipairs(file.Find((bFromLua and "" or baseDir) .. directory .. "/*.lua", "LUA")) do
		Arbitrage.base.Include(directory .. "/" .. v)
	end
end

Arbitrage.base.Include("sh_util.lua")

function Arbitrage.HookRun(data, ...)
	local ARBhook = Arbitrage[data]

	if ARBhook and isfunction(ARBhook) then
		ARBhook(...)
	end
end


Arbitrage.base.Include("sh_constants.lua")
Arbitrage.base.Include("player_arbitrage.lua", "shared")

Arbitrage.base.Include("cl_props.lua")
Arbitrage.base.Include("cl_fonts.lua")
Arbitrage.base.Include("sh_system.lua")

Arbitrage.base.IncludeDir("derma")
Arbitrage.base.IncludeDir("system")

Arbitrage.base.Include("sh_framework.lua")
Arbitrage.base.Include("cl_framework.lua")
Arbitrage.base.Include("sv_framework.lua")


Arbitrage.GamemodeCompletion = os.clock()

if Arbitrage.util.IsServerSide() then
	local time = Arbitrage.GamemodeCompletion - Arbitrage.GamemodeStart

	Arbitrage.util.WriteMessage(Color(0, 255, 0), "Arbitrage gamemode was successfully loaded for '" .. math.Round(time, 3) .. "s'. You are using version '" .. Arbitrage.version .. "'")
end




do
	hook.ArbitrageCall = hook.ArbitrageCall or hook.Call

	function hook.Call(name, gm, ...)
		local _hook = Arbitrage[name]

		if _hook and isfunction(_hook) then
			local a, b, c, d, e, f = _hook(name, ...)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		return hook.ArbitrageCall(name, gm, ...)
	end
end

do
	local think_delay = 1 * 0.125
	local next_think = 0
	local next_second = 0

	function Arbitrage.GM:Tick()
		local cur_time = CurTime()

		if cur_time >= next_think then
			local one_second_tick = (cur_time >= next_second)

			for k, v in ipairs(player.GetAll()) do
				hook.Call("PlayerThink", self, v, cur_time)

				if one_second_tick then
					hook.Call("PlayerOneSecond", self, v, cur_time)
				end
			end

			next_think = cur_time + think_delay

			if one_second_tick then
				hook.Call("OneSecond", self, cur_time)
				next_second = cur_time + 1
			end
		end
	end
end
