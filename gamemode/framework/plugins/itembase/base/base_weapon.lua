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


local BASE = ItemBase.GetBase()

BASE.name = "База Оружия"
BASE.description = ""
BASE.category = "Оружие"
BASE.model = "models/weapons/w_pistol.mdl"
BASE.class = "weapon_pistol"
BASE.isWeapon = true

if CLIENT then
	local ribbon = Material("danganronpa/inventory/ribbon.png")

	function BASE:Paint(item, w, h)
		if item:GetData("equip") then
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(ribbon)
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
end

function BASE:Equip(client, item, id)
	if id < 1 or id > 4 then return end

	client.carryWeapons = client.carryWeapons or {}

	local items = client:GetInventory():GetItems()

	for _, v in pairs(items) do
		if v.id != item.id then
			local itemTable = ItemBase.instances[v.id]

			if itemTable and itemTable.isWeapon and client.carryWeapons[item.class] and itemTable:GetData("equip") then
				return Arbitrage.commands.Notify(client, "У вас уже экипированно оружие данного типа!")
			end
		end
	end


	local class = item.class
	if client:HasWeapon(class) then
		client:StripWeapon(class)
	end

	local weapon = client:Give(class)

	if IsValid(weapon) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[item.class] = weapon

		client:SetNetVar("fast_slot_" .. id, {
			weapon,
			item:GetID()
		}, client)

		if client:GetAmmoCount(ammoType) == weapon:Clip1() and item:GetData("ammo", 0) == 0 then
			client:RemoveAmmo(weapon:Clip1(), ammoType)
		end

		if weapon:GetMaxClip1() == -1 and weapon:GetMaxClip2() == -1 and client:GetAmmoCount(ammoType) == 0 then
			client:SetAmmo(1, ammoType)
		end

		item:SetData("equip", true)
		weapon:SetClip1(item:GetData("ammo", 0))
		item.slotID = id
	end
end

function BASE:UnEquip(client, item)
	local id = item.slotID
	if !id then return end

	client.carryWeapons = client.carryWeapons or {}
	local data = client:GetNetVar("fast_slot_" .. id)
	local weapon = data and data[1]

	if !IsValid(weapon) then
		weapon = client:GetWeapon(item.class)
	end

	if IsValid(weapon) then
		item:SetData("ammo", weapon:Clip1())
		client:StripWeapon(item.class)
	end

	client.carryWeapons[item.class] = nil
	client:SetNetVar("fast_slot_" .. id, nil, client)
	item:SetData("equip", nil)
	item.slotID = nil
end

local function FindClient(owner)
	for k, v in ipairs(player.GetAll()) do
		if v == owner then
			return v
		end
	end
end

BASE:HookAdd("drop", function(item)
	local inventory = item:GetInventory()
	if !inventory then return end

	local client = FindClient(inventory:GetOwner())
	if !IsValid(client) then return end

	if item:GetData("equip") then
		item:UnEquip(item.player, item)
	end
end)

BASE:AddAction("Снять", {
	OnRun = function(item)
		item:UnEquip(item.player, item, 1)
	    return false
	end,
	OnCanRun = function(item)
	    return !IsValid(item.entity) and item:GetData("equip")
	end
})

ItemBase:RegisterBase("base_weapon", BASE)