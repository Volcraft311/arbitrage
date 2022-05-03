--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.weapon = Arbitrage.library.Add("weapon")
Arbitrage.weapon.views = {}
Arbitrage.weapon.ignoring = {}

function Arbitrage.weapon.Drop(client)
	if !IsValid(client) then return end
	if !client:Alive() then return end

	local weapon = client:GetActiveWeapon()
	if !IsValid(weapon) then return end

	local class = weapon:GetClass()
	local model = weapon:GetWeaponWorldModel()
	local _type = Arbitrage.weapon.views[class]

	if _type then
		if class == "weapon_flashlight" or class == "buu_lantern" or class == "buu_lantern_oil" then
			weapon:Holster()
		end

		local dropPos = client:GetPos() + Vector(0, 0, 35) + client:GetAngles():Forward() * 8

		local entity = ents.Create( "arb_weapon" )
		entity:SetPos(dropPos)
		entity:SetModel(model)
		entity:SetType(_type)
		entity:SetClassARB(class)

		entity:Spawn()

		client:StripWeapon(class)

		client.weapons = client.weapons or {}
		client.weapons[_type] = nil

		netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_DROP, true)
	else
		return "Вы не можете выбросить данное оружие!"
	end
end

function Arbitrage.weapon.Add(class, _type, data)
	Arbitrage.weapon.views[class] = _type

	if data then
		Arbitrage.weapon.ignoring[class] = true
	end
end