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

local PLUGIN = PLUGIN

function PLUGIN:SendDoorData(client, data)
	netstream.Start(client, "arb.DoorGetData", data)
end

function PLUGIN:LoadData()
	local data = {} -- self:GetData()

	if !data then return end

	for k, v in pairs(data) do
		local entity = ents.GetMapCreatedEntity(k)

		if (IsValid(entity) and (entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_door_rotating")) then
			for k2, v2 in pairs(v) do
				entity[k2] = v2

				data[k].indexDoor = entity:EntIndex()
			end
		end
	end

	self.DoorsData = data

	for k, v in pairs(player.GetAll()) do
		self:SendDoorData(v, data)
	end
end

local initData = {
	["drp_hopespeak"] = {
		[3460] = true,
		[2750] = true,
		[2748] = true,
		[2746] = true,
		[2744] = true,
		[2725] = true,
		[2727] = true,
		[2728] = true,
		[2730] = true,
		[2733] = true,
		[2732] = true,
		[2735] = true,
		[2736] = true,
		[2738] = true,
		[2740] = true,
		[2742] = true
	}
}

function PLUGIN:InitPlayersDoor()
	if !Arbitrage.plugin.list then return end
	if !Arbitrage.plugin.list.doors then return end

	local doorsEntity = {}
	for _, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "func_door_rotating" and initData[game.GetMap()][v:MapCreationID()] then
			doorsEntity[#doorsEntity + 1] = v
		end
	end

	local db = Arbitrage.plugin.list.doors.DoorsData or {}
	local num = 1
	for k, v in pairs(player.GetAll()) do
		if v:IsPlaying() and num <= 16 then
			local entity = doorsEntity[num]
			if !IsValid(entity) then continue end

			db[entity:MapCreationID()] = db[entity:MapCreationID()] or {}
			db[entity:MapCreationID()].arbOwnerID = db[entity:MapCreationID()].arbOwnerID or {}
			db[entity:MapCreationID()].arbOwnerID[v:SteamID()] = v:Name()
			db[entity:MapCreationID()].indexDoor = entity:EntIndex()

			entity:SetNetVar("arb.team", v:Team())

			entity:Fire("close")
			entity:Fire("lock")

			num = num + 1
		end
	end

	for k, v in pairs(player.GetAll()) do
		self:SendDoorData(v, self.DoorsData)
	end
end

function Arbitrage:InitDoors()
	PLUGIN:InitPlayersDoor()
end

netstream.Hook("arb.DoorAddOwner", function(client, data)
	if !data then return end

	local trace = client:GetEyeTraceNoCursor()
	local entity = trace.Entity

	if !client:IsAdmin() then return end

	if IsValid(entity) and (entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_door_rotating") then
		local db = Arbitrage.plugin.list.doors.DoorsData or {}
		db[entity:MapCreationID()] = db[entity:MapCreationID()] or {}

		db[entity:MapCreationID()].arbOwnerID = db[entity:MapCreationID()].arbOwnerID or {}
		db[entity:MapCreationID()].arbOwnerID[data[1]] = data[2]
		db[entity:MapCreationID()].indexDoor = entity:EntIndex()

		for k, v in pairs(player.GetAll()) do
			PLUGIN:SendDoorData(v, PLUGIN.DoorsData)
		end
	end
end)

netstream.Hook("arb.DoorRemoveOwner", function(client, data)
	if !data then return end

	local trace = client:GetEyeTraceNoCursor()
	local entity = trace.Entity

	if !client:IsAdmin() then return end

	if IsValid(entity) and (entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_door_rotating") then
		local db = Arbitrage.plugin.list.doors.DoorsData or {}
		db[entity:MapCreationID()] = db[entity:MapCreationID()] or {}

		db[entity:MapCreationID()].arbOwnerID = db[entity:MapCreationID()].arbOwnerID or {}
		db[entity:MapCreationID()].arbOwnerID[data] = nil
		db[entity:MapCreationID()].indexDoor = entity:EntIndex()

		for k, v in pairs(player.GetAll()) do
			PLUGIN:SendDoorData(v, PLUGIN.DoorsData)
		end
	end
end)

netstream.Hook("arb.DoorGetData", function(client)
	PLUGIN:SendDoorData(client, PLUGIN.DoorsData)
end)

netstream.Hook("arb.DoorSetIcon", function(client, data)
	if !data then return end

	local trace = client:GetEyeTraceNoCursor()
	local door = trace.Entity

	if !client:IsAdmin() then return end

	if IsValid(door) and (door:GetClass() == "prop_door_rotating" or door:GetClass() == "func_door_rotating") then
		door:SetNetVar("arb.team", data > 0 and data or nil)
	end
end)