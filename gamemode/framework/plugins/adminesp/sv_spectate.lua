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

local players_hook = {}
local function create_hook()
	hook.Add("StartCommand", "AdminESP:StartCommand", function(client, ucmd)
		if !players_hook[client] then return end

		ucmd:ClearMovement()
		ucmd:SetForwardMove(0)
		ucmd:SetUpMove(0)
		ucmd:SetSideMove(0)

		ucmd:SetMouseX(0)
		ucmd:SetMouseY(0)
		ucmd:SetMouseWheel(0)
	end)

	hook.Add("SetupPlayerVisibility", "AdminESP:SetupPlayerVisibility", function(client)
		if !players_hook[client] then return end

		local entity = client._CameraEntity
		if IsValid(entity) and !client:TestPVS(entity) then
			AddOriginToPVS(entity:GetPos())
		end

		local position = client._CameraPosition
		if position and !client:TestPVS(position) then
			AddOriginToPVS(position)
		end
	end)
end

local function remove_hook()
	players_hook = {}

	hook.Remove("StartCommand", "AdminESP:StartCommand")
	hook.Remove("SetupPlayerVisibility", "AdminESP:SetupPlayerVisibility")
end

local function update_hook(client)
	if IsValid(client) then
		players_hook[client] = nil
	end

	local count = 0
	for k in pairs(players_hook) do
		if IsValid(k) then
			count = count + 1
		end
	end

	if count <= 0 then
		remove_hook()
	end
end

function PLUGIN:Spec(client, target)
	client._CameraEntity = nil

	local var = client:GetLocalVar("spectating", false)
	client:SetLocalVar("spectating", !var)

	if !var then
		players_hook[client] = true
		create_hook()

		if IsValid(target) then
			client._CameraEntity = target

			netstream.Start(client, "AdminESP:CameraSetEntity", target)
		end
	else
		update_hook(client)
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

	update_hook(client)
end)