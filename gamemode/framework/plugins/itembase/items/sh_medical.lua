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

    ITEM.health = 20
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

    ITEM.health = 30
    ITEM.maxuse = 3
    ITEM.sound = "items/medshot4.wav"

    ItemBase:RegisterItem("medkit", ITEM)
end