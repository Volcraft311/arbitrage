local ITEM = ItemBase.GetBase("base_food")

ITEM.name = "Арбуз"
ITEM.description = "Это арбуз да!"
ITEM.model = "models/props_junk/watermelon01.mdl"

ITEM.maxuse = 5
ITEM.thirst = 2
ITEM.hunger = 3
ITEM.sleep = 0
ITEM.sound = "garrysmod/ui_click.wav"

ItemBase:RegisterItem("food_melon", ITEM)