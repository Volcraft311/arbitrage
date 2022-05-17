--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

include("shared.lua")


AddCSLuaFile("cl_panel.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001b.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end
end

function ENT:Use(client, caller)
	asterionlib.netgui:Close(client, "arb.OpenWardrobe")
	asterionlib.netgui:Create(client, "arb.OpenWardrobe", nil, "SetData", client:GetModel())
end


netstream.Hook("arb.WardrobeChange", function(client, bg, skin)
	local bAllow = false
	for k, v in ipairs(ents.FindInSphere(client:GetPos(), 300)) do
		if v:GetClass() == "arb_wardrobe" then
			bAllow = true
			break
		end
	end

	if bAllow then
		for name, value in pairs(bg) do
			local id = client:FindBodygroupByName(name)

			client:SetBodygroup(id, value)
		end

		client:SetSkin(skin)
		netstream.Start(client, "arb.Notify", "Вы успешно изменили одежду!")
	end
end)