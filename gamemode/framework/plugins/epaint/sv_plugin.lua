EPaint.stored = EPaint.stored or {}

function EPaint:PlayerUse(client, entity)
	if !EPaint:AllowEntity(entity) then return end

	if (!client.EPaintCD or CurTime() >= client.EPaintCD) then
		local idx = entity:EntIndex()
		local array = self.stored[idx] or {}

		netstream.Heavy(client, "EPaint:OpenEditor", idx, array)

		client.EPaintCD = CurTime() + 2
	end
end

function EPaint:PlayerInitialSpawnForRealz(client)
	for idx, array in pairs(self.stored) do
		netstream.Heavy(client, "EPaint:Load", idx, array)
	end
end


netstream.Hook("EPaint:Save", function(client, idx, array)
	local entity = Entity(idx)
	if !IsValid(entity) then return end

	if !EPaint:AllowEntity(entity) then return end

	local dist = client:GetPos():Distance(entity:GetPos())
	if dist >= 200 then return end

	EPaint.stored[idx] = array
	netstream.Heavy(nil, "EPaint:Load", idx, array)
end)