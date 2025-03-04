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

	client:ChatNotify("#doors_provided " .. factionData.name .. " #doors_access")
	PLUGIN:SendDoorData(nil, PLUGIN.DoorsData)
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

	client:ChatNotify("#doors_removed " .. factionData.name .. " #doors_access")
	PLUGIN:SendDoorData(nil, PLUGIN.DoorsData)
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

	client:ChatNotify("#doors_addedicon")
end)

netstream.Hook("arb.DoorRemoveIcon", function(client, entity, indx)
	if !client:IsAdmin() then return end

	if !IsValid(entity) then return end
	if !entity:IsDoor() then return end

	local data = entity:GetNetVar("arb.image", {})
	table.remove(data, indx)

	entity:SetNetVar("arb.image", data)

	client:ChatNotify("#doors_removedicon")
end)

netstream.Hook("arb.DoorSetHack", function(client)
	if !client:IsAdmin() then return end

	local trace = client:GetEyeTraceNoCursor()

	local entity = trace.Entity
	if !IsValid(entity) then return end

	if !entity:IsDoor() then return end

	local data = entity:GetNWBool("disableHack", false)
	entity:SetNWBool("disableHack", !data)

	client:ChatNotify("#doors_successfully " .. (data and "#doors_allowed" or "#doors_prohibited") .. " #doors_lockpicking")
end)

netstream.Hook("arb.DoorSetUniqueID", function(client, data)
	if !client:IsAdmin() then return end

	local trace = client:GetEyeTraceNoCursor()

	local entity = trace.Entity
	if !IsValid(entity) then return end

	if !entity:IsDoor() then return end

	entity:SetNetVar("key_uniqueid", data)

	client:ChatNotify("#doors_addeduniqueid " .. data .. "!")
end)