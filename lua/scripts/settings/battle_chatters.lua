-- chunkname: @scripts/settings/battle_chatters.lua

BattleChatters = {}

local ALWAYS = 1
local COMMON = 0.5
local UNCOMMON = 0.35
local RARE = 0.2
local ABYSMAL = 0.01
local DEFAULT_QUEUE_CONFIG = {
	queue_time = 2
}

BattleChatters.headshot = {
	relevant_active = 1,
	delay = 0.5,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_headshot",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("headshot_response", data)
			end
		}
	}
}
BattleChatters.longshot_headshot = {
	relevant_active = 1,
	delay = 0,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 4,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_longshot_headshot",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("headshot_response", data)
			end
		}
	}
}
BattleChatters.headshot_response = {
	relevant_active = 1,
	delay = 0,
	talker = "get_talker_random_teammate",
	irrelevant_active = 4,
	trigger_chance = ALWAYS,
	timpani_events = {
		{
			event = "bc_battle_headshot_response",
			weight = 1
		}
	}
}
BattleChatters.instakill = {
	relevant_active = 1,
	delay = 1,
	talker = "get_talker_random_teammate",
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_insta-kill",
			weight = 1
		}
	}
}
BattleChatters.finishing_blow = {
	relevant_active = 1,
	delay = 0,
	talker = "get_talker_random_teammate",
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_finishing_blow",
			weight = 1
		}
	}
}
BattleChatters.decapitation = {
	relevant_active = 1,
	delay = 1,
	talker = "get_talker_random_teammate",
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_decapitations",
			weight = 1
		}
	}
}
BattleChatters.intercept = {
	relevant_active = 1,
	delay = 0.3,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_intercept",
			weight = 1
		}
	}
}
BattleChatters.shield_break = {
	relevant_distance = 20,
	relevant_active = 1,
	delay = 0.5,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_shield_destroyed",
			weight = 1
		}
	}
}
BattleChatters.revive_started = {
	relevant_distance = 20,
	relevant_active = 1,
	delay = 0,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_helping_downed_ally",
			weight = 1
		}
	}
}
BattleChatters.revive_completed = {
	relevant_distance = 20,
	relevant_active = 1,
	delay = 0,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_helping_downed_ally_response",
			weight = 1
		}
	}
}
BattleChatters.enemy_revive_started = {
	relevant_distance = 20,
	relevant_active = 1,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_enemy_revives_teammate",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("enemy_revive_started_response", data)
			end
		}
	}
}
BattleChatters.enemy_revive_started_response = {
	irrelevant_active = 4,
	relevant_active = 1,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_enemy_revives_teammate_response",
			weight = 1
		}
	}
}
BattleChatters.parry_master = {
	delay = 0.5,
	relevant_active = 1,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 4,
	trigger_chance = COMMON,
	timpani_events = {},
	teammate_events = {
		{
			event = "bc_battle_parrying_multiple_attacks_response",
			weight = 1
		}
	},
	player_events = {
		{
			event = "bc_battle_parrying_multiple_attacks",
			weight = 1
		}
	}
}
BattleChatters.tagged_enemy = {
	relevant_active = 1,
	delay = 0.5,
	irrelevant_active = 4,
	trigger_chance = RARE,
	timpani_events = {
		{
			event = "bc_battle_marking_an_enemy_player",
			weight = 1
		}
	}
}
BattleChatters.teammate_capture_point = {
	relevant_distance = 40,
	relevant_active = 1,
	delay = 2,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_capturing_point",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("teammate_capture_point_response", data)
			end
		}
	}
}
BattleChatters.teammate_capture_point_response = {
	relevant_active = 1,
	delay = 0,
	irrelevant_active = 4,
	trigger_chance = ALWAYS,
	timpani_events = {
		{
			event = "bc_outside_battle_capturing_point_response",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("teammate_capture_point_response", data)
			end
		}
	}
}
BattleChatters.enemy_capture_point = {
	relevant_distance = 40,
	relevant_active = 1,
	delay = 2,
	irrelevant_active = 4,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_enemy_captures_point",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("enemy_capture_point_response", data)
			end
		}
	}
}
BattleChatters.enemy_capture_point_response = {
	relevant_active = 1,
	delay = 0.5,
	irrelevant_active = 4,
	trigger_chance = ALWAYS,
	timpani_events = {
		{
			event = "bc_outside_battle_enemy_captures_point_response",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("enemy_capture_point_response", data)
			end
		}
	}
}
BattleChatters.travel_mode_entered = {
	relevant_distance = 5,
	relevant_active = 1,
	delay = 0.1,
	irrelevant_active = 4,
	trigger_chance = RARE,
	timpani_events = {
		{
			event = "bc_outside_battle_travel_mode_alongside_teammates",
			weight = 1
		}
	}
}
BattleChatters.kill_streak_kill = {
	relevant_distance = 15,
	relevant_active = 1,
	delay = 0.6,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 4,
	trigger_chance = COMMON,
	timpani_events = {},
	teammate_events = {
		{
			event = "bc_battle_killing_enemy_with_killstreak_response",
			weight = 1
		}
	},
	player_events = {
		{
			event = "bc_battle_killing_enemy_with_killstreak",
			weight = 1
		}
	}
}
BattleChatters.throwing_kill = {
	relevant_distance = 15,
	relevant_active = 1,
	delay = 0.5,
	talker = "get_talker_random_teammate",
	talker_distance = 15,
	irrelevant_active = 4,
	trigger_chance = COMMON,
	timpani_events = {},
	teammate_events = {
		{
			event = "bc_battle_killing_with_throwing_weapon_response",
			weight = 1
		}
	},
	player_events = {
		{
			event = "bc_battle_killing_with_throwing_weapon",
			weight = 1
		}
	}
}
BattleChatters.first_blood = {
	irrelevant_active = 4,
	relevant_active = 1,
	delay = 1,
	talker = "get_talker_random_teammate",
	talker_distance = 15,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_battle_first_kill",
			weight = 1
		}
	}
}
BattleChatters.round_started = {
	irrelevant_active = 4,
	relevant_active = 1,
	delay = 1,
	talker_distance = 20,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_start_of_round",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("round_started_response", data)
			end
		}
	}
}
BattleChatters.round_started_response = {
	irrelevant_active = 4,
	relevant_active = 1,
	delay = 0.6,
	talker = "get_talker_random_teammate",
	talker_distance = 20,
	trigger_chance = ALWAYS,
	timpani_events = {
		{
			event = "bc_outside_battle_start_of_round_response",
			weight = 1
		}
	}
}
BattleChatters.under_enemy_fire = {
	relevant_active = 2,
	delay = 0.6,
	irrelevant_active = 5,
	trigger_chance = RARE,
	timpani_events = {
		{
			event = "bc_battle_under_enemy_fire",
			weight = 1
		}
	}
}
BattleChatters.bandage = {
	relevant_active = 2,
	delay = 0,
	irrelevant_active = 5,
	trigger_chance = ALWAYS,
	timpani_events = {
		{
			event = "bc_outside_battle_bandage",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("player_bandaging_response", data)
			end
		}
	}
}
BattleChatters.bandage_response = {
	relevant_active = 2,
	delay = 0,
	irrelevant_active = 5,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_bandage_response",
			weight = 1
		}
	}
}
BattleChatters.friendly_fire_melee = {
	relevant_active = 1,
	delay = 0.8,
	irrelevant_active = 5,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_melee",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("player_friendly_fire_response", data)
			end
		}
	}
}
BattleChatters.friendly_fire_melee_response = {
	irrelevant_active = 5,
	relevant_active = 1,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_melee_response",
			weight = 1
		}
	}
}
BattleChatters.friendly_fire_bow = {
	relevant_active = 1,
	delay = 0.8,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 5,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_ranged",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("player_friendly_fire_response", data)
			end
		}
	}
}
BattleChatters.friendly_fire_bow_response = {
	irrelevant_active = 5,
	relevant_active = 1,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_ranged_response",
			weight = 1
		}
	}
}
BattleChatters.friendly_fire_throwing = {
	relevant_active = 1,
	delay = 0.8,
	talker = "get_talker_closest_teammate",
	irrelevant_active = 5,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_throwing",
			weight = 1,
			response = function(data)
				Managers.state.event:trigger("player_friendly_fire_response", data)
			end
		}
	}
}
BattleChatters.friendly_fire_throwing_response = {
	irrelevant_active = 5,
	relevant_active = 1,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_friendly_fire_throwing_response",
			weight = 1
		}
	}
}
BattleChatters.help_request = {
	irrelevant_active = 5,
	relevant_active = 1,
	trigger_chance = UNCOMMON,
	timpani_events = {
		{
			event = "bc_outside_battle_pleading_ally_for_revive",
			weight = 1
		}
	}
}
BattleChatters.cleanup = {
	relevant_distance = 25,
	relevant_active = 1,
	delay = 0.8,
	irrelevant_active = 5,
	trigger_chance = COMMON,
	timpani_events = {
		{
			event = "bc_battle_killing_off_all_enemys",
			weight = 1
		}
	}
}

for name, data in pairs(BattleChatters) do
	fassert(data.trigger_chance, "No trigger chance defined in battle chatter %q", name)
	fassert(data.timpani_events, "No timpani events defined in battle chatter %q", name)
	fassert(data.relevant_active, "No relevant_active defined in battle chatter %q", name)
	fassert(data.irrelevant_active, "No irrelevant_active defined in battle chatter %q", name)

	data.name = name
	data.queue_config = data.queue_config or DEFAULT_QUEUE_CONFIG
	data.delay = data.delay or 0
end

if script_data.debug_battle_chatter then
	for name, data in pairs(BattleChatters) do
		data.trigger_chance = ALWAYS
	end
end
