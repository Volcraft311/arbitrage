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

local PLUGIN = PLUGIN

function PLUGIN:Spec(client, target)
	client._CameraEntity = nil

	local var = client:GetLocalVar("spectating", false)
	client:SetLocalVar("spectating", !var)

	if !var and IsValid(target) then
		client._CameraEntity = target

		netstream.Start(client, "AdminESP:CameraSetEntity", target)
	end

	local hookID = "AdminESP:StartCommand_" .. client:SteamID()
	if !var then
		hook.Add("StartCommand", hookID, function(_, ucmd)
			if !IsValid(client) then return hook.Remove(hookID) end

			ucmd:ClearMovement()
			ucmd:SetForwardMove(0)
			ucmd:SetUpMove(0)
			ucmd:SetSideMove(0)

			ucmd:SetMouseX(0)
			ucmd:SetMouseY(0)
			ucmd:SetMouseWheel(0)
		end)
	else
		hook.Remove("StartCommand", hookID)
	end
end

concommand.Add("spectate", function(client, cmd, args)
	if !client:IsAdmin() then return end

	local text = args[1]
	local target = nil

	if text then
		target = player.GetByIdentifier(text)
	end

	PLUGIN:Spec(client, target)
end)

function PLUGIN:InitPostEntity()
	if serverguard then
	    serverguard.command:Remove("spectate")
	end
end

function PLUGIN:SetupPlayerVisibility(client)
	if !client:IsAdmin() then return end
	if !client:IsSpectating() then return end

	local entity = client._CameraEntity
	if IsValid(entity) then
		local position = entity:IsPlayer() and entity:GetShootPos() or entity:GetPos()

		if position then
			AddOriginToPVS(position)
		end
	end

	local position = client._CameraPosition
	if position then
		AddOriginToPVS(position)
	end
end

local dist = 325
function PLUGIN:ChatAddText(client, message)
	for k, v in ipairs(player.GetAdmins()) do
	    if !v:IsSpectating() then continue end
	    if client == v then continue end

	    local data = v:GetLocalVar("spectatescommand", {})
	    if data[client:SteamID()] then continue end

	    if v._CameraPosition:Distance(client:GetPos()) <= dist or (IsValid(v._CameraEntity) and v._CameraEntity:GetPos():Distance(client:GetPos()) <= dist) then
	    	netstream.Start(v, "arb.SendMessage", Color(255, 0, 0), "[Наблюдение] ", team.GetColor(client:Team()), client:FullName(), Color(238, 220, 194), " написал в чат: ", "'", message, "'")
	    end
	end
end


netstream.Hook("AdminESP:CameraUpdatePosition", function(client, vector)
	if !client:IsAdmin() then return end
	if !client:IsSpectating() then return end

	client._CameraPosition = vector
end)

netstream.Hook("AdminESP:CameraSetEntity", function(client, entity)
	if !client:IsAdmin() then return end
	if !client:IsSpectating() then return end

	if !IsValid(entity) then entity = nil end

	if client._CameraEntity != entity then
		client._CameraEntity = entity
	end
end)

netstream.Hook("AdminESP:CameraTeleportToPosition", function(client, vector, angles)
	if !client:IsAdmin() then return end
	if !client:IsSpectating() then return end

	client._CameraEntity = nil
	client:SetLocalVar("spectating", false)

	client:SetPos(vector - Vector(0, 0, 50))

	timer.Simple(0.1, function()
		client:SetEyeAngles(angles)
	end)
end)