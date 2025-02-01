Arbitrage.plugin = Arbitrage.library.Add("plugin")
Arbitrage.plugin.list = Arbitrage.plugin.list or {}
Arbitrage.plugin.unloaded = Arbitrage.plugin.unloaded or {}
Arbitrage.hookscache = {}

function Arbitrage.plugin.Load(uniqueID, path, isSingleFile, variable)
	variable = variable or "PLUGIN"

	local oldPlugin = PLUGIN
	local PLUGIN = {
		folder = path,
		plugin = oldPlugin,
		uniqueID = uniqueID,
		name = "Unknown",
	}

	if Arbitrage.plugin.list[uniqueID] then
		PLUGIN = Arbitrage.plugin.list[uniqueID]
	end

	_G[variable] = PLUGIN
	PLUGIN.loading = true

	if !isSingleFile then
		Arbitrage.base.IncludeDir(path .. "/libs", true)
		Arbitrage.base.IncludeDir(path .. "/derma", true)
	end

	Arbitrage.base.Include(isSingleFile and path or path .. "/sh_" .. variable:lower() .. ".lua", "shared")
	PLUGIN.loading = false

	local uniqueID2 = uniqueID

	function PLUGIN:SetData(value)
		asterionlib.data:Set(uniqueID2, value)
	end

	function PLUGIN:GetData(default)
		return asterionlib.data:Get(uniqueID2, default) or {}
	end

	PLUGIN.name = PLUGIN.name or "Unknown"

	for k, v in pairs(PLUGIN) do
		if isfunction(v) then
			Arbitrage.hookscache[k] = Arbitrage.hookscache[k] or {}
			Arbitrage.hookscache[k][PLUGIN] = v
		end
	end

	Arbitrage.plugin.list[uniqueID] = PLUGIN
	_G[variable] = nil

	if PLUGIN.OnLoaded then
		PLUGIN:OnLoaded()
	end
end

function Arbitrage:LoadFromDir(directory)
	local files, folders = file.Find(directory .. "/*", "LUA")

	for _, v in ipairs(folders) do
		Arbitrage.plugin.Load(v, directory .. "/" .. v)
	end

	for _, v in ipairs(files) do
		Arbitrage.plugin.Load(string.StripExtension(v), directory .. "/" .. v, true)
	end
end

function Arbitrage:InitializePlugins()
	if !Arbitrage.plugin.updates then
		Arbitrage:LoadFromDir("arbitrage/gamemode/framework/plugins")
		Arbitrage.plugin.updates = true
	end
end

Arbitrage:InitializePlugins()

do
	hook.pluginCall = hook.pluginCall or hook.Call

	function hook.Call(name, gm, ...)
		local cache = Arbitrage.hookscache[name]

		if (cache) then
			for k, v in pairs(cache) do
				local a, b, c, d, e, f = v(k, ...)

				if (a != nil) then
					return a, b, c, d, e, f
				end
			end
		end

		return hook.pluginCall(name, gm, ...)
	end
end