do
    local ITEM = ItemBase.GetBase()

    ITEM.name = "Test"
    ITEM.description = "Test test"
    ITEM.model = "models/props_c17/oildrum001.mdl"

    ITEM:AddAction("Абоба", {
        icon = "icon16/world.png",
        OnRun = function(item)
            print(item.player)
            print("Hi!")
        end,
        OnCanRun = function(item)
            return true
        end
    })

    ItemBase:RegisterItem("test", ITEM)
end