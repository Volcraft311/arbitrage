do
    local ITEM = ItemBase.GetBase("base_note")

    ITEM.name = "Блокнот"
    ITEM.description = "Самый обычный блокнот, скорее всего содержит в себе какие-то записи."
    ITEM.model = "models/props_lab/clipboard.mdl"

    ItemBase:RegisterItem("notepad", ITEM)
end