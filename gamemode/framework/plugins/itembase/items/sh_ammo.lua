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

    ITEM.name = "Пули для 9мм Пистолета"
    ITEM.description = "Контейнер, заполненный пулями и 9мм напечатаны на стороне."
    ITEM.model = "models/items/boxsrounds.mdl"

    ITEM.ammoClass = "pistol"
    ITEM.ammoAmount = 20

    ItemBase:RegisterItem("ammo_pistol", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Пули для Магнума .357"
    ITEM.description = "Маленькая коробочка с пулями для магнума на боку."
    ITEM.model = "models/items/357ammo.mdl"

    ITEM.ammoClass = "357"
    ITEM.ammoAmount = 21

    ItemBase:RegisterItem("ammo_357", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Пули для ПП"
    ITEM.description = "Тяжелый контейнер, наполненный множеством пуль."
    ITEM.model = "models/items/boxmrounds.mdl"

    ITEM.ammoClass = "smg1"
    ITEM.ammoAmount = 30

    ItemBase:RegisterItem("ammo_smg1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Картечь"
    ITEM.description = "Красная коробка с картечью."
    ITEM.model = "models/items/boxbuckshot.mdl"

    ITEM.ammoClass = "buckshot"
    ITEM.ammoAmount = 16

    ItemBase:RegisterItem("ammo_buckshot", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_ammo")

    ITEM.name = "Импульсно-винтовочная энергия"
    ITEM.description = "Картридж с голубым свечением."
    ITEM.model = "models/items/combine_rifle_cartridge01.mdl"

    ITEM.ammoClass = "ar2"
    ITEM.ammoAmount = 30

    ItemBase:RegisterItem("ammo_ar2", ITEM)
end