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


local classData = {
	["chats"] = function(client, chatID)
		local monopad = MonoPad:GetObject(client)
		if !monopad then return false end

		if monopad.mutedChats[chatID] then
			return false
		end

		return true
	end
}

function MonoPad:SendNotify(client, class, ...)
	if client == nil then
		for k, v in ipairs(player.GetAll()) do
			MonoPad:SendNotify(v, class, ...)
		end
	else
		local allow = true

		if classData[class] then
			allow = classData[class](client, ...)
		end

		timer.Simple(math.random() * 3, function()
			if !IsValid(client) then return end
			if !self:FindMonoPad(client) then return end

			if !client:IsNocliping() and allow == true then
				client:EmitSound(self.sounds.notification, SNDLVL_45dB, 100, 0.7, CHAN_ITEM)
			end

			netstream.Start(client, "MonoPad:Notify")
		end)
	end
end

netstream.Hook("MonoPad:SyncHistory", function(client, id, history, lastHistory)
	local find = false

	local inventory = client:GetInventory()
	if !inventory then return end

	local items = inventory:GetItems()
	for _, item in ipairs(items) do
		if item:GetID() == id then
			find = true
		end
	end

	if find then
		local object = MonoPad.instances[id]
		if !object then return end

		object.history = history
		object.lastHistory = lastHistory
	end
end)

netstream.Hook("MonoPad:CreateNotes", function(client, title)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	monopad:CreateNotes(title)
end)

netstream.Hook("MonoPad:EditNotes", function(client, notesID, title, description)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	monopad:EditNotes(notesID, title, description)
end)

netstream.Hook("MonoPad:RemoveNotes", function(client, notesID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end
	if !monopad:IsReceiver(client) then return end

	monopad:RemoveNotes(notesID)
end)


local function messageSync(senderID, senderData, targetID, targetData)
	if targetID > 0 then
		local targetFaction = Character.team:GetByID(targetID)
		if !targetFaction then return end

		for k, v in pairs(MonoPad.instances) do
			-- Синк игроку который отправил
			if v.team == senderID then
				v:AddMessage(targetID, senderData)
				v:Sync()
			end

			-- Синк игроку которому отправили
			if v.team == targetID then
				v:AddMessage(senderID, targetData)
				v:Sync()

				local receivers = v:GetReceivers()
				for k2, v2 in ipairs(receivers) do
					if IsValid(v2) and v2:IsPlayer() then
						MonoPad:SendNotify(v2, "chats", senderID)
					end
				end
			end
		end
	else
		if Arbitrage.OffMonopadGlobalChat() then return end

		local info = GetNetVar("MonoPad:PublicChat", {})
		table.insert(info, senderData)

		if #info > 50 then
			table.remove(info, 1)
		end

		SetNetVar("MonoPad:PublicChat", info)

		for k, v in pairs(MonoPad.instances) do
			v:Sync()

			if v.team != senderID then
				local receivers = v:GetReceivers()
				for k2, v2 in ipairs(receivers) do
					if IsValid(v2) and v2:IsPlayer() then
						MonoPad:SendNotify(v2, "chats", -1)
					end
				end
			end
		end
	end
end

netstream.Hook("MonoPad:SendMessage", function(client, targetID, message)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local senderID = monopad.team

	local data = {
		type = 1,
		faction = senderID,
		time = Arbitrage.ReturnTime(),
		data = message
	}

	local senderData = table.Copy(data)
	local targetData = table.Copy(data)
	targetData.notify = true

	messageSync(senderID, senderData, targetID, targetData)
end)

netstream.Hook("MonoPad:SendEvidence", function(client, targetID, id)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local senderID = monopad.team

	local evidence = Evidence:GetEvidence(id)
	if !evidence then return end
	if !client:HasEvidence(id) then return end

	local data = {
		type = 2,
		faction = senderID,
		time = Arbitrage.ReturnTime(),
		data = id
	}

	local senderData = table.Copy(data)
	local targetData = table.Copy(data)
	targetData.notify = true

	messageSync(senderID, senderData, targetID, targetData)
end)

netstream.Hook("MonoPad:ReadMessageEvidence", function(client, targetID, messageID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local message = nil
	if targetID > 0 then
		local targetFaction = Character.team:GetByID(targetID)
		if !targetFaction then return end

		monopad.messages[targetID] = monopad.messages[targetID] or {}
		message = monopad.messages[targetID][messageID]
	else
		message = GetNetVar("MonoPad:PublicChat", {})[messageID]
	end

	if message and message.type == 2 then
		monopad:AddEvidence(message.data)
		monopad:Sync()
	end
end)

netstream.Hook("MonoPad:ReadMessages", function(client, targetID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local targetFaction = Character.team:GetByID(targetID)
	if !targetFaction then return end

	for k, v in ipairs(monopad.messages[targetID]) do
		monopad.messages[targetID][k].notify = nil
	end
end)

netstream.Hook("MonoPad:AddCaseEvidence", function(client, caseID, evidenceID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local log = Arbitrage.GetGameLogs()[caseID]
	if !log then return end

	local state = log[3]
	if state == 1 then return end

	if !Evidence:GetEvidence(evidenceID) then return end
	if !client:HasEvidence(evidenceID) then return end

	local caseStored = monopad.caseStored
	caseStored[caseID] = caseStored[caseID] or {}

	local case = monopad.caseStored[caseID]
	case[6] = case[6] or {}

	if case[6][evidenceID] then
		case[6][evidenceID] = nil
	else
		for k, v in pairs(caseStored) do
			for k2 in pairs(v[6] or {}) do
				if k2 == evidenceID then
					caseStored[k][6][k2] = nil
				end
			end
		end

		case[6][evidenceID] = true
	end

	monopad:Sync()
end)

netstream.Hook("MonoPad:ClearCaseEvidence", function(client, caseID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local log = Arbitrage.GetGameLogs()[caseID]
	if !log then return end

	local state = log[3]
	if state == 1 then return end

	local caseStored = monopad.caseStored
	caseStored[caseID] = caseStored[caseID] or {}

	local case = monopad.caseStored[caseID]
	case[6] = {}

	monopad:Sync()
end)

netstream.Hook("MonoPad:EditCase", function(client, caseID, data)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local log = Arbitrage.GetGameLogs()[caseID]
	if !log then return end

	local state = log[3]
	if state == 1 then return end

	local m_inflictor = data[1] or nil
	local m_time = data[2] or "#monopad_gamelog_notspecified"
	local m_reason = data[3] or "#monopad_gamelog_notspecified"
	local m_place = data[4] or "#monopad_gamelog_notspecified"
	local m_found = data[5] or "#monopad_gamelog_notspecified"

	local caseStored = monopad.caseStored
	caseStored[caseID] = caseStored[caseID] or {}

	local case = monopad.caseStored[caseID]

	if !log[1] then
		if m_inflictor then
			local inflictorFaction = Character.team:GetByID(m_inflictor)

			if inflictorFaction then
				case[1] = m_inflictor
			end
		else
			case[1] = nil
		end
	end

	case[2] = m_time
	case[3] = m_reason
	case[4] = m_place
	case[5] = m_found

	monopad:Sync()
end)

netstream.Hook("MonoPad:MuteChat", function(client, chatID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local data = monopad.mutedChats
	if data[chatID] then
		data[chatID] = nil
	else
		data[chatID] = true
	end

	monopad.mutedChats = data
	monopad:Sync(nil, true)
end)




netstream.Listen("MonoPad:GetNotes", function(client)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local data = {}
	for k, v in pairs(monopad.notes) do
		data[k] = v.title
	end

	return true, data
end)

netstream.Listen("MonoPad:GetNoteDescription", function(client, id)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local note = monopad.notes[id]
	if !note then return end

	return true, note.description
end)


netstream.Listen("MonoPad:GetMessages", function(client)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local data = {}
	for k, v in pairs(Arbitrage.players) do
		local id = v.faction
		local faction = Character.team:GetByID(id)
		if !faction then continue end

		if id != monopad.team then
			data[id] = true
		end
	end

	for id in pairs(data) do
		local count = 0

		for k, v in ipairs(monopad.messages[id] or {}) do
			if v.notify and monopad.team != v.faction then
				count = count + 1
			end
		end

		data[id] = count
	end

	return true, data
end)

netstream.Listen("MonoPad:GetMessage", function(client, id)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local message = {}
	if id > 0 then
		message = monopad.messages[id]
		if !message then return end
	else
		message = GetNetVar("MonoPad:PublicChat", {})
	end

	return true, message
end)