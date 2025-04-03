--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
Container = PLUGIN

Container.presets = {
    medical_small = {
        name = "Малая медицинская аптечка",
        description = "Небольшой набор для первой помощи.",
        type = "medical",
        items = {
            { id = "medical_biogel" },
            { id = "medical_bandage" },
        },
        size = { w = 2, h = 2 }
    },
    medical_medium = {
        name = "Средняя медицинская аптечка",
        description = "Набор для лечения небольших ранений.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_painkillers" },
            { id = "medical_bandage" },
        },
        size = { w = 3, h = 2 }
    },
    medical_large = {
        name = "Большая медицинская аптечка",
        description = "Полный набор для серьёзных ранений.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
            { id = "medical_tablets" },
            { id = "medical_bandage" },
        },
        size = { w = 4, h = 3 }
    },
    weapon_pistol_basic = {
        name = "Базовый пистолетный набор",
        description = "Пистолет с небольшим количеством патронов.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_m92fs" },
            { id = "ammo_pistol" },
        },
        size = { w = 3, h = 2 }
    },
    weapon_pistol_advanced = {
        name = "Расширенный пистолетный набор",
        description = "Пистолет с запасом патронов.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_1911" },
            { id = "ammo_pistol" },
            { id = "ammo_pistol" },
        },
        size = { w = 4, h = 2 }
    },
    weapon_revolver_set = {
        name = "Набор с револьвером",
        description = "Револьвер и патроны к нему.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_sw686" },
            { id = "ammo_357" },
        },
        size = { w = 3, h = 2 }
    },
    weapon_shotgun_basic = {
        name = "Базовый набор с дробовиком",
        description = "Дробовик и патроны.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_870" },
            { id = "ammo_buckshot" },
        },
        size = { w = 4, h = 2 }
    },
    weapon_shotgun_advanced = {
        name = "Расширенный набор с дробовиком",
        description = "Дробовик и большой запас патронов.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_500a" },
            { id = "ammo_buckshot" },
            { id = "ammo_buckshot" },
        },
        size = { w = 5, h = 2 }
    },
    weapon_rifle_basic = {
        name = "Базовый набор с винтовкой",
        description = "Винтовка и патроны.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_sako" },
            { id = "ammo_sniper" },
        },
        size = { w = 4, h = 2 }
    },
    weapon_rifle_advanced = {
        name = "Расширенный набор с винтовкой",
        description = "Винтовка и большой запас патронов.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_sako_is" },
            { id = "ammo_sniper" },
            { id = "ammo_sniper" },
        },
        size = { w = 5, h = 2 }
    },
    weapon_smg_basic = {
        name = "Базовый набор с ПП",
        description = "Пистолет-пулемёт и патроны.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_mp5" },
            { id = "ammo_smg1" },
        },
        size = { w = 4, h = 2 }
    },
    weapon_smg_advanced = {
        name = "Расширенный набор с ПП",
        description = "Пистолет-пулемёт и большой запас патронов.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_mac10" },
            { id = "ammo_smg1" },
            { id = "ammo_smg1" },
        },
        size = { w = 5, h = 2 }
    },
    weapon_rifle_ar = {
        name = "Набор с автоматом",
        description = "Автомат и патроны.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_m16_ch" },
            { id = "ammo_ar2" },
        },
        size = { w = 4, h = 2 }
    },
    weapon_melee_knife = {
        name = "Набор с ножом",
        description = "Кухонный нож для ближнего боя.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_kknife" },
        },
        size = { w = 2, h = 1 }
    },
    weapon_melee_axe = {
        name = "Набор с топором",
        description = "Топор для рубки и самообороны.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_fireaxe" },
        },
        size = { w = 3, h = 1 }
    },
    weapon_melee_crowbar = {
        name = "Набор с ломом",
        description = "Лом для вскрытия дверей.",
        type = "weapons",
        items = {
            { id = "weapon_nmrih_crowbar" },
        },
        size = { w = 3, h = 1 }
    },
    tool_basic = {
        name = "Базовый набор инструментов",
        description = "Набор для ремонта и вскрытия.",
        type = "tools",
        items = {
            { id = "weapon_nmrih_wrench" },
            { id = "picklock_picklock" },
        },
        size = { w = 3, h = 2 }
    },
    tool_advanced = {
        name = "Расширенный набор инструментов",
        description = "Набор для сложных задач.",
        type = "tools",
        items = {
            { id = "weapon_nmrih_fubar" },
            { id = "picklock_picklock" },
            { id = "picklock_skeletonkey" },
        },
        size = { w = 4, h = 2 }
    },
    food_snack_small = {
        name = "Легкий перекус",
        description = "Небольшой набор еды.",
        type = "food",
        items = {
            { id = "food_apple1" },
            { id = "food_biscuits" },
        },
        size = { w = 2, h = 2 }
    },
    food_snack_medium = {
        name = "Средний набор еды",
        description = "Еда на несколько приёмов.",
        type = "food",
        items = {
            { id = "food_sandwich" },
            { id = "food_cola1" },
            { id = "food_chocolate1" },
        },
        size = { w = 3, h = 2 }
    },
    food_snack_large = {
        name = "Большой набор еды",
        description = "Запас еды на долгое время.",
        type = "food",
        items = {
            { id = "food_cheeseburger" },
            { id = "food_cola2" },
            { id = "food_chocolate2" },
            { id = "food_pancakes" },
        },
        size = { w = 4, h = 3 }
    },
    drink_water = {
        name = "Набор с водой",
        description = "Бутылки с водой.",
        type = "food",
        items = {
            { id = "food_water_can" },
            { id = "food_water_can" },
        },
        size = { w = 2, h = 2 }
    },
    drink_soda = {
        name = "Набор с газировкой",
        description = "Разные виды газировки.",
        type = "food",
        items = {
            { id = "food_cola1" },
            { id = "food_cola2" },
            { id = "food_cola3" },
        },
        size = { w = 3, h = 2 }
    },
    drink_alcohol = {
        name = "Набор с алкоголем",
        description = "Алкогольные напитки.",
        type = "food",
        items = {
            { id = "food_pivo" },
        },
        size = { w = 2, h = 2 }
    },
    docs_basic = {
        name = "Базовый набор документов",
        description = "Несколько важных бумаг.",
        type = "documents",
        items = {
            { id = "note_newspaper" },
            { id = "note_notepad" },
        },
        size = { w = 2, h = 2 }
    },
    docs_advanced = {
        name = "Расширенный набор документов",
        description = "Архив с документами.",
        type = "documents",
        items = {
            { id = "note_document" },
            { id = "note_book1" },
            { id = "note_paper" },
        },
        size = { w = 3, h = 2 }
    },
    container_bag_small = {
        name = "Небольшая сумка",
        description = "Маленький контейнер для вещей.",
        type = "container",
        items = {
            { id = "bag_wallet" },
        },
        size = { w = 2, h = 2 }
    },
    container_bag_medium = {
        name = "Рюкзак",
        description = "Средний контейнер для вещей.",
        type = "container",
        items = {
            { id = "bag_backpackk" },
        },
        size = { w = 3, h = 3 }
    },
    container_bag_large = {
        name = "Чемодан",
        description = "Большой контейнер для вещей.",
        type = "container",
        items = {
            { id = "bag_suitcase" },
        },
        size = { w = 4, h = 3 }
    },
    food_snack_quick = {
        name = "Быстрый перекус",
        description = "Еда для быстрого утоления голода.",
        type = "food",
        items = {
            { id = "food_biscuits" },
            { id = "food_cookies" },
        },
        size = { w = 2, h = 1 }
    },
    food_snack_sweet = {
        name = "Сладкий перекус",
        description = "Набор сладостей.",
        type = "food",
        items = {
            { id = "food_chocolate1" },
            { id = "food_chocolate2" },
            { id = "food_sweetroll" },
        },
        size = { w = 3, h = 1 }
    },
    food_snack_chips = {
        name = "Набор чипсов",
        description = "Разные виды чипсов.",
        type = "food",
        items = {
            { id = "food_chips_cheese" },
            { id = "food_chips_bbq" },
            { id = "food_chips_sour_cream_onion" },
        },
        size = { w = 3, h = 1 }
    },
    food_fastfood_burger = {
        name = "Бургер-сет",
        description = "Гамбургер и напиток.",
        type = "food",
        items = {
            { id = "food_cheeseburger" },
            { id = "food_cola1" },
        },
        size = { w = 2, h = 2 }
    },
    food_fastfood_hotdog = {
        name = "Хот-дог с напитком",
        description = "Хот-дог и газировка.",
        type = "food",
        items = {
            { id = "food_hot_dog" },
            { id = "food_cola2" },
        },
        size = { w = 2, h = 2 }
    },
    food_fastfood_mcd = {
        name = "Комбо-обед",
        description = "Полноценный обед из фастфуда.",
        type = "food",
        items = {
            { id = "food_mcd" },
            { id = "food_cola3" },
        },
        size = { w = 3, h = 2 }
    },
    food_fruits_basic = {
        name = "Фруктовая корзина",
        description = "Свежие фрукты.",
        type = "food",
        items = {
            { id = "food_apple1" },
            { id = "food_apple2" },
            { id = "food_grape1" },
        },
        size = { w = 3, h = 1 }
    },
    food_fruits_exotic = {
        name = "Экзотические фрукты",
        description = "Редкие фрукты.",
        type = "food",
        items = {
            { id = "food_pineapple" },
            { id = "food_food_melon" },
        },
        size = { w = 4, h = 2 }
    },
    food_vegetables = {
        name = "Овощной набор",
        description = "Свежие овощи.",
        type = "food",
        items = {
            { id = "food_pumpkin" },
            { id = "food_egg" },
        },
        size = { w = 3, h = 2 }
    },
    food_drinks_soda = {
        name = "Набор газировки",
        description = "Разные виды газированных напитков.",
        type = "food",
        items = {
            { id = "food_cola1" },
            { id = "food_cola2" },
            { id = "food_cola3" },
        },
        size = { w = 3, h = 1 }
    },
    food_drinks_juice = {
        name = "Набор соков",
        description = "Фруктовые соки.",
        type = "food",
        items = {
            { id = "food_orangejuice" },
            { id = "food_water_can" },
        },
        size = { w = 2, h = 1 }
    },
    food_drinks_energy = {
        name = "Энергетики",
        description = "Напитки для бодрости.",
        type = "food",
        items = {
            { id = "food_monster_assault" },
            { id = "food_monster_low_carb" },
        },
        size = { w = 2, h = 1 }
    },
    food_drinks_alcohol_light = {
        name = "Лёгкий алкоголь",
        description = "Пиво и слабоалкогольные напитки.",
        type = "food",
        items = {
            { id = "food_pivo" },
        },
        size = { w = 2, h = 1 }
    },
    food_drinks_alcohol_strong = {
        name = "Крепкий алкоголь",
        description = "Набор для вечеринки.",
        type = "food",
        items = {
            { id = "food_pivo" },
            { id = "food_pivo" },
        },
        size = { w = 2, h = 2 }
    },
    food_meat_grill = {
        name = "Мясной набор",
        description = "Готовое мясо для еды.",
        type = "food",
        items = {
            { id = "food_donemeat" },
            { id = "food_chickenlegdone" },
        },
        size = { w = 2, h = 2 }
    },
    food_bakery = {
        name = "Выпечка",
        description = "Свежая выпечка.",
        type = "food",
        items = {
            { id = "food_cakeslice" },
            { id = "food_pancakes" },
        },
        size = { w = 2, h = 2 }
    },
    food_sandwich_set = {
        name = "Набор сэндвичей",
        description = "Готовые сэндвичи.",
        type = "food",
        items = {
            { id = "food_sandwich" },
            { id = "food_sandwich" },
        },
        size = { w = 2, h = 2 }
    },
    food_icecream_variety = {
        name = "Набор мороженого",
        description = "Разные вкусы мороженого.",
        type = "food",
        items = {
            { id = "food_icecream_vanilla" },
            { id = "food_icecream_strawberry" },
            { id = "food_icecream_pistachio" },
        },
        size = { w = 3, h = 1 }
    },
    food_icecream_premium = {
        name = "Премиум мороженое",
        description = "Элитные сорта мороженого.",
        type = "food",
        items = {
            { id = "food_icecream_double" },
            { id = "food_icecream_coconut" },
        },
        size = { w = 2, h = 2 }
    },
    food_canned = {
        name = "Набор консервов",
        description = "Консервированная еда.",
        type = "food",
        items = {
            { id = "food_sguchenka" },
            { id = "food_peanut_butter" },
        },
        size = { w = 2, h = 2 }
    },
    food_longlife = {
        name = "Сухой паёк",
        description = "Еда для выживания.",
        type = "food",
        items = {
            { id = "food_hleb" },
            { id = "food_nutella" },
            { id = "food_water_can" },
        },
        size = { w = 3, h = 2 }
    },
    food_prison = {
        name = "Тюремный паёк",
        description = "Скудный, но сытный набор.",
        type = "food",
        items = {
            { id = "food_hleb" },
            { id = "food_water_can" },
        },
        size = { w = 2, h = 1 }
    },
    food_luxury = {
        name = "Роскошный ужин",
        description = "Дорогая еда для особых случаев.",
        type = "food",
        items = {
            { id = "food_turkeyy" },
            { id = "food_wine" },
        },
        size = { w = 3, h = 2 }
    },
    food_camping = {
        name = "Походный набор",
        description = "Еда для путешествий.",
        type = "food",
        items = {
            { id = "food_donemeat" },
            { id = "food_biscuits" },
            { id = "food_water_can" },
        },
        size = { w = 3, h = 2 }
    },
    food_survival = {
        name = "Набор для выживания",
        description = "Еда на крайний случай.",
        type = "food",
        items = {
            { id = "food_mcd" },
            { id = "food_water_can" },
            { id = "food_chocolate1" },
        },
        size = { w = 4, h = 2 }
    },
    medical_first_aid_small = {
        name = "Маленькая аптечка первой помощи",
        description = "Базовый набор для оказания первой помощи.",
        type = "medical",
        items = {
            { id = "medical_bandage" },
            { id = "medical_tablets" },
        },
        size = { w = 2, h = 1 }
    },
    medical_first_aid_medium = {
        name = "Средняя аптечка первой помощи",
        description = "Набор для лечения небольших ранений.",
        type = "medical",
        items = {
            { id = "medical_bandage" },
            { id = "medical_tablets" },
            { id = "medical_painkillers" },
        },
        size = { w = 3, h = 1 }
    },
    medical_biogel_kit = {
        name = "Набор с биогелем",
        description = "Набор для лечения с использованием биогеля.",
        type = "medical",
        items = {
            { id = "medical_biogel" },
            { id = "medical_biogel" },
        },
        size = { w = 2, h = 1 }
    },
    medical_medkit_small = {
        name = "Маленькая медицинская сумка",
        description = "Компактный набор с медикаментами.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_bandage" },
        },
        size = { w = 2, h = 2 }
    },
    medical_medkit_medium = {
        name = "Средняя медицинская сумка",
        description = "Стандартный набор для лечения.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
        },
        size = { w = 3, h = 2 }
    },
    medical_medkit_large = {
        name = "Большая медицинская сумка",
        description = "Полный набор для серьёзных ранений.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
            { id = "medical_tablets" },
            { id = "medical_bandage" },
        },
        size = { w = 4, h = 3 }
    },
    medical_painkillers_set = {
        name = "Набор обезболивающих",
        description = "Набор для снятия боли.",
        type = "medical",
        items = {
            { id = "medical_painkillers" },
            { id = "medical_painkillers" },
        },
        size = { w = 2, h = 1 }
    },
    medical_emergency_kit = {
        name = "Экстренный медицинский набор",
        description = "Набор для критических ситуаций.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_bandage" },
            { id = "medical_bandage" },
        },
        size = { w = 4, h = 2 }
    },
    medical_bandage_pack = {
        name = "Набор бинтов",
        description = "Несколько бинтов для перевязки.",
        type = "medical",
        items = {
            { id = "medical_bandage" },
            { id = "medical_bandage" },
            { id = "medical_bandage" },
        },
        size = { w = 3, h = 1 }
    },
    medical_tablets_pack = {
        name = "Набор таблеток",
        description = "Таблетки для лечения.",
        type = "medical",
        items = {
            { id = "medical_tablets" },
            { id = "medical_tablets" },
            { id = "medical_tablets" },
        },
        size = { w = 3, h = 1 }
    },
    medical_sleeping_pills = {
        name = "Снотворное",
        description = "Набор снотворных таблеток.",
        type = "medical",
        items = {
            { id = "medical_sleepingpills" },
        },
        size = { w = 1, h = 1 }
    },
    medical_combat_kit = {
        name = "Боевой медицинский набор",
        description = "Набор для лечения в боевых условиях.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_bandage" },
            { id = "medical_bandage" },
            { id = "medical_painkillers" },
        },
        size = { w = 4, h = 2 }
    },
    medical_biogel_advanced = {
        name = "Расширенный набор с биогелем",
        description = "Большой запас биогеля для лечения.",
        type = "medical",
        items = {
            { id = "medical_biogel" },
            { id = "medical_biogel" },
            { id = "medical_biogel" },
        },
        size = { w = 3, h = 1 }
    },
    medical_hospital_kit = {
        name = "Больничный набор",
        description = "Набор для стационарного лечения.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
            { id = "medical_tablets" },
        },
        size = { w = 5, h = 2 }
    },
    medical_trauma_kit = {
        name = "Травматологический набор",
        description = "Набор для лечения серьёзных травм.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_bandage" },
            { id = "medical_bandage" },
            { id = "medical_biogel" },
        },
        size = { w = 4, h = 2 }
    },
    medical_field_kit = {
        name = "Полевой медицинский набор",
        description = "Набор для использования в полевых условиях.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
            { id = "medical_tablets" },
        },
        size = { w = 4, h = 2 }
    },
    medical_quick_heal = {
        name = "Набор для быстрого лечения",
        description = "Набор для экстренного восстановления здоровья.",
        type = "medical",
        items = {
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
        },
        size = { w = 2, h = 1 }
    },
    medical_survival_kit = {
        name = "Медицинский набор для выживания",
        description = "Набор для длительного выживания.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_bandage" },
            { id = "medical_tablets" },
            { id = "medical_painkillers" },
        },
        size = { w = 5, h = 2 }
    },
    medical_advanced_kit = {
        name = "Продвинутый медицинский набор",
        description = "Набор с расширенными возможностями лечения.",
        type = "medical",
        items = {
            { id = "medical_medkit" },
            { id = "medical_biogel" },
            { id = "medical_biogel" },
            { id = "medical_painkillers" },
            { id = "medical_tablets" },
        },
        size = { w = 5, h = 2 }
    },
    medical_quick_bandage = {
        name = "Набор для быстрой перевязки",
        description = "Несколько бинтов для быстрого использования.",
        type = "medical",
        items = {
            { id = "medical_bandage" },
            { id = "medical_bandage" },
        },
        size = { w = 2, h = 1 }
    },
    medical_sleep_aid = {
        name = "Набор для сна",
        description = "Снотворное и успокоительное.",
        type = "medical",
        items = {
            { id = "medical_sleepingpills" },
            { id = "medical_tablets" },
        },
        size = { w = 2, h = 1 }
    },
}

function Container:GetToolData(client)
    if !client:IsUsesTool("Container Tool") then return end

    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    local angles = trace.HitNormal:Angle()
    angles:RotateAroundAxis(angles:Up(), 90)
    angles:RotateAroundAxis(angles:Forward(), 90)

    local tool = client:GetTool()

    local containerName = tool:GetClientInfo("name"):Trim()
    local containerDescription = (client.ContainerDescription or "#container_desc"):Trim()
    local containerW = tool:GetClientInfo("w")
    local containerH = tool:GetClientInfo("h")
    local containerPreset = tool:GetClientInfo("preset"):Trim()

    if IsValid(entity) and !entity:IsPlayer() and !entity:IsWorld() then
        -- eh...
    else
        entity = NULL
    end

    local data = {
        name = containerName,
        description = containerDescription,
        w = containerW,
        h = containerH,
        preset = containerPreset != "" and containerPreset or nil,
        entity = entity
    }

    return data
end

Arbitrage.base.Include("sv_plugin.lua")