netstream.Hook("AfkDraw:HideGame", function(client)
	if client:IsAFK() then return end

	client:SetNetVar("afk", true)
end)

netstream.Hook("AfkDraw:UnHideGame", function(client)
	if !client:IsAFK() then return end

	client:SetNetVar("afk", nil)
end)