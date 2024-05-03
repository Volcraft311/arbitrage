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

-- Localize Global Calls
local timer_Create = timer.Create
local IsValid = IsValid
local ipairs = ipairs
local H = H
local table_Count = table.Count
local math_abs = math.abs
local math_sin = math.sin
local RealTime = RealTime
local pairs = pairs
local Material = Material
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

local cache = {}
timer_Create("Medical:UpdateStatus", 0.1, 0, function()
	local client = LocalPlayer()
	if !IsValid(client) then return end

	local t_status_effects = client:GetTemporaryStatusEffects()
	cache = t_status_effects
end)

local function run(hook_name, ...)
	local client = LocalPlayer()

	for _, array in ipairs(cache) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks[hook_name]
		if !_hook then continue end

		local stored = Medical:TemporaryStatusEffectsStored(client, uniqueID)
		if !stored then continue end

		local values = Medical:TemporaryStatusEffectsValues(uniqueID)

		_hook(stored, values, ...)
	end
end

function Medical:RenderScreenspaceEffects(...)
	run("RenderScreenspaceEffects", ...)
end

local x, y, size, padding = 30, 100, H(25), H(5)
function Medical:HUDPaint(...)
	-- run("HUDPaint", ...) -- пока что не использовались хуки HUDPaint, по этому в комментарии

	if table_Count(self.ui_effects) <= 0 then return end
	local alpha = math_abs(math_sin(RealTime() * 3)) * 255
	local client = LocalPlayer()

	local i = 1
	for uniqueID in pairs(self.ui_effects) do
		if !client:HasTemporaryStatusEffect(uniqueID) then continue end

		local info = Medical.t_status_effects[uniqueID]
		local material = Material(info.icon or "err.png")

		surface_SetDrawColor(255, 255, 255, alpha)
		surface_SetMaterial(material)
		surface_DrawTexturedRect(x * i + padding * i - padding, y, size, size)

		i = i + 1
	end
end