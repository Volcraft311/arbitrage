--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local surface_CreateFont = surface.CreateFont
local draw_SimpleText = draw.SimpleText
local IsValid = IsValid
local timer_Create = timer.Create
local LocalPlayer = LocalPlayer
local pairs = pairs
local ents_GetAll = ents.GetAll
local ipairs = ipairs
local Vector = Vector
local math_abs = math.abs
local team_GetColor = team.GetColor
local tostring = tostring

surface_CreateFont( "AdminESPFont", {
	font = "Roboto",
	size = 17,
	extended = true,
	weight = 100,
} )

local function createText(data, x, y, col, y2)
	draw_SimpleText(data, "AdminESPFont", x, y + y2, col, TEXT_ALIGN_LEFT)
end

local function isAllow(client)
	if !IsValid(client) then return false end

	if !client:oldAlive() then return false end
	if !client:IsAdmin() then return false end
	if !client:IsNocliping() and !Arbitrage:IsDeveloping() then return false end
	if !SETTINGS.options.Get("show_admin_esp") then return false end
	if client.GetSitting and client:GetSitting() then return false end
	if Arbitrage.lawEnable then return false end

	return true
end

PLUGIN.showEntsList = {}

timer_Create("AdminESP:Update", 1, 0, function()
	PLUGIN.showEntsList = {}

	local client = LocalPlayer()
	local allow = isAllow(client)

	if !allow then return end

	for k, v in pairs(ents_GetAll()) do
		if v:IsPlayer() then
			PLUGIN.showEntsList[#PLUGIN.showEntsList + 1] = v
		elseif PLUGIN.entslist[v:GetClass()] then
			PLUGIN.showEntsList[#PLUGIN.showEntsList + 1] = v
		end
	end
end)

function PLUGIN:HUDPaint()
	for k, v in ipairs(self.showEntsList) do
		if !IsValid(v) then continue end

		local p = v:IsPlayer()
		if !p and !self.entslist[v:GetClass()] then continue end

		if !p or (p and v != LocalPlayer() and v:oldAlive()) then
			local _y = 0
			local info = v:ESPInfo()

			for k2, v2 in pairs(info) do
				if v2[1] and self:DistanceFits(LocalPlayer():GetPos(), v:GetPos(), v2[2]) then
					local pos = v:GetPos()
					local head = Vector(pos.x, pos.y, !p and pos.z or pos.z + 60)
					local headPos = head:ToScreen()
					if !headPos.visible then continue end

					local distance = LocalPlayer():GetPos():Distance(v:GetPos())
					local x, y = headPos.x, headPos.y
					local f = math_abs(350 / distance)
					local size = 52 * f
					local col = (p and team_GetColor(v:Team()) or self.entslist[v:GetClass()]) or color_white

					createText(tostring(v2[1]), (x - size / 2) + size, y - size / 2, col, _y)

					_y = _y + 15
				end
			end
		end
	end
end
