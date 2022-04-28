do
    local ITEM = ItemBase.GetBase("base_weapon")

    ITEM.name = "Test"
    ITEM.description = "Test"
    ITEM.model = "models/weapons/w_pistol.mdl"

    ItemBase:RegisterItem("test_weapon", ITEM)
end