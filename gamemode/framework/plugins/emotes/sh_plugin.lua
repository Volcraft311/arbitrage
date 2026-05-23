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

local function danceStatusEffectCallback(client, id)
	local permissionDance = hook.Run("PermissionToDance", client, id)
	if permissionDance == true then
		return permissionDance
	end

	return false, "Ваш персонаж не обучен танцам!"
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
			{name = "#emotes_action_stand_15", icon = "asterion/academy/ui/emotes/stand_meleebase.png", info = "stand_meleebase"},
			{name = "В ожидании", icon = "asterion/academy/ui/emotes/aw_hotpose_1.png", info = "aw_hotpose_1"},
			{name = "Руки на бедра", icon = "asterion/academy/ui/emotes/aw_hotpose_2.png", info = "aw_hotpose_2"},
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
			{name = "#emotes_action_sit_7", icon = "asterion/academy/ui/emotes/idle_to_sit_ground.png", info = {
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
	},
	{
		name = "Танцы",
		icon = nil,
		data = {
			{
				name = "Fortnite",
				icon = nil,
				data = {
					{
						name = "Категория 1",
						icon = nil,
						data = {
							{name = "Eerie_walk", icon = nil, info = {sequence = {"Amod_Fortnite_Eerie_walk"}}, onCanRun = danceStatusEffectCallback, bLoop = true},
							{name = "Eerie", icon = nil, info = "Amod_Fortnite_Eerie"},
							{name = "TwistDaytona", icon = nil, info = "Amod_Fortnite_TwistDaytona"},
							{name = "AutumnTea", icon = nil, info = "Amod_Fortnite_AutumnTea"},
							{name = "NeverGonna", icon = nil, info = "Amod_Fortnite_NeverGonna"},
							{name = "TwistEternity_Ayo", icon = nil, info = "Amod_Fortnite_TwistEternity_Ayo"},
							{name = "TwistEternity_Teo", icon = nil, info = "Amod_Fortnite_TwistEternity_Teo"},
							{name = "Aloha", icon = nil, info = "Amod_Fortnite_Aloha"},
							{name = "BeHere", icon = nil, info = "Amod_Fortnite_BeHere"},
							{name = "ByTheFire_Follower", icon = nil, info = "Amod_Fortnite_ByTheFire_Follower"},
							{name = "ByTheFire_Leader", icon = nil, info = "Amod_Fortnite_ByTheFire_Leader"},
							{name = "Dance_Distraction", icon = nil, info = "Amod_Fortnite_Dance_Distraction"},
							{name = "Jiggle", icon = nil, info = "Amod_Fortnite_Jiggle"},
							{name = "JumpingJoy_walk", icon = nil, info = "Amod_Fortnite_JumpingJoy_walk"},
							{name = "JumpingJoy_Static", icon = nil, info = "Amod_Fortnite_JumpingJoy_Static"}
						}
					},
					{
						name = "Категория 2",
						icon = nil,
						data = {
							{name = "LittleEgg", icon = nil, info = "Amod_Fortnite_LittleEgg"},
							{name = "Lyrical", icon = nil, info = "Amod_Fortnite_Lyrical"},
							{name = "Ohana", icon = nil, info = "Amod_Fortnite_Ohana"},
							{name = "Prance", icon = nil, info = "Amod_Fortnite_Prance"},
							{name = "Realm", icon = nil, info = "Amod_Fortnite_Realm"},
							{name = "RememberMe", icon = nil, info = "Amod_Fortnite_RememberMe"},
							{name = "Sleek", icon = nil, info = "Amod_Fortnite_Sleek"},
							{name = "SpectacleWeb", icon = nil, info = "Amod_Fortnite_SpectacleWeb"},
							{name = "Tally", icon = nil, info = "Amod_Fortnite_Tally"},
							{name = "Tonal", icon = nil, info = "Amod_Fortnite_Tonal"},
							{name = "Zest", icon = nil, info = "Amod_Fortnite_Zest"},
							{name = "Sunlit", icon = nil, info = "Amod_Fortnite_Sunlit"},
							{name = "Marionette1", icon = nil, info = "Amod_Fortnite_Marionette1"},
							{name = "CerealBox", icon = nil, info = "Amod_Fortnite_CerealBox"},
							{name = "Griddle_Walk", icon = nil, info = "Amod_Fortnite_Griddle_Walk"}
						}
					},
					{
						name = "Категория 3",
						icon = nil,
						data = {
							{name = "Griddle", icon = nil, info = "Amod_Fortnite_Griddle"},
							{name = "HotPink", icon = nil, info = "Amod_Fortnite_HotPink"},
							{name = "SunBurstDance", icon = nil, info = "Amod_Fortnite_SunBurstDance"},
							{name = "Walkywalk", icon = nil, info = "Amod_Fortnite_Walkywalk"},
							{name = "Walkywalk_Walk", icon = nil, info = "Amod_Fortnite_Walkywalk_Walk"},
							{name = "cyclone_headbang", icon = nil, info = "Amod_Fortnite_cyclone_headbang"},
							{name = "cyclone", icon = nil, info = "Amod_Fortnite_cyclone"},
							{name = "JulyBooks", icon = nil, info = "Amod_Fortnite_JulyBooks"},
							{name = "GasStation", icon = nil, info = "Amod_Fortnite_GasStation"},
							{name = "StringDance", icon = nil, info = "Amod_Fortnite_StringDance"},
							{name = "TwistWasp", icon = nil, info = "Amod_Fortnite_TwistWasp"},
							{name = "Devotion", icon = nil, info = "Amod_Fortnite_Devotion"},
							{name = "Grooving", icon = nil, info = "Amod_Fortnite_Grooving"},
							{name = "Chew", icon = nil, info = "Amod_Fortnite_Chew"},
							{name = "IndigoApple", icon = nil, info = "Amod_Fortnite_IndigoApple"}
						}
					},
					{
						name = "Категория 4",
						icon = nil,
						data = {
							{name = "Comrade", icon = nil, info = "Amod_Fortnite_Comrade"},
							{name = "HeavyRoarDance", icon = nil, info = "Amod_Fortnite_HeavyRoarDance"},
							{name = "ZebraScramble", icon = nil, info = "Amod_Fortnite_ZebraScramble"}
						}
					}
				}
			},
			{
				name = "MMD",
				icon = nil,
				data = {
					{
						name = "Категория 1",
						icon = nil,
						data = {
							{name = "Nostalogic", icon = nil, info = "Amod_MMD_Dance_Nostalogic"},
							{name = "GokurakuJodo", icon = nil, info = "Amod_MMD_Dance_GokurakuJodo"},
							{name = "Specialist", icon = nil, info = "Amod_MMD_Dance_Specialist"},
							{name = "CaramellDansen", icon = nil, info = "Amod_MMD_Dance_CaramellDansen"},
							{name = "daisukeEvolution", icon = nil, info = "Amod_MMD_Dance_daisukeEvolution"},
							{name = "Theatrical_Airline_LUK", icon = nil, info = "Amod_MMD_Theatrical_Airline_LUK"},
							{name = "Theatrical_Airline_MIK", icon = nil, info = "Amod_MMD_Theatrical_Airline_MIK"},
							{name = "Theatrical_Airline_RIN", icon = nil, info = "Amod_MMD_Theatrical_Airline_RIN"},
							{name = "Whistle", icon = nil, info = "Amod_MMD_Whistle"},
							{name = "BadBadWater", icon = nil, info = "Amod_MMD_BadBadWater"},
							{name = "KING_Kanaria", icon = nil, info = "Amod_MMD_KING_Kanaria"},
							{name = "SadCatdance", icon = nil, info = "Amod_MMD_SadCatdance"},
							{name = "SadCatdance_Loop", icon = nil, info = "Amod_MMD_SadCatdance_Loop"},
							{name = "Dance_Tuni-kun", icon = nil, info = "Amod_MMD_Dance_Tuni-kun"},
							{name = "FollowtheLeader", icon = nil, info = "Amod_MMD_FollowtheLeader"}
						}
					},
					{
						name = "Категория 2",
						icon = nil,
						data = {
							{name = "Fiery_Sarilang", icon = nil, info = "Amod_MMD_Fiery_Sarilang"},
							{name = "GetDown", icon = nil, info = "Amod_MMD_GetDown"},
							{name = "GoodbyeDeclaration", icon = nil, info = "Amod_MMD_GoodbyeDeclaration"},
							{name = "Phao2PhutHon_P1", icon = nil, info = "Amod_MMD_Phao2PhutHon_P1"},
							{name = "Phao2PhutHon_P2", icon = nil, info = "Amod_MMD_Phao2PhutHon_P2"},
							{name = "Phao2PhutHon_P3", icon = nil, info = "Amod_MMD_Phao2PhutHon_P3"},
							{name = "Phao2PhutHon_P4", icon = nil, info = "Amod_MMD_Phao2PhutHon_P4"},
							{name = "Phao2PhutHon_P5", icon = nil, info = "Amod_MMD_Phao2PhutHon_P5"},
							{name = "Calisthenics", icon = nil, info = "Amod_MMD_Calisthenics"},
							{name = "caixukun", icon = nil, info = "Amod_MMD_caixukun"},
							{name = "PonPonPon", icon = nil, info = "Amod_MMD_PonPonPon"},
							{name = "S007", icon = nil, info = {sequence = {"Amod_MMD_S007"}}},
							{name = "S017", icon = nil, info = "Amod_MMD_S017"},
							{name = "S001", icon = nil, info = "Amod_MMD_S001"},
							{name = "S002", icon = nil, info = "Amod_MMD_S002"}
						}
					},
					{
						name = "Категория 3",
						icon = nil,
						data = {
							{name = "S003", icon = nil, info = "Amod_MMD_S003"},
							{name = "S004", icon = nil, info = "Amod_MMD_S004"},
							{name = "S005", icon = nil, info = "Amod_MMD_S005"},
							{name = "S006", icon = nil, info = "Amod_MMD_S006"},
							{name = "MrSaxobeat", icon = nil, info = "Amod_MMD_MrSaxobeat"},
							{name = "PV120_SHI_P1", icon = nil, info = "Amod_MMD_PV120_SHI_P1"},
							{name = "PV120_SHI_P2", icon = nil, info = "Amod_MMD_PV120_SHI_P2"},
							{name = "PV120_SHI_P3", icon = nil, info = "Amod_MMD_PV120_SHI_P3"},
							{name = "S008", icon = nil, info = "Amod_MMD_S008"},
							{name = "S009", icon = nil, info = "Amod_MMD_S009"},
							{name = "NyaArigato", icon = nil, info = "Amod_MMD_NyaArigato"},
							{name = "HipRoll", icon = nil, info = "Amod_MMD_HipRoll"},
							{name = "HipRoll_Loop", icon = nil, info = "Amod_MMD_HipRoll_Loop"},
							{name = "LMFAO", icon = nil, info = "Amod_MMD_LMFAO"},
							{name = "S010", icon = nil, info = "Amod_MMD_S010"}
						}
					},
					{
						name = "Категория 4",
						icon = nil,
						data = {
							{name = "AOAGoodLuck", icon = nil, info = "Amod_MMD_AOAGoodLuck"},
							{name = "BlaBlaBla", icon = nil, info = "Amod_MMD_BlaBlaBla"},
							{name = "ChikiChiki", icon = nil, info = "Amod_MMD_ChikiChiki"},
							{name = "GhostDance", icon = nil, info = "Amod_MMD_GhostDance"},
							{name = "Girls", icon = nil, info = "Amod_MMD_Girls"},
							{name = "HIASOBI", icon = nil, info = "Amod_MMD_HIASOBI"},
							{name = "GFRIENDRough", icon = nil, info = "Amod_MMD_GFRIENDRough"},
							{name = "MEMEME", icon = nil, info = "Amod_MMD_MEMEME"},
							{name = "MassDestruction", icon = nil, info = "Amod_MMD_MassDestruction"},
							{name = "SuperMJopping", icon = nil, info = "Amod_MMD_SuperMJopping"},
							{name = "ROKI_P1", icon = nil, info = "Amod_MMD_ROKI_P1"},
							{name = "ROKI_P2", icon = nil, info = "Amod_MMD_ROKI_P2"},
							{name = "Senbonzakura", icon = nil, info = "Amod_MMD_Senbonzakura"},
							{name = "kemuthree", icon = nil, info = "Amod_MMD_kemuthree"},
							{name = "Bad_Apple_R", icon = nil, info = "Amod_MMD_Bad_Apple_R"}
						}
					},
					{
						name = "Категория 5",
						icon = nil,
						data = {
							{name = "Bad_Apple_L", icon = nil, info = "Amod_MMD_Bad_Apple_L"},
							{name = "Nahoha", icon = nil, info = "Amod_MMD_Nahoha"},
							{name = "BananaSong", icon = nil, info = "Amod_MMD_BananaSong"},
							{name = "ADeepMentality", icon = nil, info = "Amod_MMD_ADeepMentality"},
							{name = "S011", icon = nil, info = "Amod_MMD_S011"},
							{name = "ADJ_1", icon = nil, info = "Amod_MMD_ADJ_1"},
							{name = "Conqueror", icon = nil, info = "Amod_MMD_Conqueror"},
							{name = "Yoidore", icon = nil, info = "Amod_MMD_Yoidore"},
							{name = "Darling", icon = nil, info = "Amod_MMD_Darling"},
							{name = "Dokuhebi", icon = nil, info = "Amod_MMD_Dokuhebi"},
							{name = "Dancin", icon = nil, info = "Amod_MMD_Dancin"},
							{name = "CH4NGE", icon = nil, info = "Amod_MMD_CH4NGE"},
							{name = "S012", icon = nil, info = "Amod_MMD_S012"},
							{name = "S013", icon = nil, info = "Amod_MMD_S013"},
							{name = "S014", icon = nil, info = "Amod_MMD_S014"}
						}
					},
					{
						name = "Категория 6",
						icon = nil,
						data = {
							{name = "S015", icon = nil, info = "Amod_MMD_S015"},
							{name = "GimmexGimme", icon = nil, info = "Amod_MMD_GimmexGimme"},
							{name = "yaosobi-idol", icon = nil, info = "Amod_MMD_yaosobi-idol"},
							{name = "Kwlink", icon = nil, info = "Amod_MMD_Kwlink"}
						}
					}
				}
			},
			{
				name = "Pubg",
				icon = nil,
				data = {
					{name = "BBoomBBoom", icon = nil, info = "Amod_PUBG_BBoomBBoom"},
					{name = "Samsara", icon = nil, info = "Amod_PUBG_Samsara"},
					{name = "SeeTinh", icon = nil, info = "Amod_PUBG_SeeTinh"},
					{name = "VictoryDance60", icon = nil, info = "Amod_PUBG_VictoryDance60"},
					{name = "VictoryDance99", icon = nil, info = "Amod_PUBG_VictoryDance99"},
					{name = "VictoryDance102", icon = nil, info = "Amod_PUBG_VictoryDance102"},
					{name = "2PhutHon", icon = nil, info = "Amod_PUBG_2PhutHon"},
					{name = "TocaToca", icon = nil, info = "Amod_PUBG_TocaToca"}
				}
			},
			{
				name = "Taunt",
				icon = nil,
				data = {
					{
						name = "Категория 1",
						icon = nil,
						data = {
							{name = "Angry_01", icon = nil, info = "Amod_Angry_01"},
							{name = "Dance_GangnamStyle", icon = nil, info = "Amod_Dance_GangnamStyle"},
							{name = "Dance_Macarena", icon = nil, info = "Amod_Dance_Macarena"},
							{name = "Taunt_Quagmire", icon = nil, info = "Amod_Taunt_Quagmire"},
							{name = "MMD_Helltaker", icon = nil, info = "Amod_MMD_Helltaker"},
							{name = "Dance_California_Girls", icon = nil, info = "Amod_Dance_California_Girls"},
							{name = "Drip_01", icon = nil, info = "Amod_Drip_01"},
							{name = "DrLiveseyWalk_1", icon = nil, info = "Amod_AM4_DrLiveseyWalk_1"},
							{name = "DrLiveseyWalk_2", icon = nil, info = "Amod_AM4_DrLiveseyWalk_2"},
							{name = "DrLiveseyWalk_3", icon = nil, info = "Amod_AM4_DrLiveseyWalk_3"},
							{name = "LevePalestina", icon = nil, info = "Amod_AM4_LevePalestina"},
							{name = "Dead_1", icon = nil, info = "Amod_Mixamo_dead_1"},
							{name = "Dead_1_idle", icon = nil, info = "Amod_Mixamo_dead_1_idle"},
							{name = "Dead_2", icon = nil, info = "Amod_Mixamo_dead_2"},
							{name = "Dead_2_idle", icon = nil, info = "Amod_Mixamo_dead_2_idle"}
						}
					},
					{
						name = "Категория 2",
						icon = nil,
						data = {
							{name = "Dead_3", icon = nil, info = "Amod_Mixamo_dead_3"},
							{name = "Dead_3_idle", icon = nil, info = "Amod_Mixamo_dead_3_idle"},
							{name = "Dead_4", icon = nil, info = "Amod_Mixamo_dead_4"},
							{name = "Dead_4_idle", icon = nil, info = "Amod_Mixamo_dead_4_idle"},
							{name = "Entry", icon = nil, info = "Amod_Mixamo_entry"},
							{name = "Gesture_1", icon = nil, info = "Amod_Mixamo_gesture_1"},
							{name = "Gesture_2", icon = nil, info = "Amod_Mixamo_gesture_2"},
							{name = "Gesture_3", icon = nil, info = "Amod_Mixamo_gesture_3"},
							{name = "Gesture_4", icon = nil, info = "Amod_Mixamo_gesture_4"},
							{name = "Gesture_5", icon = nil, info = "Amod_Mixamo_gesture_5"},
							{name = "Gesture_6", icon = nil, info = "Amod_Mixamo_gesture_6"},
							{name = "Gesture_7", icon = nil, info = "Amod_Mixamo_gesture_7"},
							{name = "Gesture_8", icon = nil, info = "Amod_Mixamo_gesture_8"},
							{name = "Gesture_9", icon = nil, info = "Amod_Mixamo_gesture_9"},
							{name = "Gesture_10", icon = nil, info = "Amod_Mixamo_gesture_10"}
						}
					},
					{
						name = "Категория 3",
						icon = nil,
						data = {
							{name = "Gesture_11", icon = nil, info = "Amod_Mixamo_gesture_11"},
							{name = "Gesture_12", icon = nil, info = "Amod_Mixamo_gesture_12"},
							{name = "Gesture_13", icon = nil, info = "Amod_Mixamo_gesture_13"},
							{name = "Gesture_14", icon = nil, info = "Amod_Mixamo_gesture_14"},
							{name = "Gesture_15", icon = nil, info = "Amod_Mixamo_gesture_15"},
							{name = "Idle_1", icon = nil, info = "Amod_Mixamo_idle_1"},
							{name = "Idle_2", icon = nil, info = "Amod_Mixamo_idle_2"},
							{name = "Idle_3", icon = nil, info = "Amod_Mixamo_idle_3"},
							{name = "Idle_4", icon = nil, info = "Amod_Mixamo_idle_4"},
							{name = "Idle_5", icon = nil, info = "Amod_Mixamo_idle_5"},
							{name = "Idle_6", icon = nil, info = "Amod_Mixamo_idle_6"},
							{name = "Idle_with_something", icon = nil, info = "Amod_Mixamo_idle_with_something"},
							{name = "Jump", icon = nil, info = "Amod_Mixamo_jump"},
							{name = "Kick_1", icon = nil, info = "Amod_Mixamo_kick_1"},
							{name = "Kick_2", icon = nil, info = "Amod_Mixamo_kick_2"}
						}
					},
					{
						name = "Категория 4",
						icon = nil,
						data = {
							{name = "Kick_3", icon = nil, info = "Amod_Mixamo_kick_3"},
							{name = "Kick_4", icon = nil, info = "Amod_Mixamo_kick_4"},
							{name = "Kick_5", icon = nil, info = "Amod_Mixamo_kick_5"},
							{name = "On_knees", icon = nil, info = "Amod_Mixamo_on_knees"},
							{name = "Run_1_forward", icon = nil, info = "Amod_Mixamo_run_1_forward"},
							{name = "Run_2_forward", icon = nil, info = "Amod_Mixamo_run_2_forward"},
							{name = "Run_3_forward", icon = nil, info = "Amod_Mixamo_run_3_forward"},
							{name = "Sit", icon = nil, info = "Amod_Mixamo_sit"},
							{name = "Sit_to_stand", icon = nil, info = "Amod_Mixamo_sit_to_stand"},
							{name = "Sit_to_stand_reversed", icon = nil, info = "Amod_Mixamo_sit_to_stand_reversed"},
							{name = "Sit_typing", icon = nil, info = "Amod_Mixamo_sit_typing"},
							{name = "Sit_writing", icon = nil, info = "Amod_Mixamo_sit_writing"},
							{name = "Taunt_1", icon = nil, info = "Amod_Mixamo_taunt_1"},
							{name = "Taunt_2", icon = nil, info = "Amod_Mixamo_taunt_2"},
							{name = "Taunt_3", icon = nil, info = "Amod_Mixamo_taunt_3"}
						}
					},
					{
						name = "Категория 5",
						icon = nil,
						data = {
							{name = "Taunt_4", icon = nil, info = "Amod_Mixamo_taunt_4"},
							{name = "Taunt_5", icon = nil, info = "Amod_Mixamo_taunt_5"},
							{name = "Taunt_6", icon = nil, info = "Amod_Mixamo_taunt_6"},
							{name = "Taunt_7", icon = nil, info = "Amod_Mixamo_taunt_7"},
							{name = "Taunt_8", icon = nil, info = "Amod_Mixamo_taunt_8"},
							{name = "Taunt_9", icon = nil, info = "Amod_Mixamo_taunt_9"},
							{name = "Taunt_10", icon = nil, info = "Amod_Mixamo_taunt_10"},
							{name = "Taunt_11", icon = nil, info = "Amod_Mixamo_taunt_11"},
							{name = "Taunt_12", icon = nil, info = "Amod_Mixamo_taunt_12"},
							{name = "Walk_0_forward", icon = nil, info = "Amod_Mixamo_walk_0_forward"},
							{name = "Walk_1_forward", icon = nil, info = "Amod_Mixamo_walk_1_forward"},
							{name = "Walk_2_forward", icon = nil, info = "Amod_Mixamo_walk_2_forward"},
							{name = "Walk_3_forward", icon = nil, info = "Amod_Mixamo_walk_3_forward"},
							{name = "Warming_up", icon = nil, info = "Amod_Mixamo_warming_up"},
							{name = "Run_4_forward", icon = nil, info = "Amod_Mixamo_run_4_forward"}
						}
					},
					{
						name = "Категория 6",
						icon = nil,
						data = {
							{name = "Walk_4_forward", icon = nil, info = "Amod_Mixamo_walk_4_forward"},
							{name = "Walk_5_forward", icon = nil, info = "Amod_Mixamo_walk_5_forward"},
							{name = "Walk_6_forward", icon = nil, info = "Amod_Mixamo_walk_6_forward"},
							{name = "Walk_7_forward", icon = nil, info = "Amod_Mixamo_walk_7_forward"},
							{name = "Walk_8_forward", icon = nil, info = "Amod_Mixamo_walk_8_forward"},
							{name = "Walk_9_forward", icon = nil, info = "Amod_Mixamo_walk_9_forward"},
							{name = "Walk_10_forward", icon = nil, info = "Amod_Mixamo_walk_10_forward"},
							{name = "Walk_11_forward", icon = nil, info = "Amod_Mixamo_walk_11_forward"},
							{name = "Walk_12_forward", icon = nil, info = "Amod_Mixamo_walk_12_forward"},
							{name = "Walk_13_forward", icon = nil, info = "Amod_Mixamo_walk_13_forward"},
							{name = "Walk_14_back", icon = nil, info = "Amod_Mixamo_walk_14_back"},
							{name = "Walk_15_forward", icon = nil, info = "Amod_Mixamo_walk_15_forward"},
							{name = "Walk_16_forward", icon = nil, info = "Amod_Mixamo_walk_16_forward"},
							{name = "Walk_17_forward", icon = nil, info = "Amod_Mixamo_walk_17_forward"},
							{name = "Walk_18_forward", icon = nil, info = "Amod_Mixamo_walk_18_forward"}
						}
					},
					{
						name = "Категория 7",
						icon = nil,
						data = {
							{name = "Walk_19_forward", icon = nil, info = "Amod_Mixamo_walk_19_forward"},
							{name = "Walk_20_forward", icon = nil, info = "Amod_Mixamo_walk_20_forward"},
							{name = "Walk_21_forward", icon = nil, info = "Amod_Mixamo_walk_21_forward"},
							{name = "Catwalk_Walk", icon = nil, info = "Amod_Mixamo_Catwalk_Walk"},
							{name = "Hip_Hop_Dancing", icon = nil, info = "Amod_Mixamo_Hip_Hop_Dancing"},
							{name = "Hip_Hop_Dancing2", icon = nil, info = "Amod_Mixamo_Hip_Hop_Dancing2"},
							{name = "Talking_On_A_Cell_Phone", icon = nil, info = "Amod_Mixamo_Talking_On_A_Cell_Phone"},
							{name = "Talking_On_Phone", icon = nil, info = "Amod_Mixamo_Talking_On_Phone"}
						}
					}
				}
			}
		}
	}
}

Emotes.StandList = {
	"idle_afk_1",
	"idle_afk_2",
	"idle_afk_3",
	"stand_allbase",
	"aw_hotpose_1"
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
					sequence = {
						item.info,
						duration = -1
					}
				}
			end

			data.onCanRun = item.onCanRun
			data.bLoop = item.bLoop

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