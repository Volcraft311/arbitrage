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
    local ITEM = ItemBase.GetBase("base_note")

    ITEM.name = "Блокнот"
    ITEM.description = "Самый обычный блокнот, скорее всего содержит в себе какие-то записи."
    ITEM.model = "models/props_vtmb/dayplanner_closed.mdl"
    ITEM.icon = "danganronpa/inventory/items/notebook_paper.png"

    ItemBase:RegisterItem("notepad", ITEM)
end
