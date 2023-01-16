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

do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Ключи"
    ITEM.description = "Ключи от комнаты: \"%s\""
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

    ITEM:AddAction("Присвоить ключу фракцию", {
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

            local factionData = Character.team:GetByID(faction)
            if !factionData then return end

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
    ITEM.image = nil

    ITEM:AddAction("Использовать", {
        OnRun = function(item)
            local client = item.player

            local isGenocide = client:IsTokoGenocide()
            local model = isGenocide and Arbitrage.TokoModel or Arbitrage.TokoGenocideModel

            client:SetModel(model)
            Arbitrage.commands.Notify(client, "Вы сменили личность на \"" .. (isGenocide and "Токо Фукава" or "Геноцид Сё") .. "\".")

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