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

-- Localize Global Calls
local CurTime = CurTime
local math_min = math.min
local netstream = netstream

Medical.ui_effects = Medical.ui_effects or {}

function Medical:AddTemporaryStatusEffect(uniqueID, delay)
	local curTime = CurTime()
	local client = LocalPlayer()
	local info = self.t_status_effects[uniqueID]

	local onAdd = info.onAdd
	if onAdd then
		onAdd(client)
	end

	local index = client:EntIndex()
	info.stored[index] = {}

	if info.isHidden then return end

	delay = delay - curTime
	local time = delay <= 0 and 15 or math_min(15, delay)
	if self.ui_effects[uniqueID] then
		self.ui_effects[uniqueID].time = curTime + time
		self.ui_effects[uniqueID].start = curTime
	else
		self.ui_effects[uniqueID] = {
			time = curTime + time,
			start = curTime,
			scale = 0,
			alpha = 0,
			anim = 0
		}
	end
end

function Medical:RemoveTemporaryStatusEffect(uniqueID)
	local client = LocalPlayer()
	local info = self.t_status_effects[uniqueID]

	local onRemove = info.onRemove
	if onRemove then
		onRemove(client)
	end

	local index = client:EntIndex()
	info.stored[index] = nil

	self.ui_effects[uniqueID] = nil
end


netstream.Hook("Medical:AddTemporaryStatusEffect", function(uniqueID, delay)
	Medical:AddTemporaryStatusEffect(uniqueID, delay)
end)

netstream.Hook("Medical:RemoveTemporaryStatusEffect", function(uniqueID)
	Medical:RemoveTemporaryStatusEffect(uniqueID)
end)