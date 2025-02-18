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
local draw_RoundedBox = draw.RoundedBox
local Color = Color
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local IsValid = IsValid
local ipairs = ipairs
local isfunction = isfunction
local SortedPairsByMemberValue = SortedPairsByMemberValue
local Derma_Query = Derma_Query
local netstream = netstream
local player_GetAll = player.GetAll
local pairs = pairs
local DermaMenu = DermaMenu
local ScrW = ScrW
local ScrH = ScrH
local input_IsKeyDown = input.IsKeyDown
local vgui_CursorVisible = vgui.CursorVisible
local util_QuickTrace = util.QuickTrace
local EyePos = EyePos
local EyeAngles = EyeAngles
local ents_FindInSphere = ents.FindInSphere
local math_abs = math.abs
local util_TraceLine = util.TraceLine
local type = type
local math_Clamp = math.Clamp
local surface_GetTextureID = surface.GetTextureID
local surface_SetTexture = surface.SetTexture
local surface_DrawTexturedRect = surface.DrawTexturedRect
local math_max = math.max
local surface_SetMaterial = surface.SetMaterial
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local Material = Material
local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D
local timer_Simple = timer.Simple


local cornerRadius = 5
local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        draw_RoundedBox(cornerRadius, 0, 0, w, h, Color(255, 61, 96, 165.75))
        draw_RoundedBox(cornerRadius, 2, 2, w - 4, h - 4, Color(41, 22, 25))
    end
end

local function paintOption(panel, drawline)
    panel:SetFont("arb.Font_FuturaPTBook_6")
    panel.Paint = function(_, w, h)
        local alpha = 130

        if _:IsHovered() and _:IsEnabled() then
            surface_SetDrawColor(27, 10, 13, 200)
            surface_DrawRect(2, 2, w - 4, h - 4)

            alpha = 255
        end

        if !_:IsEnabled() then
            surface_SetDrawColor(255, 0, 0, 20)
            surface_DrawRect(2, 0, w - 4, h)

            alpha = 255
        end

        panel:SetTextColor(Color(240, 240, 240, alpha))

        if drawline then
            surface_SetDrawColor(255, 255, 255, 50)
            surface_DrawRect(w * 0.1, h - 2, w - w * 0.2, 2)
        end
    end
end

local barMargin = 23
local function paintBar(panel)
	local children = panel:GetChildren()
	local bar = children[2]
	if !IsValid(bar) then return end

	bar:SetWide(30)
	bar:DockMargin(0, 0, 0, 0)

	bar.Paint = function(_, w, h)
	    surface_SetDrawColor(255, 255, 255, 3)
	    surface_DrawRect(barMargin, 30, w - barMargin - 4, h - 60)
	end
	bar.btnUp.Paint = function(_, w, h) end
	bar.btnDown.Paint = function(_, w, h) end
	bar.btnGrip.Paint = function(_, w, h)
	    surface_SetDrawColor(255, 255, 255)
	    surface_DrawRect(barMargin, 0, w - barMargin - 4, h)
	end
end

local function CreatePanels(data, parent)
	for k, v in ipairs(data or {}) do
		local panel, subMenu = nil, nil

		if isfunction(v.data) then
			panel = parent:AddOption(v.name, v.data)
		else
			subMenu, panel = parent:AddSubMenu(v.name)
			paintMenu(subMenu)

			CreatePanels(v.data, subMenu)

			paintBar(subMenu)
		end

		paintOption(panel)
		panel:SetImage(v.icon)

		for k2, v2 in ipairs(panel:GetChildren()) do
			if v2:GetName() == "DImage" and !v2:GetImage():find("icon16/") then
				local size = parent:GetTall() * 1.5

				v2:SetSize(size, size)
			end
		end
	end
end

local function gRequestAddDoorFaction()
	local data = {}

	for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
		data[#data + 1] = {
			name = v:GetName(),
			icon = v:GetAssets().pixel,
			data = function()
				Derma_Query("#doors_char_confirm",  "#doors_ds_access", "#doors_yes", function()
					netstream.Start("arb.DoorAddOwner", k)
				end, "#doors_no")
			end
		}
	end

	return data
end

local function formatedImages(data)
	local info = {}

	for k, v in ipairs(data) do
		info[v] = true
	end

	return info
end

local function gAddIcon(entity)
	local data = {}
	local useImages = formatedImages(entity:GetNetVar("arb.image", {}))

	for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
		if v:GetAssets().pixel and !useImages[k] then
			data[#data + 1] = {
				name = v:GetName(),
				icon = v:GetAssets().pixel,
				data = function()
					netstream.Start("arb.DoorAddIcon", entity, k)
				end
			}
		end
	end

	return data
end

local function gRemoveIcon(entity)
	local data = {}

	for k, v in ipairs(entity:GetNetVar("arb.image", {})) do
		local faction = Character.team:GetByID(v)
		if !faction then continue end

		data[#data + 1] = {
			name = faction:GetName(),
			icon = faction:GetAssets().pixel,
			data = function()
				netstream.Start("arb.DoorRemoveIcon", entity, k)
			end
		}
	end

	return data
end

local function gRequestAddDoorPlayer()
	local data = {}

	for k, v in ipairs(player_GetAll()) do
		local id = v:Team()

		local faction = Character.team:GetByID(id)
		local icon = nil

		if faction and faction:GetAssets().pixel then
			icon = faction:GetAssets().pixel
		end

		data[#data + 1] = {
			name = v:FullName(true),
			icon = icon,
			data = function()
				Derma_Query("#doors_char_confirm",  "#doors_ds_access", "#doors_yes", function()
					netstream.Start("arb.DoorAddOwner", id)
				end, "#doors_no")
			end
		}
	end

	return data
end

local function gRequestRemoveDoorPlayer(doorData)
	if !doorData then return end

	local data = {}

	for k, v in pairs(doorData.list or {}) do
		local faction = Character.team:GetByID(k)

		data[#data + 1] = {
			name = faction:GetName(),
			icon = faction:GetAssets().pixel,
			data = function()
				Derma_Query("#doors_ply_delete",  "#doors_ds_remove", "#doors_yes", function()
					netstream.Start("arb.DoorRemoveOwner", k)
				end, "#doors_no")
			end
		}
	end

	return data
end

local function getActionList(entity, doorData)
	return {
		{
			name = "#doors_actions",
			icon = "icon16/report_disk.png",
			data = {
				{
					name = (entity:GetNWBool("disableHack") and "#doors_approve" or "#doors_prohibit") .. "#doors_lockpick",
					icon = "icon16/attach.png",
					data = function()
						netstream.Start("arb.DoorSetHack")
					end
				},
				{
					name = "#doors_setid",
					icon = "icon16/report_key.png",
					data = function()
						Derma_StringRequest("#doors_uniqueid", "#doors_setuniqueid", entity:GetNetVar("key_uniqueid", ""), function(text)
							netstream.Start("arb.DoorSetUniqueID", text)
						end)
					end
				},
			}
		},
		{
			name = "#doors_addaccess",
			icon = "icon16/pencil_add.png",
			data = {
				{
					name = "#doors_searchply",
					icon = "icon16/user_go.png",
					data = gRequestAddDoorPlayer()
				},
				{
					name = "#doors_searchfraction",
					icon = "icon16/transmit_go.png",
					data = gRequestAddDoorFaction()
				}
			}
		},
		{
			name = "#doors_removeaccess",
			icon = "icon16/pencil_delete.png",
			data = gRequestRemoveDoorPlayer(doorData)
		},
		{
			name = "#doors_addicon",
			icon = "icon16/camera_add.png",
			data = gAddIcon(entity)
		},
		{
			name = "#doors_removeicon",
			icon = "icon16/camera_delete.png",
			data = gRemoveIcon(entity)
		}
	}
end

local function openDoorMenu(entity)
	local doorData
	for k, v in pairs(PLUGIN.DoorsData) do
		if v.idx == entity:EntIndex() then
			doorData = PLUGIN.DoorsData[k]
		end
	end

	local actionList = getActionList(entity, doorData)

	local parentMenu = DermaMenu()
	paintMenu(parentMenu)
	CreatePanels(actionList, parentMenu)

	parentMenu:Open(ScrW() / 2, ScrH() / 2)

	parentMenu:SetAlpha(0)
	parentMenu:AlphaTo(255, 0.3)
end

function PLUGIN:Think()
	local client = LocalPlayer()

	if input_IsKeyDown(KEY_F2) and client:IsAdmin() and !vgui_CursorVisible() then
		local trace = util_QuickTrace(EyePos(), EyeAngles():Forward() * 999999, LocalPlayer())
		local entity = trace.Entity

		if !IsValid(entity) then return end

		if entity:IsDoor() then
			return openDoorMenu(entity)
		end

		local bIsRagdoll = entity:GetClass() == "prop_ragdoll"
		if entity:IsPlayer() or bIsRagdoll then
			if bIsRagdoll then
				local steamID = entity:GetNetVar("sIsRagdoll")

				entity = steamID and player.GetBySteamID(steamID)
				if !IsValid(entity) then return end
			end

			return MonoMenu:OpenEntityMenu(entity, ScrW() / 2, ScrH() / 2)
		end

		local bIsItem = entity:GetClass() == "arb_item"
		if bIsItem then
			local itemID = entity:GetItemID()

			if itemID then
				return ItemBase:EditProperties(itemID)
			end
		end
	end
end

function PLUGIN:CalculateDoorPosition(door, reversed)
	local traceData = {}
	local obbCenter = door:OBBCenter()
	local obbMaxs = door:OBBMaxs()
	local obbMins = door:OBBMins()

	traceData.endpos = door:LocalToWorld(obbCenter)
	traceData.filter = ents_FindInSphere(traceData.endpos, 20)

	for k, v in pairs(traceData.filter) do
		if v == door then
			traceData.filter[k] = nil
		end
	end

	local length = 0
	local width = 0
	local size = obbMins - obbMaxs

	size.x = math_abs(size.x)
	size.y = math_abs(size.y)
	size.z = math_abs(size.z)

	if size.z < size.x and size.z < size.y then
		length = size.z
		width = size.y

		if reverse then
			traceData.start = traceData.endpos - (door:GetUp() * length)
		else
			traceData.start = traceData.endpos + (door:GetUp() * length)
		end
	elseif size.x < size.y then
		length = size.x
		width = size.y

		if reverse then
			traceData.start = traceData.endpos - (door:GetForward() * length)
		else
			traceData.start = traceData.endpos + (door:GetForward() * length)
		end
	elseif size.y < size.x then
		length = size.y
		width = size.x

		if reverse then
			traceData.start = traceData.endpos - (door:GetRight() * length)
		else
			traceData.start = traceData.endpos + (door:GetRight() * length)
		end
	end

	local trace = util_TraceLine(traceData)
	local angles = trace.HitNormal:Angle()

	if (trace.HitWorld and !reversed) then
		return self:CalculateDoorPosition(door, true)
	end

	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 90)

	local position = trace.HitPos - (((traceData.endpos - trace.HitPos):Length() * 2) + 2) * trace.HitNormal
	local anglesBack = trace.HitNormal:Angle()
	local positionBack = trace.HitPos + (trace.HitNormal * 2)

	anglesBack:RotateAroundAxis(anglesBack:Forward(), 90)
	anglesBack:RotateAroundAxis(anglesBack:Right(), -90)

	return {
		positionBack = positionBack,
		anglesBack = anglesBack,
		position = position,
		hitWorld = trace.HitWorld,
		angles = angles,
		width = math_abs(width)
	}
end

function PLUGIN:CalculateAlphaFromDistance(maximum, start, finish)
	if type(start) == "Player" then
		start = start:GetShootPos()
	elseif type(start) == "Entity" then
		start = start:GetPos()
	end

	if type(finish) == "Player" then
		finish = finish:GetShootPos()
	elseif type(finish) == "Entity" then
		finish = finish:GetPos()
	end

	return math_Clamp(255 - ((255 / maximum) * (start:Distance(finish))), 0, 255)
end

PLUGIN.Gradients = {
	[GRADIENT_CENTER] = surface_GetTextureID("gui/center_gradient"),
	[GRADIENT_RIGHT] = surface_GetTextureID("gui/gradient"),
	[GRADIENT_DOWN] = surface_GetTextureID("gui/gradient_down"),
	[GRADIENT_UP] = surface_GetTextureID("gui/gradient_up"),
}

function PLUGIN:DrawGradient(gradientType, x, y, width, height, color)
	if !self.Gradients[gradientType] then return end

	surface_SetDrawColor(color.r, color.g, color.b, color.a)
	surface_SetTexture(self.Gradients[gradientType])
	surface_DrawTexturedRect(x, y, width, height)
end

local sSize = 400
function PLUGIN:DrawImage(alpha, data)
	local size = sSize / math_max(#data / 2, 1)
	local margin = (sSize - size) / 2

	for k, v in ipairs(data) do
		local index = k - 1
		local padding = ((#data - 1) * size) / 2

		surface_SetDrawColor(15, 6, 7, alpha)
		surface_DrawRect(index * size - padding + margin, margin, size, size)

		surface_SetDrawColor(255, 255, 255, alpha)
		surface_SetMaterial(v)
		surface_DrawTexturedRect(index * size - padding + margin, margin, size, size)
	end
end

function PLUGIN:DrawDoorText(entity, eyePos, eyeAngles, data)
	local entityColor = entity:GetColor()
	if entityColor.a <= 0 or entity:IsEffectActive(EF_NODRAW) then return end

	local doorData = self:CalculateDoorPosition(entity)
	if doorData.hitWorld then return end

	local alpha = self:CalculateAlphaFromDistance(1000, eyePos, entity:GetPos())
	if alpha <= 0 then return end

	cam_Start3D2D(doorData.position + doorData.angles:Right() * -30 + doorData.angles:Forward() * -10, doorData.angles, 0.05)
		self:DrawImage(alpha, data)
	cam_End3D2D()

	cam_Start3D2D(doorData.positionBack + doorData.anglesBack:Right() * -30 + doorData.anglesBack:Forward() * -10, doorData.anglesBack, 0.05)
		self:DrawImage(alpha, data)
	cam_End3D2D()
end

local doors_info = {}
asterionlib.entscollector:AddTrack("doors", {
	delay_apply = 3,
	onCanTrack = function(entity)
		return entity:IsDoor()
	end,
	onCanApply = function(entity)
		local distance = entity:GetPos():DistToSqr(EyePos())
		if distance > 1000000 then return false end

		local data = entity:GetNetVar("arb.image", {})
		if #data <= 0 then return false end

		local info = {}
		for k, v in ipairs(data) do
			local faction = Character.team:GetByID(v)
			if !faction then continue end

			info[#info + 1] = Material(faction:GetAssets().pixel)
		end

		doors_info[entity] = info

		return true
	end
})

function PLUGIN:PostDrawTranslucentRenderables()
	local data = asterionlib.entscollector:GetApply("doors")
	if #data <= 0 then return end

	local eyePos, eyeAngle = EyePos(), EyeAngles()
	cam_Start3D(eyePos, eyeAngle)
		for k, entity in ipairs(data) do
		    if !IsValid(entity) then continue end

			local info = doors_info[entity]
			self:DrawDoorText(entity, eyePos, eyeAngles, info)
		end
	cam_End3D()
end

netstream.Hook("arb.DoorGetData", function(data)
	if !data then return end

	PLUGIN.DoorsData = data
end)

timer_Simple(1, function()
	netstream.Start("arb.DoorGetData")
end)