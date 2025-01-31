--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

function PLUGIN:OpenMenu(client)
	local data = asterionlib.data:Get("whitelist", {}, true)

	asterionlib.netgui:Create(client, "Whitelist:Menu", nil, "SetData", data)
end


function PLUGIN:CheckPassword(steamID64)
	local steamid = util.SteamIDFrom64(steamID64)
	local data = asterionlib.data:Get("whitelist", {}, true)

	if !data[steamid] and !self:IsPublic() then
		local bSucc = hook.Run("OnCheckPassword", steamid)
		if bSucc == true then
			return true
		end

		return false, "У вас нет доступа к серверу! Если вы записаны на игру, то обратитесь к игровому мастеру проводившему игру.\n\nПодробная информация: https://asterion.games/academy"
	end
end

function PLUGIN:InitPostEntity()
	local data = asterionlib.data:Get("whitelist", {}, true)
	local isChange = false

	for k, v in pairs(data) do
		if v[1] == 0 then continue end

		if v[1] - os.time() < 0 then
			isChange = true
			data[k] = nil
		end
	end

	if isChange then
		asterionlib.data:Set("whitelist", data)
	end
end

hook("OnStaticRankLoaded", function(info)
	local data = asterionlib.data:Get("whitelist", {}, true)

	for id in pairs(info) do
		local steamid, bValid = util.SteamIDFormatFixed(id)
		if !bValid then continue end

		data[steamid] = {
			0,
			os.time(),
			true,
			"Storage Auto-Whitelist"
		}
	end

	asterionlib.data:Set("whitelist", data)
end)


netstream.Hook("Whitelist:Add", function(client, id, time)
	if !client:IsAdmin() then return end

	local steamid, bValid = util.SteamIDFormatFixed(id)
	if !bValid then return end

	local newtime = os.time() + time
	if time <= 0 then
		newtime = 0
	end

	local data = asterionlib.data:Get("whitelist", {}, true)
	if data[steamid] and data[steamid][3] == true then return end

	data[steamid] = {
		newtime,
		os.time(),
		false,
		client:SteamName() .. " (" .. client:SteamID() .. ")"
	}

	asterionlib.data:Set("whitelist", data)
	Arbitrage.adminnotify:SendNotify("addwhitelist", client:FullName(), steamid)
	PLUGIN:OpenMenu(client)
end)

concommand.Add("whitelist_add", function(client, cmd, args)
	if IsValid(client) then return end

	local steamid = util.SteamIDFrom64(args[1])
	if !string.find(steamid, "STEAM_(%d+):(%d+):(%d+)") then return end

	local data = asterionlib.data:Get("whitelist", {}, true)
	data[steamid] = {
		0,
		os.time(),
		false,
		"Console"
	}

	asterionlib.data:Set("whitelist", data)
	print("Add " .. steamid)
end)

netstream.Hook("Whitelist:Remove", function(client, array)
	if !client:IsAdmin() then return end

	local data = asterionlib.data:Get("whitelist", {}, true)

	local str = "("
	local i = 1
	local count = table.Count(array)
	for steamid in pairs(array) do
		data[steamid] = nil

		str = str .. steamid

		if i < count then
			str = str .. ", "
		end

		i = i + 1
	end
	str = str .. ")"

	Arbitrage.adminnotify:SendNotify("removewhitelist", client:FullName(), str)

	asterionlib.data:Set("whitelist", data)
	PLUGIN:OpenMenu(client)
end)

netstream.Hook("Whitelist:Protect", function(client, steamid)
	if !client:IsSuperAdmin() then return end

	local data = asterionlib.data:Get("whitelist", {}, true)
	if !data[steamid] then return end

	data[steamid][3] = !data[steamid][3]
	asterionlib.data:Set("whitelist", data)
end)

netstream.Hook("Whitelist:ChangePrivate", function(client)
	if !client:IsAdmin() then return end

	SetNetVar("Whitelist:Public", !PLUGIN:IsPublic())
end)