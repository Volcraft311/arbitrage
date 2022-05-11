local PLUGIN = PLUGIN

function PLUGIN:EntityTakeDamage(entity)
	if !entity:IsNPC() then return end

	entity:SetKeyValue("spawnflags", "8192")
end