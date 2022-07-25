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
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Патроны 9mm Para"
    ITEM.description = "Коробка с 15-ью патронами 9mm Para."
    ITEM.model = "models/items/boxsrounds.mdl"

    ITEM.ammoClass = "pistol"
    ITEM.ammoAmount = 15

    ItemBase:RegisterItem("ammo_pistol", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Патроны .357 Magnum"
    ITEM.description = "Коробка с патронами для магнума."
    ITEM.model = "models/items/357ammo.mdl"

    ITEM.ammoClass = "357"
    ITEM.ammoAmount = 6

    ItemBase:RegisterItem("ammo_357", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Патроны для ПП"
    ITEM.description = "Пехотный контейнер с аммуницией, наполненный мелкокалиберными патронами."
    ITEM.model = "models/items/boxmrounds.mdl"

    ITEM.ammoClass = "smg1"
    ITEM.ammoAmount = 40

    ItemBase:RegisterItem("ammo_smg1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Картечь 12x7mm"
    ITEM.description = "Коробка с патронами 12-го калибра."
    ITEM.model = "models/items/boxbuckshot.mdl"

    ITEM.ammoClass = "buckshot"
    ITEM.ammoAmount = 7

    ItemBase:RegisterItem("ammo_buckshot", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Магазин с инопланетной системой заражания"
    ITEM.description = "Хранит в себе картриджи, выстреливающие тёмной энергией."
    ITEM.model = "models/items/combine_rifle_cartridge01.mdl"

    ITEM.ammoClass = "ar2"
    ITEM.ammoAmount = 40

    ItemBase:RegisterItem("ammo_ar2", ITEM)
end
