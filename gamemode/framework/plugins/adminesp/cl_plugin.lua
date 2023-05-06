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
local timer_Create = timer.Create
local pairs = pairs
local ents_GetAll = ents.GetAll
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

local function drawing(entity, info, eyePos)
	if !IsValid(entity) then return end

	local isPlayer = entity:IsPlayer()
	local entityPos = getPos(entity, isPlayer)

	local headPos, x, y = getScreenPos(isPlayer, entityPos)
	if !headPos.visible then return end

	local distance = eyePos:Distance(entityPos)
	local col = (isPlayer and team_GetColor(entity:Team()) or PLUGIN.entslist[entity:GetClass()]) or color_white

	local f = math_abs(350 / distance)
	local size = 52 * f

	x = (x - size / 2) + size
	y = y - size / 2

	local y2 = 0
	for _, data in ipairs(info) do
		if isfunction(data) then
			data(entity)
		end
	end

	for _, data in ipairs(info) do
		if !isfunction(data) then
			local _x, _y = draw_SimpleTextOutlined(data, "AdminESPFont", x, y + y2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
			y2 = y2 + _y
		end
	end
end

local function isAllow(client)
	if !IsValid(client) then return false end

	if !client:oldAlive() then return false end
	if !client:IsAdmin() then return false end
	if !client:IsNocliping() and !client:IsSpectating() then return false end
	if !SETTINGS.options.Get("show_admin_esp") then return false end
	if client.GetSitting and client:GetSitting() then return false end
	if Arbitrage.lawEnable then return false end

	return true
end

local showEntsList = {}
local cache = {}
local allow = false
timer_Create("AdminESP:Update", 1, 0, function()
	showEntsList = {}

	local client = LocalPlayer()
	allow = isAllow(client)

	if !allow then cache = {} return end
	for k, v in ipairs(ents_GetAll()) do
		if v:IsPlayer() or PLUGIN.entslist[v:GetClass()] then
			showEntsList[#showEntsList + 1] = v
		end
	end
end)

local function caching(entity)
	local client = LocalPlayer()

	if entity == client and !client:IsSpectating() then return end

	local isPlayer = entity:IsPlayer()
	if !isPlayer and !PLUGIN.entslist[entity:GetClass()] then return end

	if !isPlayer or (isPlayer and entity:oldAlive()) then
		cache[entity] = {}

		local eyePos = EyePos()
		local entityPos = getPos(entity, isPlayer)

		local headPos = getScreenPos(isPlayer, entityPos)
		if !headPos.visible then return end

		for k, v in pairs(entity:ESPInfo()) do
			if !v[1] then continue end
			if !PLUGIN:DistanceFits(eyePos, entityPos, v[2]) then continue end

			cache[entity][#cache[entity] + 1] = v[1]
		end
	end
end

local function thread()
	local showEnts

	while true do
		showEnts = showEntsList

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
