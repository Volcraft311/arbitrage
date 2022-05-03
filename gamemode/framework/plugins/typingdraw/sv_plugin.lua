local PLUGIN = PLUGIN

function TypingDraw:SetTypingText(client, target, data, color)
	if !IsValid(client) then return end
	if !client:IsPlayer() then return end

	if !IsValid(target) then return end
	if !target:IsPlayer() then return end

	netstream.Start(client, "TypingDraw:SetTypingText", target, data, color)
end