--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


-- Стандартное здоровье
ARBITRAGE_HEALTH = 100

-- Стандартная броня
ARBITRAGE_ARMOR = 0

--Стандартная скорость хотьбы
ARBITRAGE_WALK_SPEED = 90

-- Стандартная скорость бега
ARBITRAGE_RUN_SPEED = 200

-- Стандартная высота прыжка
ARBITRAGE_JUMP_POWER = 200

-- Длина видимости обычного сообщения в чате
ARBITRAGE_SAY_LENGTH = 600

-- Стандартная модель игрока
ARBITRAGE_STANDART_MODEL = "models/editor/playerstart.mdl"

-- Расположения спавна при заходе на сервер
ARBITRAGE_SPAWN = {
	drp_hopespeak = {
		Vector(-1121, -3375, -48), Vector(-1194, -3375, -48), Vector(-1276, -3374, -48), Vector(-1377, -3374, -48),
		Vector(-1478, -3374, -48), Vector(-1603, -3374, -48), Vector(-1715, -3374, -48), Vector(-1700, -3263, -48),
		Vector(-1549, -3263, -48), Vector(-1458, -3263, -48), Vector(-1355, -3263, -48), Vector(-1221, -3263, -48),
		Vector(-1108, -3263, -48), Vector(-1106, -3156, -48), Vector(-1212, -3155, -48), Vector(-1321, -3155, -48),
		Vector(-1447, -3155, -48), Vector(-1542, -3154, -48), Vector(-1632, -3154, -48), Vector(-1714, -3154, -48),
		Vector(-1714, -3076, -48), Vector(-1612, -3075, -48), Vector(-1513, -3075, -48), Vector(-1418, -3076, -48),
		Vector(-1301, -3076, -48), Vector(-1238, -3076, -48), Vector(-1144, -3076, -48), Vector(-1083, -3077, -48)
	}
}

-- Расположение спавна при начале игры
ARBITRAGE_LOBBY = {
	drp_hopespeak = {
		Vector(-4134, 2138, 77), Vector(-4592, 2513, 77),
		Vector(-4140, 3155, 77), Vector(-4890, 2401, 77),
		Vector(-4327, 2732, 77), Vector(-4919, 3159, 77),
		Vector(-4833, 2225, 77), Vector(-4414, 2636, 77)
	}
}

-- Кнопки в `C` менюшке
ARBITRAGE_CONTEXT_DATA = {
	dance = {
		robot = "Робот",			muscle = "Стриптиз",		laugh = "Смех",				bow = "Поклон",
		cheer = "Приветствие",		wave = "Помахать рукой",	becon = "Иди ко мне",		agree = "Палец вверх",
		disagree = "Не согласен",	forward = "Вперед",			group = "Сгруппироваться",	zombie = "Зомби",
		dance = "Танец",			pers = "Поза льва",			halt = "Стоять",			salute = "Отдать честь"
	},
	action = {
		["Выбросить оружие"] = {"danganronpa/hud/action/drop.png", function(client)
			client:ConCommand(Format("say /%s", "drop"))
		end},
		["Найденные материалы"] = {"danganronpa/hud/action/material.png", function(client)
			vgui.Create("arb.EvidenceMenu")
		end},
		["Устав академии"] = {"danganronpa/hud/action/charter.png", function(client)
			vgui.Create("arb.AcademyCharter")
		end}
	}
}

-- Отключенные типы сообщений в чате
ARBITRAGE_DISABLE_DATA = {
	joinleave 	= 	true,
	namechange 	= 	true,
	teamchange 	= 	true,
}

-- ID Градиентов
GRADIENT_CENTER		= 		1
GRADIENT_RIGHT		= 		2
GRADIENT_DOWN		= 		3
GRADIENT_UP			= 		4
GRADIENT_LEFT		=		5
GRADIENT_ROUNDING	=		6