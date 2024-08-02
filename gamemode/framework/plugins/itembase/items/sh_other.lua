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

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Ключи"
    ITEM.description = "Ключи от комнаты: '%s'"
    ITEM.model = "models/gibs/metal_gib4.mdl"
    ITEM.category = "Уникальные"
    ITEM.icon = "danganronpa/inventory/items/key_dorms.png"

    function ITEM:GetDescription()
        local data = "Отсутствует"

        local faction = self:GetData("faction")
        if faction then
            local factionData = Character.team:GetByID(faction)

            data = factionData and factionData.name or data
        end

        return Format(self.description, data)
    end

    ITEM:AddAction("* Присвоить ключу фракцию", {
        icon = "icon16/cog.png",
        OnRun = function(item)
            local client = item.player

            netstream.Start(client, "ItemBase:OpenCreateKeyMenu", item:GetID())
            return false
        end,
        OnCanRun = function(item)
            local client = item.player
            local data = item:GetData("faction")

            return client:IsAdmin() and !data
        end
    })

    ItemBase:RegisterItem("keys", ITEM)

    if CLIENT then
        netstream.Hook("ItemBase:OpenCreateKeyMenu", function(id)
            local parent = DermaMenu()

            parent:AddOption("Уникальный идентификатор", function()
                Derma_StringRequest("Уникальный идентификатор", "Введите уникальный ID который вы хотите установить предмету", "", function(text)
                    netstream.Start("ItemBase:CreateKey", id, text)
                end)
            end)

            for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
                local panel = parent:AddOption(v.name, function()
                    netstream.Start("ItemBase:CreateKey", id, k)
                end)

                panel:SetIcon(v:GetAssets().pixel)

                for k2, v2 in ipairs(panel:GetChildren()) do
                    if v2:GetName() == "DImage" and !string.find(v2:GetImage(), "icon16/") then
                        local size = parent:GetTall() * 1.5

                        v2:SetSize(size, size)
                    end
                end
            end

            parent:Open(ScrW() / 2, ScrH() / 2)
        end)
    else
        netstream.Hook("ItemBase:CreateKey", function(client, itemID, faction)
            if !client:IsAdmin() then return end

            local item = ItemBase.instances[itemID]
            if !item then return end

            local data = item:GetData("faction")
            if data then return end

            item:SetData("faction", faction)
        end)
    end
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Ключ ко всем дверям"
    ITEM.description = "Ключи от всех дверей"
    ITEM.model = "models/gibs/metal_gib4.mdl"
    ITEM.category = "Уникальные"
    ITEM.icon = "danganronpa/inventory/items/key_dorms.png"

    ItemBase:RegisterItem("keys_all", ITEM)
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Фотография"
    ITEM.description = "Обычная фотография, на ней есть какое-то изображение"
    ITEM.model = "models/gibs/metal_gib4.mdl"
    ITEM.category = "Уникальные"
    ITEM.lawInspect = "Посмотреть"
    ITEM.image = nil
    ITEM.icon = "danganronpa/inventory/items/special_photo.png"

    ITEM:AddAction("Посмотреть", {
        icon = "icon16/page.png",
        OnRun = function(item)
            local client = item.player
            local url = item.image

            asterionlib.netgui:Create(client, "Photos:Menu", nil, "OpenData", url)

            return false
        end,
        OnCanRun = function(item)
            return item.image
        end
    })

    ITEM:AddAction("Изменить картинку", {
        icon = "icon16/page_gear.png",
        OnRun = function(item)
            local client = item.player

            netstream.Start(client, "ItemBase:OpenCreateImageMenu", item:GetID(), item.image)
            return false
        end,
        OnCanRun = function(item)
            return item.player:IsAdmin()
        end
    })

    ItemBase:RegisterItem("camera_image", ITEM)

    if CLIENT then
        netstream.Hook("ItemBase:OpenCreateImageMenu", function(itemID, oldURL)
            Derma_StringRequest("Установить изображение", "Введите URL картинки которую хотите прикрепить к фотографии", oldURL or "", function(text)
                netstream.Start("ItemBase:CreateImage", itemID, text)
            end, nil, "Установить", "Отменить")
        end)
    else
        netstream.Hook("ItemBase:CreateImage", function(client, itemID, url)
            if !client:IsAdmin() then return end

            local item = ItemBase.instances[itemID]
            if !item then return end

            item.image = url
        end)
    end
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Шокер"
    ITEM.description = "Уникальный тазер Токо Фукавы, которым она приручила свою вторую личность «Геноцид Сё». В экстренных случаях он может быть использован для намеренной смены личности."
    ITEM.model = "models/weapons/w_alyx_gun.mdl"
    ITEM.category = "Уникальные"
    ITEM.icon = "https://cdn-icons-png.flaticon.com/512/7991/7991337.png"

    ITEM:AddAction("Использовать", {
        icon = "icon16/tick.png",
        OnRun = function(item)
            local client = item.player

            local isGenocide = client:IsTokoGenocide()
            local model = isGenocide and Arbitrage.TokoModel or Arbitrage.TokoGenocideModel

            client:SetModel(model)
            Arbitrage.commands.Notify(client, "Вы сменили личность на '" .. (isGenocide and "Токо Фукава" or "Геноцид Сё") .. "'.")

            return false
        end,
        OnCanRun = function(item)
            local client = item.player

            return client:IsToko()
        end
    })

    ItemBase:RegisterItem("toko_shocker", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Монопад"
    ITEM.icon = "https://cdn-icons-png.flaticon.com/512/8818/8818724.png"
    ITEM.description = "Самый обычный планшет."
    ITEM.model = "models/props_junk/cardboard_box004a.mdl"
    ITEM.class = "academy_monopad"

    ITEM:HookAdd("equip", function(item, client)
        if !item.stored then
            local monopad = MonoPad:New(item:GetID())
            monopad:SetOwner(client)

            client:ChatNotify("Данный монопад еще никто не запускал! Вы были установлены как его владелец.")
            item.stored = monopad
        end

        local object = item.stored
        object:Sync()
        object:SyncHistory()
    end)

    function ITEM:GetName()
        local object = self.stored
        if object then
            local faction = Character.team:GetByID(object:GetTeam())

            return self.name .. " " .. faction:GetName()
        end

        return self.name
    end

    ItemBase:RegisterItem("monopad", ITEM)
end

local function findTarget(client)
    local data = {}
    data.start = client:GetShootPos()
    data.endpos = data.start + client:GetAimVector() * 84
    data.filter = {client}

    local trace = util.TraceLine(data)
    local entity = trace.Entity

    if IsValid(entity) and entity:IsPlayer() then
        return entity
    end
end

local cuffTime = 5
local function cuff(item, ropeLength)
    local client = item.player

    local target = findTarget(client)
    if !IsValid(target) then Arbitrage.commands.Notify(client, "Не валидный игрок") return false end

    Arbitrage.action.ActionRun(target, "Вас связывают", cuffTime, function()
        if findTarget(client) != target then return true end

        return false
    end, function()
    end)

    for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, "Связывает '" .. target:Name() .. "'", Color(255, 170, 23))
    end

    Arbitrage.action.ActionRun(client, "Связываем", cuffTime, function()
        if findTarget(client) != target then return true end

        if (!client.CuffindCD or CurTime() >= client.CuffindCD) then
            client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)
            client:EmitSound("physics/cardboard/cardboard_box_impact_soft" .. math.random(1, 6) .. ".wav")
            client.CuffindCD = CurTime() + 1.5
        end

        return false
    end, function(activator)
        local wep = target:Give("weapon_handcuffed")
        wep:SetCuffStrength(1.0)
        wep:SetCuffRegen(1.6)

        wep:SetCuffMaterial("models/props_pipes/GutterMetal01a")
        wep:SetRopeMaterial("cable/red")

        wep:SetKidnapper(client)
        wep:SetRopeLength(ropeLength)

        wep:SetCanBlind(false)
        wep:SetCanGag(false)
        wep:SetIsUnbreakable(true)

        item:Remove()
    end)
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Стяжки"
    ITEM.icon = "https://cdn-icons-png.flaticon.com/512/3365/3365759.png"
    ITEM.description = "Ими можно попробовать кого-то связать."
    ITEM.model = "models/props_lab/box01a.mdl"
    ITEM.category = "Наручники"

    ITEM:AddAction("Связать", {
        icon = "icon16/tick.png",
        OnRun = function(item)
            cuff(item, 0)

            return false
        end
    })

    ItemBase:RegisterItem("cuff", ITEM)
end

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Стяжки с веревкой"
    ITEM.icon = "https://cdn-icons-png.flaticon.com/512/4664/4664962.png"
    ITEM.description = "Ими можно попробовать кого-то связать."
    ITEM.model = "models/props_lab/box01a.mdl"
    ITEM.category = "Наручники"

    ITEM:AddAction("Связать", {
        icon = "icon16/tick.png",
        OnRun = function(item)
            cuff(item, 100)

            return false
        end
    })

    ItemBase:RegisterItem("cuff_rope", ITEM)
end



do
    local ITEM = ItemBase.GetBase()

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_basic", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_medical", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_food", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_ammo", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_note")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_note", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_picklock")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_picklock", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_weapon", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_stack")

    ITEM.name = ""
    ITEM.description = ""
    ITEM.category = "Converter"

    ItemBase:RegisterItem("converter_stack", ITEM)
end