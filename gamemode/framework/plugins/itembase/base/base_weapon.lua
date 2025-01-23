--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
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

BASE.creationExample = {
	{
	    variable = "category",
	    title = "Категория",
	    default = "Оружие"
	},
	{
		variable = "class",
		title = "Класс оружия",
		default = "weapon_pistol"
	}
}

BASE.propertiesInfo = {
	{"class", "Класс оружия", function(a)
	    return a:GetClass()
	end},
	{"ammoClip", "Патрон в магазине", function(a)
	    return a:GetAmmoClip()
	end, function(a, b, c)
	    a:SetData("ammoClip", tonumber(c))
	    a:SetData("m_ammoClip", nil)
	end},
}

function BASE:Tooltip(tooltip)
	tooltip:SetTitle(self:GetName())
	tooltip:SetDescription(self:GetDescription())
	tooltip:SetIcon("asterion/academy/ui/tooltip/melee.png")

	local amount = tonumber(self:GetData("ammoClip", 0))

	if amount > 0 then
		tooltip:AddSubMenu("Количество патрон: " .. amount)
	end
end

function BASE:GetClass()
	return self:GetData("m_class", self.class)
end

function BASE:GetAmmoClip()
	return self:GetData("ammoClip", 0)
end

if CLIENT then
	local ribbon = Material("danganronpa/ribbon/orange.png")

	function BASE:Paint(item, w, h)
		if item:GetData("equip") then
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(ribbon)
			surface.DrawTexturedRect(0, 0, w, h)
		else
			local amount = item:GetAmmoClip()

			if amount > 0 then
	        	draw.SimpleTextOutlined(amount, "DermaDefault", w - 5, h - 15, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
	    	end
		end
	end
end

function BASE:GetDescription()
	local description = self:GetData("m_description", self.description)
	local amount = tonumber(self:GetData("ammoClip", 0))

	if amount > 0 then
		return description .. " Количество патрон: " .. amount
	end

	return description
end

function BASE:Equip(client, item, id)
	if id < 1 or id > 4 then return end

	client.carryWeapons = client.carryWeapons or {}

	local items = client:GetInventory():GetItems()
	local class = item:GetClass()

	for _, v in pairs(items) do
		if v.id != item.id then
			local itemTable = ItemBase.instances[v.id]

			if itemTable and itemTable.isWeapon and client.carryWeapons[class] and itemTable:GetData("equip") then
				return Arbitrage.commands.Notify(client, "У вас уже экипированно оружие данного типа!")
			end
		end
	end

	if client:HasWeapon(class) then
		client:StripWeapon(class)
	end

	local saveAmmoTable = client:GetAmmo() -- копия всех патрон
	local weapon = client:Give(class, true)

	if IsValid(weapon) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[class] = weapon

		client:SetLocalVar("fast_slot_" .. id, {
			weapon,
			item:GetID()
		})

		-- некоторые паки оружия выдают патроны при эквипе, по этому сохраняет копию и после выдаем ее обратно
		client:RemoveAmmo(weapon:Clip1(), ammoType)
		client:SetAmmo(0, ammoType)
		weapon:SetClip1(0)

		for k, v in pairs(saveAmmoTable) do
			client:SetAmmo(v, k)
		end

		local count = item:GetData("ammoClip", 0)
		if count > 0 then
			weapon:SetClip1(count)
		end

		item:SetData("equip", true)
		item.slotID = id

		item:HookRun("equip", client)
	end

	TypingDraw:SendSphere(0.5, client, "Экипирует '" .. item:GetName() .. "'", Color(255, 170, 23))
end

function BASE:UnEquip(client, item)
	local id = item.slotID
	if !id then return end

	client.carryWeapons = client.carryWeapons or {}
	local data = client:GetLocalVar("fast_slot_" .. id)
	local weapon = data and data[1]
	local class = item:GetClass()

	if !IsValid(weapon) then
		weapon = client:GetWeapon(class)
	end

	if IsValid(weapon) then
		client:StripWeapon(class)
		item:SetData("ammoClip", weapon:Clip1())
	end

	client.carryWeapons[class] = nil
	client:SetLocalVar("fast_slot_" .. id, nil)
	item:SetData("equip", nil)
	item.slotID = nil

	item:HookRun("unequip", client)
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

	if item:GetData("equip") then
		item:UnEquip(item.player, item)
	end
end)

BASE:HookAdd("transferOtherInventory", function(item, old, new)
	local client = FindClient(old:GetOwner())
	if !IsValid(client) then return end

	if item:GetData("equip") then
		item:UnEquip(client, item)
	end
end)

BASE:AddAction("Снять", {
	icon = "icon16/wand.png",
	OnRun = function(item)
		item:UnEquip(item.player, item, 1)
	    return false
	end,
	OnCanRun = function(item)
	    return !IsValid(item.entity) and item:GetData("equip")
	end
})

BASE:AddAction("Разоружить", {
	icon = "icon16/chart_organisation.png",
	OnRun = function(item)
		local client = item.player

		local weapon = nil
		for k, v in ipairs(weapons.GetList()) do
			if v.ClassName == item:GetClass() then
				weapon = v
				break
			end
		end
		if !weapon then return false end

		local name = weapon.Primary and weapon.Primary.Ammo
		if !name then return false end

		local amount = item:GetData("ammoClip", 0)
		if amount <= 0 then return false end

		local itemsAmmo = {}
	    for k, v in pairs(ItemBase.list) do
	        if v.base == "base_ammo" and v.uniqueID != "converter_ammo" then
	            itemsAmmo[string.lower(v.ammoClass)] = k
	        end
	    end

	    local uniqueID = itemsAmmo[string.lower(name)]
	    if !uniqueID then return false end

	    local item2 = ItemBase.CreateItem(uniqueID)
	    item2:SetData("amount", amount)

	    local notify = item2:Transfer(client:GetInventory():GetID())
	    if notify then
	        item2:Spawn(client:GetPos() + Vector(0, 0, 20))
	    end

	    item:SetData("ammoClip", 0)
	    client:ChatNotify("Вы успешно вытащили патроны из " .. item:GetName() .. "!")

	    return false
	end,
	OnCanRun = function(item)
	    return !IsValid(item.entity) and !item:GetData("equip") and item:GetData("ammoClip", 0) > 0
	end
})

ItemBase:RegisterBase("base_weapon", BASE)