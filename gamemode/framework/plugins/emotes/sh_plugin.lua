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
Emotes = PLUGIN

Emotes.name = "Emotes"
Emotes.action = {}
Emotes.action.stored = {}

function Emotes.action:Register(uniqueID, data)
	Emotes.action.stored[uniqueID:lower()] = data
end

Emotes.ActionList = {
	{
		name = "#emotes_category_stand",
		icon = nil,
		data = {
			{name = "#emotes_action_stand_1", icon = "asterion/academy/ui/emotes/lineidle01.png", info = "LineIdle01"},
			{name = "#emotes_action_stand_2", icon = "asterion/academy/ui/emotes/lineidle02.png", info = "LineIdle02"},
			{name = "#emotes_action_stand_3", icon = "asterion/academy/ui/emotes/lineidle03.png", info = "LineIdle03"},
			-- {name = "Стойка 4", icon = nil, info = "menu_combine"},
			{name = "#emotes_action_stand_4", icon = "asterion/academy/ui/emotes/pose_standing_02.png", info = "pose_standing_02"},
			{name = "#emotes_action_stand_5", icon = "asterion/academy/ui/emotes/standpose_1.png", info = "standpose_1"},
			{name = "#emotes_action_stand_6", icon = "asterion/academy/ui/emotes/standpose_3.png", info = "standpose_3"},
			{name = "#emotes_action_stand_7", icon = "asterion/academy/ui/emotes/standpose_5.png", info = "standpose_5"},
			{name = "#emotes_action_stand_8", icon = "asterion/academy/ui/emotes/idle_suitcase.png", info = "idle_suitcase"},
			{name = "#emotes_action_stand_9", icon = "asterion/academy/ui/emotes/lineidle04.png", info = "LineIdle04"},
			{name = "#emotes_action_stand_10", icon = "asterion/academy/ui/emotes/pose_standing_01.png", info = "pose_standing_01"},
			{name = "#emotes_action_stand_11", icon = "asterion/academy/ui/emotes/standpose_2.png", info = "standpose_2"},
			{name = "#emotes_action_stand_12", icon = "asterion/academy/ui/emotes/standpose_4.png", info = "standpose_4"},
			{name = "#emotes_action_stand_13", icon = "asterion/academy/ui/emotes/pose_standing_03.png", info = "pose_standing_03"},
			{name = "#emotes_action_stand_14", icon = "asterion/academy/ui/emotes/pose_standing_04.png", info = "pose_standing_04"},
			{name = "#emotes_action_stand_15", icon = "asterion/academy/ui/emotes/scaredidle.png", info = "scaredidle"},
			{name = "#emotes_action_stand_16", icon = "asterion/academy/ui/emotes/d1_t02_playground_cit1_arms_crossed.png", info = "d1_t02_Playground_Cit1_Arms_Crossed"},
			{name = "#emotes_action_stand_17", icon = "asterion/academy/ui/emotes/d1_t02_playground_cit2_pockets.png", info = "d1_t02_Playground_Cit2_Pockets"},
			{name = "#emotes_action_stand_15", icon = "asterion/academy/ui/emotes/canals_arlene_pourgas.png", info = "canals_arlene_pourgas"},
			{name = "#emotes_action_stand_18", icon = "asterion/academy/ui/emotes/2_coast03_postBattle_idle02.png", info = {
				start = {"d2_coast03_postbattle_idle02_entry"},
				sequence = {"d2_coast03_PostBattle_Idle02", duration = -1}
			}},
			{name = "#emotes_action_stand_19", icon = "asterion/academy/ui/emotes/cower_idle.png", info = "cower_Idle"},
			{name = "#emotes_action_stand_20", icon = "asterion/academy/ui/emotes/stand_villagebase.png", info = "stand_villagebase"},
			{name = "#emotes_action_stand_15", icon = "asterion/academy/ui/emotes/stand_meleebase.png", info = "stand_meleebase"}
		}
	},
	{
		name = "#emotes_category_wall",
		icon = nil,
		data = {
			{name = "#emotes_action_wall_1", icon = "asterion/academy/ui/emotes/d2_coast03_postbattle_idle01_entry.png", info = {
				start = {"d2_coast03_postbattle_idle01_entry"},
				sequence = {"d2_coast03_PostBattle_Idle01", duration = -1}
			}},
			{name = "#emotes_action_wall_2", icon = "asterion/academy/ui/emotes/doorbracer_closed.png", info = "doorBracer_Closed"},
			{name = "#emotes_action_wall_3", icon = "asterion/academy/ui/emotes/d1_t03_lookoutwindow.png", info = "d1_t03_LookOutWindow"},
			{name = "#emotes_action_wall_4", icon = "asterion/academy/ui/emotes/lean_left.png", info = "Lean_Left"},
			{name = "#emotes_action_wall_5", icon = "asterion/academy/ui/emotes/idle_to_lean_back.png", info = {
				start = {"idle_to_lean_back"},
				sequence = {"Lean_Back", duration = -1},
			}},
			{name = "#emotes_action_wall_6", icon = "asterion/academy/ui/emotes/plazaidle1.png", info = "plazaidle1"},
			{name = "#emotes_action_wall_7", icon = "asterion/academy/ui/emotes/plazaidle2.png", info = "plazaidle2"}
		}
	},
	{
		name = "#emotes_category_sit",
		icon = nil,
		data = {
			{name = "#emotes_action_sit_1", icon = "asterion/academy/ui/emotes/base_cit_medic_postanim.png", info = "citizen4_preaction"}, -- мужская
			{name = "#emotes_action_sit_1", icon = "asterion/academy/ui/emotes/base_cit_medic_postanim.png", info = "base_cit_medic_postanim"}, -- женская
			{name = "#emotes_action_sit_2", icon = "asterion/academy/ui/emotes/lookoutidle.png", info = "lookoutidle"},
			{name = "#emotes_action_sit_3", icon = "asterion/academy/ui/emotes/canals_mary_postidle.png", info = "canals_mary_postidle"},
			{name = "#emotes_action_sit_4", icon = "asterion/academy/ui/emotes/canals_mary_preidle.png", info = "canals_mary_preidle"},
			{name = "#emotes_action_sit_5", icon = "asterion/academy/ui/emotes/checkmalepost.png", info = "checkmalepost"},
			{name = "#emotes_action_sit_6", icon = "asterion/academy/ui/emotes/d1_town05_daniels_kneel_idle.png", info = "d1_town05_Daniels_Kneel_Idle"}, -- мужская
			{name = "#emotes_action_sit_6", icon = "asterion/academy/ui/emotes/d1_town05_jacobs_heal.png", info = "d1_town05_Jacobs_Heal"}, -- женская
			{name = "#emotes_action_sit_5", icon = "asterion/academy/ui/emotes/idle_to_sit_ground.png", info = {
				start = {"idle_to_sit_ground"},
				sequence = {"sit_ground", duration = -1},
				finish = {"sit_ground_to_idle", duration = 2.1}
			}},
			{name = "#emotes_action_sit_8", icon = "asterion/academy/ui/emotes/plazaidle4.png", info = "plazaidle4"},
			{name = "#emotes_action_sit_9", icon = "asterion/academy/ui/emotes/sit_zen.png", info = "sit_zen"},
		}
	},
	{
		name = "#emotes_category_lie",
		icon = nil,
		data = {
			{name = "#emotes_action_lie_1", icon = "asterion/academy/ui/emotes/arrestidle.png", info = "arrestidle"},
			{name = "#emotes_action_lie_2", icon = "asterion/academy/ui/emotes/d1_town05_winston_down.png", info = "d1_town05_Winston_Down"},
			{name = "#emotes_action_lie_3", icon = "asterion/academy/ui/emotes/d1_town05_wounded_idle_2.png", info = "d1_town05_Wounded_Idle_2"},
			{name = "#emotes_action_lie_4", icon = "asterion/academy/ui/emotes/injured1.png", info = "injured1"},
			{name = "#emotes_action_lie_5", icon = "asterion/academy/ui/emotes/injured2.png", info = "injured2"},
			{name = "#emotes_action_lie_6", icon = nil, info = "injured3"},
			{name = "#emotes_action_lie_7", icon = "asterion/academy/ui/emotes/sniper_victim_pre.png", info = "sniper_victim_pre"},
			{name = "#emotes_action_lie_8", icon = "asterion/academy/ui/emotes/d2_coast11_tobias.png", info = "d2_coast11_Tobias"},
			{name = "#emotes_action_lie_5", icon = "asterion/academy/ui/emotes/lying_down.png", info = "Lying_Down"},
			{name = "#emotes_action_lie_10", icon = "asterion/academy/ui/emotes/d1_town05_wounded_idle_1.png", info = "d1_town05_Wounded_Idle_1"},
		}
	},
	{
		name = "#emotes_category_other",
		icon = nil,
		data = {
			{name = "#emotes_action_other_1", icon = "asterion/academy/ui/emotes/stopwomanpre.png", info = "stopwomanpre"},
			{name = "#emotes_action_other_2", icon = "asterion/academy/ui/emotes/d1_t01_clutch_chainlink_idle.png", info = "d1_t01_Clutch_Chainlink_Idle"},
			{name = "#emotes_action_other_3", icon = "asterion/academy/ui/emotes/luggageidle.png", info = "luggageidle"},
			{name = "#emotes_action_other_4", icon = "asterion/academy/ui/emotes/d2_coast03_odessa_rpg_give_idle.png", info = "d2_coast03_Odessa_RPG_Give_Idle"},
		}
	},
	{
		name = "#emotes_category_animated",
		icon = nil,
		data = {
			{name = "#emotes_action_animated_1", icon = "asterion/academy/ui/emotes/pickup.png", info = {sequence = {"Pickup"}}},
			{name = "#emotes_action_animated_2", icon = "asterion/academy/ui/emotes/menu_gman.png", info = "menu_gman"},
			{name = "#emotes_action_animated_3", icon = "asterion/academy/ui/emotes/idle_afk_1.png", info = "idle_afk_1"},
			{name = "#emotes_action_animated_4", icon = "asterion/academy/ui/emotes/idle_afk_2.png", info = "idle_afk_2"},
			{name = "#emotes_action_animated_5", icon = "asterion/academy/ui/emotes/idle_afk_3.png", info = "idle_afk_3"},
			{name = "#emotes_action_animated_6", icon = "asterion/academy/ui/emotes/stand_allbase.png", info = "stand_allbase"},
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
		name = "#mood_action_standart",
		icon = "asterion/academy/ui/emotes/mood_standard.png"
	},
	[1] = {
		name = "#mood_action_relaxed",
		icon = "asterion/academy/ui/emotes/mood_relaxed.png",
		sequences = {
			idle = "LineIdle01",
		}
	},
	[2] = {
		name = "#mood_action_panicked",
		icon = "asterion/academy/ui/emotes/mood_panicked.png",
		sequences = {
			idle = "scaredidle",
			run = "run_protected_all"
		}
	},
	[3] = {
		name = "#mood_action_stubborn",
		icon = "asterion/academy/ui/emotes/mood_stubborn.png",
		sequences = {
			idle = "LineIdle03",
			walk = "luggage_walk_all"
		}
	},
	[4] = {
		name = "#mood_action_dissatisfied",
		icon = "asterion/academy/ui/emotes/mood_dissatisfied.png",
		sequences = {
			idle = "LineIdle02",
			walk = "pace_all"
		}
	},
	[5] = {
		name = "#mood_action_confident",
		icon = "asterion/academy/ui/emotes/mood_confident.png",
		sequences = {
			idle = "standpose_1"
		}
	},
	[6] = {
		name = "#mood_action_diligent",
		icon = "asterion/academy/ui/emotes/mood_diligent.png",
		sequences = {
			idle = "standpose_5"
		}
	}
}

local function ProcessEmoteData(dataTable)
	for _, item in ipairs(dataTable) do
		if item.data then
			ProcessEmoteData(item.data)
		else
			local data = nil
			if istable(item.info) then
				data = item.info
			else
				data = {
					sequence = {item.info, duration = -1}
				}
			end

			local id = data.sequence[1]
			Emotes.action:Register(id, data)
		end
	end
end

for _, category in ipairs(Emotes.ActionList) do
	if category.data then
		ProcessEmoteData(category.data)
	end
end

local playerMeta = FindMetaTable("Player")
function playerMeta:GetAction()
	local data = self:GetNetVar("action")
	if !data then return end

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

function Emotes:UpdateAnimation(client, moveData)
	local _, _, bThirdPerson, seqAngle = client:GetAction()

	if bThirdPerson and seqAngle then
		client:SetRenderAngles(seqAngle)
	end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")