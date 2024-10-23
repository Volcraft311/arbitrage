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
		icon = "",
		data = {
			{name = "Стойка 1", icon = "", info = "LineIdle01"},
			{name = "Стойка 2", icon = "", info = "LineIdle02"},
			{name = "Стойка 3", icon = "", info = "LineIdle03"},
			-- {name = "Стойка 4", icon = "", info = "menu_combine"},
			{name = "Руки на пояс", icon = "", info = "pose_standing_02"},
			{name = "Рука на бок", icon = "", info = "standpose_1"},
			{name = "Руки на пояснице", icon = "", info = "standpose_3"},
			{name = "Руки за спину", icon = "", info = "standpose_5"},
			{name = "Облокотиться", icon = "", info = "idle_suitcase"},
			{name = "Официально", icon = "", info = "menu_gman"},
			{name = "Руки в карманы", icon = "", info = "LineIdle04"},
			{name = "Скрестить руки 1", icon = "", info = "pose_standing_01"},
			{name = "Скрестить руки 2", icon = "", info = "standpose_2"},
			{name = "Скрестить руки 3", icon = "", info = "standpose_4"},
			{name = "Представить", icon = "", info = "pose_standing_03"},
			{name = "Одобрить", icon = "", info = "pose_standing_04"},
			{name = "Напряженно", icon = "", info = "scaredidle"},
			{name = "Скрестить руки, сгорбиться", icon = "", info = "d1_t02_Playground_Cit1_Arms_Crossed"},
			{name = "Руки в карманы, сгорбиться", icon = "", info = "d1_t02_Playground_Cit2_Pockets"},
			{name = "Напряженно", icon = "", info = "canals_arlene_pourgas"},
			{name = "Одышка", icon = "", info = {
				start = {"d2_coast03_postbattle_idle02_entry"},
				sequence = {"d2_coast03_PostBattle_Idle02", duration = -1}
			}},
			{name = "Прятать голову", icon = "", info = "cower_Idle"}
		}
	},
	{
		name = "Возле стены",
		icon = "",
		data = {
			{name = "Одышка, лицом к стене", icon = "", info = {
				start = {"d2_coast03_postbattle_idle01_entry"},
				sequence = {"d2_coast03_PostBattle_Idle01", duration = -1}
			}},
			{name = "Упереться в стену", icon = "", info = "doorBracer_Closed"},
			{name = "Смотреть в окно", icon = "", info = "d1_t03_LookOutWindow"},
			{name = "Облокотиться влево", icon = "", info = "Lean_Left"},
			{name = "Облокотиться назад", icon = "", info = {
				start = {"idle_to_lean_back"},
				sequence = {"Lean_Back", duration = -1},
			}},
			{name = "Облокотиться назад, руки за спину", icon = "", info = "plazaidle1"},
			{name = "Облокотиться назад, руки прямо", icon = "", info = "plazaidle2"}
		}
	},
	{
		name = "Присесть",
		icon = "",
		data = {
			{name = "На колено", icon = "", info = "citizen4_preaction"}, -- мужская
			{name = "На колено", icon = "", info = "base_cit_medic_postanim"}, -- женская
			{name = "Осматриваться", icon = "", info = "lookoutidle"},
			{name = "На колени", icon = "", info = "canals_mary_postidle"},
			{name = "На колени, сгорбиться", icon = "", info = "canals_mary_preidle"},
			{name = "Осматривать предмет", icon = "", info = "checkmalepost"},
			{name = "Изучать пол", icon = "", info = "d1_town05_Daniels_Kneel_Idle"}, -- мужская
			{name = "Изучать пол", icon = "", info = "d1_town05_Jacobs_Heal"}, -- женская
			{name = "На пол", icon = "", info = {
				start = {"idle_to_sit_ground"},
				sequence = {"sit_ground", duration = -1},
				finish = {"sit_ground_to_idle", duration = 2.1}
			}},
			{name = "На корты", icon = "", info = "plazaidle4"},
			{name = "Медитировать", icon = "", info = "sit_zen"},
		}
	},
	{
		name = "Лечь",
		icon = "",
		data = {
			{name = "На живот, руки за голову", icon = "", info = "arrestidle"},
			{name = "На спину, ранение", icon = "", info = "d1_town05_Winston_Down"},
			{name = "На спину, корчиться", icon = "", info = "d1_town05_Wounded_Idle_2"},
			{name = "На спину, облокотиться, раздвинуть ноги", icon = "", info = "injured1"},
			{name = "На спину, облокотиться", icon = "", info = "injured2"},
			{name = "На спину, в развалку", icon = "", info = "injured3"},
			{name = "На бок, спокойно", icon = "", info = "sniper_victim_pre"},
			{name = "Оперевшись на руки", icon = "", info = "d2_coast11_Tobias"},

			{name = "На спину, спокойно", icon = "", info = "Lying_Down"},
			{name = "На бок, корчиться", icon = "", info = "d1_town05_Wounded_Idle_1"},
		}
	},
	{
		name = "Другое",
		icon = "",
		data = {
			{name = "Прикрываться руками", icon = "", info = "stopwomanpre"},
			{name = "Поднять руки перед собой", icon = "", info = "d1_t01_Clutch_Chainlink_Idle"},
			{name = "Положить руки перед собой", icon = "", info = "luggageidle"},
			{name = "Протянуть руки ладонями вверх", icon = "", info = "d2_coast03_Odessa_RPG_Give_Idle"},
		}
	},
	{
		name = "Анимированные",
		icon = "",
		data = {
			{name = "Подобрать", icon = "", info = {sequence = {"Pickup"}}},
		}
	}
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
		name = "Стандартная"
	},
	[1] = {
		name = "Расслабленный",
		sequences = {
			idle = "LineIdle01",
		}
	},
	[2] = {
		name = "Запаниковал",
		sequences = {
			idle = "scaredidle",
			run = "run_protected_all"
		}
	},
	[3] = {
		name = "Упрямый",
		sequences = {
			idle = "LineIdle03",
			walk = "luggage_walk_all"
		}
	},
	[4] = {
		name = "Недовольный",
		sequences = {
			idle = "LineIdle02",
			walk = "pace_all"
		}
	},
	[5] = {
		name = "Уверенный",
		sequences = {
			idle = "standpose_1"
		}
	},
	[6] = {
		name = "Прилежный",
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
					local len2D = velocity:Length2D()

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