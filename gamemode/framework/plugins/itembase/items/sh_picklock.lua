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
    local ITEM = ItemBase.GetBase("base_picklock")

    ITEM.name = "Отмычка"
    ITEM.description = "Отмычка для взлома дверей."
    ITEM.model = "models/weapons/w_crowbar.mdl"

    ITEM.maxuse = 2
    ITEM.hacktime = 15

    ItemBase:RegisterItem("picklock", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_picklock")

    ITEM.name = "Скелетный Ключ"
    ITEM.description = "Позволяет автоматически открыть любую дверь."
    ITEM.model = "models/weapons/w_crowbar.mdl"

    ITEM.maxuse = 999
    ITEM.hacktime = 0

    ItemBase:RegisterItem("skeletonkey", ITEM)
end
