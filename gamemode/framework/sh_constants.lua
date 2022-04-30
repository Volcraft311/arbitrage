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
ARBITRAGE_SAY_LENGTH = 300

-- Стандартная модель игрока
ARBITRAGE_STANDART_MODEL = "models/player/skeleton.mdl"

-- Кнопки в `C` менюшке
ARBITRAGE_CONTEXT_DATA = {
	dance = {
		robot = "Робот",			muscle = "Стриптиз",		laugh = "Смех",				bow = "Поклон",
		cheer = "Приветствие",		wave = "Помахать рукой",	becon = "Иди ко мне",		agree = "Палец вверх",
		disagree = "Не согласен",	forward = "Вперед",			group = "Сгруппироваться",	zombie = "Зомби",
		dance = "Танец",			pers = "Поза льва",			halt = "Стоять",			salute = "Отдать честь"
	},
	action = {
		["Скрыть свое состояние"] = {"danganronpa/hud/action/drop.png", function(client)
			local a = !client:GetNetVar("hideStatus", false)

			netstream.Start("arb.HideState", a)
		end},
		["Найденные материалы"] = {"danganronpa/hud/action/material.png", function(client)
			vgui.Create("arb.EvidenceMenu")
		end},
		["Устав академии"] = {"danganronpa/hud/action/charter.png", function(client)
			vgui.Create("arb.AcademyCharter")
		end},
		["Открыть инвентарь"] = {"danganronpa/hud/action/charter.png", function(client)
			local panel = Arbitrage.gui.inventory

			if IsValid(panel) then
				panel:Remove()
			end

			vgui.Create("InventoryBase:Menu")
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