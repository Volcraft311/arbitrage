--- Returns a cached copy of the given material, or creates and caches one if it doesn't exist. This is a quick helper function
-- if you aren't locally storing a `Material()` call.
-- @realm shared
-- @string materialPath Path to the material
-- @treturn[1] material The cached material
-- @treturn[2] nil If the material doesn't exist in the filesystem
function Arbitrage.GetMaterial(materialPath)
	-- Cache the material.
	Arbitrage.cachedMaterials = Arbitrage.cachedMaterials or {}
	Arbitrage.cachedMaterials[materialPath] = Arbitrage.cachedMaterials[materialPath] or Material(materialPath)

	return Arbitrage.cachedMaterials[materialPath]
end



oldMaterial = oldMaterial or Material
function Material(...)
	local data = {...}

	local cache = data[1]
	if cache and Arbitrage.cachedMaterials[cache] and type(Arbitrage.cachedMaterials[cache]) == "IMaterial" then
		return Arbitrage.cachedMaterials[cache]
	end

	return oldMaterial(...)
end