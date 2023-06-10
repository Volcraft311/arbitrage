local PLUGIN = PLUGIN
Prone = PLUGIN

Prone.name = "Prone"

function Prone:CanHandle(client)
	if Arbitrage.lawEnable then return false, "Вы не можете лечь во время суда!" end

	if !client:IsProne() then
		local seq = client:GetAction()
		if seq then return false, "Вы находитесь в анимации!" end
	end

	local info = Character.team:GetByID(client:Team())

	if info then
		return info.allowProne == nil and true or info.allowProne, "Вы не можете лечь за данного персонажа!"
	end

	return true
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")