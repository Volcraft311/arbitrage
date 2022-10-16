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


-- TRIGGER HAPPY HAVOC
Character.team:Create({
    name = "Аой Асахина",
    title = "Абсолютный Пловец",
    category = "trigger_happy_havoc",
    model = "models/custom/aoi_asahina.mdl",
    uniqueID = "aoi",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 0.8},
    speed = {walk = 1.02, run = 1.2},
    needs = {hunger = 22, thirst = 30, fatique = 33},
    scale = 0.879,
    hullscale = 0.995,
    hullduckscale = 1.26
})

Character.team:Create({
    name = "Бьякуя Тогами",
    title = "Абсолютный Наследник",
    category = "trigger_happy_havoc",
    model = "models/custom/byakuya_togami.mdl",
    uniqueID = "byakuya",
    evidence_visibility = 0.7,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 40, thirst = 37, fatique = 37},
    scale = 1.001,
    hullscale = 1.019,
    hullduckscale = 1.321
})

Character.team:Create({
    name = "Селестия Люденберг",
    title = "Абсолютный Азартный Игрок",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/celestia_ludenberg/default_p.mdl",
    uniqueID = "celestia",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.8, run = 0.8},
    needs = {hunger = 36, thirst = 30, fatique = 33},
    scale = 1,
    hullscale = 0.9,
    hullduckscale = 1.123
})

Character.team:Create({
    name = "Чихиро Фуджисаки",
    title = "Абсолютный Программист",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/chihiro/default_p.mdl",
    uniqueID = "chihiro",
    evidence_visibility = 1.1,
    stamina = {run_consumption = 1.5},
    speed = {walk = 0.7, run = 0.8},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.97,
    hullscale = 0.825,
    hullduckscale = 0.994
})

Character.team:Create({
    name = "Хифуми Ямада",
    title = "Абсолютный Автор Фанфиков",
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/hifumi_yamada.mdl",
    uniqueID = "hifumi",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 4},
    speed = {walk = 0.8, run = 0.8},
    needs = {hunger = 50, thirst = 46, fatique = 30},
    scale = 1.02,
    hullscale = 0.914,
    hullduckscale = 1.099
})

Character.team:Create({
    name = "Джунко Эношима",
    title = "Абсолютная Модница",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/junko_enoshima/default_p.mdl",
    uniqueID = "junko",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 33, thirst = 30, fatique = 37},
    scale = 1.09,
    hullscale = 0.851,
    hullduckscale = 1.062
})

Character.team:Create({
    name = "Киётака Ишимару",
    title = "Абсолютный Дежурный",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/kiyotaka_ishimaru/default_p.mdl",
    uniqueID = "kiyotaka",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 33, thirst = 30, fatique = 45},
    scale = 1.002,
    hullscale = 0.961,
    hullduckscale = 1.21
})

Character.team:Create({
    name = "Кёко Киригири",
    title = "Абсолютный Детектив",
    category = "trigger_happy_havoc",
    model = "models/kyoko_kirigiri_yoru/danganronpa/rstar/kyoko_kirigiri_yoru/kyoko_kirigiri_yoru.mdl",
    uniqueID = "kyoko",
    evidence_visibility = 1,
    stamina = {run_consumption = 0.98},
    speed = {walk = 0.95, run = 0.95},
    needs = {hunger = 37, thirst = 34, fatique = 50},
    scale = 0.968,
    hullscale = 0.95,
    hullduckscale = 1.225
})

Character.team:Create({
    name = "Леон Кувата",
    title = "Абсолютный Бейсболист",
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/leon_kuwata.mdl",
    uniqueID = "leon",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 33, thirst = 26, fatique = 30},
    scale = 0.979,
    hullscale = 0.967,
    hullduckscale = 1.244
})

Character.team:Create({
    name = "Макото Наэги",
    title = "Абсолютный Счастливчик",
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/makoto_naegi.mdl",
    uniqueID = "makoto",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 30, fatique = 33},
    scale = 0.984,
    hullscale = 0.89,
    hullduckscale = 1.097
})

Character.team:Create({
    name = "Мондо Овада",
    title = "Абсолютный Лидер Банды Байкеров",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/mondo_owada/default_p.mdl",
    uniqueID = "mondo",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 30, fatique = 33},
    scale = 1.008,
    hullscale = 1,
    hullduckscale = 1.292
})

Character.team:Create({
    name = "Сакура Огами",
    title = "Абсолютный Мастер Боевых Искусств",
    category = "trigger_happy_havoc",
    model = "models/player/yourtoast4/danganronpa/sakura_ogami.mdl",
    uniqueID = "sakura",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1},
    needs = {hunger = 42, thirst = 38, fatique = 20},
    scale = 0.983,
    hullscale = 1.065,
    hullduckscale = 1.451
})

Character.team:Create({
    name = "Саяка Майзоно",
    title = "Абсолютная Поп-Звезда",
    category = "trigger_happy_havoc",
    model = "models/sayaka_yoru/danganronpa/rstar/sayaka_yoru/sayaka_yoru.mdl",
    uniqueID = "sayaka",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.9, run = 0.8},
    needs = {hunger = 33, thirst = 30, fatique = 36},
    scale = 0.961,
    hullscale = 0.929,
    hullduckscale = 1.186
})

Character.team:Create({
    name = "Токо Фукава",
    title = "Абсолютная Писательница",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/toko_fukawa/default_p.mdl",
    uniqueID = "toko",
    evidence_visibility = 0.5,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 30, fatique = 33},
    items = {"toko_shocker"},
    scale = 1.007,
    hullscale = 0.887,
    hullduckscale = 1.226
})

Character.team:Create({
    name = "Ясухиро Хагакурэ",
    title = "Абсолютный Предсказатель",
    category = "trigger_happy_havoc",
    model = "models/player/dewobedil/danganronpa/yasuhiro_hagakure/default_p.mdl",
    uniqueID = "yasuhiro",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 30, fatique = 33},
    scale = 0.994,
    hullscale = 0.991,
    hullduckscale = 1.3
})


-- GOODBYE DESPAIR
Character.team:Create({
    name = "Аканэ Овари",
    title = "Абсолютная Гимнастка",
    category = "goodbye_despair",
    model = "models/player/yourtoast4/danganronpa/akane_owari.mdl",
    uniqueID = "akane",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 1.2},
    speed = {walk = 1, run = 1.2},
    needs = {hunger = 25, thirst = 36, fatique = 38},
    scale = 1,
    hullscale = 0.957,
    hullduckscale = 1.23
})

Character.team:Create({
    name = "Чиаки Нанами",
    title = "Абсолютный Геймер",
    category = "goodbye_despair",
    model = "models/player/dewobedil/chiaki_nanami/default_p.mdl",
    uniqueID = "chiaki",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 0.8, run = 0.8},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.974,
    hullscale = 0.895,
    hullduckscale = 1.142
})

Character.team:Create({
    name = "Фуюхико Кузурю",
    title = "Абсолютный Якудза",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/fuyuhiko/default_p.mdl",
    uniqueID = "fuyuhiko",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.969,
    hullscale = 0.875,
    hullduckscale = 1.052
})

Character.team:Create({
    name = "Гандам Танака",
    title = "Абсолютный Животновод",
    category = "goodbye_despair",
    model = "models/player/dewobedil/gundam_tanaka/default_p.mdl",
    uniqueID = "gundham",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 1.144,
    hullscale = 0.868,
    hullduckscale = 1.035
})

Character.team:Create({
    name = "Хаджимэ Хината",
    title = "Абсолютный ???",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/hajime_hinata/default_p.mdl",
    uniqueID = "hajime",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.976,
    hullscale = 0.995,
    hullduckscale = 1.274
})

Character.team:Create({
    name = "Хиёко Сайонджии",
    title = "Абсолютный Традиционный Танцор",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/hiyoko_saionji/default_p.mdl",
    uniqueID = "hiyoko",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.996,
    hullscale = 0.714,
    hullduckscale = 0.789
})

Character.team:Create({
    name = "Ибуки Миода",
    title = "Абсолютный Музыкант",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/ibuki_mioda/default_p.mdl",
    uniqueID = "ibuki",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.975,
    hullscale = 0.918,
    hullduckscale = 1.174
})

Character.team:Create({
    name = "Казуичи Сода",
    title = "Абсолютный Механик",
    category = "goodbye_despair",
    model = "models/player/danganronpa/kazuichi_soda.mdl",
    uniqueID = "kazuichi",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.988,
    hullscale = 0.942,
    hullduckscale = 1.154
})

Character.team:Create({
    name = "Махиру Коизуми",
    title = "Абсолютный Фотограф",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/mahiru_koizumi/default_p.mdl",
    uniqueID = "mahiru",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    items = {"camera"},
    scale = 0.993,
    hullscale = 0.91,
    hullduckscale = 1.184
})

Character.team:Create({
    name = "Микан Цумики",
    title = "Абсолютная Медсестра",
    category = "goodbye_despair",
    model = "models/player/dewobedil/mikan_tsumiki/default_p.mdl",
    uniqueID = "mikan",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    weapons = {"weapon_medkit"},
    scale = 0.993,
    hullscale = 0.897,
    hullduckscale = 1.134
})

Character.team:Create({
    name = "Нагито Комаэда",
    title = "Абсолютный Везунчик",
    category = "goodbye_despair",
    model = "models/player/dewobedil/nagito_komaeda/default_p.mdl",
    uniqueID = "nagito",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 1.133,
    hullscale = 0.872,
    hullduckscale = 1.05
})

Character.team:Create({
    name = "Нэкомару Нидай",
    title = "Абсолютный Тренер",
    category = "goodbye_despair",
    model = "models/player/yourtoast4/danganronpa/akane_owari.mdl",
    uniqueID = "nekomaru",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 1.4},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 36, fatique = 38},
    scale = 1,
    hullscale = 1,
    hullduckscale = 1
})

Character.team:Create({
    name = "Пеко Пекояма",
    title = "Абсолютная Мечница",
    category = "goodbye_despair",
    model = "models/player/dewobedil/peko_pekoyama/default_p.mdl",
    uniqueID = "peko",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 1.082,
    hullscale = 0.868,
    hullduckscale = 1.08
})

Character.team:Create({
    name = "Сония Невермайнд",
    title = "Абсолютная Принцесса",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa/sonia_nevermind/default_p.mdl",
    uniqueID = "sonia",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 1.014,
    hullscale = 0.935,
    hullduckscale = 1.21
})

Character.team:Create({
    name = "Тэрутэру Ханамура",
    title = "Абсолютный Повар",
    category = "goodbye_despair",
    model = "models/player/yourtoast4/danganronpa/teruteru_hanamura.mdl",
    uniqueID = "teruteru",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.962,
    hullscale = 0.745,
    hullduckscale = 0.793
})

Character.team:Create({
    name = "Бьякуя Тогами",
    title = "Абсолютный Самозванец",
    category = "goodbye_despair",
    model = "models/player/dewobedil/danganronpa2/byakuya_togami/default_p.mdl",
    uniqueID = "twogami",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    weapons = {"nightvision"},
    scale = 0.975,
    hullscale = 1.04,
    hullduckscale = 1.352
})


-- KILLING HARMONY
Character.team:Create({
    name = "Анджи Ёнага",
    title = "Абсолютная Художница",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/angie_yonaga/default_p.mdl",
    uniqueID = "angie",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 0.9, run = 0.9},
    needs = {hunger = 38, thirst = 35, fatique = 37},
    scale = 0.992,
    hullscale = 0.855,
    hullduckscale = 1.058
})

Character.team:Create({
    name = "Гонта Гокухара",
    title = "Абсолютный Энтомолог",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/gonta/default_p.mdl",
    uniqueID = "gonta",
    evidence_visibility = 0.2,
    stamina = {run_consumption = 0.8},
    speed = {walk = 1, run = 1},
    needs = {hunger = 27, thirst = 30, fatique = 33},
    scale = 1.108,
    hullscale = 0.965,
    hullduckscale = 1.22
})

Character.team:Create({
    name = "Химико Юмено",
    title = "Абсолютная Фокусница",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/himiko_yumeno/default_p.mdl",
    uniqueID = "himiko",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.85, run = 0.85},
    needs = {hunger = 30, thirst = 27, fatique = 30},
    scale = 1,
    hullscale = 0.811,
    hullduckscale = 0.963
})

Character.team:Create({
    name = "K1-B0",
    title = "Абсолютный Робот",
    category = "killing_harmony",
    model = "models/player_kiibo.mdl",
    uniqueID = "k1b0",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.5},
    speed = {walk = 1, run = 1},
    needs = {hunger = 10000, thirst = 10000, fatique = 30},
    weapons = {"nightvision"},
    scale = 0.935,
    hullscale = 0.933,
    hullduckscale = 1.139
})

Character.team:Create({
    name = "Каэде Акамацу",
    title = "Абсолютная Пианистка",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kaede_akamatsu/default_p.mdl",
    uniqueID = "kaede",
    evidence_visibility = 1,
    stamina = {run_consumption = 1},
    speed = {walk = nil, run = nil},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.985,
    hullscale = 0.926,
    hullduckscale = 1.183
})

Character.team:Create({
    name = "Кайто Момота",
    title = "Абсолютный Астронавт",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kaito_momota/default_p.mdl",
    uniqueID = "kaito",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 1.3},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 33, thirst = 36, fatique = 38},
    scale = 0.978,
    hullscale = 1.026,
    hullduckscale = 1.327
})

Character.team:Create({
    name = "Кируми Тоджо",
    title = "Абсолютная Горничная",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/kirumi_tojo/default_p.mdl",
    uniqueID = "kirumi",
    evidence_visibility = 0.5,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 40, thirst = 37, fatique = 37},
    scale = 0.998,
    hullscale = 0.956,
    hullduckscale = 1.28
})

Character.team:Create({
    name = "Кокичи Ома",
    title = "Абсолютный Верховный Лидер",
    category = "killing_harmony",
    model = "models/player_kokichioumaultimate.mdl",
    uniqueID = "kokichi",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.9},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 40, thirst = 37, fatique = 37},
    items = {"picklock"},
    scale = 0.954,
    hullscale = 0.892,
    hullduckscale = 1.075
})

Character.team:Create({
    name = "Корекиё Шингуджи",
    title = "Абсолютный Антрополог",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/korekiyo_shinguji/default_p.mdl",
    uniqueID = "korekiyo",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 30, fatique = 39},
    scale = 1.01,
    hullscale = 1.014,
    hullduckscale = 1.407
})

Character.team:Create({
    name = "Маки Харукава",
    title = "Абсолютная Воспитательница",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/maki_harukawa/default_p.mdl",
    uniqueID = "maki",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.989,
    hullscale = 0.884,
    hullduckscale = 1.14
})

Character.team:Create({
    name = "Миу Ирума",
    title = "Абсолютный Изобретатель",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/miu_iruma/default_p.mdl",
    uniqueID = "miu",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.96,
    hullscale = 0.985,
    hullduckscale = 1.31
})

Character.team:Create({
    name = "Рантаро Амами",
    title = "Абсолютный Авантюрист",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/rantaro_amami/default_p.mdl",
    uniqueID = "rantaro",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 40, thirst = 37, fatique = 37},
    scale = 0.977,
    hullscale = 0.991,
    hullduckscale = 1.267
})

Character.team:Create({
    name = "Рёма Хоши",
    title = "Абсолютный Теннисист",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/ryoma_hoshi/default_p.mdl",
    uniqueID = "ryoma",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 1.08,
    hullscale = 0.53,
    hullduckscale = 0.38
})

Character.team:Create({
    name = "Шуичи Сайхара",
    title = "Абсолютный Детектив",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/shuichi_saihara/default_p.mdl",
    uniqueID = "shuichi",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 33, thirst = 33, fatique = 33},
    scale = 0.991,
    hullscale = 0.945,
    hullduckscale = 1.18
})

Character.team:Create({
    name = "Тенко Чабашира",
    title = "Абсолютный Мастер Айкидо",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/tenko_chabashira/default_p.mdl",
    uniqueID = "tenko",
    evidence_visibility = 0.3,
    stamina = {run_consumption = 0.8},
    speed = {walk = 1, run = 1.1},
    needs = {hunger = 40, thirst = 37, fatique = 33},
    scale = 0.998,
    hullscale = 0.894,
    hullduckscale = 1.13
})

Character.team:Create({
    name = "Цумуги Широганэ",
    title = "Абсолютный Косплеер",
    category = "killing_harmony",
    model = "models/player/dewobedil/danganronpa/tsumugi_shirogane/default_p.mdl",
    uniqueID = "tsumugi",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1.2},
    speed = {walk = 0.9, run = 0.8},
    needs = {hunger = 33, thirst = 30, fatique = 36},
    scale = 0.99,
    hullscale = 0.96,
    hullduckscale = 1.23
})


-- ULTRA DESPAIR GIRLS
Character.team:Create({
    name = "Джатаро Кемури",
    title = "Юный Абсолютный Художник",
    category = "ultra_despair_girls",
    model = "models/player/jataro.mdl",
    uniqueID = "jataro",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 32, thirst = 36, fatique = 42},
    scale = 1.11,
    hullscale = 0.63,
    hullduckscale = 0.56
})

Character.team:Create({
    name = "Комару Наэги",
    title = "Абсолютная Младшая Сестра Надежды",
    category = "ultra_despair_girls",
    model = "models/player/someguy/komaru_p.mdl",
    uniqueID = "komaru",
    evidence_visibility = 0.4,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1},
    needs = {hunger = 36, thirst = 36, fatique = 36},
    scale = 1.006,
    hullscale = 0.877,
    hullduckscale = 1.10
})

Character.team:Create({
    name = "Котоко Уцуги",
    title = "Юная Абсолютная Актриса",
    category = "ultra_despair_girls",
    model = "models/player/kotoko/kotoko_p.mdl",
    uniqueID = "kotoko",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 32, thirst = 36, fatique = 42},
    scale = 1.138,
    hullscale = 0.638,
    hullduckscale = 0.634
})

Character.team:Create({
    name = "Масару Даймон",
    title = "Юный Абсолютный Спортсмен",
    category = "ultra_despair_girls",
    model = "models/player/masaru_p.mdl",
    uniqueID = "masaru",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 32, thirst = 36, fatique = 42},
    scale = 1.118,
    hullscale = 0.638,
    hullduckscale = 0.575
})

Character.team:Create({
    name = "Монака Това",
    title = "Юная Абсолютная Староста",
    category = "ultra_despair_girls",
    model = "models/player/someguy/monaca_p.mdl",
    uniqueID = "monaca",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 1.1},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 32, thirst = 36, fatique = 42},
    scale = 1.153,
    hullscale = 0.627,
    hullduckscale = 0.607
})

Character.team:Create({
    name = "Нагиса Шингецу",
    title = "Юный Абсолютный Обществовед",
    category = "ultra_despair_girls",
    model = "models/player/nagisa/nagisa_p.mdl",
    uniqueID = "nagisa",
    evidence_visibility = 0.6,
    stamina = {run_consumption = 0.8},
    speed = {walk = 0.9, run = 1},
    needs = {hunger = 32, thirst = 36, fatique = 42},
    scale = 1.171,
    hullscale = 0.64,
    hullduckscale = 0.6
})


-- Ведущие
Character.team:Create({
    name = "Монокума",
    title = "Директор Абсолютного Отчаяния",
    category = "leading",
    model = "models/player/yourtoast4/danganronpa/monokuma.mdl",
    uniqueID = "monokuma",
    evidence_visibility = 1,
    stamina = {run_consumption = 0},
    speed = {walk = 1, run = 1.3},
    needs = {hunger = 10000, thirst = 10000, fatique = 10000},
    scale = 0.628,
    hullscale = 0.643,
    hullduckscale = 0.564
})


-- Уникальные
Character.team:Create({
    name = "Мичиру Мидзуно",
    title = "Абсолютный Стилист",
    category = "unique",
    model = "models/player/yourtoast4/danganronpa/monokuma.mdl",
    uniqueID = "michiru",
    evidence_visibility = 3,
    stamina = {run_consumption = 1},
    speed = {walk = 1.2, run = 1.6},
    needs = {hunger = 30, thirst = 35, fatique = 50},
    scale = 1,
    hullscale = 1,
    hullduckscale = 1
})

Character.team:Create({
    name = "Ирис Юма",
    title = "Абсолютный помощник",
    category = "unique",
    model = "models/player/ciel/heihua/xier.mdl",
    uniqueID = "iris",
    evidence_visibility = 3,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1.6},
    needs = {hunger = 10000, thirst = 10000, fatique = 10000},
    scale = 1,
    hullscale = 1,
    hullduckscale = 1
})

Character.team:Create({
    name = "Нагито Комаэда",
    title = "Абсолютный ???",
    category = "unique",
    model = "models/player/dewobedil/nagito_komaeda/default_p.mdl",
    uniqueID = "nagitoo",
    evidence_visibility = 3,
    stamina = {run_consumption = 1},
    speed = {walk = 1, run = 1.6},
    needs = {hunger = 10000, thirst = 10000, fatique = 10000},
    scale = 1.133,
    hullscale = 0.872,
    hullduckscale = 1.05
})