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

PLUGIN.isClose = false
PLUGIN.clampingTime = RealTime()

timer.Simple(1, function()
	hook.Remove("PlayerButtonDown", "PlayerButtonDown_FacialEmote")
end)

function PLUGIN:FacialEmotesOption()
	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	if facialEmote and facialEmote.face.data[LocalPlayer():GetModel()] then
		for k, v in pairs(facialEmote.face.data[LocalPlayer():GetModel()]) do
			local name = v.name
			local firstSymbol = string.utf8upper(utf8.sub(name, 1, 1))
			name = firstSymbol .. utf8.sub(name, 2, utf8.len(name))

			data[#data + 1] = {
				name = name,
				id = "emotion_" .. LocalPlayer():Team() .. "_" .. k,
				icon = facialEmote.interface.emojis[v.image],
				description = "Изменить анимацию лица персонажа на: \"" .. name .. "\"",
				action = function()
					facialEmote.network.sendCommand("applyEmotion", k)
				end
			}
		end
	end

	return data, self.MainOption
end

function PLUGIN:SittingOption()
	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	for k, v in pairs(Emotes.SittingList) do
		data[#data + 1] = {
			name = v[1],
			id = "sitting_" .. k,
			description = "Изменить анимацию при сидении на: \"" .. v[1] .. "\"",
			action = function()
				RunConsoleCommand("say", "/sitting " .. k)
			end
		}
	end

	return data, self.MainOption
end

function PLUGIN:MoodsOption()
	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	for k, v in pairs(Emotes.MoodList) do
		data[#data + 1] = {
			name = v.name,
			id = "mood_" .. k,
			description = "Изменить настроение персонажа на: \"" .. v.name .. "\"",
			action = function()
				RunConsoleCommand("say", "/mood " .. k)
			end
		}
	end

	return data, self.MainOption
end

function PLUGIN:ActionsOption()
	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		},
		{
			name = "Изменить внешний вид",
			id = "wardrobe",
			description = "Открыть редактор внешнего вида вашего персонажа",
			icon = Material("danganronpa/radialmenu/fashion.png"),
			action = function()
				local panel = vgui.Create("arb.OpenWardrobe")
				panel:SetData(LocalPlayer():GetModel())
			end
		},
		{
			name = "Скрыть свое состояние",
			id = "hidestatus",
			description = "Скрыть состояние здоровья вашего персонажа от других игроков",
			icon = Material("danganronpa/radialmenu/hide.png"),
			action = function()
				local a = !LocalPlayer():GetNetVar("hideStatus", false)
				netstream.Start("arb.HideState", a)
			end
		},
		{
			name = "Скрыть свое имя",
			id = "hidename",
			description = "Скрыть имя вашего персонажа от других игроков",
			icon = Material("danganronpa/radialmenu/hidden.png"),
			action = function()
				netstream.Start("arb.HideName")
			end
		},
		{
			name = "Изменить РП описание",
			id = "description",
			description = "Изменить РП описание вашего персонажа",
			icon = Material("danganronpa/radialmenu/loupe.png"),
			action = function()
				vgui.Create("arb.OpenEditorDescription")
			end
		},
		-- {
		-- 	name = "Открыть инвентарь",
		-- 	description = "Посмотреть содержимое вашего инвентаря",
		-- 	icon = Material("danganronpa/radialmenu/box.png"),
		-- 	action = function()
		-- 		local panel = Arbitrage.gui.inventory

		-- 		if IsValid(panel) then
		-- 			panel:Remove()
		-- 		end

		-- 		asterionlib.netgui:Create("InventoryBase:Menu")
		-- 	end
		-- },
		{
			name = "Осмотреться",
			id = "lookaround",
			description = "Осмотреть своего персонажа от 3-го лица",
			icon = Material("danganronpa/radialmenu/focus.png"),
			action = function()
				RunConsoleCommand("say", "/lookaround")
			end
		},
		{
			name = "Кинуть ролл",
			id = "roll",
			description = "Испытать удачу вашего персонажа",
			icon = Material("danganronpa/radialmenu/dice.png"),
			action = function()
				RunConsoleCommand("say", "/roll")
			end
		}
	}

	if LocalPlayer():IsToko() then
		data[#data + 1] = {
			name = "Вкл случайные чихания",
			id = "tazer",
			description = "Включить автоматическую смену личности за вашего персонажа",
			icon = Material("danganronpa/radialmenu/sneeze.png"),
			action = function()
				netstream.Start("arb.TokoSneezing")
			end
		}
	end

	local ammo = LocalPlayer():GetAmmo()
	if table.Count(ammo) > 0 then
		local function stored()
			local info = {
				{
					name = "Вернуться назад",
					description = "Вернуть в предыдущую категорию",
					icon = Material("danganronpa/radialmenu/back.png"),
					action = self.ActionsOption
				}
			}

		    for id, count in pairs(ammo) do
				local name = game.GetAmmoName(id)
				if !name then continue end

				info[#info + 1] = {
					name = name .. " (" .. count .. ")",
					id = "unequip_ammo_" .. string.lower(name),
					description = "Вытащить патроны из запаса для " .. name,
					action = function()
						DermaStringRequest = Derma_StringRequest("Разоружить оружие", "Введите количество патрон, которое вы хотите вытащить", count, function(text)
							text = tonumber(text)
							if !text then return end

							netstream.Start("Inventory:UnequipAmmo", id, text)
						end, nil, "Вытащить", "Отменить")
						DermaStringRequest.startTime = SysTime()
						DermaStringRequest:SetAlpha(0)
						DermaStringRequest:AlphaTo(255, 0.3)

					    DermaStringRequest.Paint = function(_, w, h)
					        Derma_DrawBackgroundBlur(_, _.startTime)

					        surface.SetDrawColor(41, 22, 25)
					        surface.DrawRect(0, 0, w, h)

					        surface.SetDrawColor(255, 61, 96, 165.75)
					        surface.DrawOutlinedRect(0, 0, w, h, 2)

					        surface.SetDrawColor(255, 61, 96, 165.75)
					        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

					        surface.SetDrawColor(255, 61, 96, 20)
					        surface.DrawRect(0, 0, w, H(23))
					    end

					    DermaStringRequest:GetChildren()[4]:SetTextColor(Color(255, 255, 255))
					    DermaStringRequest:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(255, 255, 255))
					end
				}
			end

			return info, self.ActionsOption
		end

		data[#data + 1] = {
			name = "Вытащить патроны из запаса",
			description = "Вытащить патроны из запаса для определенного оружия",
			icon = Material("danganronpa/radialmenu/ammo.png"),
			iscategory = true,
			action = stored,
		}
	end

	local character = Character.team:GetByID(LocalPlayer():Team())
	if character then
		local uniqueID = character:GetUniqueID()

		if uniqueID == "chiaki" or uniqueID == "himiko" then
			data[#data + 1] = {
				name = "Уснуть",
				id = "sleep",
				description = "Погрузить вашего персонажа в глубокий сон",
				icon = Material("danganronpa/radialmenu/sleep.png"),
				action = function()
					netstream.Start("arb.Sleeping")
				end
			}
		end
	end

	if LocalPlayer():IsAdmin() then
		data[#data + 1] = {
			name = "Открыть Моно-Меню",
			id = "monomenu",
			description = "Открыть панель администратора",
			icon = Material("danganronpa/hud/action/mono.png"),
			action = function()
				netstream.Start("arb.OpenMonoMenu")
			end
		}
	end

	if Arbitrage.OnThirdPerson() then
		data[#data + 1] = {
			name = "3-е лицо",
			id = "thirdperson",
			description = "Включить вид от 3-го лица",
			icon = Material("danganronpa/radialmenu/thirdperson.png"),
			action = function()
				Arbitrage.ThirdPerson = !Arbitrage.ThirdPerson
			end
		}
	end

	return data, self.MainOption
end

function PLUGIN:StaticAnimationsOption()
	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	for k, v in ipairs(Emotes.ActionList) do
		local function stored()
			local info = {
				{
					name = "Вернуться назад",
					description = "Вернуть в предыдущую категорию",
					icon = Material("danganronpa/radialmenu/back.png"),
					action = self.StaticAnimationsOption
				}
			}

			for k2, v2 in ipairs(v.data) do
				local sequnce = v2.info
				if istable(sequnce) then
					sequnce = sequnce.sequence[1]

					local seqID = LocalPlayer():LookupSequence(sequnce)
					if seqID <= -1 then continue end
				else
					local seqID = LocalPlayer():LookupSequence(sequnce)
					if seqID <= -1 then continue end
				end

				info[#info + 1] = {
					name = v2.name,
					id = "saction_" .. sequnce,
					description = "Установить анимацию персонажа на: \"" .. v2.name .. "\"",
					action = function()
						RunConsoleCommand("say", "/action " .. sequnce)
					end
				}
			end

			return info, self.StaticAnimationsOption
		end

		data[#data + 1] = {
			name = v.name,
			description = "Выбрать анимацию из категории: \"" .. v.name .. "\"",
			iscategory = true,
			action = stored
		}
	end

	return data, self.MainOption
end

function PLUGIN:DynamicAnimationsOption()
	local info = {
		robot = "Робот",			muscle = "Стриптиз",		laugh = "Смех",				bow = "Поклон",
		cheer = "Приветствие",		wave = "Помахать рукой",	becon = "Иди ко мне",		agree = "Палец вверх",
		disagree = "Не согласен",	forward = "Вперед",			group = "Сгруппироваться",	zombie = "Зомби",
		dance = "Танец",			pers = "Поза льва",			halt = "Стоять",			salute = "Отдать честь"
	}

	local data = {
		{
			name = "Вернуться назад",
			description = "Вернуть в предыдущую категорию",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	for k, v in pairs(info) do
		data[#data + 1] = {
			name = v,
			id = "daction_" .. k,
			description = "Проиграть анимацию \"" .. v .. "\"",
			action = function()
				RunConsoleCommand("act", k)
			end
		}
	end

	return data, self.MainOption
end

function PLUGIN:MainOption()
	return {
		{
			name = "Эмоции",
			description = "Выбрать интересующую эмоцию лица для вашего персонажа",
			icon = Material("danganronpa/radialmenu/emoticons.png"),
			iscategory = true,
			action = self.FacialEmotesOption
		},
		{
			name = "Статические анимации",
			description = "Выбрать стойку для вашего персонажа",
			icon = Material("danganronpa/radialmenu/s_animation.png"),
			iscategory = true,
			action = self.StaticAnimationsOption
		},
		{
			name = "Динамические анимации",
			description = "Выбрать динамическую анимацию стойку для вашего персонажа",
			icon = Material("danganronpa/radialmenu/d_animation.png"),
			iscategory = true,
			action = self.DynamicAnimationsOption
		},
		{
			name = "Настроение",
			description = "Выбрать стиль хождения для вашего персонажа",
			icon = Material("danganronpa/radialmenu/mood.png"),
			iscategory = true,
			action = self.MoodsOption
		},
		-- {
		-- 	name = "Анимация сидения",
		-- 	description = "Выбрать нужную вам анимацию когда вы будете сидеть",
		-- 	icon = Material("danganronpa/radialmenu/sit.png"),
		-- 	action = self.SittingOption
		-- },
		{
			name = "Действия",
			description = "Выполнить какое либо действие",
			icon = Material("danganronpa/radialmenu/settings.png"),
			iscategory = true,
			action = self.ActionsOption
		}
	}
end

function PLUGIN:PlayerOption()
	local data = {
		{
			name = "Обыскать",
			id = "search",
			description = "Посмотреть содержимое инвентаря данного игрока",
			icon = Material("danganronpa/radialmenu/search.png"),
			action = function()
				netstream.Start("RadialMenu:SearchAction")
			end
		},
		{
			name = "Предложить обмен",
			id = "exchange",
			description = "Предложить обмен предметами с данным игроком",
			icon = Material("danganronpa/radialmenu/exchange.png"),
			action = function()
				netstream.Start("RadialMenu:ExchangeAction")
			end
		},
		{
			name = "Толкнуть",
			id = "push",
			description = "Толкнуть данного игрока",
			icon = Material("danganronpa/radialmenu/push.png"),
			action = function()
				netstream.Start("RadialMenu:PushAction")
			end
		},
	}

	local inventory = LocalPlayer():GetInventory()
	if inventory then
		local items = inventory:GetItems()

		for _, item in ipairs(items) do
			if item.base == "base_medical" then
				data[#data + 1] = {
					name = "Вылечить",
					id = "cure",
					description = "Вылечить данного игрока при помощи ваших медикаментов",
					icon = Material("danganronpa/radialmenu/cure.png"),
					action = function()
						netstream.Start("ItemBase:SendAction", item:GetID(), "Использовать на другом игроке")
					end
				}
				break
			end
		end

		for _, item in ipairs(items) do
			if item.uniqueID == "cuff" or item.uniqueID == "cuff_rope" then
				data[#data + 1] = {
					name = "Связать",
					id = "cuff",
					description = "Связать данного игрока при помощи ваших наручников",
					icon = Material("danganronpa/radialmenu/cuff.png"),
					action = function()
						netstream.Start("ItemBase:SendAction", item:GetID(), "Связать")
					end
				}
				break
			end
		end
	end

	local target = self:ReturnTracePlayer(LocalPlayer())
	if IsValid(target) and target:IsHandcuffed() then
		data[#data + 1] = {
			name = "Развязать",
			id = "uncuff",
			description = "Развязать данного игрока при помощи ваших наручников",
			icon = Material("danganronpa/radialmenu/uncuff.png"),
			action = function()
				net.Start("Cuffs_FreePlayer")
					net.WriteEntity(target)
				net.SendToServer()
			end
		}
	end

	return data
end

function PLUGIN:OpenRadialMenu()
	if !IsValid(Arbitrage.gui.radialmenu) and !self.isClose and (!vgui.CursorVisible() or (Arbitrage.lawEnable and !Arbitrage.gui.chat:GetActive())) then
		self.clampingTime = RealTime() + 0.5
		return vgui.Create("Radial:Menu")
	end

	local panel = Arbitrage.gui.radialmenu
	if IsValid(panel) and !panel.bClose then
		panel:NewClose()
	end

	self.isClose = false
end

function PLUGIN:CloseRadialMenu()
	if RealTime() > self.clampingTime then
		local panel = Arbitrage.gui.radialmenu
		if IsValid(panel) and !panel.bClose then
			panel:NewClose()
		end

		self.isClose = false
	end
end

local function add(old, new)
	for k, v in ipairs(new or {}) do
		if v.id then
			old[v.id] = v
		end

		if v.action and v.iscategory then
			old = add(old, v.action(PLUGIN))
		end
	end

	return old
end

function PLUGIN:GetActionsList()
	local data = {}
	data = add(data, self:MainOption())
	data = add(data, self:PlayerOption())

	return data
end

concommand.Add("arb_radialmenu_action", function(client, cmd, args)
	local id = args[1]
	if !id then return end

	local actions = PLUGIN:GetActionsList()
	local action = actions[id]
	if !action then return end

	local func = action.action
	if func then
		func()
	end
end)

function PLUGIN:KeyPressID(client, id)
	if id != "radialmenu" then return end

	if client:IsSpectate() then return end

	local radial = self:OpenRadialMenu()
	if IsValid(radial) and #radial.options <= 0 then
		radial.options = self:MainOption()
	end
end

function PLUGIN:KeyReleaseID(client, id)
	if id != "radialmenu" then return end

	self:CloseRadialMenu()
end

function PLUGIN:KeyPress(client, key)
	if key != IN_USE then return end
	if !IsFirstTimePredicted() then return end

	local entity = self:ReturnTracePlayer()
	if !IsValid(entity) then return end

	if client:IsSpectate() then return end

	local radial = self:OpenRadialMenu()
	if IsValid(radial) and #radial.options <= 0 then
		radial.options = self:PlayerOption()
		radial.isPlayerOptions = true
	end
end

function PLUGIN:KeyRelease(client, key)
	if key != IN_USE then return end
	if !IsFirstTimePredicted() then return end

	local panel = Arbitrage.gui.radialmenu
	if !IsValid(panel) then return end
	if !panel.isPlayerOptions then return end

	self:CloseRadialMenu()
end