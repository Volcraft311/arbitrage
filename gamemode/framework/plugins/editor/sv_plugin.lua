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


local PLUGIN = PLUGIN

local propertyList = {
	camPos = function(data, info)
		local vec, ang = data[1], data[2]
		info = {vec, ang}

		return info
	end,
	camPosEnd = function(data, info)
		local vec = data[1]
		info = vec

		return info
	end,
	placesList = function(data, info)
		local id, vec, ang = data[1], data[2], data[3]
		info[id] = {vec, ang}

		return info
	end,
	spawnList = function(data, info)
		local id, vec = data[1], data[2]
		info[id] = vec

		return info
	end,
	lobbyList = function(data, info)
		local id, vec = data[1], data[2]
		info[id] = vec

		return info
	end,
	camPosPlaces = function(data, info)
		local id, vec = data[1], data[2]
		info[id] = vec

		return info
	end,
}

local function clearTable(data)
	if istable(data) then
		if table.Count(data) <= 0 then
			return nil
		else
			for k, v in pairs(data) do
				data[k] = clearTable(v)
			end
		end
	end

	return data
end

function PLUGIN:PlayerInitialSpawn(client)
	netstream.Start(client, "Editor:SetVariables", Editor.stored)
end

netstream.Hook("Editor:ChangeProperty", function(client, id, data)
	if !client:IsAdmin() then return end

	local info = Editor.stored
	info[id] = info[id] or {}
	if propertyList[id] then
		if data == nil then
			info[id] = nil
		else
			local property = propertyList[id](data, info[id])

			if property then
				info[id] = property
				info = clearTable(info)

				Editor.stored = info
			end
		end

		Arbitrage.commands.Notify(client, "Вы успешно добавили изменения в \"" .. id .. "\".")
		Arbitrage:ReplaceVariables()
		netstream.Start(nil, "Editor:SetVariables", info)
	end
end)