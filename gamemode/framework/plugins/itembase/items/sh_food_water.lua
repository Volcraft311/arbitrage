local ITEM = ItemBase.GetBase("base_food")

ITEM.name = "Банка воды"
ITEM.description = "Типо описание"
ITEM.model = "models/props_junk/PopCan01a.mdl"

ITEM.maxuse = 3
ITEM.thirst = 10
ITEM.hunger = 10
ITEM.sleep = 10
ITEM.sound = "garrysmod/ui_click.wav"

ItemBase:RegisterItem("food_water", ITEM)