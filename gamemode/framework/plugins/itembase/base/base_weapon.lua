local BASE = ItemBase.GetBase()

BASE.name = "База Оружия"
BASE.description = ""
BASE.category = "Оружие"

BASE:AddAction("Использовать", {
    icon = "icon16/world.png",
    OnRun = function(item)

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_weapon", BASE)