local PLUGIN = PLUGIN

if !CLIENT then return end

local hiddenBones = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Upperarm",
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Upperarm",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42"
}

if IsValid(LocalPlayer()) and LocalPlayer().legs then
	LocalPlayer().legs:Remove()
end

function PLUGIN:RenderScreenspaceEffects()
	local client = LocalPlayer()

	if !IsValid(client) or client:GetLocalVar("observer") or client:ShouldDrawLocalPlayer() or !client:oldAlive() or client:IsPlayingTaunt() or (client.GetSitting and client:GetSitting()) then return end

	local angs = client:EyeAngles()
	if angs.p < 0 then return end

	cam.Start3D(EyePos(), EyeAngles())
		if !IsValid(client.legs) then
			self:SpawnLegs(client)
		end

		local real_time = RealTime()
		local legs = client.legs

		angs.p = 0
		angs.r = 0

		local radAngle = math.rad(angs.y)
		local offset = -20
		local origin = client:GetPos()

		origin.x = origin.x + math.cos(radAngle) * offset
		origin.y = origin.y + math.sin(radAngle) * offset

		legs:SetPoseParameter("move_yaw", 360 * client:GetPoseParameter("move_yaw") - 180)
		legs:SetPoseParameter("move_x", client:GetPoseParameter("move_x") * 2 - 1)
		legs:SetPoseParameter("move_y", client:GetPoseParameter("move_y") * 2 - 1)
		legs:SetPoseParameter("body_yaw", (client:GetPoseParameter("body_yaw") * 180) - 90)
		legs:SetPoseParameter("spine_yaw", (client:GetPoseParameter("spine_yaw") * 180) - 90)

		legs:SetRenderMode(client:GetRenderMode())
		legs:SetMaterial(client:GetMaterial())
		legs:SetSequence(client:GetSequence())
		legs:SetColor(client:GetColor())
		legs:FrameAdvance(real_time - (legs.last_draw or real_time))
		legs:SetPlaybackRate(client:GetPlaybackRate())
		legs:SetRenderOrigin(origin)
		legs:SetRenderAngles(angs)
		legs:DrawModel()

		legs.last_draw = real_time
	cam.End3D()
end

local offset = Vector(0, -100, 0)
local scale = Vector(1, 1, 1)
function PLUGIN:SpawnLegs(client)
	if IsValid(client.legs) then
		client.legs:Remove()
	end

	client.legs = ClientsideModel(client:GetModel(), RENDERGROUP_VIEWMODEL)

	local legs = client.legs

	if IsValid(legs) then
		for k, v in pairs(hiddenBones) do
			local bone = legs:LookupBone(v)

			if bone then
				legs:ManipulateBonePosition(bone, offset)
				legs:ManipulateBoneAngles(bone, angle_zero)
				legs:ManipulateBoneScale(bone, scale)
			end
		end

		legs:SetNoDraw(true)
		legs:SetIK(true)
	end
end

timer.Create("Legs:Update", 3, 0, function()
	local client = LocalPlayer()
	if !IsValid(client) then return end

	local legs = client.legs

	if IsValid(legs) then
		local clientModel = client:GetModel()
		local legsModel = legs:GetModel()

		if clientModel != legsModel then
			PLUGIN:SpawnLegs(client)
		end
	end
end)