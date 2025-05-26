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

util.AddNetworkString("EPaint_Save")
util.AddNetworkString("EPaint_Load")
util.AddNetworkString("EPaint_Open")

EPaint.stored = EPaint.stored or {}

function EPaint:PlayerUse(client, entity)
	if !EPaint:AllowEntity(entity) then return end

	if (!client.EPaintCD or CurTime() >= client.EPaintCD) then
		local idx = entity:EntIndex()
		local array = self.stored[idx] or {}

		local compressed = self:CompressData(array)

		net.Start("EPaint_Open")
			net.WriteUInt(idx, 16)
			net.WriteString(compressed)
		net.Send(client)

		client.EPaintCD = CurTime() + 2
	end
end

function EPaint:PlayerInitialSpawnForRealz(client)
	for idx, array in pairs(self.stored) do
		netstream.Heavy(client, "EPaint:Load", idx, array)
	end
end

net.Receive("EPaint_Save", function(len, client)
	local idx = net.ReadUInt(16)
	local compressed = net.ReadString()

	local entity = Entity(idx)
	if !IsValid(entity) or !EPaint:AllowEntity(entity) then
		return
	end

	if client:GetPos():Distance(entity:GetPos()) >= 200 then
		return
	end

	local decompressed = EPaint:DecompressData(compressed)
	if #decompressed > 5000 then return end

	EPaint.stored[idx] = decompressed

	net.Start("EPaint_Load")
		net.WriteUInt(idx, 16)
		net.WriteString(compressed)
	net.Broadcast()
end)