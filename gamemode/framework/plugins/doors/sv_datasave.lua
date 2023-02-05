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

local PLUGIN = PLUGIN

function PLUGIN:SendDoorData(client, data)
	netstream.Start(client, "arb.DoorGetData", data)
end

function PLUGIN:LoadData()
	local data = {} -- self:GetData()

	if !data then return end

	for k, v in pairs(data) do
		local entity = ents.GetMapCreatedEntity(k)

		if IsValid(entity) and entity:IsDoor() then
			for k2, v2 in pairs(v) do
				entity[k2] = v2

				data[k].idx = entity:EntIndex()
			end
		end
	end

	self.DoorsData = data

	for k, v in pairs(player.GetAll()) do
		self:SendDoorData(v, data)
	end
end

local initData = {
	asterion_hopespeak_prerelease = {
		[1373] = true,
		[1608] = true,
		[2749] = true,
		[2770] = true,
		[2288] = true,
		[2496] = true,
		[2696] = true,
		[2386] = true,
		[2078] = true,
		[2739] = true,
		[2081] = true,
		[2116] = true,
		[1260] = true,
		[2315] = true,
		[2057] = true,
		[2374] = true
	}
}

function PLUGIN:InitPlayersDoor()
	if !Arbitrage.plugin.list then return end
	if !Arbitrage.plugin.list.doors then return end

	local map = game.GetMap()

	local doorsEntity = {}
	for _, v in ipairs(ents.GetAll()) do
		if v:IsDoor() and initData[map][v:MapCreationID()] then
			doorsEntity[#doorsEntity + 1] = v
		end
	end

	local db = Arbitrage.plugin.list.doors.DoorsData or {}
	local num = 1
	for k, v in pairs(Arbitrage.players) do
		local client = v.client

		if IsValid(client) and client:IsPlaying() and num <= table.Count(initData[map]) and !client:IsHost() then
			local entity = doorsEntity[num]
			if !IsValid(entity) then continue end

			local id = entity:MapCreationID()
			local faction = client:Team()

			db[id] = db[id] or {}
			db[id].list = db[id].list or {}
			db[id].list[faction] = true
			db[id].idx = entity:EntIndex()

			entity:SetNetVar("arb.image", {faction})
			entity:Fire("close")
			entity:Fire("lock")
			entity:SetNWBool("Locked", true)
			entity:SetNWBool("disableHack", true)

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

netstream.Hook("arb.DoorAddOwner", function(client, faction)
	if !client:IsAdmin() then return end
	if !faction then return end

	local factionData = Character.team:GetByID(faction)
	if !factionData then return end

	local trace = client:GetEyeTraceNoCursor()

	local entity = trace.Entity
	if !IsValid(entity) then return end

	if !entity:IsDoor() then return end

	local id = entity:MapCreationID()
	local db = Arbitrage.plugin.list.doors.DoorsData or {}

	db[id] = db[id] or {}
	db[id].list = db[id].list or {}
	db[id].list[faction] = true
	db[id].idx = entity:EntIndex()

	Arbitrage.commands.Notify(client, "Вы успешно дали " .. factionData.name .. " доступ к двери!")

	for k, v in pairs(player.GetAll()) do
		PLUGIN:SendDoorData(v, PLUGIN.DoorsData)
	end
end)

netstream.Hook("arb.DoorRemoveOwner", function(client, faction)
	if !client:IsAdmin() then return end
	if !faction then return end

	local factionData = Character.team:GetByID(faction)
	if !factionData then return end

	local trace = client:GetEyeTraceNoCursor()

	local entity = trace.Entity
	if !IsValid(entity) then return end

	if !entity:IsDoor() then return end

	local id = entity:MapCreationID()
	local db = Arbitrage.plugin.list.doors.DoorsData or {}

	db[id] = db[id] or {}
	db[id].list = db[id].list or {}
	db[id].list[faction] = nil
	db[id].idx = entity:EntIndex()

	Arbitrage.commands.Notify(client, "Вы успешно убрали у " .. factionData.name .. " доступ к двери!")

	for k, v in pairs(player.GetAll()) do
		PLUGIN:SendDoorData(v, PLUGIN.DoorsData)
	end
end)

netstream.Hook("arb.DoorGetData", function(client)
	PLUGIN:SendDoorData(client, PLUGIN.DoorsData)
end)

netstream.Hook("arb.DoorAddIcon", function(client, entity, id)
	if !client:IsAdmin() then return end
	if !id then return end

	local faction = Character.team:GetByID(id)
	if !faction then return end
	if !faction:GetAssets().pixel then return end

	if !IsValid(entity) then return end
	if !entity:IsDoor() then return end

	local data = entity:GetNetVar("arb.image", {})
	table.insert(data, id)

	entity:SetNetVar("arb.image", data)

	Arbitrage.commands.Notify(client, "Вы успешно добавили новую иконку к двери!")
end)

netstream.Hook("arb.DoorRemoveIcon", function(client, entity, indx)
	if !client:IsAdmin() then return end

	if !IsValid(entity) then return end
	if !entity:IsDoor() then return end

	local data = entity:GetNetVar("arb.image", {})
	table.remove(data, indx)

	entity:SetNetVar("arb.image", data)

	Arbitrage.commands.Notify(client, "Вы успешно удалили иконку у двери!")
end)

netstream.Hook("arb.DoorSetHack", function(client)
	if !client:IsAdmin() then return end

	local trace = client:GetEyeTraceNoCursor()

	local entity = trace.Entity
	if !IsValid(entity) then return end

	if !entity:IsDoor() then return end

	local data = entity:GetNWBool("disableHack", false)
	entity:SetNWBool("disableHack", !data)

	Arbitrage.commands.Notify(client, "Вы успешно " .. (data and "разрешили" or "запретили") .. " взламывать двеь!")
end)