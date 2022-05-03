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

Arbitrage.persistent = Arbitrage.library.Add("persistent")

Arbitrage.persistent.ragdolls = Arbitrage.persistent.ragdolls or {}
Arbitrage.persistent.HitGroupsName = {
	[HITGROUP_HEAD] = "head",
	[HITGROUP_CHEST] = "chest",
	[HITGROUP_GENERIC] = "chest",
	[HITGROUP_STOMACH] = "stomach",
	[HITGROUP_LEFTARM] = "left_hand",
	[HITGROUP_RIGHTARM] = "right_hand",
	[HITGROUP_LEFTLEG] = "left_leg",
	[HITGROUP_RIGHTLEG] = "right_leg",
}

function Arbitrage.persistent.PlaceDecal(client, ent, data)
	if (!IsValid(ent) and !ent:IsWorld()) then return end

	local bone
	if ( data.bone and data.bone < ent:GetPhysicsObjectCount() ) then
		bone = ent:GetPhysicsObjectNum( data.bone )
	end

	if (!IsValid(bone)) then
		bone = ent:GetPhysicsObject()
	end

	if (!IsValid(bone)) then
		bone = ent
	end

	util.Decal(data.decal, bone:LocalToWorld( data.Pos1 ), bone:LocalToWorld(data.Pos2), client)

	local i = ent.DecalCount or 0
	i = i + 1
	duplicator.StoreEntityModifier( ent, "decal" .. i, data )
	ent.DecalCount = i
end

function Arbitrage.persistent.ReturnRagdollInfo(entity)
	local info = {
		["head"] = {},
		["chest"] = {},
		["stomach"] = {},
		["left_hand"] = {},
		["right_hand"] = {},
		["left_leg"] = {},
		["right_leg"] = {},
		["time"] = {},
	}

	local damage = entity.info

	if damage then
		local all_damage = damage.info.evidence[1]
		local last_damage = all_damage[#all_damage]

		local hitgroups = {}
		for k, v in pairs(all_damage) do
			local _wep = v.type
			local _type = v.hitgroup

			hitgroups[_type] = hitgroups[_type] or {}
			hitgroups[_type][_wep] = hitgroups[_type][_wep] or 0

			hitgroups[_type][_wep] = hitgroups[_type][_wep] + 1
		end

		for k, v in pairs(hitgroups) do
			for k2, v2 in pairs(v) do
				info[k][#info[k] + 1] = tostring(k2 .. " (x" .. v2 .. ")")
			end
		end

		info["name"] = tostring(damage.info.name)
		info["last_damage"] = tostring(last_damage and last_damage.type or "Неизвестно")
		info["last_damage2"] = tostring(last_damage and last_damage.hitgroup or "Неизвестно")
		info["time"] = damage.info.time

		if damage.info.fracture then
			info["last_damage"] = "Множественные переломы"
		end
	else
		return nil
	end

	return info, damage
end

function Arbitrage.persistent.ReturnRagdoll(client)
	local data = {}
	data.start = client:GetShootPos()
	data.endpos = data.start + client:GetAimVector() * 84
	data.filter = {client}

	local trace = util.TraceLine(data)
	local entity = trace.Entity

	if IsValid(entity) and entity:GetClass() == "prop_ragdoll" then
		return entity
	end
end