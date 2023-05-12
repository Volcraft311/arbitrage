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

function Emotes:PlayerBindPress(client, bind, bPressed)
	local bThirdPerson = select(3, client:GetAction())
	if !bThirdPerson then return end

	if bind:find("+jump") and bPressed then
		RunConsoleCommand("say", "/exitaction")
		return true
	end
end

function Emotes:ShouldDrawLocalPlayer(client)
	local bThirdPerson = select(3, client:GetAction())
	if bThirdPerson then
		return true
	end
end

local function GetHeadBone(client)
	local head

	for i = 1, client:GetBoneCount() do
		local name = client:GetBoneName(i)

		if (string.find(name:lower(), "head")) then
			head = i
			break
		end
	end

	return head
end

local offset = 16
local height = Vector(0, 0, 20)
local forwardOffset = 16
local GROUND_PADDING = Vector(0, 0, 8)
local PLAYER_OFFSET = Vector(0, 0, 72 - 20)
local nCameraType = 1
local bKeyDown = false
function Emotes:CalcView(client, origin)
	if Arbitrage.lawEnable then return end
	if client:IsSpectating() then return end

	local bThirdPerson = select(3, client:GetAction())
	if bThirdPerson then
		Hints:AddKeyDraw("Выйти из анимации", "+jump")

		local ang = client:EyeAngles()

		local data = {}
		data.start = client:GetPos() + PLAYER_OFFSET
		data.endpos = data.start - ang:Forward() * 80
		data.filter = client

		local view = {}
		view.origin = util.TraceLine(data).HitPos + GROUND_PADDING + ang:Forward() * 4
		view.angles = ang
		view.filter = client

		return view
	end

	if client.GetSitting and client:GetSitting() then
		Hints:AddKeyDraw("Изменить положение камеры", "+duck")
		Hints:AddKeyDraw("Встать на ноги", "+use")

		if client:GetPos():DistToSqr(Vector(0, 0, 0)) <= 150 then
			RunConsoleCommand("+use")
			timer.Simple(0.2, function()
				RunConsoleCommand("-use")
			end)

			return
		end

		local x, y, z = 0, 0, 0

		local bKeyPress = client:KeyDown(IN_DUCK)
		if bKeyPress then
			if !bKeyDown then
				nCameraType = nCameraType + 1

				if nCameraType > 3 then
					nCameraType = 1
				end
			end

			bKeyDown = true
		else
			bKeyDown = false
		end

		local sitID = client:GetNetVar("sitting")
		if sitID then
			local data = Emotes.SittingList[sitID]
			local campos = data and data[2] or Vector(0, 0, 0)

			x, y, z = -campos.x, -campos.y, -campos.z
		end

		local pos, ang = origin, client:EyeAngles()

		pos = pos + client:GetAngles():Forward() * x + client:GetAngles():Right() * y + client:GetAngles():Up() * z

		local view = {}
		view.drawviewer = true
		if nCameraType == 1 then
			local data = {}
			data.start = pos
			data.endpos = data.start - ang:Forward() * 72
			data.filter = client

			view.origin = util.TraceLine(data).HitPos + GROUND_PADDING
		elseif nCameraType == 2 then
			local enterAngle = client:GetAngles()
			local forward = enterAngle:Forward()
			local head = GetHeadBone(client)
			if head then
				local position = client:GetBonePosition(head) + client:GetAngles():Forward() * 7
				local data = {
					start = (client:GetBonePosition(head) or Vector(0, 0, 64)) + forward * 8,
					endpos = position + forward * offset,
					mins = traceMin,
					maxs = traceMax,
					filter = client
				}

				data = util.TraceHull(data)

				if data.Hit then
					view.origin = data.HitPos
				else
					view.origin = position
				end
			else
				view.origin = origin + forward * forwardOffset + height
			end
		elseif nCameraType == 3 then
			view.origin = pos
			view.drawviewer = false
		end

		view.angles = ang
		view.filter = client
		return view
	end
end

-- На меня накричал Нито, по этому я это удалил :(  (может когда то пригодится ¯\_(ツ)_/¯)
--[[
local rectAlpha = 0
local rectDist = 1000
local rectSize = 10000
function Emotes:PostDrawTranslucentRenderables()
	local client = LocalPlayer()
	local _, _, bThirdPerson, seqAngle = client:GetAction()
	if bThirdPerson or (client.GetSitting and client:GetSitting()) then
		local time = FrameTime() * 5
		rectAlpha = Lerp(time, rectAlpha, 257)
		rectDist = Lerp(time, rectDist, 80)

		local sAng = seqAngle or client:GetAngles()
		local pos, ang = client:GetPos(), Angle(sAng.p, sAng.y, sAng.r)
		pos = pos + ang:Forward() * -rectDist
		ang:RotateAroundAxis(ang:Right(), 90)

		cam.Start3D2D(pos, ang, 1)
			surface.SetDrawColor(20, 20, 20, rectAlpha)
			surface.DrawRect(-rectSize, -rectSize, rectSize * 2, rectSize * 2)
		cam.End3D2D()
	else
		rectAlpha = 0
		rectDist = 1000
	end
end
]]--