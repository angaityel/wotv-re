-- chunkname: @scripts/settings/experience_settings.lua

ExperienceSettings = {
	enemy_knockdown = 125,
	con_objective_captured_assist = 250,
	battle_objective_captured_assist = 50,
	domination_objective_captured = 150,
	kill_on_low_health = 50,
	headshot = 100,
	execution = 200,
	revive = 125,
	domination_objective_captured_assist = 150,
	assist = 50,
	friendly_damage = -1,
	fire_arrow_destroyed_shield = 50,
	bow_zoom_longshot = 50,
	conquest_match_won = 600,
	fake_death_and_kill = 100,
	revived_yourself_and_kill = 50,
	xp_test = 300,
	battle_confirmed_kill = 150,
	enemy_kill_within_objective = 30,
	battle_round_played = 75,
	successful_last_stand = 50,
	tag_kill = 20,
	longshot = 25,
	kill_on_low_stamina = 20,
	arena_confirmed_kill = 100,
	arena_match_played = 150,
	MULTIPLIER = 1,
	conquest_match_played = 300,
	battle_match_won = 450,
	round_won = 0,
	enemy_instakill_backstab = 200,
	squad_spawn = 25,
	battle_round_survived = 300,
	finish_off = 50,
	tdm_match_played = 300,
	DEMO_MULTIPLIER = 0.8,
	team_bandage = 75,
	revive_yourself = 25,
	tag_kill_tag_on_bow_shot = 40,
	tdm_match_won = 600,
	tagger_reward = 15,
	enemy_damage = 1,
	assist_enemy_damage = 1,
	con_objective_captured = 250,
	battle_round_won = 225,
	arena_round_played = 50,
	enemy_instakill = 175,
	successive_kill = 15,
	arena_round_survived = 200,
	conquest_total_victory = 1000,
	domination_match_played = 150,
	tdm_confirmed_kill = 20,
	domination_match_won = 300,
	arena_round_won = 150,
	tagger_reward_tag_on_bow_shot = 30,
	arena_match_won = 300,
	blade_master_counter = 25,
	player_heal_on_taunt = 25,
	piercing_shots_multi_hit = 50,
	dodge_attack_kill = 20,
	battle_objective_captured = 50,
	faster_bow_charge_hit = 15,
	throw_all_weps_kill = 50,
	battle_match_played = 225
}
ExperienceDiminishingReturnsSettings = {
	revive = {
		stat = "revives",
		returns_function = function(stat_value, base_xp)
			if stat_value <= 8 then
				return base_xp
			elseif stat_value >= 12 then
				return 25
			else
				return base_xp - (stat_value - 8) * 25
			end
		end
	},
	team_bandage = {
		stat = "team_bandages",
		returns_function = function(stat_value, base_xp)
			if stat_value <= 6 then
				return base_xp
			elseif stat_value >= 8 then
				return 25
			else
				return base_xp - (stat_value - 6) * 25
			end
		end
	}
}
