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


-- TRIGGER HAPPY HAVOC
Character.team:Create({
    name = "Аой Асахина",
    title = "Абсолютный Пловец",
    color = Color(234, 185, 9),
    category = "trigger_happy_havoc",
    model = "models/custom/aoi_asahina.mdl",
    uniqueID = "aoi",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 0.5},
    speed = {walk = 1.02, run = 1.2},
    needs = {hunger = 27, thirst = 30, fatique = 46},
    scale = 0.879,
    hullscale = 0.995,
    hullduckscale = 1.26,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Бьякуя Тогами",
    title = "Абсолютный Наследник",
    color = Color(7, 164, 225),
    category = "trigger_happy_havoc",
    model = "models/custom/byakuya_togami.mdl",
    uniqueID = "byakuya",
    evidence_visibility = 0.82,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1.05, run = 1.05},
    needs = {hunger = 36, thirst = 30, fatique = 44},
    scale = 1.001,
    hullscale = 1.019,
    hullduckscale = 1.321,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Селестия Люденберг",
    title = "Абсолютный Азартный Игрок",
    color = Color(248, 27, 65),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/celestia_ludenberg/default_p.mdl",
    uniqueID = "celestia",
    evidence_visibility = 0.71,
    stamina = {run_consumption = 1.4},
    speed = {walk = 0.8, run = 0.8},
    needs = {hunger = 33, thirst = 33, fatique = 46},
    scale = 1,
    hullscale = 0.9,
    hullduckscale = 1.123,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Чихиро Фуджисаки",
    title = "Абсолютный Программист",
    color = Color(182, 220, 10),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/chihiro/default_p.mdl",
    uniqueID = "chihiro",
    evidence_visibility = 0.65,
    stamina = {run_consumption = 1.4},
    speed = {walk = 0.75, run = 0.75},
    needs = {hunger = 39, thirst = 36, fatique = 46},
    scale = 0.97,
    hullscale = 0.825,
    hullduckscale = 0.994,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Хифуми Ямада",
    title = "Абсолютный Автор Фанфиков",
    color = Color(210, 31, 107),
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/hifumi_yamada.mdl",
    uniqueID = "hifumi",
    evidence_visibility = 0.32,
    stamina = {run_consumption = 4},
    speed = {walk = 0.8, run = 0.9},
    needs = {hunger = 26, thirst = 26, fatique = 46},
    scale = 1.02,
    hullscale = 0.914,
    hullduckscale = 1.099,
    inventory = {w = 4, h = 3},

    allowProne = false
})

Character.team:Create({
    name = "Джунко Эношима",
    title = "Абсолютная Модница",
    color = Color(168, 8, 10),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/junko_enoshima/default_p.mdl",
    uniqueID = "junko",
    evidence_visibility = 1,
    stamina = {run_consumption = 0.95},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 46},
    scale = 1.09,
    hullscale = 0.851,
    hullduckscale = 1.062,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Киётака Ишимару",
    title = "Абсолютный Дежурный",
    color = Color(1, 94, 181),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/kiyotaka_ishimaru/default_p.mdl",
    uniqueID = "kiyotaka",
    evidence_visibility = 0.57,
    stamina = {run_consumption = 0.85},
    speed = {walk = 0.9, run = 1.2},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 1.002,
    hullscale = 0.961,
    hullduckscale = 1.21,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Кёко Киригири",
    title = "Абсолютный Детектив",
    color = Color(200, 57, 234),
    category = "trigger_happy_havoc",
    model = "models/kyoko_kirigiri_yoru/danganronpa/rstar/kyoko_kirigiri_yoru/kyoko_kirigiri_yoru.mdl",
    uniqueID = "kyoko",
    evidence_visibility = 1.26,
    stamina = {run_consumption = 0.7},
    speed = {walk = 0.85, run = 1},
    needs = {hunger = 36, thirst = 36, fatique = 58},
    scale = 0.968,
    hullscale = 0.95,
    hullduckscale = 1.225,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Леон Кувата",
    title = "Абсолютный Бейсболист",
    color = Color(248, 171, 8),
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/leon_kuwata.mdl",
    uniqueID = "leon",
    evidence_visibility = 0.5,
    stamina = {run_consumption = 0.6},
    speed = {walk = 0.9, run = 1.15},
    needs = {hunger = 30, thirst = 27, fatique = 46},
    scale = 0.979,
    hullscale = 0.967,
    hullduckscale = 1.244,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Макото Наэги",
    title = "Абсолютный Счастливчик",
    color = Color(90, 136, 89),
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/makoto_naegi.mdl",
    uniqueID = "makoto",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 0.984,
    hullscale = 0.89,
    hullduckscale = 1.097,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Мондо Овада",
    title = "Абсолютный Лидер Банды Байкеров",
    color = Color(226, 28, 9),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/mondo_owada/default_p.mdl",
    uniqueID = "mondo",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 0.8},
    speed = {walk = 1, run = 1.25},
    needs = {hunger = 27, thirst = 27, fatique = 53},
    scale = 1.008,
    hullscale = 1,
    hullduckscale = 1.292,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Сакура Огами",
    title = "Абсолютный Мастер Боевых Искусств",
    color = Color(142, 68, 36),
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/sakura_ogami.mdl",
    uniqueID = "sakura",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.7},
    speed = {walk = 0.9, run = 1.3},
    needs = {hunger = 39, thirst = 39, fatique = 48},
    scale = 0.983,
    hullscale = 1.065,
    hullduckscale = 1.451,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Саяка Майзоно",
    title = "Абсолютная Поп-Звезда",
    color = Color(242, 111, 188),
    category = "trigger_happy_havoc",
    model = "models/sayaka_yoru/danganronpa/rstar/sayaka_yoru/sayaka_yoru.mdl",
    uniqueID = "sayaka",
    evidence_visibility = 0.7,
    stamina = {run_consumption = 0.85},
    speed = {walk = 0.9, run = 0.9},
    needs = {hunger = 39, thirst = 30, fatique = 46},
    scale = 0.961,
    hullscale = 0.929,
    hullduckscale = 1.186,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Токо Фукава",
    title = "Абсолютная Писательница",
    color = Color(148, 21, 131),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/toko_fukawa/default_p.mdl",
    uniqueID = "toko",
    evidence_visibility = 0.53,
    stamina = {run_consumption = 1.4},
    speed = {walk = 0.85, run = 0.95},
    needs = {hunger = 36, thirst = 36, fatique = 52},
    items = {"toko_shocker"},
    scale = 1.007,
    hullscale = 0.887,
    hullduckscale = 1.1,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Ясухиро Хагакурэ",
    title = "Абсолютный Предсказатель",
    color = Color(114, 189, 36),
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/yasuhiro_hagakure/default_p.mdl",
    uniqueID = "yasuhiro",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 0.8},
    speed = {walk = 0.85, run = 1.2},
    needs = {hunger = 28, thirst = 28, fatique = 44},
    scale = 0.994,
    hullscale = 0.991,
    hullduckscale = 1.3,
    inventory = {w = 4, h = 2}
})


-- GOODBYE DESPAIR
Character.team:Create({
    name = "Аканэ Овари",
    title = "Абсолютная Гимнастка",
    color = Color(243, 201, 199),
    category = "goodbye_despair",
    model = "models/player/yourtoast4/danganronpa/akane_owari.mdl",
    uniqueID = "akane",
    evidence_visibility = 0.53,
    stamina = {run_consumption = 0.65},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 26, thirst = 33, fatique = 51},
    scale = 1,
    hullscale = 0.957,
    hullduckscale = 1.23,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Чиаки Нанами",
    title = "Абсолютный Геймер",
    color = Color(215, 186, 225),
    category = "goodbye_despair",
    model = "models/player/dewobedil/chiaki_nanami/default_p.mdl",
    uniqueID = "chiaki",
    evidence_visibility = 0.78,
    stamina = {run_consumption = 1.6},
    speed = {walk = 0.85, run = 0.8},
    needs = {hunger = 30, thirst = 30, fatique = 33},
    scale = 1, -- 0.974,
    hullscale = 0.895,
    hullduckscale = 1.142,
    inventory = {w = 4, h = 3}
})

Character.team:Create({
    name = "Фуюхико Кузурю",
    title = "Абсолютный Якудза",
    color = Color(213, 210, 212),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/fuyuhiko/default_p.mdl",
    uniqueID = "fuyuhiko",
    evidence_visibility = 0.65,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 36},
    scale = 0.969,
    hullscale = 0.875,
    hullduckscale = 1.052,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Гандам Танака",
    title = "Абсолютный Животновод",
    color = Color(226, 198, 239),
    category = "goodbye_despair",
    model = "models/player/dewobedil/gundam_tanaka/default_p.mdl",
    uniqueID = "gundham",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 0.9, run = 1.1},
    needs = {hunger = 36, thirst = 36, fatique = 51},
    scale = 1.144,
    hullscale = 0.868,
    hullduckscale = 1.035,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Хаджимэ Хината",
    title = "Абсолютный ???",
    color = Color(43, 167, 95),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/hajime_hinata/default_p.mdl",
    uniqueID = "hajime",
    evidence_visibility = 0.85,
    stamina = {run_consumption = 0.95},
    speed = {walk = 1, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 0.976,
    hullscale = 0.995,
    hullduckscale = 1.274,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Хиёко Сайонджии",
    title = "Абсолютный Традиционный Танцор",
    color = Color(206, 184, 172),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/hiyoko_saionji/default_p.mdl",
    uniqueID = "hiyoko",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.85, run = 0.85},
    needs = {hunger = 36, thirst = 30, fatique = 46},
    scale = 0.996,
    hullscale = 0.714,
    hullduckscale = 0.789,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Ибуки Миода",
    title = "Абсолютный Музыкант",
    color = Color(188, 204, 247),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/ibuki_mioda/default_p.mdl",
    uniqueID = "ibuki",
    evidence_visibility = 0.45,
    stamina = {run_consumption = 0.7},
    speed = {walk = 1, run = 1.05},
    needs = {hunger = 33, thirst = 33, fatique = 51},
    scale = 0.975,
    hullscale = 0.918,
    hullduckscale = 1.174,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Казуичи Сода",
    title = "Абсолютный Механик",
    color = Color(238, 219, 195),
    category = "goodbye_despair",
    model = "models/player/danganronpa/kazuichi_soda.mdl",
    uniqueID = "kazuichi",
    evidence_visibility = 0.55,
    stamina = {run_consumption = 0.95},
    speed = {walk = 0.9, run = 1.05},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 0.988,
    hullscale = 0.942,
    hullduckscale = 1.154,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Махиру Коизуми",
    title = "Абсолютный Фотограф",
    color = Color(243, 199, 199),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/mahiru_koizumi/default_p.mdl",
    uniqueID = "mahiru",
    evidence_visibility = 0.63,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    items = {"weapon_camera"},
    scale = 0.993,
    hullscale = 0.91,
    hullduckscale = 1.184,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Микан Цумики",
    title = "Абсолютная Медсестра",
    color = Color(252, 195, 229),
    category = "goodbye_despair",
    model = "models/player/dewobedil/mikan_tsumiki/default_p.mdl",
    uniqueID = "mikan",
    evidence_visibility = 0.73,
    stamina = {run_consumption = 1.3},
    speed = {walk = 0.9, run = 1.15},
    needs = {hunger = 36, thirst = 36, fatique = 55},
    weapons = {"weapon_medkit"},
    scale = 0.993,
    hullscale = 0.897,
    hullduckscale = 1.134,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Нагито Комаэда",
    title = "Абсолютный Везунчик",
    color = Color(193, 201, 242),
    category = "goodbye_despair",
    model = "models/player/dewobedil/nagito_komaeda/default_p.mdl",
    uniqueID = "nagito",
    evidence_visibility = 0.85,
    stamina = {run_consumption = 1.15},
    speed = {walk = 0.8, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 51},
    scale = 1.133,
    hullscale = 0.872,
    hullduckscale = 1.05,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Нэкомару Нидай",
    title = "Абсолютный Тренер",
    color = Color(182, 175, 217),
    category = "goodbye_despair",
    model = "models/nekomaru/nekomaruniidai.mdl",
    uniqueID = "nekomaru",
    evidence_visibility = 0.45,
    stamina = {run_consumption = 0.65},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 27, thirst = 27, fatique = 46},
    scale = 1,
    hullscale = 1,
    hullduckscale = 1,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Пеко Пекояма",
    title = "Абсолютная Мечница",
    color = Color(191, 189, 191),
    category = "goodbye_despair",
    model = "models/player/dewobedil/peko_pekoyama/default_p.mdl",
    uniqueID = "peko",
    evidence_visibility = 0.67,
    stamina = {run_consumption = 0.85},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 36, thirst = 36, fatique = 55},
    scale = 1.082,
    hullscale = 0.868,
    hullduckscale = 1.08,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Сония Невермайнд",
    title = "Абсолютная Принцесса",
    color = Color(202, 204, 223),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/sonia_nevermind/default_p.mdl",
    uniqueID = "sonia",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.9},
    speed = {walk = 0.95, run = 1.15},
    needs = {hunger = 33, thirst = 30, fatique = 46},
    scale = 1.014,
    hullscale = 0.935,
    hullduckscale = 1.21,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Тэрутэру Ханамура",
    title = "Абсолютный Повар",
    color = Color(237, 191, 192),
    category = "goodbye_despair",
    model = "models/player/yourtoast4/danganronpa/teruteru_hanamura.mdl",
    uniqueID = "teruteru",
    evidence_visibility = 0.5,
    stamina = {run_consumption = 1.1},
    speed = {walk = 1, run = 1.05},
    needs = {hunger = 33, thirst = 33, fatique = 46},
    scale = 0.962,
    hullscale = 0.745,
    hullduckscale = 0.793,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Бьякуя Тогами",
    title = "Абсолютный Самозванец",
    color = Color(193, 230, 238),
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa2/byakuya_togami/default_p.mdl",
    uniqueID = "twogami",
    evidence_visibility = 0.82,
    stamina = {run_consumption = 0.83},
    speed = {walk = 1, run = 1.5},
    needs = {hunger = 24, thirst = 30, fatique = 46},
    weapons = {"nightvision"},
    scale = 0.975,
    hullscale = 1.04,
    hullduckscale = 1.352,
    inventory = {w = 4, h = 2}
})


-- KILLING HARMONY
Character.team:Create({
    name = "Анджи Ёнага",
    title = "Абсолютная Художница",
    color = Color(214, 177, 14),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/angie_yonaga/default_p.mdl",
    uniqueID = "angie",
    evidence_visibility = 0.64,
    stamina = {run_consumption = 0.85},
    speed = {walk = 0.9, run = 0.9},
    needs = {hunger = 36, thirst = 36, fatique = 55},
    scale = 0.992,
    hullscale = 0.855,
    hullduckscale = 1.058,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Гонта Гокухара",
    title = "Абсолютный Энтомолог",
    color = Color(139, 74, 33),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/gonta/default_p.mdl",
    uniqueID = "gonta",
    evidence_visibility = 0.8,
    stamina = {run_consumption = 0.8},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 27, thirst = 27, fatique = 46},
    scale = 1.108,
    hullscale = 0.965,
    hullduckscale = 1.22,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Химико Юмено",
    title = "Абсолютная Фокусница",
    color = Color(181, 20, 49),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/himiko_yumeno/default_p.mdl",
    uniqueID = "himiko",
    evidence_visibility = 0.45,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.85, run = 0.85},
    needs = {hunger = 33, thirst = 33, fatique = 44},
    scale = 1,
    hullscale = 0.811,
    hullduckscale = 0.963,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "K1-B0",
    title = "Абсолютный Робот",
    color = Color(73, 226, 99),
    category = "killing_harmony",
    model = "models/player_kiibo.mdl",
    uniqueID = "k1b0",
    evidence_visibility = 0.7,
    armor = 100,
    stamina = {run_consumption = 0.1},
    speed = {walk = 1, run = 1},
    needs = {hunger = -1, thirst = -1, fatique = 351},
    weapons = {"nightvision"},
    scale = 0.935,
    hullscale = 0.933,
    hullduckscale = 1.139,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Каэде Акамацу",
    title = "Абсолютная Пианистка",
    color = Color(253, 123, 255),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kaede_akamatsu/default_p.mdl",
    uniqueID = "kaede",
    evidence_visibility = 0.65,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 0.985,
    hullscale = 0.926,
    hullduckscale = 1.183,
    inventory = {w = 4, h = 3}
})

Character.team:Create({
    name = "Кайто Момота",
    title = "Абсолютный Астронавт",
    color = Color(159, 92, 208),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl",
    uniqueID = "kaito",
    evidence_visibility = 0.46,
    stamina = {run_consumption = 1.2},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 33, thirst = 33, fatique = 43},
    scale = 0.978,
    hullscale = 1.026,
    hullduckscale = 1.327,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Кируми Тоджо",
    title = "Абсолютная Горничная",
    color = Color(82, 48, 183),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kirumi_tojo/default_p.mdl",
    uniqueID = "kirumi",
    evidence_visibility = 0.77,
    stamina = {run_consumption = 0.8},
    speed = {walk = 0.95, run = 1.1},
    needs = {hunger = 36, thirst = 36, fatique = 51},
    weapons = {"weapon_broom"},
    scale = 0.998,
    hullscale = 0.956,
    hullduckscale = 1.28,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Кокичи Ома",
    title = "Абсолютный Верховный Лидер",
    color = Color(64, 4, 201),
    category = "killing_harmony",
    model = "models/player_kokichioumaultimate.mdl",
    uniqueID = "kokichi",
    evidence_visibility = 0.9,
    stamina = {run_consumption = 0.7},
    speed = {walk = 1, run = 1.175},
    needs = {hunger = 33, thirst = 33, fatique = 51},
    items = {"picklock"},
    scale = 0.954,
    hullscale = 0.892,
    hullduckscale = 1.075,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Корекиё Шингуджи",
    title = "Абсолютный Антрополог",
    color = Color(196, 133, 39),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/korekiyo_shinguji/default_p.mdl",
    uniqueID = "korekiyo",
    evidence_visibility = 0.8,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 0.95},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 1.01,
    hullscale = 1.014,
    hullduckscale = 1.407,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Маки Харукава",
    title = "Абсолютная Воспитательница",
    color = Color(240, 53, 42),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/maki_harukawa/default_p.mdl",
    uniqueID = "maki",
    evidence_visibility = 0.9,
    stamina = {run_consumption = 0.5},
    speed = {walk = 0.95, run = 1.3},
    needs = {hunger = 42, thirst = 42, fatique = 56},
    scale = 0.989,
    hullscale = 0.884,
    hullduckscale = 1.14,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Миу Ирума",
    title = "Абсолютный Изобретатель",
    color = Color(238, 78, 195),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/miu_iruma/default_p.mdl",
    uniqueID = "miu",
    evidence_visibility = 0.63,
    stamina = {run_consumption = 1.314},
    speed = {walk = 0.9, run = 0.9},
    needs = {hunger = 30, thirst = 30, fatique = 51},
    scale = 0.96,
    hullscale = 0.985,
    hullduckscale = 1.31,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Рантаро Амами",
    title = "Абсолютный Авантюрист",
    color = Color(168, 199, 35),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/rantaro_amami/default_p.mdl",
    uniqueID = "rantaro",
    evidence_visibility = 0.75,
    stamina = {run_consumption = 0.85},
    speed = {walk = 0.9, run = 1.15},
    needs = {hunger = 36, thirst = 36, fatique = 51},
    scale = 0.977,
    hullscale = 0.991,
    hullduckscale = 1.267,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Рёма Хоши",
    title = "Абсолютный Теннисист",
    color = Color(26, 40, 184),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/ryoma_hoshi/default_p.mdl",
    uniqueID = "ryoma",
    evidence_visibility = 0.65,
    stamina = {run_consumption = 0.6},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 36, thirst = 36, fatique = 46},
    scale = 1.08,
    hullscale = 0.53,
    hullduckscale = 0.38,
    inventory = {w = 4, h = 2},

    allowProne = false
})

Character.team:Create({
    name = "Шуичи Сайхара",
    title = "Абсолютный Детектив",
    color = Color(32, 91, 150),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/shuichi_saihara/default_p.mdl",
    uniqueID = "shuichi",
    evidence_visibility = 1.06,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 30, thirst = 30, fatique = 48},
    scale = 0.991,
    hullscale = 0.945,
    hullduckscale = 1.18,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Тенко Чабашира",
    title = "Абсолютный Мастер Айкидо",
    color = Color(0, 211, 189),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/tenko_chabashira/default_p.mdl",
    uniqueID = "tenko",
    evidence_visibility = 0.53,
    stamina = {run_consumption = 0.7},
    speed = {walk = 0.95, run = 1.2},
    needs = {hunger = 36, thirst = 36, fatique = 46},
    scale = 0.998,
    hullscale = 0.894,
    hullduckscale = 1.13,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Цумуги Широганэ",
    title = "Абсолютный Косплеер",
    color = Color(23, 57, 177),
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/tsumugi_shirogane/default_p.mdl",
    uniqueID = "tsumugi",
    evidence_visibility = 0.8,
    stamina = {run_consumption = 1.3},
    speed = {walk = 0.85, run = 0.85},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 0.99,
    hullscale = 0.96,
    hullduckscale = 1.23,
    inventory = {w = 4, h = 2}
})


-- ULTRA DESPAIR GIRLS
Character.team:Create({
    name = "Джатаро Кемури",
    title = "Юный Абсолютный Художник",
    color = Color(157, 137, 128),
    category = "ultra_despair_girls",
    model = "models/player/jataro.mdl",
    uniqueID = "jataro",
    evidence_visibility = 0.7,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.8, run = 0.9},
    needs = {hunger = 36, thirst = 36, fatique = 42},
    scale = 1.11,
    hullscale = 0.63,
    hullduckscale = 0.56,
    inventory = {w = 4, h = 2},

    allowProne = false
})

Character.team:Create({
    name = "Комару Наэги",
    title = "Абсолютная Младшая Сестра Надежды",
    color = Color(158, 61, 113),
    category = "ultra_despair_girls",
    model = "models/player/someguy/komaru_p.mdl",
    uniqueID = "komaru",
    evidence_visibility = 0.5,
    stamina = {run_consumption = 1},
    speed = {walk = 0.9, run = 0.9},
    needs = {hunger = 30, thirst = 30, fatique = 46},
    scale = 1.006,
    hullscale = 0.877,
    hullduckscale = 1.10,
    inventory = {w = 4, h = 2}
})

Character.team:Create({
    name = "Котоко Уцуги",
    title = "Юная Абсолютная Актриса",
    color = Color(251, 197, 255),
    category = "ultra_despair_girls",
    model = "models/player/kotoko/kotoko_p.mdl",
    uniqueID = "kotoko",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1.4},
    speed = {walk = 0.8, run = 0.8},
    needs = {hunger = 36, thirst = 36, fatique = 42},
    scale = 1.138,
    hullscale = 0.638,
    hullduckscale = 0.634,
    inventory = {w = 4, h = 2},

    allowProne = false
})

Character.team:Create({
    name = "Масару Даймон",
    title = "Юный Абсолютный Спортсмен",
    color = Color(175, 68, 60),
    category = "ultra_despair_girls",
    model = "models/player/masaru_p.mdl",
    uniqueID = "masaru",
    evidence_visibility = 0.35,
    stamina = {run_consumption = 0.3},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 36, thirst = 36, fatique = 42},
    scale = 1.118,
    hullscale = 0.638,
    hullduckscale = 0.575,
    inventory = {w = 4, h = 2},

    allowProne = false
})

Character.team:Create({
    name = "Монака Това",
    title = "Юная Абсолютная Староста",
    color = Color(200, 185, 102),
    category = "ultra_despair_girls",
    model = "models/player/someguy/monaca_p.mdl",
    uniqueID = "monaca",
    evidence_visibility = 0.9,
    stamina = {run_consumption = 1.4},
    speed = {walk = 0.8, run = 0.9},
    needs = {hunger = 36, thirst = 36, fatique = 46},
    scale = 1.153,
    hullscale = 0.627,
    hullduckscale = 0.607,
    inventory = {w = 4, h = 2},

    allowProne = false
})

Character.team:Create({
    name = "Нагиса Шингецу",
    title = "Юный Абсолютный Обществовед",
    color = Color(118, 189, 210),
    category = "ultra_despair_girls",
    model = "models/player/nagisa/nagisa_p.mdl",
    uniqueID = "nagisa",
    evidence_visibility = 0.85,
    stamina = {run_consumption = 0.7},
    speed = {walk = 0.8, run = 0.9},
    needs = {hunger = 39, thirst = 39, fatique = 55},
    scale = 1.171,
    hullscale = 0.64,
    hullduckscale = 0.6,
    inventory = {w = 4, h = 2},

    allowProne = false
})


-- Ведущие
Character.team:Create({
    name = "Монокума",
    title = "Директор Абсолютного Отчаяния",
    color = Color(253, 182, 186),
    category = "leading",
    model = "models/player/yourtoast4/danganronpa/monokuma.mdl",
    uniqueID = "monokuma",
    evidence_visibility = 1,
    stamina = {run_consumption = 0},
    speed = {walk = 1, run = 1.3},
    needs = {hunger = -1, thirst = -1, fatique = -1},
    scale = 0.628,
    hullscale = 0.643,
    hullduckscale = 0.564,
    inventory = {w = 4, h = 5},

    allowProne = false
})