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
			name = "#radial_option_back",
			description = "#radial_option_back_desc",
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
				description = "#radial_option_facialemote_desc '" .. name .. "'",
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

function PLUGIN:MoodsOption()
	local data = {
		{
			name = "#radial_option_back",
			description = "#radial_option_back_desc",
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
			description = "#radial_option_mood_desc '" .. v.name .. "'",
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
			name = "#radial_option_back",
			description = "#radial_option_back_desc",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		},
		{
			name = "#radial_option_wardrobe",
			id = "wardrobe",
			description = "#radial_option_wardrobe_desc",
			icon = Material("danganronpa/radialmenu/fashion.png"),
			action = function()
				local panel = vgui_Create("arb.OpenWardrobe")
				panel:SetData(LocalPlayer():GetModel())
			end
		},
		{
			name = "#radial_option_hidestatus",
			id = "hidestatus",
			description = "#radial_option_hidestatus_desc",
			icon = Material("danganronpa/radialmenu/hide.png"),
			action = function()
				local a = !LocalPlayer():GetNetVar("hideStatus", false)
				netstream.Start("arb.HideState", a)
			end
		},
		{
			name = "#radial_option_hidename",
			id = "hidename",
			description = "#radial_option_hidename_desc",
			icon = Material("danganronpa/radialmenu/hidden.png"),
			action = function()
				netstream.Start("arb.HideName")
			end
		},
		{
			name = "#radial_option_description",
			id = "description",
			description = "#radial_option_description_desc",
			icon = Material("danganronpa/radialmenu/loupe.png"),
			action = function()
				vgui_Create("arb.OpenEditorDescription")
			end
		},
		{
			name = "#radial_option_lookaround",
			id = "lookaround",
			description = "#radial_option_lookaround_desc",
			icon = Material("danganronpa/radialmenu/focus.png"),
			action = function()
				RunConsoleCommand("say", "/lookaround")
			end
		},
		{
			name = "#radial_option_roll",
			id = "roll",
			description = "#radial_option_roll_desc",
			icon = Material("danganronpa/radialmenu/dice.png"),
			action = function()
				RunConsoleCommand("say", "/roll")
			end
		},
		{
			name = "#radial_option_fallover",
			id = "fallover",
			description = "#radial_option_fallover_desc",
			icon = Material("danganronpa/radialmenu/d_animation.png"),
			action = function()
				RunConsoleCommand("say", "/fallover")
			end
		}
	}

	if LocalPlayer():IsToko() then
		data[#data + 1] = {
			name = "#radial_option_tokotazer",
			id = "tazer",
			description = "#radial_option_tokotazer_desc",
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
					name = "#radial_option_back",
					description = "#radial_option_back_desc",
					icon = Material("danganronpa/radialmenu/back.png"),
					action = self.ActionsOption
				}
			}

		    for id, count in pairs(ammo) do
				local name = game_GetAmmoName(id)
				if !name then continue end

				info[#info + 1] = {
					name = name .. " (" .. count .. ")",
					id = "unequip_ammo_" .. name:lower(),
					description = "#radial_option_unequipammo " .. name,
					action = function()
					    local DermaPanel = vgui_Create("DFrame")
	                    DermaPanel:SetTitle(L("#radial_option_unquipammo_menu_title"))
	                    DermaPanel:SetSize(400, 100)
	                    DermaPanel:Center()
	                    DermaPanel:MakePopup()

	                    local DermaNumSlider = DermaPanel:Add("DNumSlider")
	                    DermaNumSlider:Dock(FILL)
	                    DermaNumSlider:SetText(L("#radial_option_unquipammo_menu_slider"))
	                    DermaNumSlider:SetMin(1)
	                    DermaNumSlider:SetMax(count)
	                    DermaNumSlider:SetDecimals(0)
	                    DermaNumSlider:SetValue(math_floor(count / 2))

	                    local DermaButton = DermaNumSlider:Add("DButton")
	                    DermaButton:SetText(L("#radial_option_unquipammo_menu_button"))
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
			name = "#radial_option_unquipammob",
			description = "#radial_option_unquipammob_desc",
			icon = Material("danganronpa/radialmenu/ammo.png"),
			iscategory = true,
			action = stored,
		}
	end

	local bSucc = false
	local t_status_effects = LocalPlayer():GetTemporaryStatusEffects()
	for _, array in ipairs(t_status_effects) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks.OnCanGiftedSleeper
		if !_hook then continue end

		local onCan = _hook(LocalPlayer())
		if onCan == true then
			bSucc = true
			break
		end
	end

	if bSucc then
		data[#data + 1] = {
			name = "#radial_option_sleep",
			id = "sleep",
			description = "#radial_option_sleep_desc",
			icon = Material("danganronpa/radialmenu/sleep.png"),
			action = function()
				netstream.Start("arb.Sleeping")
			end
		}
	end

	if Arbitrage.OnThirdPerson() then
		data[#data + 1] = {
			name = "#radial_option_thirdperson",
			id = "thirdperson",
			description = "#radial_option_thirdperson_desc",
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
			name = "#radial_option_back",
			description = "#radial_option_back_desc",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	local function ProcessCategory(category, parentAction)
		local categoryData = {
			{
				name = "#radial_option_back",
				description = "#radial_option_back_desc",
				icon = Material("danganronpa/radialmenu/back.png"),
				action = parentAction
			}
		}

		for _, item in ipairs(category.data) do
			if item.data then
				categoryData[#categoryData + 1] = {
					name = item.name,
					description = item.description or ("#radial_option_action_desc '" .. item.name .. "'"),
					icon = item.icon and Material(item.icon) or nil,
					iscategory = true,
					action = function()
						return ProcessCategory(item, function()
							return categoryData, parentAction
						end)
					end
				}
			else
				local sequence = item.info
				if istable(sequence) then
					sequence = sequence.sequence[1]
				end

				local seqID = LocalPlayer():LookupSequence(sequence)
				if seqID <= -1 then continue end

				categoryData[#categoryData + 1] = {
					name = item.name,
					id = "saction_" .. sequence,
					description = "#radial_option_saction_desc '" .. item.name .. "'",
					icon = item.icon and Material(item.icon) or nil,
					sequence = sequence,
					action = function()
						RunConsoleCommand("say", "/action " .. sequence)
					end
				}
			end
		end

		return categoryData, parentAction
	end

	for _, category in ipairs(Emotes.ActionList) do
		if category.data then
			data[#data + 1] = {
				name = category.name,
				description = "#radial_option_action_desc '" .. category.name .. "'",
				icon = category.icon and Material(category.icon) or nil,
				iscategory = true,
				action = function()
					return ProcessCategory(category, self.StaticAnimationsOption)
				end
			}
		end
	end

	return data, self.MainOption
end

function PLUGIN:DynamicAnimationsOption()
	local info = {
		robot = {"#taunt_robot", ACT_GMOD_TAUNT_ROBOT, "asterion/academy/ui/emotes/act_gmod_taunt_robot.png"},
		muscle = {"#taunt_muscle", ACT_GMOD_TAUNT_MUSCLE, "asterion/academy/ui/emotes/act_gmod_taunt_muscle.png"},
		laugh = {"#taunt_laugh", ACT_GMOD_TAUNT_LAUGH, "asterion/academy/ui/emotes/act_gmod_taunt_laugh.png"},
		bow = {"#taunt_bow", ACT_GMOD_GESTURE_BOW, "asterion/academy/ui/emotes/act_gmod_gesture_bow.png"},
		cheer = {"#taunt_cheer", ACT_GMOD_TAUNT_CHEER, "asterion/academy/ui/emotes/act_gmod_taunt_cheer.png"},
		wave = {"#taunt_wave", ACT_GMOD_GESTURE_WAVE, "asterion/academy/ui/emotes/act_gmod_gesture_wave.png"},
		becon = {"#taunt_becon", ACT_GMOD_GESTURE_BECON, "asterion/academy/ui/emotes/act_gmod_gesture_becon.png"},
		agree = {"#taunt_agree", ACT_GMOD_GESTURE_AGREE, "asterion/academy/ui/emotes/act_gmod_gesture_agree.png"},
		disagree = {"#taunt_disagree", ACT_GMOD_GESTURE_DISAGREE, "asterion/academy/ui/emotes/act_gmod_gesture_disagree.png"},
		forward = {"#taunt_forward", ACT_SIGNAL_FORWARD, "asterion/academy/ui/emotes/act_signal_forward.png"},
		group = {"#taunt_group", ACT_SIGNAL_GROUP, "asterion/academy/ui/emotes/act_signal_group.png"},
		zombie = {"#taunt_zombie", ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, "asterion/academy/ui/emotes/act_gmod_gesture_range_zombie_special.png"},
		dance = {"#taunt_dance", ACT_GMOD_TAUNT_DANCE, "asterion/academy/ui/emotes/act_gmod_taunt_dance.png"},
		pers = {"#taunt_pers", ACT_GMOD_TAUNT_PERSISTENCE, "asterion/academy/ui/emotes/act_gmod_taunt_persistence.png"},
		halt = {"#taunt_halt", ACT_SIGNAL_HALT, "asterion/academy/ui/emotes/act_signal_halt.png"},
		salute = {"#taunt_salute", ACT_GMOD_TAUNT_SALUTE, "asterion/academy/ui/emotes/act_gmod_taunt_salute.png"}
	}

	local data = {
		{
			name = "#radial_option_back",
			description = "#radial_option_back_desc",
			icon = Material("danganronpa/radialmenu/back.png"),
			action = self.MainOption
		}
	}

	for k, v in pairs(info) do
		data[#data + 1] = {
			name = v[1],
			id = "daction_" .. k,
			description = "#radial_option_daction_desc '" .. v[1] .. "'",
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
			name = "#radial_option_emotions",
			description = "#radial_option_emotions_desc",
			icon = Material("danganronpa/radialmenu/emoticons.png"),
			iscategory = true,
			action = self.FacialEmotesOption
		},
		{
			name = "#radial_option_staticanim",
			description = "#radial_option_staticanim_desc",
			icon = Material("danganronpa/radialmenu/s_animation.png"),
			iscategory = true,
			action = self.StaticAnimationsOption
		},
		{
			name = "#radial_option_dynamicanim",
			description = "#radial_option_dynamicanim_desc",
			icon = Material("danganronpa/radialmenu/d_animation.png"),
			iscategory = true,
			action = self.DynamicAnimationsOption
		},
		{
			name = "#radial_option_moods",
			description = "#radial_option_moods_desc",
			icon = Material("danganronpa/radialmenu/mood.png"),
			iscategory = true,
			action = self.MoodsOption
		},
		{
			name = "#radial_option_actionsanim",
			description = "#radial_option_actionsanim_desc",
			icon = Material("danganronpa/radialmenu/settings.png"),
			iscategory = true,
			action = self.ActionsOption
		}
	}
end

function PLUGIN:PlayerOption()
	local data = {
		{
			name = "#radial_option_search",
			id = "search",
			description = "#radial_option_search_desc",
			icon = Material("danganronpa/radialmenu/search.png"),
			action = function()
				netstream.Start("RadialMenu:SearchAction")
			end
		},
		{
			name = "#radial_option_exchange",
			id = "exchange",
			description = "#radial_option_exchange_desc",
			icon = Material("danganronpa/radialmenu/exchange.png"),
			action = function()
				netstream.Start("RadialMenu:ExchangeAction")
			end
		},
		{
			name = "#radial_option_push",
			id = "push",
			description = "#radial_option_push_desc",
			icon = Material("danganronpa/radialmenu/push.png"),
			action = function()
				netstream.Start("RadialMenu:PushAction")
			end
		},
		{
			name = "#radial_option_drag",
			id = "drag",
			description = "#radial_option_drag_desc",
			icon = Material("asterion/academy/ui/radial/action/drag.png"),
			action = function()
				netstream.Start("RadialMenu:DragPlayerAction")
			end
		},
		{
			name = "#radial_option_kiss",
			id = "kiss",
			description = "#radial_option_kiss_desc",
			icon = Material("asterion/academy/ui/radial/action/kiss.png"),
			action = function()
				netstream.Start("RadialMenu:KissPlayerAction")
			end
		},
		{
			name = "#radial_option_hug",
			id = "hug",
			description = "#radial_option_hug_desc",
			icon = Material("asterion/academy/ui/radial/action/hug.png"),
			action = function()
				netstream.Start("RadialMenu:HugPlayerAction")
			end
		}
	}

	local inventory = LocalPlayer():GetInventory()
	if inventory then
		local items = inventory:GetItems()

		for _, item in ipairs(items) do
			if item.base == "base_medical" then
				data[#data + 1] = {
					name = "#radial_option_cure",
					id = "cure",
					description = "#radial_option_cure_desc",
					icon = Material("danganronpa/radialmenu/cure.png"),
					action = function()
						netstream.Start("ItemBase:SendAction", item:GetID(), "#item_action_use_another_player")
					end
				}
				break
			end
		end

		for _, item in ipairs(items) do
			if item.uniqueID == "cuff" or item.uniqueID == "cuff_rope" then
				data[#data + 1] = {
					name = "#radial_option_cuff",
					id = "cuff",
					description = "#radial_option_cuff_desc",
					icon = Material("danganronpa/radialmenu/cuff.png"),
					action = function()
						netstream.Start("ItemBase:SendAction", item:GetID(), "#item_action_tie")
					end
				}
				break
			end
		end
	end

	local target = self:ReturnTracePlayer(LocalPlayer())
	if IsValid(target) and target.IsHandcuffed and target:IsHandcuffed() then
		data[#data + 1] = {
			name = "#radial_option_uncuff",
			id = "uncuff",
			description = "#radial_option_uncuff_desc",
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
			name = "#radial_option_search",
			id = "search",
			description = "#radial_option_search_desc",
			icon = Material("danganronpa/radialmenu/search.png"),
			action = function()
				netstream.Start("RadialMenu:SearchAction")
			end
		},
		{
			name = "#radial_option_standup",
			id = "standup",
			description = "#radial_option_standup_desc",
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

hook("KeyPressID", function(client, id)
	if id != "radialmenu" then return end

	if client:IsSpectate() then return end

	local radial = PLUGIN:OpenRadialMenu()
	if IsValid(radial) and #radial.options <= 0 then
		radial.options = PLUGIN:MainOption()
	end
end)

hook("KeyReleaseID", function(client, id)
	if id != "radialmenu" then return end

	PLUGIN:CloseRadialMenu()
end)

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