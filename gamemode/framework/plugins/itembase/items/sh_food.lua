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
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Сыр"
    ITEM.description = "Классический твёрдый голландский сыр."
    ITEM.model = "models/foodnhouseholditems/cheesewheel1c.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 1
    ITEM.hunger = 10
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("cheese1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Сыр c плесенью"
    ITEM.description = "Вкуснейший дор блю, признанный годами выбор."
    ITEM.model = "models/foodnhouseholditems/cheesewheel2c.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 1
    ITEM.hunger = 12
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("cheese2", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Шоколад (Без Сахара)"
    ITEM.description = "Низкокалорийная альтернатива для любителей сладкого."
    ITEM.model = "models/foodnhouseholditems/marabou4.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 0
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("chocolate1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Шоколад"
    ITEM.description = "Классический молочный шоколад."
    ITEM.model = "models/foodnhouseholditems/marabou1.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 0
    ITEM.hunger = 7
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("chocolate2", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Шоколад с апельсином"
    ITEM.description = "Устоявшееся сочетание тёмного горького шоколада и апельсина, раскрывающее вкус с другой стороны."
    ITEM.model = "models/foodnhouseholditems/marabou2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -2
    ITEM.hunger = 6
    ITEM.sleep = 4
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("chocolate3", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Шоколад с Орео"
    ITEM.description = "Экстремально сладкий шоколад с добавлением печенья Орео."
    ITEM.model = "models/foodnhouseholditems/marabou3.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -6
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("chocolate4", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Кофе"
    ITEM.description = "Классический горячий напиток греющий душу!"
    ITEM.model = "models/themask/scenebuildthemes/groceries/sm_coffee_cup_paper_02.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 6
    ITEM.hunger = -3
    ITEM.sleep = 10
    ITEM.sound = "eating_and_drinking/drinking.wav"

    ItemBase:RegisterItem("coffee", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Хлопья"
    ITEM.description = "Скандально известные хлопья с своим прекрасным карамельным вкусом."
    ITEM.model = "models/foodnhouseholditems/applejacks.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = -3
    ITEM.hunger = 7
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/crunchy_double.wav"

    ItemBase:RegisterItem("crunch1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Кокосовое)"
    ITEM.description = "Мороженое которое можно очень редко найти, обычно нигде не продаётся."
    ITEM.model = "models/foodnhouseholditems/icecream_open6.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 5
    ITEM.hunger = 11
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_coconut", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Крем-Брюле)"
    ITEM.description = "Скандально известный вкус, порадовавший своим нежным сочетанием карамели, сливок и ванили!"
    ITEM.model = "models/foodnhouseholditems/icecream_open4.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 4.5
    ITEM.hunger = 16
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_creme_brulette", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Неаполитанское)"
    ITEM.description = "Прекрасное сочетание ванили, шоколада и клубники!"
    ITEM.model = "models/foodnhouseholditems/icecream_open1.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 2.5
    ITEM.hunger = 15
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_double", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Фисташковое)"
    ITEM.description = "Экзотический вкус фисташки с сочетанием сливок и ванили, прекрасно!"
    ITEM.model = "models/foodnhouseholditems/icecream_open5.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 5
    ITEM.hunger = 11
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_pistachio", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Клубничное)"
    ITEM.description = "Альтернативная классика, радующая большинство девушек!"
    ITEM.model = "models/foodnhouseholditems/icecream_open3.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 3.5
    ITEM.hunger = 12
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_strawberry", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мороженое (Ванильное)"
    ITEM.description = "Классический вкус который оставит неравнодушным!"
    ITEM.model = "models/foodnhouseholditems/icecream_open2.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 3.5
    ITEM.hunger = 10
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("icecream_vanilla", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Фастфудовый ужин"
    ITEM.description = "Любимые бургеры, картошечка, соус и газировка. Что может быть не так?"
    ITEM.model = "models/foodnhouseholditems/mcdmeal2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 100
    ITEM.hunger = 100
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/mcd_meal.wav"

    ItemBase:RegisterItem("mcd", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Арбуз"
    ITEM.description = "Многими любимый фрукт, известен своим сладким вкусом и низкокалорийностью."
    ITEM.model = "models/foodnhouseholditems/watermelon_unbreakable.mdl"

    ITEM.maxuse = 4
    ITEM.thirst = 2
    ITEM.hunger = 3
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating_long.wav"

    ItemBase:RegisterItem("food_melon", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Энергетик (Без Сахара)"
    ITEM.description = "Освежающий и тонизирующий энергетик, который не испортит фигуру!"
    ITEM.model = "models/foodnhouseholditems/sodacanb02.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 10
    ITEM.hunger = 0
    ITEM.sleep = 15
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("monster_low_carb", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Энергетик (С Сахаром)"
    ITEM.description = "Тонизирующий напиток, который пробудит вас от сонливости, а также даст чувство сытости!"
    ITEM.model = "models/foodnhouseholditems/sodacanb03.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 10
    ITEM.hunger = 0
    ITEM.sleep = 20
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("monster_assault", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Банка воды"
    ITEM.description = "Вода - основа жизни."
    ITEM.model = "models/props_junk/PopCan01a.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 10
    ITEM.hunger = 0
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/drinking.wav"

    ItemBase:RegisterItem("water_can", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Нутелла"
    ITEM.description = "Всемирно любимая шоколадно-ореховая паста."
    ITEM.model = "models/foodnhouseholditems/nutella.mdl"

    ITEM.maxuse = 5
    ITEM.thirst = -2
    ITEM.hunger = 7
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("nutella", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Виноград (Фиолетовый)"
    ITEM.description = "Известен как виноград \"Изабелла\", имеет достаточно интесивный вкус, по сравнению с белым виноградом. "
    ITEM.model = "models/foodnhouseholditems/grapes1.mdl"

    ITEM.maxuse = 3
    ITEM.thirst = 7
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("grape1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Виноград (Красный)"
    ITEM.description = "Один из самых полезных виноградов по содержанию витаминов."
    ITEM.model = "models/foodnhouseholditems/grapes2.mdl"

    ITEM.maxuse = 3
    ITEM.thirst = 7
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("grape2", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Виноград (Белый)"
    ITEM.description = "Виноград с самым нежным вкусом по сравнению с остальными."
    ITEM.model = "models/foodnhouseholditems/grapes3.mdl"

    ITEM.maxuse = 3
    ITEM.thirst = 7
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("grape3", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Арахисовая Паста"
    ITEM.description = "Излюбленный американцами десерт, используется с огромным спектром продуктов."
    ITEM.model = "models/foodnhouseholditems/peanut_butter.mdl"

    ITEM.maxuse = 5
    ITEM.thirst = -1
    ITEM.hunger = 6
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("peanut_butter", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Сэндвич"
    ITEM.description = "Вкусный и сытный закрытый бутерброд для любителей фастфуда и быстрых перекусов."
    ITEM.model = "models/foodnhouseholditems/sandwich.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -5 
    ITEM.hunger = 10
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("sandwich", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы со вкусом сметаны и лука"
    ITEM.description = "Прекрасная калорийная закуска из картошки со вкусом сметаны и лука!"
    ITEM.model = "models/foodnhouseholditems/chipslays4.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -4
    ITEM.hunger = 6
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_sour_cream_onion", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Печенье"
    ITEM.description = "Классическое сдобное печенье"
    ITEM.model = "models/foodnhouseholditems/digestive2.mdl"

    ITEM.maxuse = 3
    ITEM.thirst = -6
    ITEM.hunger = 6
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/crunchy_double.wav"

    ItemBase:RegisterItem("biscuits", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Печенье шоколадное"
    ITEM.description = "Печенье с добавлением какао и шоколадной глазури."
    ITEM.model = "models/foodnhouseholditems/digestive.mdl"
    ITEM.maxuse = 3
    ITEM.thirst = -4
    ITEM.hunger = 4
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/crunchy_double.wav"

    ItemBase:RegisterItem("biscuits_chocolate", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы со вкусом барбекю"
    ITEM.description = "Чёрная пачка с пряным вкусом"
    ITEM.model = "models/foodnhouseholditems/chipslays3.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -5
    ITEM.hunger = 8
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_bbq", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы со вкусом сыра"
    ITEM.description = "Яркая пачка и приятный вкус."
    ITEM.model = "models/foodnhouseholditems/chipsdoritos2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -5
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_cheese", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Острые Чипсы"
    ITEM.description = "Пачка в агрессивном красном стиле, вкус настолько острый что их можно есть наспор."
    ITEM.model = "models/foodnhouseholditems/chipsdoritos2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -5
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_diablo", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы со вкусом малосольных огурчиков"
    ITEM.description = "Болотно-зелёная пачка с изображением огурцов и укропа."
    ITEM.model = "models/foodnhouseholditems/chipslays5.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -4
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_dull_pickle", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы с солью"
    ITEM.description = "Небесно синяя пачка, с классическим солёным вкусом"
    ITEM.model = "models/foodnhouseholditems/chipsdoritos5.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -5
    ITEM.hunger = 10
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_salty", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чипсы со вкусом гуакамоле"
    ITEM.description = "Пачка в кислотно-зелёном стиле, имеют приятный запах"
    ITEM.model = "models/foodnhouseholditems/chipsdoritos6.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = -6
    ITEM.hunger = 10
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/chips.wav"

    ItemBase:RegisterItem("chips_wasabi", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Кола"
    ITEM.description = "Всемирно известный и любимый напиток."
    ITEM.model = "models/foodnhouseholditems/sodacan01.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 15
    ITEM.hunger = 7
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("cola1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Вишнёвая Кола"
    ITEM.description = "Второй по популярности напиток, знаменит эталонным вкусом и нулевым содержанием сахара."
    ITEM.model = "models/foodnhouseholditems/sodacan02.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 15
    ITEM.hunger = 0
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("cola2", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Кола (Лайф)"
    ITEM.description = "Кола с натуральными сахарозаменителями"
    ITEM.model = "models/foodnhouseholditems/sodacan03.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 15
    ITEM.hunger = 0
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("cola3", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Мохито"
    ITEM.description = "Газировка с нежным лимонно-лаймовым вкусом."
    ITEM.model = "models/foodnhouseholditems/sodacan06.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 15
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/can.wav"

    ItemBase:RegisterItem("cola4", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Печенье с шоколадными каплями"
    ITEM.description = "Излюбленное печенье американцев с кусочками шоколада"
    ITEM.model = "models/foodnhouseholditems/cookies.mdl"
    ITEM.maxuse = 3
    ITEM.thirst = -3
    ITEM.hunger = 6
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/crunchy_double.wav"

    ItemBase:RegisterItem("cookies", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Сладкий Рулет"
    ITEM.description = "Очень известный десерт, угадайте сами почему."
    ITEM.model = "models/foodnhouseholditems/sweetroll.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 0
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("sweetroll", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Красное Яблоко"
    ITEM.description = "Сладкое красное яблоко."
    ITEM.model = "models/foodnhouseholditems/apple.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 5
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("apple1", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Зелёное Яблоко"
    ITEM.description = "Кислое зелёное яблоко."
    ITEM.model = "models/foodnhouseholditems/apple1.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 3
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("apple2", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Розовое Яблоко"
    ITEM.description = "Очень редко можно найти, невероятно красивый цвет."
    ITEM.model = "models/foodnhouseholditems/apple2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 5
    ITEM.hunger = 5
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("apple3", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Ананас"
    ITEM.description = "Тропический фрукт с сладким вкусом и слегка томным послевкусием."
    ITEM.model = "models/foodnhouseholditems/pineapple.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 3
    ITEM.hunger = 6
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("pineapple", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Кола со вкусом ежевики"
    ITEM.description = "Премиальный вкус колы, продаётся за огромные суммы."
    ITEM.model = "models/foodnhouseholditems/cola_swift2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 5
    ITEM.hunger = 0
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/beerbottle.wav"

    ItemBase:RegisterItem("cola5", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Чизбургер"
    ITEM.description = "Классический чизбургер."
    ITEM.model = "models/foodnhouseholditems/burgersims2.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 0
    ITEM.hunger = 15
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("cheeseburger", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Кусок торта"
    ITEM.description = "Кусочек прекрасного торта."
    ITEM.model = "models/foodnhouseholditems/cakeslice1.mdl"

    ITEM.maxuse = 1
    ITEM.thirst = 0
    ITEM.hunger = 9
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("cakeslice", ITEM)
end

do
    local ITEM = ItemBase.GetBase("base_food")

    ITEM.name = "Блинчики"
    ITEM.description = "Блинчики с сливочным маслом, идеально."
    ITEM.model = "models/foodnhouseholditems/pancakes.mdl"

    ITEM.maxuse = 2
    ITEM.thirst = 0
    ITEM.hunger = 8
    ITEM.sleep = 0
    ITEM.sound = "eating_and_drinking/eating.wav"

    ItemBase:RegisterItem("pancakes", ITEM)
end