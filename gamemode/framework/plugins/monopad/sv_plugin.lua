function MonoPad:SendNotify(client)
	if client == nil then
		for k, v in ipairs(player.GetAll()) do
			MonoPad:SendNotify(v)
		end
	else
		timer.Simple(math.random() * 3, function()
			if !IsValid(client) then return end

			if self:FindMonoPad(client) then
				if !client:IsNocliping() then
					client:EmitSound(MonoPad.sounds.notification)
				end

				netstream.Start(client, "MonoPad:Notify")
			end
		end)
	end
end

netstream.Hook("MonoPad:CreateNotes", function(client, title)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	monopad:CreateNotes(title)
	-- monopad:Sync()
end)

netstream.Hook("MonoPad:EditNotes", function(client, notesID, title, description)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	monopad:EditNotes(notesID, title, description)
	-- monopad:Sync()
end)

netstream.Hook("MonoPad:RemoveNotes", function(client, notesID)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end
	if !monopad:IsReceiver(client) then return end

	monopad:RemoveNotes(notesID)
	-- monopad:Sync()
end)


local function messageSync(senderID, senderData, targetID, targetData)
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
					MonoPad:SendNotify(v2)
				end
			end
		end
	end
end

netstream.Hook("MonoPad:SendMessage", function(client, targetID, message)
	local monopad = MonoPad:GetObject(client)
	if !monopad then return end

	local targetFaction = Character.team:GetByID(targetID)
	if !targetFaction then return end

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

	local targetFaction = Character.team:GetByID(targetID)
	if !targetFaction then return end

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

	local targetFaction = Character.team:GetByID(targetID)
	if !targetFaction then return end

	monopad.messages[targetID] = monopad.messages[targetID] or {}
	local message = monopad.messages[targetID][messageID]

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
	for k, v in ipairs(player.GetAll()) do
		local id = v:Team()
		local faction = Character.team:GetByID(id)
		if !faction then continue end

		if id != monopad.team then
			data[id] = true
		end
	end

	for id in pairs(monopad.messages) do
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

	local message = monopad.messages[id]
	if !message then return end

	return true, message
end)