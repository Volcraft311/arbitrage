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

	if (Arbitrage.plugin.list[uniqueID]) then
		PLUGIN = Arbitrage.plugin.list[uniqueID]
	end

	_G[variable] = PLUGIN
	PLUGIN.loading = true

	if (!isSingleFile) then
		Arbitrage.base.IncludeDir(path.."/libs", true)
		Arbitrage.base.IncludeDir(path.."/derma", true)
		Arbitrage.plugin.LoadEntities(path .. "/entities")
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
	PLUGIN.description = PLUGIN.description or "No description available."

	for k, v in pairs(PLUGIN) do
		if (isfunction(v)) then
			Arbitrage.hookscache[k] = Arbitrage.hookscache[k] or {}
			Arbitrage.hookscache[k][PLUGIN] = v
		end
	end

	Arbitrage.plugin.list[uniqueID] = PLUGIN
	_G[variable] = nil

	if (PLUGIN.OnLoaded) then
		PLUGIN:OnLoaded()
	end
end

function Arbitrage.plugin.LoadEntities(path)
	local bLoadedTools
	local files, folders

	local function IncludeFiles(path2, bClientOnly)
		if (SERVER and !bClientOnly) then
			if (file.Exists(path2 .. "init.lua", "LUA")) then
				Arbitrage.base.Include(path2 .. "init.lua", "server")
			elseif (file.Exists(path2 .. "shared.lua", "LUA")) then
				Arbitrage.base.Include(path2 .. "shared.lua")
			end

			if (file.Exists(path2 .. "cl_init.lua", "LUA")) then
				Arbitrage.base.Include(path2 .. "cl_init.lua", "client")
			end
		elseif (file.Exists(path2 .. "cl_init.lua", "LUA")) then
			Arbitrage.base.Include(path2 .. "cl_init.lua", "client")
		elseif (file.Exists(path2 .. "shared.lua", "LUA")) then
			Arbitrage.base.Include(path2 .. "shared.lua")
		end
	end

	local function HandleEntityInclusion(folder, variable, register, default, clientOnly, create, complete)
		files, folders = file.Find(path .. "/" .. folder .. "/*", "LUA")
		default = default or {}

		for _, v in ipairs(folders) do
			local path2 = path .. "/" .. folder .. "/" .. v .. "/"
			v = Arbitrage.util.StripRealmPrefix(v)

			_G[variable] = table.Copy(default)

			if (!isfunction(create)) then
				_G[variable].ClassName = v
			else
				create(v)
			end

			IncludeFiles(path2, clientOnly)

			if (clientOnly) then
				if (CLIENT) then
					register(_G[variable], v)
				end
			else
				register(_G[variable], v)
			end

			if (isfunction(complete)) then
				complete(_G[variable])
			end

			_G[variable] = nil
		end

		for _, v in ipairs(files) do
			local niceName = Arbitrage.util.StripRealmPrefix(string.StripExtension(v))

			_G[variable] = table.Copy(default)

			if (!isfunction(create)) then
				_G[variable].ClassName = niceName
			else
				create(niceName)
			end

			Arbitrage.base.Include(path.."/"..folder.."/"..v, clientOnly and "client" or "shared")

			if (clientOnly) then
				if (CLIENT) then
					register(_G[variable], niceName)
				end
			else
				register(_G[variable], niceName)
			end

			if (isfunction(complete)) then
				complete(_G[variable])
			end

			_G[variable] = nil
		end
	end

	local function RegisterTool(tool, className)
		local gmodTool = weapons.GetStored("gmod_tool")

		if (className:sub(1, 3) == "sh_") then
			className = className:sub(4)
		end

		if (gmodTool) then
			gmodTool.Tool[className] = tool
		else
			ErrorNoHalt(string.format("attempted to register tool '%s' with invalid gmod_tool weapon", className))
		end

		bLoadedTools = true
	end

	HandleEntityInclusion("entities", "ENT", scripted_ents.Register, {
		Type = "anim",
		Base = "base_gmodentity",
		Spawnable = true
	}, false, nil, function(ent)
	end)

	HandleEntityInclusion("weapons", "SWEP", weapons.Register, {
		Primary = {},
		Secondary = {},
		Base = "weapon_base"
	})

	HandleEntityInclusion("effects", "EFFECT", effects and effects.Register, nil, true)

	if (CLIENT and bLoadedTools) then
		RunConsoleCommand("spawnmenu_reload")
	end
end

function Arbitrage:LoadFromDir(directory)
	local files, folders = file.Find(directory.."/*", "LUA")

	for _, v in ipairs(folders) do
		Arbitrage.plugin.Load(v, directory.."/"..v)
	end

	for _, v in ipairs(files) do
		Arbitrage.plugin.Load(string.StripExtension(v), directory.."/"..v, true)
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