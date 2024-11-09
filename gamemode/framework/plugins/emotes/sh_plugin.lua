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

-- Localize Global Calls
local string_lower = string.lower
local Vector = Vector
local ipairs = ipairs
local istable = istable
local FindMetaTable = FindMetaTable
local table_Copy = table.Copy
local CurTime = CurTime
local IsValid = IsValid
local select = select


local PLUGIN = PLUGIN
Emotes = PLUGIN

Emotes.name = "Emotes"

Emotes.action = {}
Emotes.action.stored = {}

Arbitrage.GM.HandlePlayerLanding = zero

function Emotes.action:Register(uniqueID, data)
	Emotes.action.stored[string_lower(uniqueID)] = data
end

Emotes.ActionList = {
	{
		name = "Встать",
		icon = nil,
		data = {
			{name = "Стойка 1", icon = "asterion/academy/ui/emotes/lineidle01.png", info = "LineIdle01"},
			{name = "Стойка 2", icon = "asterion/academy/ui/emotes/lineidle02.png", info = "LineIdle02"},
			{name = "Стойка 3", icon = "asterion/academy/ui/emotes/lineidle03.png", info = "LineIdle03"},
			-- {name = "Стойка 4", icon = nil, info = "menu_combine"},
			{name = "Руки на пояс", icon = "asterion/academy/ui/emotes/pose_standing_02.png", info = "pose_standing_02"},
			{name = "Рука на бок", icon = "asterion/academy/ui/emotes/standpose_1.png", info = "standpose_1"},
			{name = "Руки на пояснице", icon = "asterion/academy/ui/emotes/standpose_3.png", info = "standpose_3"},
			{name = "Руки за спину", icon = "asterion/academy/ui/emotes/standpose_5.png", info = "standpose_5"},
			{name = "Облокотиться", icon = "asterion/academy/ui/emotes/idle_suitcase.png", info = "idle_suitcase"},
			{name = "Руки в карманы", icon = "asterion/academy/ui/emotes/lineidle04.png", info = "LineIdle04"},
			{name = "Скрестить руки 1", icon = "asterion/academy/ui/emotes/pose_standing_01.png", info = "pose_standing_01"},
			{name = "Скрестить руки 2", icon = "asterion/academy/ui/emotes/standpose_2.png", info = "standpose_2"},
			{name = "Скрестить руки 3", icon = "asterion/academy/ui/emotes/standpose_4.png", info = "standpose_4"},
			{name = "Представить", icon = "asterion/academy/ui/emotes/pose_standing_03.png", info = "pose_standing_03"},
			{name = "Одобрить", icon = "asterion/academy/ui/emotes/pose_standing_04.png", info = "pose_standing_04"},
			{name = "Напряженно", icon = "asterion/academy/ui/emotes/scaredidle.png", info = "scaredidle"},
			{name = "Скрестить руки, сгорбиться", icon = "asterion/academy/ui/emotes/d1_t02_playground_cit1_arms_crossed.png", info = "d1_t02_Playground_Cit1_Arms_Crossed"},
			{name = "Руки в карманы, сгорбиться", icon = "asterion/academy/ui/emotes/d1_t02_playground_cit2_pockets.png", info = "d1_t02_Playground_Cit2_Pockets"},
			{name = "Напряженно", icon = "asterion/academy/ui/emotes/canals_arlene_pourgas.png", info = "canals_arlene_pourgas"},
			{name = "Одышка", icon = "asterion/academy/ui/emotes/2_coast03_postBattle_idle02.png", info = {
				start = {"d2_coast03_postbattle_idle02_entry"},
				sequence = {"d2_coast03_PostBattle_Idle02", duration = -1}
			}},
			{name = "Прятать голову", icon = "asterion/academy/ui/emotes/cower_idle.png", info = "cower_Idle"},
			{name = "Прямо", icon = "asterion/academy/ui/emotes/stand_villagebase.png", info = "stand_villagebase"},
			{name = "Напряженно", icon = "asterion/academy/ui/emotes/stand_meleebase.png", info = "stand_meleebase"}
		}
	},
	{
		name = "Возле стены",
		icon = nil,
		data = {
			{name = "Одышка, лицом к стене", icon = "asterion/academy/ui/emotes/d2_coast03_postbattle_idle01_entry.png", info = {
				start = {"d2_coast03_postbattle_idle01_entry"},
				sequence = {"d2_coast03_PostBattle_Idle01", duration = -1}
			}},
			{name = "Упереться в стену", icon = "asterion/academy/ui/emotes/doorbracer_closed.png", info = "doorBracer_Closed"},
			{name = "Смотреть в окно", icon = "asterion/academy/ui/emotes/d1_t03_lookoutwindow.png", info = "d1_t03_LookOutWindow"},
			{name = "Облокотиться влево", icon = "asterion/academy/ui/emotes/lean_left.png", info = "Lean_Left"},
			{name = "Облокотиться назад", icon = "asterion/academy/ui/emotes/idle_to_lean_back.png", info = {
				start = {"idle_to_lean_back"},
				sequence = {"Lean_Back", duration = -1},
			}},
			{name = "Облокотиться назад, руки за спину", icon = "asterion/academy/ui/emotes/plazaidle1.png", info = "plazaidle1"},
			{name = "Облокотиться назад, руки прямо", icon = "asterion/academy/ui/emotes/plazaidle2.png", info = "plazaidle2"}
		}
	},
	{
		name = "Присесть",
		icon = nil,
		data = {
			{name = "На колено", icon = "asterion/academy/ui/emotes/base_cit_medic_postanim.png", info = "citizen4_preaction"}, -- мужская
			{name = "На колено", icon = "asterion/academy/ui/emotes/base_cit_medic_postanim.png", info = "base_cit_medic_postanim"}, -- женская
			{name = "Осматриваться", icon = "asterion/academy/ui/emotes/lookoutidle.png", info = "lookoutidle"},
			{name = "На колени", icon = "asterion/academy/ui/emotes/canals_mary_postidle.png", info = "canals_mary_postidle"},
			{name = "На колени, сгорбиться", icon = "asterion/academy/ui/emotes/canals_mary_preidle.png", info = "canals_mary_preidle"},
			{name = "Осматривать предмет", icon = "asterion/academy/ui/emotes/checkmalepost.png", info = "checkmalepost"},
			{name = "Изучать пол", icon = "asterion/academy/ui/emotes/d1_town05_daniels_kneel_idle.png", info = "d1_town05_Daniels_Kneel_Idle"}, -- мужская
			{name = "Изучать пол", icon = "asterion/academy/ui/emotes/d1_town05_jacobs_heal.png", info = "d1_town05_Jacobs_Heal"}, -- женская
			{name = "На пол", icon = "asterion/academy/ui/emotes/idle_to_sit_ground.png", info = {
				start = {"idle_to_sit_ground"},
				sequence = {"sit_ground", duration = -1},
				finish = {"sit_ground_to_idle", duration = 2.1}
			}},
			{name = "На корты", icon = "asterion/academy/ui/emotes/plazaidle4.png", info = "plazaidle4"},
			{name = "Медитировать", icon = "asterion/academy/ui/emotes/sit_zen.png", info = "sit_zen"},
		}
	},
	{
		name = "Лечь",
		icon = nil,
		data = {
			{name = "На живот, руки за голову", icon = "asterion/academy/ui/emotes/arrestidle.png", info = "arrestidle"},
			{name = "На спину, ранение", icon = "asterion/academy/ui/emotes/d1_town05_winston_down.png", info = "d1_town05_Winston_Down"},
			{name = "На спину, корчиться", icon = "asterion/academy/ui/emotes/d1_town05_wounded_idle_2.png", info = "d1_town05_Wounded_Idle_2"},
			{name = "На спину, облокотиться 1", icon = "asterion/academy/ui/emotes/injured1.png", info = "injured1"},
			{name = "На спину, облокотиться 2", icon = "asterion/academy/ui/emotes/injured2.png", info = "injured2"},
			{name = "На спину, в развалку", icon = "asterion/academy/ui/emotes/injured3.png", info = "injured3"},
			{name = "На бок, спокойно", icon = "asterion/academy/ui/emotes/sniper_victim_pre.png", info = "sniper_victim_pre"},
			{name = "Оперевшись на руки", icon = "asterion/academy/ui/emotes/d2_coast11_tobias.png", info = "d2_coast11_Tobias"},
			{name = "На спину, спокойно", icon = "asterion/academy/ui/emotes/lying_down.png", info = "Lying_Down"},
			{name = "На бок, корчиться", icon = "asterion/academy/ui/emotes/d1_town05_wounded_idle_1.png", info = "d1_town05_Wounded_Idle_1"},
		}
	},
	{
		name = "Другое",
		icon = nil,
		data = {
			{name = "Прикрываться руками", icon = "asterion/academy/ui/emotes/stopwomanpre.png", info = "stopwomanpre"},
			{name = "Поднять руки перед собой", icon = "asterion/academy/ui/emotes/d1_t01_clutch_chainlink_idle.png", info = "d1_t01_Clutch_Chainlink_Idle"},
			{name = "Положить руки перед собой", icon = "asterion/academy/ui/emotes/luggageidle.png", info = "luggageidle"},
			{name = "Протянуть руки ладонями вверх", icon = "asterion/academy/ui/emotes/d2_coast03_odessa_rpg_give_idle.png", info = "d2_coast03_Odessa_RPG_Give_Idle"},
		}
	},
	{
		name = "Анимированные",
		icon = nil,
		data = {
			{name = "Подобрать", icon = "asterion/academy/ui/emotes/pickup.png", info = {sequence = {"Pickup"}}},
			{name = "Официально", icon = "asterion/academy/ui/emotes/menu_gman.png", info = "menu_gman"},
			{name = "Ожидание 1", icon = "asterion/academy/ui/emotes/idle_afk_1.png", info = "idle_afk_1"},
			{name = "Ожидание 2", icon = "asterion/academy/ui/emotes/idle_afk_2.png", info = "idle_afk_2"},
			{name = "Ожидание 3", icon = "asterion/academy/ui/emotes/idle_afk_3.png", info = "idle_afk_3"},
			{name = "Ожидание 4", icon = "asterion/academy/ui/emotes/stand_allbase.png", info = "stand_allbase"},
		}
	}
}

Emotes.StandList = {
	"idle_afk_1",
	"idle_afk_2",
	"idle_afk_3",
	"stand_allbase"
}

Emotes.SittingList = {
	[0] = {"sit"},
	[1] = {"d1_t02_Plaza_Sit01_Idle", Vector(0, 0, -19)},
	[2] = {"Sit_Chair", Vector(20, 0, -17)},
	[3] = {"Sit_Ground", Vector(8, 0, -5)},
	[4] = {"sit_zen"},
	[5] = {"sitccouchtv1", Vector(24, 0, -20)},
	[6] = {"sitchair1", Vector(6, 0, -23)},
	[7] = {"sitchairtable1", Vector(2, 0, -23)},
	[8] = {"sitcouch1", Vector(18, 0, -17)},
	[9] = {"sitcouchfeet1", Vector(20, 0, -20)},
	[10] = {"sitcouchknees1", Vector(20, 0, -18)}
}

Emotes.MoodList = {
	[0] = {
		name = "Стандартная",
		icon = "asterion/academy/ui/emotes/mood_standard.png"
	},
	[1] = {
		name = "Расслабленный",
		icon = "asterion/academy/ui/emotes/mood_relaxed.png",
		sequences = {
			idle = "LineIdle01",
		}
	},
	[2] = {
		name = "Запаниковал",
		icon = "asterion/academy/ui/emotes/mood_panicked.png",
		sequences = {
			idle = "scaredidle",
			run = "run_protected_all"
		}
	},
	[3] = {
		name = "Упрямый",
		icon = "asterion/academy/ui/emotes/mood_stubborn.png",
		sequences = {
			idle = "LineIdle03",
			walk = "luggage_walk_all"
		}
	},
	[4] = {
		name = "Недовольный",
		icon = "asterion/academy/ui/emotes/mood_dissatisfied.png",
		sequences = {
			idle = "LineIdle02",
			walk = "pace_all"
		}
	},
	[5] = {
		name = "Уверенный",
		icon = "asterion/academy/ui/emotes/mood_confident.png",
		sequences = {
			idle = "standpose_1"
		}
	},
	[6] = {
		name = "Прилежный",
		icon = "asterion/academy/ui/emotes/mood_diligent.png",
		sequences = {
			idle = "standpose_5"
		}
	}
}

for k, v in ipairs(Emotes.ActionList) do
	for k2, v2 in ipairs(v.data or {}) do
		local data = nil
		if istable(v2.info) then
			data = v2.info
		else
			data = {
				sequence = {v2.info, duration = -1}
			}
		end

		local id = data.sequence[1]
		Emotes.action:Register(id, data)
	end
end

local playerMeta = FindMetaTable("Player")
function playerMeta:GetAction()
	local data = self:GetNetVar("action")
	if !data then return end

	data = table_Copy(data)
	return data[1], data[2], data[3], data[4]
end

function playerMeta:GetSittingSequence()
	local sequence = "sit"

	local sittingID = self:GetNetVar("sitting")
	if sittingID then
		return Emotes.SittingList[sittingID][1]
	end

	return sequence
end

function playerMeta:GetMood()
	local moodID = self:GetNetVar("mood")
	if !moodID then return end

	return Emotes.MoodList[moodID]
end

local function getSequenceID(array, id, client)
	local sequence = array[id]
	local sequenceID = sequence and client:LookupSequence(sequence)

	if sequenceID and sequenceID > -1 then
		return sequenceID
	end
end

if CLIENT then
	function Emotes:CalcMainActivity(client, velocity)
		local isProne = client.IsProne and client:IsProne()
		if isProne then return end

		-- Акты
		do
			local seq, seqTime = client:GetAction()
			if seq then
				local seqID = client:LookupSequence(seq)

				if seqID > -1 and (seqTime <= -1 or seqTime > CurTime()) then
					if client:GetSequence() != seqID then
						client:SetCycle(0)
						client:SetPlaybackRate(1)
					end

					return -1, seqID
				end
			end
		end

		-- Сидение
		do
			if client.GetSitting and client:GetSitting() then
				local sitID = client:GetNetVar("sitting")
				if sitID then
					local seq = client:GetSittingSequence()
					local seqID = client:LookupSequence(seq)

					if seqID > -1 then
						return -1, seqID
					end
				end
			end
		end

		local len2D = velocity:Length2D()
		-- Анимации ожидания
		do
			if len2D <= 0 then
				local animationData = client:GetNetVar("stand_animation")
				if animationData then
					local seq = animationData[1]
					local delay = animationData[2]

					if delay >= CurTime() then
						local seqID = client:LookupSequence(seq)

						if seqID > -1 then
							if client:GetSequence() != seqID then
								client:SetCycle(0)
								client:SetPlaybackRate(1)
							end

							return -1, seqID
						end
					end
				end
			end
		end

		-- Настроение
		do
			local mood = client:GetMood()
			if mood and !client:InVehicle() and !client:Crouching() and client:OnGround() then
				local weapon = client:GetActiveWeapon()
				local holdType = "normal"
				local class = nil
				if IsValid(weapon) then
					holdType = weapon.HoldType or weapon:GetHoldType()
					class = weapon:GetClass()
				end

				if (class == "academy_key" or class == "academy_first") and holdType == "normal" then
					local sequence = nil
					local data = mood.sequences or {}

					if len2D < 10 then
						local sequenceID = getSequenceID(data, "idle", client)
						if sequenceID then
							sequence = sequenceID
						end
					elseif len2D >= 140 then
						local sequenceID = getSequenceID(data, "run", client)
						if sequenceID then
							sequence = sequenceID
						end
					else
						local sequenceID = getSequenceID(data, "walk", client)
						if sequenceID then
							sequence = sequenceID
						end
					end

					if sequence then
						client.CalcIdeal = ACT_MP_STAND_IDLE
						client.CalcSeqOverride = sequence

						return client.CalcIdeal, client.CalcSeqOverride
					end
				end
			end
		end
	end
end

function Emotes:UpdateAnimation(client, moveData)
	local _, _, bThirdPerson, seqAngle = client:GetAction()

	if bThirdPerson and seqAngle then
		client:SetRenderAngles(seqAngle)
	end
end

local keyBlacklist = IN_ATTACK + IN_ATTACK2 + IN_JUMP + IN_DUCK
function Emotes:StartCommand(client, command)
	if select(3, client:GetAction()) then
		command:RemoveKey(keyBlacklist)
		command:ClearMovement()
	end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")