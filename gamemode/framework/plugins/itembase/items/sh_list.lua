local data = {
	base_picklock = {
		skeletonkey = {
			name        = "Скелетный Ключ",
	        description = "Перед вами открыты любые двери. Неподвластный человеческому разуму артефакт, таящий в себе силы раскрывать сокровенное ",
	        model       = "models/union/props/lockpick.mdl",
	        icon        = "danganronpa/inventory/items/artifact_skeletonkey_1.png",
	        hacktime    = 0,
	        maxuse      = 999
	    },
	    picklock = {
	    	name        = "Отмычка",
	        description = "Инструмент для открывания замков без ключа. Состоит из различных компонентов, таких как пики, скребки, крюки и другие инструменты, которые помогут открыть замок.",
	        model       = "models/union/props/lockpick.mdl",
	        icon        = "https://cdn-icons-png.flaticon.com/512/669/669087.png",
	        hacktime    = 15,
	        maxuse      = 2
	    },
	},
	base_ammo = {
		sniper = {
			name        = "Патроны для снайперки",
			description = "Снайперское патронное оружие, которое используется для стрельбы из оружия для больших дистанций.",
			model       = "models/items/sniper_round_box.mdl",
	        ammoClass   = "SniperPenetratedRound",
	        ammoAmount  = 10,
	        icon        = "https://cdn-icons-png.flaticon.com/512/1614/1614994.png",
	    },
	    gas = {
	        ammoClass   = "gasoline",
	        ammoAmount  = 100,
	        icon        = "https://cdn-icons-png.flaticon.com/512/6380/6380486.png",
	        model       = "models/props_junk/metalgascan.mdl",
	        name        = "Канистра бензина",
	        description = "Обычный 92-й бензин с небольшим добавлением машинного масла."
	    },
	    pistol = {
	        ammoClass   = "pistol",
	        ammoAmount  = 15,
	        icon        = "https://cdn-icons-png.flaticon.com/512/884/884473.png",
	        description = "Коробка с патронами мелкого калибра. Хранят самые обширные в использовании калибры патронов для пистолетов и ПП.",
	        model       = "models/items/boxsrounds.mdl",
	        name        = "Патроны мелкого калибра"
	    },
	    ar2 = {
	        ammoClass   = "ar2",
	        ammoAmount  = 40,
	        icon        = "https://cdn-icons-png.flaticon.com/512/238/238516.png",
	        description = "Коробка с патронами для автомата.",
	        model       = "models/items/combine_rifle_cartridge01.mdl",
	        name        = "Патроны для Автомата"
	    },
	    smg1 = {
	        ammoClass   = "smg1",
	        ammoAmount  = 40,
	        icon        = "https://cdn-icons-png.flaticon.com/512/7675/7675032.png",
	        description = "Пехотный контейнер с аммуницией, наполненный мелкокалиберными патронами.",
	        model       = "models/items/boxmrounds.mdl",
	        name        = "Патроны для ПП"
	    },
	    ["357"] = {
	        ammoClass   = "357",
	        ammoAmount  = 6,
	        icon        = "https://cdn-icons-png.flaticon.com/512/4611/4611320.png",
	        model       = "models/items/357ammo.mdl",
	        name        = "Патроны .357 Magnum",
	        description = "Коробка с патронами для магнума."
	    },
	    buckshot = {
	        ammoClass   = "buckshot",
	        ammoAmount  = 7,
	        icon        = "https://cdn-icons-png.flaticon.com/512/8572/8572145.png",
	        model       = "models/items/boxbuckshot.mdl",
	        name        = "Картечь 12x7mm",
	        description = "Коробка с патронами 12-го калибра."
	    }
	},
	base_medical = {
		biogel = {
	        icon        = "danganronpa/inventory/items/health_small_biogel.png",
	        model       = "models/healthvial.mdl",
	        maxuse      = "2",
	        sound       = "items/medshot4.wav",
	        health      = "15",
	        name        = "Банка биогеля",
	        description = "Стеклянная банка с пластиковой крышкой, внутри которой находится зеленая жидкость.",
	    },
	    medkit = {
	        icon        = "danganronpa/inventory/items/health_big_biogel.png",
	        model       = "models/Items/HealthKit.mdl",
	        maxuse      = "3",
	        sound       = "items/medshot4.wav",
	        health      = "30",
	        name        = "Аптечка",
	        description = "Пластиковая конструкция с красным крестом посередине, внутри которой находятся флакон биогеля, бинты и различные таблетки.",
	    },
		tablets = {
	        sound       = "items/medshot4.wav",
	        name        = "Таблетки",
	        icon        = "https://cdn-icons-png.flaticon.com/512/3567/3567506.png",
	        health      = 10,
	        model       = "models/w_models/weapons/w_eq_painpills.mdl",
	        maxuse      = 5,
	        description = "Универсальные таблетки \"Убейболь\".",
	    },
	    painkillers = {
	        maxuse      = 5,
	        icon        = "https://cdn-icons-png.flaticon.com/512/1686/1686545.png",
	        sound       = "items/medshot4.wav",
	        health      = 20,
	        model       = "models/w_models/weapons/w_eq_painpills.mdl",
	        name        = "Обезболивающие",
	        description = "Поможет уменьшить вашу боль при травмах.",
	    }
	},
	base_note = {
		newspaper = {
	        icon        = "https://cdn-icons-png.flaticon.com/512/1566/1566566.png",
	        model       = "models/foodnhouseholditems/newspaper1.mdl",
	        name        = "Кусок газеты",
	        description = "Газета, которая содержит новости, статьи, рекламу и другую информацию, которая издается ежедневно или регулярно.",
	    },
	    notepad = {
	        icon        = "danganronpa/inventory/items/special_papernotebook.png",
	        model       = "models/props_vtmb/dayplanner_closed.mdl",
	        name        = "Блокнот",
	        description = "Блокнот, который содержит бумажные листы для записи заметок, идей и другой информации.",
	    },
	    document = {
	        icon        = "https://cdn-icons-png.flaticon.com/512/1302/1302002.png",
	        model       = "models/props_vtmb/dayplanner.mdl",
	        name        = "Документ",
	        description = "Документ, может содержать информацию и может служить для доказательства определенных фактов.",
	    }
	},
	base_weapon = {
		flashlight = {
			name = "Фонарь",
			description = "Лучший помощник, дабы ориентироваться в темноте.",
			model = "models/weapons/w_flashlight_zm.mdl",
			icon = "https://cdn-icons-png.flaticon.com/512/3068/3068819.png",
			class = "weapon_flashlight",
			hooks = {
				unequip = function(item, client)
					client:Flashlight(false)
				end
			}
		},
		extinguisher = {
			name = "Огнетушитель",
			description = "Самая полезная вещь при пожаре.",
			model = "models/weapons/w_fire_extinguisher.mdl",
			icon = "https://cdn-icons-png.flaticon.com/512/3183/3183140.png",
			class = "weapon_extinguisher_infinite"
		},
		nightvision = {
			name = "Очки ночного зрения",
			description = "Очень популярны из-за фильмов про шпионов.",
			model = "models/weapons/cbinocularsbp/w_nvbinoculars.mdl",
			icon = "danganronpa/inventory/items/special_nvg.png",
			class = "nightvision"
		},
		camera = {
			name = "Фотоаппарат",
			description = "Фотоаппарат Полароид, имеющий функцию мгновенной распечатки фотографии.",
			model = "models/MaxOfS2D/camera.mdl",
			icon = "danganronpa/inventory/items/special_polaroid.png",
			class = "academy_camera"
		},

		nmrih_asaw = {
			name = "Абразивная пила",
			description = "Мощная электрическая пила, которая используется для резки твердых материалов с помощью абразивного диска. Идеально подходит для металла, камня, бетона и других твердых материалов.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_abrasivesaw.mdl",
			icon = "vgui/entities/tfa_nmrih_asaw",
			class = "tfa_nmrih_asaw"
		},
		nmrih_bat = {
			name = "Бейсбольная бита",
			description = "Алюминиевая бита, используемая в игре бейсбол. Имеет тупой конец для удара по мячу и заточенный конец для лучшей рукоятки.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_bat_metal.mdl",
			icon = "danganronpa/inventory/items/wep_baseballbat.png",
			class = "tfa_nmrih_bat"
		},
		nmrih_chainsaw = {
			name = "Бензопила",
			description = "Мощный интрумент, который используется для резки дерева и других материалов. Имеет длинную цепную пилу, которая движется быстро и обеспечивает точную резку.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_chainsaw.mdl",
			icon = "vgui/entities/tfa_nmrih_chainsaw",
			class = "tfa_nmrih_chainsaw"
		},
		nmrih_bcd = {
			name = "Молоток",
			description = "Типичный молоток, который используется для гвоздей и других креплений. Имеет клювовидную конструкцию для извлечения гвоздей.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_tool_barricade.mdl",
			icon = "vgui/entities/tfa_nmrih_bcd",
			class = "tfa_nmrih_bcd"
		},
		nmrih_cleaver = {
			name = "Кухонный нож",
			description = "Кухонный нож с толстым и тяжелым лезвием, идеально подходит для резки костей и других твердых материалов в кухне. Он также может использоваться для разделки мяса и размельчения овощей.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_cleaver.mdl",
			icon = "vgui/entities/tfa_nmrih_cleaver",
			class = "tfa_nmrih_cleaver"
		},
		nmrih_crowbar = {
			name = "Лом",
			description = "Длинный и толстый металлический инструмент, который используется для раздвижения и извлечения материалов. Имеет крюковидную конструкцию в конце, которая обеспечивает точность и силу.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_crowbar.mdl",
			icon = "vgui/entities/tfa_nmrih_crowbar",
			class = "tfa_nmrih_crowbar"
		},
		nmrih_etool = {
			name = "Инструмент для копания",
			description = "Многофункциональный инструмент, который используется для земляных работ, таких как копание траншей, копание ям и разработка полей.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_etool.mdl",
			icon = "vgui/entities/tfa_nmrih_etool",
			class = "tfa_nmrih_etool"
		},
		nmrih_fireaxe = {
			name = "Пожарный топор",
			description = "Специальный тип боевого топора, который используется для разрушения объектов в пожарных операциях. Имеет тяжелое лезвие и крюковидную рукоятку для лучшей силы и точности.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_axe_fire.mdl",
			icon = "danganronpa/inventory/items/wep_fireaxe.png",
			class = "tfa_nmrih_fireaxe"
		},
		nmrih_fubar = {
			name = "Фубар",
			description = "Многофункциональный инструмент, который используется для различных задач, от ремонта и конструкции до военных и выживальных операций.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_fubar.mdl",
			icon = "vgui/entities/tfa_nmrih_fubar",
			class = "tfa_nmrih_fubar"
		},
		nmrih_hatchet = {
			name = "Топор",
			description = "Маленький топор с коротким и тонким лезвием, который используется для резки дерева и других материалов. Идеально подходит для выживания и кемпинга.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_hatchet.mdl",
			icon = "vgui/entities/tfa_nmrih_hatchet",
			class = "tfa_nmrih_hatchet"
		},
		nmrih_kknife = {
			name = "Нож",
			description = "Небольшой нож с коротким лезвием, который используется для различных задач, от кухонных до садовых и выживальных. Идеально подходит для носки в кармане или кейсе.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_kitknife.mdl",
			icon = "danganronpa/inventory/items/wep_kitchenknife.png",
			class = "tfa_nmrih_kknife"
		},
		nmrih_lpipe = {
			name = "Свинцовая труба",
			description = "Длинный и толстый металлический трубопровод, который используется в качестве оружия или инструмента для ремонта. Он имеет грубую текстуру и достаточно твердый для нанесения ударов.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_pipe_lead.mdl",
			icon = "vgui/entities/tfa_nmrih_lpipe",
			class = "tfa_nmrih_lpipe"
		},
		nmrih_machete = {
			name = "Мачете",
			description = "Длинный и острый нож с длинным лезвием, который используется для резки и рубки растительности и других материалов. Идеально подходит для сельского хозяйства и выживания.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_machete.mdl",
			icon = "vgui/entities/tfa_nmrih_machete",
			class = "tfa_nmrih_machete"
		},
		nmrih_pickaxe = {
			name = "Кирка",
			description = "Инструмент с двумя концами: одна сторона имеет острый конец для разработки горных жил и другая сторона имеет колющий конец для копания ям.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_pickaxe.mdl",
			icon = "vgui/entities/tfa_nmrih_pickaxe",
			class = "tfa_nmrih_pickaxe"
		},
		nmrih_sledge = {
			name = "Кувалда",
			description = "Тяжелый молот с длинной рукояткой, который используется для нанесения ударов по твердым материалам и для разбивания камней и бетона.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_sledge.mdl",
			icon = "vgui/entities/tfa_nmrih_sledge",
			class = "tfa_nmrih_sledge"
		},
		nmrih_spade = {
			name = "Лопата",
			description = "Инструмент с круглой рукояткой и острым концом для копания и перемещения земли. Идеально подходит для садоводства, строительства и других земляных работ.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_spade.mdl",
			icon = "vgui/entities/tfa_nmrih_spade",
			class = "tfa_nmrih_spade"
		},
		nmrih_wrench = {
			name = "Гаечный ключ",
			description = "Инструмент, который используется для затягивания и ослабления болтов и гайки. Имеет различные типы и размеры для работы с различными видами крепежа.",
			category = "Оружие - Ближнее",
			model = "models/weapons/tfa_nmrih/w_me_wrench.mdl",
			icon = "vgui/entities/tfa_nmrih_wrench",
			class = "tfa_nmrih_wrench"
		},

		nmrih_m92fs = {
			name = "Beretta M92FS",
			description = "Пистолет с магазином на 15 патронов, используемый в армии, полиции и вооруженных силах многих стран. Имеет надежное действие, охотничий и спортивный варианты.",
			category = "Оружие - Пистолеты",
			model = "models/weapons/tfa_nmrih/w_fa_m92fs.mdl",
			icon = "vgui/entities/tfa_nmrih_m92fs",
			class = "tfa_nmrih_m92fs"
		},
		nmrih_1911 = {
			name = "Colt M1911",
			description = "Пистолет с магазином на 7 патронов, использовавшийся в армии США и многих других странах. Известен своей надежностью, простотой использования и мощным выстрелом.",
			category = "Оружие - Пистолеты",
			model = "models/weapons/tfa_nmrih/w_fa_1911.mdl",
			icon = "vgui/entities/tfa_nmrih_1911",
			class = "tfa_nmrih_1911"
		},
		nmrih_g17 = {
			name = "Glock 17",
			description = "Пистолет с магазином на 17 патронов, используемый в армии, полиции и вооруженных силах многих стран. Известен своей надежностью, легкостью использования в боевых условиях.",
			category = "Оружие - Пистолеты",
			model = "models/weapons/tfa_nmrih/w_fa_glock17.mdl",
			icon = "vgui/entities/tfa_nmrih_g17",
			class = "tfa_nmrih_g17"
		},
		nmrih_mkiii = {
			name = "Ruger MK III",
			description = "Популярный пистолет, используемый для спортивной стрельбы и охоты. Имеет надежное действие, простоту использования и различные варианты прицелов.",
			category = "Оружие - Пистолеты",
			model = "models/weapons/tfa_nmrih/w_fa_mkiii.mdl",
			icon = "vgui/entities/tfa_nmrih_mkiii",
			class = "tfa_nmrih_mkiii"
		},
		nmrih_sw686 = {
			name = "Smith & Wesson 686",
			description = "Популярный  револьвер, используемый для спортивной стрельбы и охоты. Имеет надежное действие, мощный выстрел и различные варианты прицелов.",
			category = "Оружие - Пистолеты",
			model = "models/weapons/tfa_nmrih/w_fa_sw686.mdl",
			icon = "vgui/entities/tfa_nmrih_sw686",
			class = "tfa_nmrih_sw686"
		},

		nmrih_m16_ch = {
			name = "Colt M16A4",
			description = "Автомат, используемый в армии и вооруженных силах многих стран. Имеет надежное действие, простоту использования и различные варианты прицелов.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_m16a4_carryhandle.mdl",
			icon = "vgui/entities/tfa_nmrih_m16_ch",
			class = "tfa_nmrih_m16_ch"
		},
		nmrih_m16_rt = {
			name = "Colt M16A4 ACOG",
			description = "Вариант модели Colt M16A4 с добавленным прицелом ACOG, который обеспечивает увеличенную точность.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_m16a4.mdl",
			icon = "vgui/entities/tfa_nmrih_m16_rt",
			class = "tfa_nmrih_m16_rt"
		},
		nmrih_cz = {
			name = "CZ 858 Tactical",
			description = "Автомат, используемый в армии и вооруженных силах некоторых стран. Он имеет надежное действие, простоту использования и различные варианты прицелов.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_cz858.mdl",
			icon = "vgui/entities/tfa_nmrih_cz",
			class = "tfa_nmrih_cz"
		},
		nmrih_fal = {
			name = "FN FAL",
			description = "Автомат, используемый в армиях и вооруженных силах многих стран. Известен своей надежностью, мощным выстрелом и различными вариантами прицелов.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_fnfal.mdl",
			icon = "vgui/entities/tfa_nmrih_fal",
			class = "tfa_nmrih_fal"
		},
		nmrih_mp5 = {
			name = "H&K MP5A4",
			description = "Пистолет-пулемет, используемый в армии, полиции и вооруженных силах многих стран. Известен своей надежностью, малым весом и стрельбой в боевых условиях.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_mp5.mdl",
			icon = "vgui/entities/tfa_nmrih_mp5",
			class = "tfa_nmrih_mp5"
		},
		nmrih_mac10 = {
			name = "MAC 10",
			description = "Пистолета-пулемет, используемый в армии и вооруженных силах некоторых стран. Известен своей малым размером, легкостью и высокой скорострельностью.",
			category = "Оружие - ПП/Автоматы",
			model = "models/weapons/tfa_nmrih/w_fa_mac10.mdl",
			icon = "vgui/entities/tfa_nmrih_mac10",
			class = "tfa_nmrih_mac10"
		},

		nmrih_sv10 = {
			name = "Beretta Perennia SV10",
			description = "Дробовик, изготовленный итальянской компанией Beretta. Известен своей надежностью и мощным выстрелом.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_sv10.mdl",
			icon = "vgui/entities/tfa_nmrih_sv10",
			class = "tfa_nmrih_sv10"
		},
		nmrih_500a = {
			name = "Mosserg 500A",
			description = "Дробовик, изготовленный американской компанией Mossberg. Известен своей надежностью, легкостью использования и множеством вариантов конфигурации.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_500a.mdl",
			icon = "vgui/entities/tfa_nmrih_500a",
			class = "tfa_nmrih_500a"
		},
		nmrih_870 = {
			name = "Remington 870",
			description = "Дробовик, используемый для охоты, сельского хозяйства и защиты. Известен своей надежностью и множеством вариантов конфигурации.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_870.mdl",
			icon = "vgui/entities/tfa_nmrih_870",
			class = "tfa_nmrih_870"
		},
		nmrih_rug1022 = {
			name = "Ruger 10/22",
			description = "Автоматический карабин, используемый для спортивной стрельбы, охоты и защиты. Известен своей надежностью, легкостью использования и различными вариантами прицелов.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_ruger1022.mdl",
			icon = "vgui/entities/tfa_nmrih_rug1022",
			class = "tfa_nmrih_rug1022"
		},
		nmrih_rug1022_25 = {
			name = "Ruger 10/22 25 Round",
			description = "Вариант модели Ruger 10/22 с большим магазином на 25 патронов, который позволяет использовать больше патронов без необходимости частого перезарядки.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_ruger1022_25mag.mdl",
			icon = "vgui/entities/tfa_nmrih_rug1022_25",
			class = "tfa_nmrih_rug1022_25"
		},
		nmrih_sako = {
			name = "Sako 85",
			description = "Охотничье ружье, изготовленное финской компанией Sako. Известно своей надежностью, прочностью и точностью.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_sako85.mdl",
			icon = "vgui/entities/tfa_nmrih_sako",
			class = "tfa_nmrih_sako"
		},
		nmrih_jae700 = {
			name = "JAE 700",
			description = "Тактическое ружье, разработанная компанией JAE. Известна своей надежностью, гибкостью и тактической настройкой.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_jae700.mdl",
			icon = "vgui/entities/tfa_nmrih_jae700",
			class = "tfa_nmrih_jae700"
		},
		nmrih_sako_is = {
			name = "Sako 85 Ironsights",
			description = "Вариант модели Sako 85 с капельковыми прицелами, который позволяет использовать оптику и капельковые прицелы одновременно, обеспечивая большую точность и гибкость в использовании.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_sako85_ironsights.mdl",
			icon = "vgui/entities/tfa_nmrih_sako_is",
			class = "tfa_nmrih_sako_is"
		},
		nmrih_sks = {
			name = "Simonov SKS",
			description = "Советский автомат, разработанный Симоновым в 1945 году. Известен своей надежностью, простотой использования и большой емкостью магазина.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_sks.mdl",
			icon = "vgui/entities/tfa_nmrih_sks",
			class = "tfa_nmrih_sks"
		},
		nmrih_sks_nb = {
			name = "Simonov SKS - No Bayonet",
			description = "Вариант модели Simonov SKS без штык-ножа, что делает его более легким и удобным для использования в стрельбе и переноске.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_sks_nobayo.mdl",
			icon = "vgui/entities/tfa_nmrih_sks_nb",
			class = "tfa_nmrih_sks_nb"
		},
		nmrih_1892 = {
			name = "Winchester 1892",
			description = "Охотничье ружье, изготовленное американской компанией Winchester. Известна своей надежностью, точностью и исторической ценностью.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_win1892.mdl",
			icon = "vgui/entities/tfa_nmrih_1892",
			class = "tfa_nmrih_1892"
		},
		nmrih_superx3 = {
			name = "Winchester Super X3",
			description = "Охотничий дробовик, изготовленный американской компанией Winchester. Известен своей надежностью, точностью и автоматической запирающей системой.",
			category = "Оружие - Остальное",
			model = "models/weapons/tfa_nmrih/w_fa_superx3.mdl",
			icon = "vgui/entities/tfa_nmrih_superx3",
			class = "tfa_nmrih_superx3"
		},

		tfcss_ak47 = {
			name = "AK47",
			description = "Автомат, разработанный в СССР в 1947 году. Известен своей надежностью, простотой использования и мощным выстрелом.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_ak47.mdl",
			icon = "vgui/entities/tfcss_ak47",
			class = "tfcss_ak47"
		},
		tfcss_awp = {
			name = "AWP",
			description = "Тактическая снайперская винтовка, используемая в операциях спецназа и других вооруженных сил. Известен своей мощным выстрелом и высокой точностью на большие дистанции.",
			category = "Оружие - CSS",
			model = "models/weapons/w_snip_awp.mdl",
			icon = "vgui/entities/tfcss_awp",
			class = "tfcss_awp"
		},
		tfcss_deagle = {
			name = "Desert Eagle",
			description = "Пистолет, изготовленный израильской компанией Magnum Research. Известен своей мощным выстрелом, большой емкостью магазина и компактным размером.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_deagle.mdl",
			icon = "vgui/entities/tfcss_deagle",
			class = "tfcss_deagle"
		},
		tfcss_dualelites = {
			name = "Dual Elites",
			description = "Двойной пистолет, используемая в спецназе и других вооруженных силах. Известен своей высокой скорострельностью и мощным выстрелом.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_elite.mdl",
			icon = "vgui/entities/tfcss_dualelites",
			class = "tfcss_dualelites"
		},
		tfcss_famas = {
			name = "FAMAS",
			description = "Французский автомат, разработанный в 1970-х годах. Известен своей надежностью и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_famas.mdl",
			icon = "vgui/entities/tfcss_famas",
			class = "tfcss_famas"
		},
		tfcss_fiveseven = {
			name = "FiveseveN",
			description = "Пистолет, разработанный компанией FN Herstal. Известен своим высоким калибром, малым размером и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_fiveseven.mdl",
			icon = "vgui/entities/tfcss_fiveseven",
			class = "tfcss_fiveseven"
		},
		tfcss_p90 = {
			name = "FN P90",
			description = "Пистолет-пулемет. Известен своим малым размером, легкостью и высокой скорострельностью, а также своим инновационным дизайном, который позволяет ему стрелять без отдачи.",
			category = "Оружие - CSS",
			model = "models/weapons/w_smg_p90.mdl",
			icon = "vgui/entities/tfcss_p90",
			class = "tfcss_p90"
		},
		tfcss_g3sg1 = {
			name = "G3SG1",
			description = "Снайперская винтовка, разработанная компанией Heckler & Koch. Известен своей надежностью, точностью и высокой скорострельностью на дальние дистанции.",
			category = "Оружие - CSS",
			model = "models/weapons/w_snip_g3sg1.mdl",
			icon = "vgui/entities/tfcss_g3sg1",
			class = "tfcss_g3sg1"
		},
		tfcss_galil = {
			name = "Galil",
			description = "Израильский автомат, разработанная в 1970-х годах. Известен своей надежностью и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_galil.mdl",
			icon = "vgui/entities/tfcss_galil",
			class = "tfcss_galil"
		},
		tfcss_glock = {
			name = "Glock 18",
			description = "Пистолета, разработанная компанией Glock. Известен своей надежностью, легкостью использования и возможностью автоматической стрельбы, которая делает его полезным.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_glock18.mdl",
			icon = "vgui/entities/tfcss_glock",
			class = "tfcss_glock"
		},
		tfcss_ump45 = {
			name = "HK UMP45",
			description = "Пистолет-пулемет, разработанный компанией Heckler & Koch. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_smg_ump45.mdl",
			icon = "vgui/entities/tfcss_ump45",
			class = "tfcss_ump45"
		},
		tfcss_usp = {
			name = "HK USP",
			description = "Пистолет, разработанный компанией Heckler & Koch. Известен своей надежностью, гибкостью в использовании и настройкой различных вариантов прицелов.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_usp.mdl",
			icon = "vgui/entities/tfcss_usp",
			class = "tfcss_usp"
		},
		tfcss_m249 = {
			name = "M249 Para",
			description = "Пулемет, разработанный компанией Fabrique Nationale. Известен своей надежностью, мощным выстрелом и высокой скорострельностью, а также легкостью использования и портативностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_mach_m249para.mdl",
			icon = "vgui/entities/tfcss_m249",
			class = "tfcss_m249"
		},
		tfcss_m3 = {
			name = "M3 Super 90",
			description = "Дробовик, изготовленный компанией Benelli. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_shot_m3super90.mdl",
			icon = "vgui/entities/tfcss_m3",
			class = "tfcss_m3"
		},
		tfcss_m4a1 = {
			name = "M4A1",
			description = "Автомат, используемый в США и других странах. Известен своей надежностью, мощным выстрелом и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_m4a1.mdl",
			icon = "vgui/entities/tfcss_m4a1",
			class = "tfcss_m4a1"
		},
		tfcss_mac10 = {
			name = "MAC 10",
			description = "Пистолет-пулемет, разработанный компанией Military Armament Corporation. Известен своей высокой скорострельностью и мощным выстрелом.",
			category = "Оружие - CSS",
			model = "models/weapons/w_smg_mac10.mdl",
			icon = "vgui/entities/tfcss_mac10",
			class = "tfcss_mac10"
		},
		tfcss_mp5 = {
			name = "MP5",
			description = "Пистолет-Пулемет, разработанный компанией Heckler & Koch. Известен своей надежностью и высокой скорострельностью, а также гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS",
			model = "models/weapons/w_smg_mp5.mdl",
			icon = "vgui/entities/tfcss_mp5",
			class = "tfcss_mp5"
		},
		tfcss_p228 = {
			name = "P228",
			description = "Пистолет, разработанный компанией SIG Sauer. Известен своей надежностью, малым размером и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_pist_p228.mdl",
			icon = "vgui/entities/tfcss_p228",
			class = "tfcss_p228"
		},
		tfcss_scout = {
			name = "Scout",
			description = "Снайперская Винтовка, изготовленная компанией Steyr Mannlicher. Известен своей легкостью, точностью и высокой скорострельностью на дальние дистанции.",
			category = "Оружие - CSS",
			model = "models/weapons/w_snip_scout.mdl",
			icon = "vgui/entities/tfcss_scout",
			class = "tfcss_scout"
		},
		tfcss_sg550 = {
			name = "SG550",
			description = "Швейцарская автоматическая винтовка, разработанная компанией Swiss Arms AG. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_snip_sg550.mdl",
			icon = "vgui/entities/tfcss_sg550",
			class = "tfcss_sg550"
		},
		tfcss_sg552 = {
			name = "SG552",
			description = "Карабин, разработанный компанией Swiss Arms AG. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_sg552.mdl",
			icon = "vgui/entities/tfcss_sg552",
			class = "tfcss_sg552"
		},
		tfcss_aug = {
			name = "Steyr AUG",
			description = "Австрийский автомат, разработанный компанией Steyr Mannlicher. Известен своей надежностью, мощным выстрелом и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS",
			model = "models/weapons/w_rif_aug.mdl",
			icon = "vgui/entities/tfcss_aug",
			class = "tfcss_aug"
		},
		tfcss_tmp = {
			name = "TMP",
			description = "Пистолет-пулемет, разработанный компанией Steyr Mannlicher. Известен своей высокой скорострельностью и мощным выстрелом, а также легкостью использования и портативностью.",
			category = "Оружие - CSS",
			model = "models/weapons/w_smg_tmp.mdl",
			icon = "vgui/entities/tfcss_tmp",
			class = "tfcss_tmp"
		},
		tfcss_xm1014 = {
			name = "XM1014",
			description = "Дробовик, разработанный компанией Benelli. Известен своей надежностью, мощным выстрелом и высокой скорострельностью, а также его особенностями как полуавтоматического оружия.",
			category = "Оружие - CSS",
			model = "models/weapons/w_shot_xm1014.mdl",
			icon = "vgui/entities/tfcss_xm1014",
			class = "tfcss_xm1014"
		},

		tfcss_ak47_alt = {
			name = "AK47",
			description = "Автомат, разработанный в СССР в 1947 году. Известен своей надежностью, простотой использования и мощным выстрелом.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_ak47.mdl",
			icon = "vgui/entities/tfcss_ak47_alt",
			class = "tfcss_ak47_alt"
		},
		tfcss_awp_alt = {
			name = "AWP",
			description = "Тактическая снайперская винтовка, используемая в операциях спецназа и других вооруженных сил. Известен своей мощным выстрелом и высокой точностью на большие дистанции.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_snip_awp.mdl",
			icon = "vgui/entities/tfcss_awp_alt",
			class = "tfcss_awp_alt"
		},
		tfcss_deagle_alt = {
			name = "Desert Eagle",
			description = "Пистолет, изготовленный израильской компанией Magnum Research. Известен своей мощным выстрелом, большой емкостью магазина и компактным размером.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_pist_deagle.mdl",
			icon = "danganronpa/inventory/items/wep_deserteagle.png",
			class = "tfcss_deagle_alt"
		},
		tfcss_dualelites_alt = {
			name = "Dual Elites",
			description = "Двойной пистолет, используемая в спецназе и других вооруженных силах. Известен своей высокой скорострельностью и мощным выстрелом.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/w_pist_elite.mdl",
			icon = "vgui/entities/tfcss_dualelites_alt",
			class = "tfcss_dualelites_alt"
		},
		tfcss_famas_alt = {
			name = "FAMAS",
			description = "Французский автомат, разработанный в 1970-х годах. Известен своей надежностью и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_famas.mdl",
			icon = "vgui/entities/tfcss_famas_alt",
			class = "tfcss_famas_alt"
		},
		tfcss_fiveseven_alt = {
			name = "FiveseveN",
			description = "Пистолет, разработанный компанией FN Herstal. Известен своим высоким калибром, малым размером и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_pist_fiveseven.mdl",
			icon = "vgui/entities/tfcss_fiveseven_alt",
			class = "tfcss_fiveseven_alt"
		},
		tfcss_p90_alt = {
			name = "FN P90",
			description = "Пистолет-пулемет. Известен своим малым размером, легкостью и высокой скорострельностью, а также своим инновационным дизайном, который позволяет ему стрелять без отдачи.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_smg_p90.mdl",
			icon = "vgui/entities/tfcss_p90_alt",
			class = "tfcss_p90_alt"
		},
		tfcss_g3sg1_alt = {
			name = "G3SG1",
			description = "Снайперская винтовка, разработанная компанией Heckler & Koch. Известен своей надежностью, точностью и высокой скорострельностью на дальние дистанции.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_snip_g3sg1.mdl",
			icon = "vgui/entities/tfcss_g3sg1_alt",
			class = "tfcss_g3sg1_alt"
		},
		tfcss_galil_alt = {
			name = "Galil",
			description = "Израильский автомат, разработанная в 1970-х годах. Известен своей надежностью и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_galil.mdl",
			icon = "vgui/entities/tfcss_galil_alt",
			class = "tfcss_galil_alt"
		},
		tfcss_glock_alt = {
			name = "Glock 18",
			description = "Пистолета, разработанная компанией Glock. Известен своей надежностью, легкостью использования и возможностью автоматической стрельбы, которая делает его полезным.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_pist_glock18.mdl",
			icon = "vgui/entities/tfcss_glock_alt",
			class = "tfcss_glock_alt"
		},
		tfcss_ump45_alt = {
			name = "HK UMP45",
			description = "Пистолет-пулемет, разработанный компанией Heckler & Koch. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_smg_ump45.mdl",
			icon = "vgui/entities/tfcss_ump45_alt",
			class = "tfcss_ump45_alt"
		},
		tfcss_usp_alt = {
			name = "HK USP",
			description = "Пистолет, разработанный компанией Heckler & Koch. Известен своей надежностью, гибкостью в использовании и настройкой различных вариантов прицелов.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_pist_usp.mdl",
			icon = "vgui/entities/tfcss_usp_alt",
			class = "tfcss_usp_alt"
		},
		tfcss_m249_alt = {
			name = "M249 Para",
			description = "Пулемет, разработанный компанией Fabrique Nationale. Известен своей надежностью, мощным выстрелом и высокой скорострельностью, а также легкостью использования и портативностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_mach_m249para.mdl",
			icon = "vgui/entities/tfcss_m249_alt",
			class = "tfcss_m249_alt"
		},
		tfcss_m3_alt = {
			name = "M3 Super 90",
			description = "Дробовик, изготовленный компанией Benelli. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_shot_m3super90.mdl",
			icon = "vgui/entities/tfcss_m3_alt",
			class = "tfcss_m3_alt"
		},
		tfcss_m4a1_alt = {
			name = "M4A1",
			description = "Автомат, используемый в США и других странах. Известен своей надежностью, мощным выстрелом и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_m4a1.mdl",
			icon = "vgui/entities/tfcss_m4a1_alt",
			class = "tfcss_m4a1_alt"
		},
		tfcss_mac10_alt = {
			name = "MAC 10",
			description = "Пистолет-пулемет, разработанный компанией Military Armament Corporation. Известен своей высокой скорострельностью и мощным выстрелом.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_smg_mac10.mdl",
			icon = "vgui/entities/tfcss_mac10_alt",
			class = "tfcss_mac10_alt"
		},
		tfcss_mp5_alt = {
			name = "MP5",
			description = "Пистолет-Пулемет, разработанный компанией Heckler & Koch. Известен своей надежностью и высокой скорострельностью, а также гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_smg_mp5.mdl",
			icon = "vgui/entities/tfcss_mp5_alt",
			class = "tfcss_mp5_alt"
		},
		tfcss_p228_alt = {
			name = "P228",
			description = "Пистолет, разработанный компанией SIG Sauer. Известен своей надежностью, малым размером и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_pist_p228.mdl",
			icon = "vgui/entities/tfcss_p228_alt",
			class = "tfcss_p228_alt"
		},
		tfcss_scout_alt = {
			name = "Scout",
			description = "Снайперская Винтовка, изготовленная компанией Steyr Mannlicher. Известен своей легкостью, точностью и высокой скорострельностью на дальние дистанции.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_snip_scout.mdl",
			icon = "vgui/entities/tfcss_scout_alt",
			class = "tfcss_scout_alt"
		},
		tfcss_sg550_alt = {
			name = "SG550",
			description = "Швейцарская автоматическая винтовка, разработанная компанией Swiss Arms AG. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_snip_sg550.mdl",
			icon = "vgui/entities/tfcss_sg550_alt",
			class = "tfcss_sg550_alt"
		},
		tfcss_sg552_alt = {
			name = "SG552",
			description = "Карабин, разработанный компанией Swiss Arms AG. Известен своей надежностью, мощным выстрелом и высокой скорострельностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_sg552.mdl",
			icon = "vgui/entities/tfcss_sg552_alt",
			class = "tfcss_sg552_alt"
		},
		tfcss_aug_alt = {
			name = "Steyr AUG",
			description = "Австрийский автомат, разработанный компанией Steyr Mannlicher. Известен своей надежностью, мощным выстрелом и гибкостью в использовании в различных условиях.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_rif_aug.mdl",
			icon = "vgui/entities/tfcss_aug_alt",
			class = "tfcss_aug_alt"
		},
		tfcss_tmp_alt = {
			name = "TMP",
			description = "Пистолет-пулемет, разработанный компанией Steyr Mannlicher. Известен своей высокой скорострельностью и мощным выстрелом, а также легкостью использования и портативностью.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_smg_tmp.mdl",
			icon = "vgui/entities/tfcss_tmp_alt",
			class = "tfcss_tmp_alt"
		},
		tfcss_xm1014_alt = {
			name = "XM1014",
			description = "Дробовик, разработанный компанией Benelli. Известен своей надежностью, мощным выстрелом и высокой скорострельностью, а также его особенностями как полуавтоматического оружия.",
			category = "Оружие - CSS Alt",
			model = "models/weapons/3_shot_xm1014.mdl",
			icon = "vgui/entities/tfcss_xm1014_alt",
			class = "tfcss_xm1014_alt"
		},

		lantern = {
			name = "Масляная лампа",
			description = "Старенькая масляная лампа.",
			category = "Amnesia Lantern Rework",
			model = "models/weapons/w_lantern.mdl",
			icon = "https://cdn-icons-png.flaticon.com/512/3127/3127167.png",
			class = "buu_lantern"
		}
	},
	base_food = {
		apple2 = {
			name = "Зелёное Яблоко",
	        description = "Кислое зелёное яблоко.",
	        model = "models/foodnhouseholditems/apple1.mdl",
	        icon = "danganronpa/inventory/items/food_applegreen.png",
	        thirst = 8,
	        hunger = 8,
	        maxuse = 4,
	        sleep = 0,
	        sound = "eating_and_drinking/eating.wav",
	    },
	    coffee = {
	    	name = "Кофе",
	        description = "Классический горячий напиток греющий душу!",
	        model = "models/themask/scenebuildthemes/groceries/sm_coffee_cup_paper_02.mdl",
	        icon = "danganronpa/inventory/items/food_coffee.png",
	        thirst = 10,
	        hunger = 0,
	        maxuse = 1,
	        sleep = 100,
	        sound = "eating_and_drinking/drinking.wav",
	    },
	}
}

local function registerItem(base, id, info)
	if base == "" or base == " " or base == "default" then
		base = nil
	end

	if base then
		local prefix = base:gsub("base_", "")
		id = prefix .. "_" .. id
	end

	local ITEM = ItemBase.GetBase(base)

	for k, v in pairs(info) do
		ITEM[k] = v
	end

	ItemBase:RegisterItem(id, ITEM)
end

for base, stored in pairs(data) do
	for id, info in pairs(stored) do
		registerItem(base, id, info)
	end
end