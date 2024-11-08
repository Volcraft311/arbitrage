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

-- Localize Global Calls
local RealTime = RealTime
local timer_Simple = timer.Simple
local hook_Remove = hook.Remove
local Material = Material
local pairs = pairs
local string = string
local utf8_sub = utf8.sub
local utf8_len = utf8.len
local facialEmote = facialEmote
local RunConsoleCommand = RunConsoleCommand
local vgui_Create = vgui.Create
local netstream = netstream
local table_Count = table.Count
local game_GetAmmoName = game.GetAmmoName
local string_lower = string.lower
local math_floor = math.floor
local math_Round = math.Round
local SysTime = SysTime
local Derma_DrawBackgroundBlur = Derma_DrawBackgroundBlur
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local Color = Color
local ipairs = ipairs
local istable = istable
local IsValid = IsValid
local net_Start = net.Start
local net_WriteEntity = net.WriteEntity
local net_SendToServer = net.SendToServer
local vgui_CursorVisible = vgui.CursorVisible
local concommand_Add = concommand.Add
local IsFirstTimePredicted = IsFirstTimePredicted

PLUGIN.isClose = false
PLUGIN.clampingTime = RealTime()

timer_Simple(1, function()
	hook_Remove("PlayerButtonDown", "PlayerButtonDown_FacialEmote")
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

	if facialEmote then
		local info = facialEmote.face.data[LocalPlayer():GetModel()]

		for k, v in pairs(info or {}) do
			local name = v.name
			local firstSymbol = string.utf8upper(utf8_sub(name, 1, 1))
			name = firstSymbol .. utf8_sub(name, 2, utf8_len(name))

			data[#data + 1] = {
				name = name,
				id = "emotion_" .. LocalPlayer():Team() .. "_" .. k,
				icon = facialEmote.interface.emojis[v.image],
				description = "Изменить анимацию лица персонажа на: '" .. name .. "'",
				sequence = "idle_all_01",
				facial = v.data,
				cameraBone = "ValveBiped.Bip01_Head1",
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
			description = "Изменить анимацию при сидении на: '" .. v[1] .. "'",
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
			icon = v.icon and Material(v.icon) or nil,
			sequence = v.sequences and (LocalPlayer():LookupSequence(v.sequences.idle) >= 0 and v.sequences.idle) or "idle_all_01",
			description = "Изменить настроение персонажа на: '" .. v.name .. "'",
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
				local panel = vgui_Create("arb.OpenWardrobe")
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
				vgui_Create("arb.OpenEditorDescription")
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
		},
		{
			name = "Упасть",
			id = "fallover",
			description = "Заставить вашего персонажа упасть на пол",
			icon = Material("danganronpa/radialmenu/d_animation.png"),
			action = function()
				RunConsoleCommand("say", "/fallover")
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
	if table_Count(ammo) > 0 then
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
				local name = game_GetAmmoName(id)
				if !name then continue end

				info[#info + 1] = {
					name = name .. " (" .. count .. ")",
					id = "unequip_ammo_" .. string_lower(name),
					description = "Вытащить патроны из запаса для " .. name,
					action = function()
					    local DermaPanel = vgui_Create("DFrame")
	                    DermaPanel:SetTitle("Вытащить патроны")
	                    DermaPanel:SetSize(400, 100)
	                    DermaPanel:Center()
	                    DermaPanel:MakePopup()

	                    local DermaNumSlider = DermaPanel:Add("DNumSlider")
	                    DermaNumSlider:Dock(FILL)
	                    DermaNumSlider:SetText("Количество:")
	                    DermaNumSlider:SetMin(1)
	                    DermaNumSlider:SetMax(count)
	                    DermaNumSlider:SetDecimals(0)
	                    DermaNumSlider:SetValue(math_floor(count / 2))

	                    local DermaButton = DermaNumSlider:Add("DButton")
	                    DermaButton:SetText("Вытащить")
	                    DermaButton:Dock(BOTTOM)
	                    DermaButton.DoClick = function()
	                        local value = DermaNumSlider:GetValue()

	                        DermaPanel:Remove()
	                        netstream.Start("Inventory:UnequipAmmo", id, math_Round(value, 0))
	                    end

	                    DermaPanel.startTime = SysTime()
	                    DermaPanel:SetAlpha(0)
	                    DermaPanel:AlphaTo(255, 0.3)

	                    DermaPanel.Paint = function(_, w, h)
	                        Derma_DrawBackgroundBlur(_, _.startTime)

	                        surface_SetDrawColor(41, 22, 25)
	                        surface_DrawRect(0, 0, w, h)

	                        surface_SetDrawColor(255, 61, 96, 165.75)
	                        surface_DrawOutlinedRect(0, 0, w, h, 2)

	                        surface_SetDrawColor(255, 61, 96, 165.75)
	                        surface_DrawOutlinedRect(0, 0, w, H(23), 2)

	                        surface_SetDrawColor(255, 61, 96, 20)
	                        surface_DrawRect(0, 0, w, H(23))
	                    end

	                    DermaPanel:GetChildren()[4]:SetTextColor(Color(255, 255, 255))
	                    DermaPanel:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(255, 255, 255))
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
					description = "Установить анимацию персонажа на: '" .. v2.name .. "'",
					icon = v2.icon and Material(v2.icon) or nil,
					sequence = sequnce,
					action = function()
						RunConsoleCommand("say", "/action " .. sequnce)
					end
				}
			end

			return info, self.StaticAnimationsOption
		end

		data[#data + 1] = {
			name = v.name,
			description = "Выбрать анимацию из категории: '" .. v.name .. "'",
			icon = v.icon and Material(v.icon) or nil,
			iscategory = true,
			action = stored
		}
	end

	return data, self.MainOption
end

function PLUGIN:DynamicAnimationsOption()
	local info = {
		robot = {"Робот", ACT_GMOD_TAUNT_ROBOT, "asterion/academy/ui/emotes/act_gmod_taunt_robot.png"},
		muscle = {"Стриптиз", ACT_GMOD_TAUNT_MUSCLE, "asterion/academy/ui/emotes/act_gmod_taunt_muscle.png"},
		laugh = {"Смех", ACT_GMOD_TAUNT_LAUGH, "asterion/academy/ui/emotes/act_gmod_taunt_laugh.png"},
		bow = {"Поклон", ACT_GMOD_GESTURE_BOW, "asterion/academy/ui/emotes/act_gmod_gesture_bow.png"},
		cheer = {"Приветствие", ACT_GMOD_TAUNT_CHEER, "asterion/academy/ui/emotes/act_gmod_taunt_cheer.png"},
		wave = {"Помахать рукой", ACT_GMOD_GESTURE_WAVE, "asterion/academy/ui/emotes/act_gmod_gesture_wave.png"},
		becon = {"Иди ко мне", ACT_GMOD_GESTURE_BECON, "asterion/academy/ui/emotes/act_gmod_gesture_becon.png"},
		agree = {"Палец вверх", ACT_GMOD_GESTURE_AGREE, "asterion/academy/ui/emotes/act_gmod_gesture_agree.png"},
		disagree = {"Не согласен", ACT_GMOD_GESTURE_DISAGREE, "asterion/academy/ui/emotes/act_gmod_gesture_disagree.png"},
		forward = {"Вперед", ACT_SIGNAL_FORWARD, "asterion/academy/ui/emotes/act_signal_forward.png"},
		group = {"Сгруппироваться", ACT_SIGNAL_GROUP, "asterion/academy/ui/emotes/act_signal_group.png"},
		zombie = {"Зомби", ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, "asterion/academy/ui/emotes/act_gmod_gesture_range_zombie_special.png"},
		dance = {"Танец", ACT_GMOD_TAUNT_DANCE, "asterion/academy/ui/emotes/act_gmod_taunt_dance.png"},
		pers = {"Поза льва", ACT_GMOD_TAUNT_PERSISTENCE, "asterion/academy/ui/emotes/act_gmod_taunt_persistence.png"},
		halt = {"Стоять", ACT_SIGNAL_HALT, "asterion/academy/ui/emotes/act_signal_halt.png"},
		salute = {"Отдать честь", ACT_GMOD_TAUNT_SALUTE, "asterion/academy/ui/emotes/act_gmod_taunt_salute.png"}
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
			name = v[1],
			id = "daction_" .. k,
			description = "Проиграть анимацию '" .. v[1] .. "'",
			icon = v[3] and Material(v[3]) or nil,
			-- sequence = "idle_all_01",
			-- weightedSequence = v[2],
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
	if IsValid(target) and target.IsHandcuffed and target:IsHandcuffed() then
		data[#data + 1] = {
			name = "Развязать",
			id = "uncuff",
			description = "Развязать данного игрока при помощи ваших наручников",
			icon = Material("danganronpa/radialmenu/uncuff.png"),
			action = function()
				net_Start("Cuffs_FreePlayer")
					net_WriteEntity(target)
				net_SendToServer()
			end
		}
	end

	return data
end

function PLUGIN:RagdollOption()
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
			name = "Поднять",
			id = "standup",
			description = "Поднять игрока на ноги",
			icon = Material("danganronpa/radialmenu/push.png"),
			action = function()
				netstream.Start("RadialMenu:StandUp")
			end
		}
	}

	return data
end

function PLUGIN:OpenRadialMenu()
	if !IsValid(Arbitrage.gui.radialmenu) and !self.isClose and (!vgui_CursorVisible() or (Arbitrage.lawEnable and !Arbitrage.gui.chat:GetActive())) then
		self.clampingTime = RealTime() + 0.5
		return vgui_Create("Radial:Menu")
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

concommand_Add("arb_radialmenu_action", function(client, cmd, args)
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
	if client:IsSpectate() then return end

	if key != IN_USE then return end
	if !IsFirstTimePredicted() then return end

	local entity, clientRagdoll = self:ReturnTracePlayer()
	if !IsValid(entity) then return end

	local radial = self:OpenRadialMenu()
	if IsValid(radial) and #radial.options <= 0 then
		radial.options = clientRagdoll and self:RagdollOption() or self:PlayerOption()
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