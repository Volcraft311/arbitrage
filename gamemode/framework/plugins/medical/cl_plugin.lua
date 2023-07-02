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


Medical.ui_effects = Medical.ui_effects or {}

function Medical:AddTemporaryStatusEffect(uniqueID, delay)
	local client = LocalPlayer()
	local info = self.t_status_effects[uniqueID]

	local onAdd = info.onAdd
	if onAdd then
		onAdd(client)
	end

	local index = client:EntIndex()
	info.stored[index] = {}

	if info.isHidden then return end

	self.ui_effects[uniqueID] = true
	delay = delay - CurTime()

	local timerID = "Medical:RemoveTimer_" .. uniqueID
	timer.Remove(timerID)

	timer.Create(timerID, delay <= 0 and 15 or math.min(15, delay), 1, function()
		timer.Remove(timerID)

		self.ui_effects[uniqueID] = nil
	end)
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

	local timerID = "Medical:RemoveTimer_" .. uniqueID
	timer.Remove(timerID)
end


netstream.Hook("Medical:AddTemporaryStatusEffect", function(uniqueID, delay)
	Medical:AddTemporaryStatusEffect(uniqueID, delay)
end)

netstream.Hook("Medical:RemoveTemporaryStatusEffect", function(uniqueID)
	Medical:RemoveTemporaryStatusEffect(uniqueID, delay)
end)