function Prone:Handle(client)
	local succ, text = self:CanHandle(client)
	if !succ then
		return client:ChatNotify(text)
	end

	if (!client.proneCD or CurTime() >= client.proneCD) then
		prone.Handle(client)

		local allow = false
		if client:IsProne() then
			if prone.CanExit(client) then
				allow = true
			end
		else
			if prone.CanEnter(client) then
				allow = true
			end
		end

		if allow then
			client.proneCD = CurTime() + 2
		end
	end
end

function Prone:KeyPressID(client, id, bIsVisibleGUI)
	if bIsVisibleGUI then return end
	if id != "prone" then return end
	if !prone then return end

	self:Handle(client)
end

netstream.Hook("Prone:Handle", function(client)
	Prone:Handle(client)
end)

hook.Add("prone.OnPlayerExitted", "Prone:OnPlayerExitted", function(client)
	timer.Simple(0.1, function()
		Character.team:EstablishHull(client)
		client:UnStuck()
	end)
end)

hook.Add("prone.OnPlayerEntered", "Prone:OnPlayerEntered", function(client)
	client:CheckStuck(0.1)
end)