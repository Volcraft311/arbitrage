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

	local map = game.GetMap()

	local doorsEntity = {}
	for _, v in ipairs(ents.GetAll()) do
		if v:IsDoor() and initData[map][v:MapCreationID()] then
			doorsEntity[#doorsEntity + 1] = v
		end
	end

	local db = Arbitrage.plugin.list.doors.DoorsData or {}
	local num = 1
	for k, v in pairs(player.GetAll()) do
		if v:IsPlaying() and num <= table.Count(initData[map]) then
			local entity = doorsEntity[num]
			if !IsValid(entity) then continue end

			local id = entity:MapCreationID()
			local faction = v:Team()

			db[id] = db[id] or {}
			db[id].list = db[id].list or {}
			db[id].list[faction] = true
			db[id].idx = entity:EntIndex()

			local data = entity:GetNetVar("arb.image", {})
			table.insert(data, v:Team())

			entity:SetNetVar("arb.image", data)

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

	local factionData = Arbitrage.teams.Get(faction)
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

	local factionData = Arbitrage.teams.Get(faction)
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

	local faction = Arbitrage.teams.Get(id)
	if !faction then return end
	if !faction.pixel then return end

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