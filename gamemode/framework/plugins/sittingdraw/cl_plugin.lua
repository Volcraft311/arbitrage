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
local Color = Color
local util_IntersectRayWithPlane = util.IntersectRayWithPlane
local Vector = Vector
local WorldToLocal = WorldToLocal
local Angle = Angle
local SitAnywhere = SitAnywhere
local math_abs = math.abs
local timer_Create = timer.Create
local FrameTime = FrameTime
local IsValid = IsValid
local EyePos = EyePos
local RunConsoleCommand = RunConsoleCommand
local timer_Remove = timer.Remove
local net_Start = net.Start
local net_WriteInt = net.WriteInt
local net_WriteFloat = net.WriteFloat
local net_WriteVector = net.WriteVector
local net_SendToServer = net.SendToServer
local ents_CreateClientProp = ents.CreateClientProp

PLUGIN.csEnt = NULL

local sitBindID = "sitting"
local color_alpha = 160
local color_blue = Color(0, 0, 255, color_alpha)
local color_yellow = Color(255, 119, 0, color_alpha)
local color_red = Color(255, 0, 0, color_alpha)
local color_green = Color(0, 255, 0, color_alpha)
local uniqueID = "SittingDraw:Timer"
local fixAng = 180

function PLUGIN:GetInfo(wantedAng, client, trace)
	local vec = util_IntersectRayWithPlane(client:EyePos(), client:EyeAngles():Forward(), trace.HitPos, Vector(0, 0, 1))
	if !vec then
		return {
			wantedAng = wantedAng
		}
	end

	local posOnPlane = WorldToLocal(vec, Angle(0, 90, 0), trace.HitPos, Angle(0, 0, 0))
	local currentAng = (trace.HitPos - vec):Angle()
	wantedAng = currentAng

	if posOnPlane:Length() < 2 then
		wantedAng = nil

		return {
			wantedAng = wantedAng,
			currentAng = currentAng
		}
	end

	if wantedAng then
		local goodSit = SitAnywhere.CheckValidAngForSit(trace.HitPos, trace.HitNormal:Angle(), wantedAng.y)
		if !goodSit then wantedAng = nil end

		return {
			wantedAng = wantedAng,
			currentAng = currentAng,
			goodSit = goodSit
		}
	end
end

function PLUGIN:GetAngles(client, trace, wantedAng)
	local valid, ent = SitAnywhere.ValidSitTrace(client, trace)
	if !valid then return end

	local surfaceAng = trace.HitNormal:Angle() + Angle(-270, 0, 0)
	local ang = surfaceAng

	if wantedAng and math_abs(surfaceAng.pitch) <= 15 then
		ent = trace.Entity

		if trace.HitWorld or !ent:IsPlayer() then
			if SitAnywhere.CheckValidAngForSit(trace.HitPos, trace.HitNormal:Angle(), wantedAng) then
				ang.yaw = wantedAng
			else
				return
			end
		end
	end

	return ang
end

function PLUGIN:StartSit(trace)
	local wantedAng = nil
	local client = LocalPlayer()

	timer_Create(uniqueID, 0, 0, function()
		if !IsValid(self.csEnt) then self:CreateCSEnt() end

		if client.IsProne and client:IsProne() then
			return self:RemoveCSEnt()
		end

		self.csEnt:SetColor(color_yellow)

		local currentAng = Angle(0, 0, 0)
		local goodSit = false

		local data = self:GetInfo(wantedAng, client, trace)

		if data then
			wantedAng = data.wantedAng or wantedAng
			goodSit = data.goodSit or goodSit
			currentAng = data.currentAng or currentAng
		end

		local angles = currentAng
		if wantedAng and wantedAng.y then
			local ang = self:GetAngles(client, trace, wantedAng.y)

			if ang then
				angles = ang
			end
		else
			angles.pitch = 0
		end

		angles.y = currentAng.y + fixAng

		self.csEnt:SetPos(trace.HitPos)
		self.csEnt:SetAngles(angles)
		self.csEnt:SetColor(goodSit and color_green or color_red)
		local seq = self:GetSitSequence(client)
		self.csEnt:SetSequence(seq)

		local sitID = client:GetNetVar("sitting")
		if sitID then
			local info = Emotes.SittingList[sitID]
			local origin = info[2] or Vector(0, 0, 0)

			local x, y, z = origin.x, origin.y, origin.z
			local pos, ang = self.csEnt:GetPos(), self.csEnt:GetAngles()

			pos = pos + ang:Forward() * x + ang:Right() * y + ang:Up() * z

			self.csEnt:SetPos(pos)
		end

		if trace.HitPos:Distance(EyePos()) >= 100 then
			self.csEnt:SetColor(color_blue)
		end

		if wantedAng then
			wantedAng.y = wantedAng.y + fixAng

			self.Ang = wantedAng
			self.StartPos = trace.StartPos
			self.Normal = trace.Normal
		end

		Hints:AddKeyDraw("Предыдущая поза", {MOUSE_RIGHT, SETTINGS.binds.Get("sitting")})
		Hints:AddKeyDraw("Следующая поза", {MOUSE_LEFT, SETTINGS.binds.Get("sitting")})
	end)
end

function PLUGIN:DoSit(trace)
	if !trace.Hit then return end

	local client = LocalPlayer()
	if client.IsProne and client:IsProne() then
		return self:RemoveCSEnt()
	end

	if trace.HitPos:Distance(EyePos()) >= 150 then
		return self:RemoveCSEnt()
	end

	local surfaceAng = trace.HitNormal:Angle() + Angle(-270, 0, 0)
	local playerTrace = !trace.HitWorld and IsValid(trace.Entity) and trace.Entity:IsPlayer()

	local goodSit = SitAnywhere.GetAreaProfile(trace.HitPos + Vector(0, 0, 0.1), 24, true)
	if math_abs(surfaceAng.pitch) >= 15 or !goodSit or playerTrace then
		return RunConsoleCommand("sit")
	end

	local valid = SitAnywhere.ValidSitTrace(LocalPlayer(), trace)
	if !valid then return end

	self:StartSit(trace)
end

function PLUGIN:KeyPressID(client, id, bIsVisibleGUI)
	if bIsVisibleGUI then return end
	if id != sitBindID then return end
	if !SitAnywhere then return end

	if Arbitrage.lawEnable then return end
	if client.IsProne and client:IsProne() then return end
	if client.GetSitting and client:GetSitting() then return end

	if client:IsSpectate() then return end
	if client:IsNocliping() then return end

	self.Ang = nil
	self.StartPos = nil
	self.Normal = nil

	self:CreateCSEnt()
	self:DoSit(client:GetEyeTrace())
end

function PLUGIN:KeyReleaseID(client, id)
	if id != sitBindID then return end
	if !SitAnywhere then return end

	timer_Remove(uniqueID)
	self:RemoveCSEnt()

	if client:IsNocliping() then return end
	if client.GetSitting and client:GetSitting() then return end

	if self.Ang and self.StartPos and self.Normal then
		net_Start("SitAnywhere")
			net_WriteInt(0, 4)
			net_WriteFloat(self.Ang.y - fixAng)
			net_WriteVector(self.StartPos)
			net_WriteVector(self.Normal)
		net_SendToServer()
	end

	self.Ang = nil
	self.StartPos = nil
	self.Normal = nil
end

function PLUGIN:CreateCSEnt()
	local client = LocalPlayer()
	local trace = client:GetEyeTrace()

	local entity = ents_CreateClientProp(client:GetModel())
	entity:SetRenderMode(RENDERMODE_TRANSCOLOR)
	entity:SetAngles(Angle(0, 0, 0))
	entity:SetPos(trace.HitPos + Vector(0, 0, 1))
	entity:SetMaterial("models/debug/debugwhite")
	entity:SetColor(color_yellow)

	entity:SetNoDraw(false)
	entity:DrawShadow(false)
	entity:SetIK(false)

	local sitID = client:GetNetVar("sitting")
	if sitID then
		local info = Emotes.SittingList[sitID]
		local origin = info[2] or Vector(0, 0, 0)

		local x, y, z = origin.x, origin.y, origin.z
		local pos, ang = entity:GetPos(), entity:GetAngles()

		pos = pos + ang:Forward() * x + ang:Right() * y + ang:Up() * z

		entity:SetPos(pos)
	end

	local physObj = entity:GetPhysicsObject()
	if IsValid(physObj) then
		physObj:EnableMotion(false)
	end

	local seq = self:GetSitSequence(client)
	entity:SetSequence(seq)

	self.csEnt = entity
	return entity
end

function PLUGIN:RemoveCSEnt()
	if IsValid(self.csEnt) then
		self.csEnt:Remove()
	end

	self.csEnt = NULL
end

function PLUGIN:GetSitSequence(client)
	local seq = client:GetSittingSequence()
	local id = client:LookupSequence(seq)

	return id
end

function PLUGIN:PlayerBindPress(client, bind, bPress)
	if !IsValid(self.csEnt) then return end
	if !bPress then return end

	if bind == "+attack" then
		local id = client:GetNetVar("sitting", 0)
		id = id + 1

		if id > #Emotes.SittingList then
			id = 0
		end

		RunConsoleCommand("say", "/sitting " .. id)
		return true
	elseif bind == "+attack2" then
		local id = client:GetNetVar("sitting", 0)
		id = id - 1

		if id < 0 then
			id = #Emotes.SittingList
		end

		RunConsoleCommand("say", "/sitting " .. id)
		return true
	end
end