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
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Банка биогеля"
    ITEM.description = "Стеклянная банка с пластиковой крышкой, внутри которой находится зеленая жидкость."
    ITEM.model = "models/healthvial.mdl"

    ITEM.health = 15
    ITEM.maxuse = 2
    ITEM.sound = "items/medshot4.wav"

    ItemBase:RegisterItem("biogel", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Медицинский шприц"
    ITEM.description = "Белый шприц с красным крестом на корпусе и зелёной жидкостью внутри. По нажатию кнопки выпускает иглу, вводит содержимое как только крючок на конце чувствует давление."
    ITEM.model = "models/healthvial.mdl"

    ITEM.health = 33
    ITEM.maxuse = 1
    ITEM.sound = "items/medshot4.wav"

    ItemBase:RegisterItem("health_vial", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Аптечка"
    ITEM.description = "Пластиковая конструкция с красным крестом посередине, внутри которой находятся флакон биогеля, бинты и различные таблетки."
    ITEM.model = "models/Items/HealthKit.mdl"

    ITEM.health = 20
    ITEM.maxuse = 3
    ITEM.sound = "items/medshot4.wav"

    ItemBase:RegisterItem("medkit", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Анальгин"
    ITEM.description = "Востребованный болеутоляющий препарат с широким спектром применения."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/analgin.mdl"

    ITEM.health = 15
    ITEM.maxuse = 5
    ITEM.sound = "weapons/smg1/switch_burst.wav"

    ItemBase:RegisterItem("analgin", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Адреналин"
    ITEM.description = "Считается средством выбора при всех видах остановки сердца. Имеет эффект привыкания."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/adrenaline.mdl"

    ITEM.health = 70
    ITEM.maxuse = 1
    ITEM.sound = "weapons/crossbow/bolt_skewer1.wav"

    ItemBase:RegisterItem("adrenalin", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Хирургический набор"
    ITEM.description = "Полевой хирургический набор. В комплекте имеется ряд приспособлений для проведения полевых операций."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/automedkit.mdl"

    ITEM.health = 40
    ITEM.maxuse = 2
    ITEM.sound = "items/medshot4.wav"

    ItemBase:RegisterItem("hirurg", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Вакцина"
    ITEM.description = "Укол вакцины, спасающий от заражения на ранних стадиях."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/sj1.mdl"

    ITEM.health = 10
    ITEM.maxuse = 1
    ITEM.sound = "weapons/crossbow/bolt_skewer1.wav"

    ItemBase:RegisterItem("vaczine", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Бинт"
    ITEM.description = "Стерильный бинт, которым можно остановить кровотечение."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/bandage_army.mdl"

    ITEM.health = 10
    ITEM.maxuse = 5
    ITEM.sound = "npc/fast_zombie/claw_strike1.wav"

    ItemBase:RegisterItem("bint", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_medical")

    ITEM.name = "Вазелин"
    ITEM.description = "Довольно популярное средство. Оказывает на кожу смягчающее действие."
    ITEM.model = "models/carlsmei/escapefromtarkov/medical/vaselin.mdl"

    ITEM.health = 15
    ITEM.maxuse = 5
    ITEM.sound = "npc/barnacle/barnacle_crunch3.wav"

    ItemBase:RegisterItem("vazelin", ITEM)
end
