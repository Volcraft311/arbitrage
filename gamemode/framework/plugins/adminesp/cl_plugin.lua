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

-- Localize Global Calls
local surface_CreateFont = surface.CreateFont
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local IsValid = IsValid
local pairs = pairs
local ipairs = ipairs
local Vector = Vector
local math_abs = math.abs
local team_GetColor = team.GetColor
local isfunction = isfunction
local EyePos = EyePos
local next = next
local coroutine_yield = coroutine.yield
local coroutine_resume = coroutine.resume
local coroutine_create = coroutine.create
local Color = Color
local Material = Material
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect

surface_CreateFont( "AdminESPFont", {
	font = "Roboto",
	size = 17,
	extended = true,
	weight = 100,
})

local function getScreenPos(isPlayer, pos)
	local head = Vector(pos.x, pos.y, isPlayer and pos.z + 60 or pos.z)
	local headPos = head:ToScreen()
	local x, y = headPos.x, headPos.y

	return headPos, x, y
end

local function getPos(entity, isPlayer)
	local pos = entity:GetPos()

	return isPlayer and (entity:IsDormant() and entity:GetNetVar("esp.position", pos)) or pos
end

local iconSize = 15
local function drawing(entity, info, eyePos)
	if !IsValid(entity) then return end

	local isPlayer = entity:IsPlayer()
	local entityPos = getPos(entity, isPlayer)

	local headPos, x, y = getScreenPos(isPlayer, entityPos)
	if !headPos.visible then return end

	local distance = eyePos:Distance(entityPos)
	local col = (isPlayer and team_GetColor(entity:Team()) or PLUGIN.entslist[entity:GetClass()][1]) or color_white

	local f = math_abs(350 / distance)
	local size = 52 * f

	x = (x - size / 2) + size
	y = y - size / 2

	local y2 = 0
	for _, data in ipairs(info) do
		if isfunction(data) then
			data(entity)
		elseif isstring(data) then
		    local _x, _y = draw_SimpleTextOutlined(data, "AdminESPFont", x, y + y2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			y2 = y2 + _y
		end
	end

	if isPlayer then
		for k, v in ipairs(entity:GetTemporaryStatusEffects()) do
			local uniqueID = v.uniqueID
	    	local status = Medical.t_status_effects[uniqueID]

	    	local material = Material(status.icon or "err.png")

	    	surface_SetDrawColor(255, 255, 255)
	    	surface_SetMaterial(material)
	    	surface_DrawTexturedRect(x + (k * iconSize - iconSize), y - iconSize, iconSize, iconSize)
		end
	end
end

local function isAllow(client)
	if !IsValid(client) then return false end

	if client:IsSpectating() then return true end

	if Arbitrage.lawEnable then return false end
	if !SETTINGS.options.Get("show_admin_esp") then return false end
	if !client:oldAlive() then return false end
	if !client:IsAdmin() then return false end
	if !client:IsNocliping() then return false end
	if client.GetSitting and client:GetSitting() then return false end
	if client:InVehicle() then return false end

	return true
end

local allow = false
local cache = {}
asterionlib.entscollector:AddTrack("adminesp", {
	delay_apply = 1,
	onCanTrack = function(entity)
		local object = PLUGIN.entslist[entity:GetClass()]

		if entity:IsPlayer() or object then
			local func = object and object[2]
			if func then
				local bAllow = func(entity)

				if bAllow == false then
					return false
				end
			end

		    return true
		end
	end,
	onCanApply = function(entity)
	    -- вообще это не должно тут находиться... но... okeeey...
	    local client = LocalPlayer()
	    if IsValid(client) then
	    	allow = isAllow(client)
	    end

	    if !allow then
	        cache = {}
	    end

	    return false -- мы не пользуемся :GetApply() в данном случае, по этому не засоряем оперативку лишним мусором
	end
})

local function caching(entity)
	local client = LocalPlayer()

	if entity == client and !client:IsSpectating() then return end

	local isPlayer = entity:IsPlayer()
	if isPlayer and !entity:oldAlive() then return end

	cache[entity] = {}

	local eyePos = EyePos()
	local entityPos = getPos(entity, isPlayer)

	local headPos = getScreenPos(isPlayer, entityPos)
	if !headPos.visible then return end

	for k, v in ipairs(entity:ESPInfo()) do
		if !v[1] then continue end
		if !PLUGIN:DistanceFits(eyePos, entityPos, v[2]) then continue end

		cache[entity][#cache[entity] + 1] = v[1]
	end
end

local function thread()
	local showEnts

	while true do
		showEnts = asterionlib.entscollector:GetAll("adminesp")

		if !next(showEnts) then
			coroutine_yield()
		else
			for _, entity in ipairs(showEnts) do
				coroutine_yield()

				if !IsValid(entity) then
					cache[entity] = nil
					continue
				end

				caching(entity)
			end
		end
	end
end

local co
function PLUGIN:Think()
	if !allow then return end

	if !co or !coroutine_resume(co) then
		co = coroutine_create(thread)
		coroutine_resume(co)
	end
end

function PLUGIN:HUDPaint()
	if !allow then return end

	local eyePos = EyePos()
	for entity, info in pairs(cache) do
		drawing(entity, info, eyePos)
	end

	local client = LocalPlayer()
	if client:IsSpectating() then
		self:SpectatePaint()
	end
end