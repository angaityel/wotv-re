-- chunkname: @scripts/managers/stats/stats_collector_server.lua

require("scripts/managers/stats/stats_collection")
require("scripts/managers/stats/stats_contexts")
require("scripts/settings/experience_settings")
require("scripts/settings/currency_settings")

local function is_squad_wipe(victim)
	local squad_index = victim.squad_index

	if squad_index then
		for member, _ in pairs(victim.team.squads[squad_index]:members()) do
			if Unit.alive(member.player_unit) and ScriptUnit.extension(member.player_unit, "damage_system"):is_alive() then
				return false
			end
		end

		return true
	end

	return false
end

StatsCollectorServer = class(StatsCollectorServer)

function StatsCollectorServer:init(stats_collection)
	self._stats = stats_collection

	Managers.state.event:register(self, "player_self_kd", "event_player_self_kd", "player_team_kd", "event_player_team_kd", "player_enemy_kd", "event_player_enemy_kd", "player_self_kill", "event_player_self_kill", "player_team_kill", "event_player_team_kill", "player_enemy_kill", "event_player_enemy_kill", "enemy_kill_within_objective", "event_enemy_kill_within_objective", "player_spawned_at_unit", "event_player_spawned_at_unit", "player_parried", "event_player_parried", "player_heal_on_taunt", "event_player_heal_on_taunt", "piercing_shots_multi_hit", "event_piercing_shots_multi_hit", "fire_arrow_destroyed_shield", "event_fire_arrow_destroyed_shield", "gain_xp_test", "event_gain_xp_test", "player_joined_team", "event_player_joined_team", "player_left_team", "event_player_left_team", "profile_attributes_received", "event_profile_attributes_received", "anti_cheat_status_changed", "event_anti_cheat_status_changed", "anti_cheat_connect", "event_anti_cheat_connect", "anti_cheat_kick", "event_anti_cheat_kick", "heal_on_kill_trigger_on_low_health", "event_heal_on_kill_trigger_on_low_health")

	self._player_team_join_times = {}
end

function StatsCollectorServer:event_player_joined_team(player)
	local round_time = Managers.time:time("round")
	local team = player.team
	local team_name = team.name

	self._player_team_join_times[player] = round_time
end

function StatsCollectorServer:event_player_left_team(player)
	self:_increment_player_coins(player)
end

function StatsCollectorServer:event_profile_attributes_received(player)
	local network_id = player:network_id()
	local utc_time = Application.utc_time()
	local short_term_goal_end_time = self._stats:get(network_id, "short_term_goal_end_time")
	local short_term_goal_end_xp = self._stats:get(network_id, "short_term_goal_end_xp")
	local short_term_goal = self._stats:get(network_id, "short_term_goal")
	local current_short_term_level = self._stats:get(network_id, "current_short_term_level")

	if short_term_goal_end_time < utc_time then
		self:_set_new_short_term_goal(player, 1)
	else
		local coins_bonus = 0

		if current_short_term_level >= 1 then
			local goal_settings = ShortTermGoals[current_short_term_level]

			coins_bonus = goal_settings.bonus
		end

		self._stats:set(network_id, "coins_bonus", coins_bonus)

		if Managers.state.network:game() then
			RPC.rpc_set_short_term_goal(network_id, short_term_goal_end_time, short_term_goal_end_xp, short_term_goal)
		end
	end
end

function StatsCollectorServer:_set_new_short_term_goal(player, level)
	local goal_settings = ShortTermGoals[level]
	local utc_time = Application.utc_time()
	local network_id = player:network_id()
	local current_short_term_goal = self._stats:get(network_id, "short_term_goal")
	local coins_bonus = 0
	local current_short_term_level = 0

	if level > 1 then
		if level == #ShortTermGoals and level == current_short_term_goal then
			coins_bonus = goal_settings.bonus
			current_short_term_level = #ShortTermGoals
		else
			coins_bonus = ShortTermGoals[level - 1].bonus
			current_short_term_level = level - 1
		end
	end

	self._stats:set(network_id, "current_short_term_level", current_short_term_level)
	self._stats:set(network_id, "coins_bonus", coins_bonus)

	local short_term_goal_end_time = utc_time + goal_settings.time_to_achieve_goal

	self._stats:set(network_id, "short_term_goal_end_time", short_term_goal_end_time)

	local current_xp = self._stats:get(network_id, "experience") + self._stats:get(network_id, "experience_round")
	local rank = xp_to_rank(current_xp)
	local next_rank = RANKS[rank + 1]
	local next_rank_base_xp = next_rank and next_rank.xp.base or math.huge
	local xp_needed = math.min(next_rank_base_xp - current_xp, goal_settings.xp_required)
	local short_term_goal_end_xp = current_xp + xp_needed

	self._stats:set(network_id, "short_term_goal_end_xp", short_term_goal_end_xp)

	local short_term_goal = level

	self._stats:set(network_id, "short_term_goal", short_term_goal)

	if Managers.state.network:game() then
		local networked_goal_end_xp = math.clamp(short_term_goal_end_xp, NetworkConstants.player_xp.min, NetworkConstants.player_xp.max)

		RPC.rpc_set_short_term_goal(network_id, short_term_goal_end_time, networked_goal_end_xp, short_term_goal)

		local persistence_manager = Managers.persistence

		persistence_manager:save_short_term_goal(player, short_term_goal_end_time, short_term_goal_end_xp, short_term_goal, current_short_term_level)
	end
end

function StatsCollectorServer:event_player_self_kd(player)
	local player_id = player:network_id()

	self._stats:increment(player_id, "deaths", 1)
	self._stats:increment(player_id, "player_stats", "deaths", 1)
	self._stats:decrement(player_id, "enemy_kills", 1)
	self._stats:decrement(player_id, "player_stats", "kills", 1)
	self._stats:set(player_id, "first_kill_since_death", false)
	self._stats:set(player_id, "kill_streak", 0)
end

function StatsCollectorServer:event_player_team_kd(victim, attacker, gear_name, damage_type)
	local victim_id, attacker_id = victim:network_id(), attacker:network_id()

	self._stats:increment(attacker_id, "team_kills", 1)
	self._stats:increment(victim_id, "deaths", 1)
	self._stats:increment(victim_id, "player_stats", "deaths", 1)
	self._stats:set(victim_id, "first_kill_since_death", false)
	self._stats:set(victim_id, "kill_streak", 0)
end

function StatsCollectorServer:event_player_enemy_kd(victim, attacker, gear_name, damagers, attack_name, riposte)
	local victim_id, attacker_id = victim:network_id(), attacker:network_id()

	self._stats:increment(attacker_id, "weapon_stats", gear_name, "knockdowns", 1)
	self:_player_killed(victim, attacker, gear_name, damagers, false, attack_name, riposte)
end

function StatsCollectorServer:event_enemy_kill_within_objective(attacker)
	local attacker_id = attacker:network_id()

	self._stats:increment(attacker_id, "enemy_kill_within_objective", 1)
	self:_gain_xp_and_coins(attacker, "enemy_kill_within_objective")
end

function StatsCollectorServer:event_gain_xp_test(player)
	self:_gain_xp_and_coins(player, "xp_test")
end

function StatsCollectorServer:event_player_self_kill(player, damage_type, is_instakill)
	if is_instakill then
		local player_id = player:network_id()

		self._stats:increment(player_id, "deaths", 1)
		self._stats:increment(player_id, "player_stats", "deaths", 1)
		self._stats:decrement(player_id, "enemy_kills", 1)
		self._stats:decrement(player_id, "player_stats", "kills", 1)
		self._stats:set(player_id, "first_kill_since_death", false)
		self._stats:set(player_id, "kill_streak", 0)
	end
end

function StatsCollectorServer:event_player_team_kill(victim, attacker, gear_name, is_instakill)
	if is_instakill then
		local victim_id, attacker_id = victim:network_id(), attacker:network_id()

		self._stats:increment(attacker_id, "team_kills", 1)
		self._stats:decrement(attacker_id, "enemy_kills", 1)
		self._stats:decrement(attacker_id, "player_stats", "kills", 1)
		self._stats:increment(victim_id, "deaths", 1)
		self._stats:increment(victim_id, "player_stats", "deaths", 1)
		self._stats:set(victim_id, "first_kill_since_death", false)
		self._stats:set(victim_id, "kill_streak", 0)
	end
end

function StatsCollectorServer:event_player_enemy_kill(victim, attacker, gear_name, is_instakill, damagers, attack_name, riposte)
	local victim_id, attacker_id = victim:network_id(), attacker:network_id()

	if is_instakill then
		self:_player_killed(victim, attacker, gear_name, damagers, true, attack_name, riposte)
	else
		self._stats:increment(attacker_id, "finish_offs", 1)
		self:_gain_xp_and_coins(attacker, "finish_off")
	end

	local game_mode_settings = Managers.state.game_mode:game_mode_settings()
	local reward = game_mode_settings.rewards.confirmed_kill

	if reward then
		self:_gain_xp_and_coins(attacker, reward)
	end
end

function StatsCollectorServer:_player_killed(victim, attacker, gear_name, damagers, is_instakill, attack_name, riposte)
	local victim_id, attacker_id = victim:network_id(), attacker:network_id()

	if gear_name == "throwing_dagger_11" or gear_name == "throwing_dagger_12" or gear_name == "throwing_dagger_13" or gear_name == "throwing_dagger_41" or gear_name == "throwing_dagger_42" or gear_name == "throwing_dagger_43" then
		self._stats:increment(attacker_id, "throwing_dagger_kills", 1)
	end

	self._stats:increment(attacker_id, "enemy_kills", 1)
	self._stats:increment(attacker_id, "player_stats", "kills", 1)
	self._stats:increment(attacker_id, "kill_streak", 1)

	local kill_streak = self._stats:get(attacker_id, "kill_streak")

	self._stats:max(attacker_id, "longest_kill_streak", kill_streak)

	if is_instakill then
		self._stats:increment(attacker_id, "weapon_stats", gear_name, "instakills", 1)

		if attack_name == "backstab" then
			self:_gain_xp_and_coins(attacker, "enemy_instakill_backstab")
		else
			self:_gain_xp_and_coins(attacker, "enemy_instakill")
		end
	else
		self._stats:increment(attacker_id, "weapon_stats", gear_name, "knockdowns", 1)
		self:_gain_xp_and_coins(attacker, "enemy_knockdown")
	end

	if self._stats:get(attacker_id, "first_kill_since_death") then
		self._stats:increment(attacker_id, "successive_kills", 1)
		self:_gain_xp_and_coins(attacker, "successive_kill")
	else
		self._stats:set(attacker_id, "first_kill_since_death", true)
	end

	if Unit.alive(victim.player_unit) then
		local tagger = Managers.state.tagging:tagger_by_tagged_unit(victim.player_unit)

		if tagger then
			self._stats:increment(attacker_id, "tagged_assists", 1)

			local attacker_player_unit = attacker.player_unit
			local attacker_locomotion = Unit.alive(attacker_player_unit) and ScriptUnit.extension(attacker_player_unit, "locomotion_system")
			local tagger_player_unit = tagger.player_unit
			local tagger_locomotion = Unit.alive(tagger_player_unit) and ScriptUnit.extension(tagger_player_unit, "locomotion_system")
			local reward_name = attacker_locomotion and attacker_locomotion:has_perk("tag_on_bow_shot") and "tag_kill_tag_on_bow_shot" or "tag_kill"

			self:_gain_xp_and_coins(attacker, reward_name)

			reward_name = tagger_locomotion and tagger_locomotion:has_perk("tag_on_bow_shot") and "tagger_reward_tag_on_bow_shot" or "tagger_reward"

			self:_gain_xp_and_coins(tagger, reward_name)
		end
	end

	if Unit.alive(attacker.player_unit) then
		local attacker_player_unit = attacker.player_unit
		local attacker_locomotion = Unit.alive(attacker_player_unit) and ScriptUnit.extension(attacker_player_unit, "locomotion_system")

		if attacker_locomotion:is_getting_fake_death_bonus() then
			self:_gain_xp_and_coins(attacker, "fake_death_and_kill")
		end
	end

	if victim.is_corporal then
		if victim.team.name == "white" then
			self._stats:increment(attacker_id, "saxon_squad_leader_kills", 1)
		elseif victim.team.name == "red" then
			self._stats:increment(attacker_id, "viking_squad_leader_kills", 1)
		end
	end

	for assister, damage in pairs(damagers) do
		if Managers.player:player_exists(assister.index) then
			if attacker ~= assister and assister.team ~= victim.team then
				local assister_id = assister:network_id()

				self._stats:increment(assister_id, "assists", 1)
				self:_gain_xp_and_coins(assister, "assist")
				self:_gain_xp_and_coins(assister, "assist_enemy_damage", ExperienceSettings.enemy_damage * damage)
			elseif attacker == assister and assister.team ~= victim.team then
				self:_gain_xp_and_coins(assister, "enemy_damage", ExperienceSettings.enemy_damage * damage)
			end
		end
	end

	if attack_name == "dodge_left" or attack_name == "dodge_right" or attack_name == "dodge_forward" or attack_name == "dodge_backward" then
		self:_gain_xp_and_coins(attacker, "dodge_attack_kill")
	end

	local gear = Gear[gear_name]

	if attack_name == "throw" and gear.category ~= "throwing_weapon" then
		self:_gain_xp_and_coins(attacker, "throw_all_weps_kill")
	end

	local attacker_player_unit = attacker.player_unit

	if riposte then
		local attacker_locomotion = Unit.alive(attacker_player_unit) and ScriptUnit.extension(attacker_player_unit, "locomotion_system")

		if attacker_locomotion and attacker_locomotion:has_perk("blade_master") then
			self:_gain_xp_and_coins(attacker, "blade_master_counter")
		end
	end

	if Unit.alive(attacker_player_unit) and ScriptUnit.has_extension(attacker_player_unit, "damage_system") and ScriptUnit.has_extension(attacker_player_unit, "locomotion_system") then
		local attacker_damage_system = ScriptUnit.extension(attacker_player_unit, "damage_system")
		local attacker_locomotion = ScriptUnit.extension(attacker_player_unit, "locomotion_system")

		if attacker_damage_system:was_last_stand_active() then
			self:_gain_xp_and_coins(attacker, "successful_last_stand")
		end

		if attacker_damage_system:is_getting_revive_yourself() then
			self:_gain_xp_and_coins(attacker, "revived_yourself_and_kill")
		end

		local network_manager = Managers.state.network
		local game = network_manager:game()
		local id = network_manager:unit_game_object_id(attacker_player_unit)
		local stamina_state = game and id and NetworkLookup.stamina_state[GameSession.game_object_field(game, id, "stamina_state")]

		if attacker_locomotion:has_perk("stamina_on_kill") then
			if stamina_state == "tired" then
				self:_gain_xp_and_coins(attacker, "kill_on_low_stamina")
			end

			if game and id then
				RPC.rpc_perk_triggered(attacker_id, id, NetworkLookup.perks.stamina_on_kill)
			end
		end
	end

	self._stats:increment(victim_id, "deaths", 1)
	self._stats:increment(victim_id, "player_stats", "deaths", 1)
	self._stats:set(victim_id, "first_kill_since_death", false)
	self._stats:set(victim_id, "kill_streak", 0)
end

function StatsCollectorServer:event_fire_arrow_destroyed_shield(attacking_player)
	self:_gain_xp_and_coins(attacking_player, "fire_arrow_destroyed_shield")
end

function StatsCollectorServer:event_player_heal_on_taunt(healee)
	self:_gain_xp_and_coins(healee, "player_heal_on_taunt")
end

function StatsCollectorServer:event_player_parried(hit_gear_unit, gear_unit)
	local user_unit = Unit.get_data(hit_gear_unit, "user_unit")
	local blocker = Managers.player:owner(user_unit)
	local blocker_id = blocker:network_id()
	local gear_name = Unit.get_data(hit_gear_unit, "gear_name")
	local locomotion = Unit.alive(user_unit) and ScriptUnit.extension(user_unit, "locomotion_system")

	self._stats:increment(blocker_id, "weapon_stats", gear_name, "parries", 1)
end

function StatsCollectorServer:event_piercing_shots_multi_hit(shooter)
	self:_gain_xp_and_coins(shooter, "piercing_shots_multi_hit")
end

function StatsCollectorServer:player_revived(revivee, reviver)
	local revivee_id, reviver_id = revivee:network_id(), reviver:network_id()

	self._stats:increment(reviver_id, "revives", 1)
	self._stats:decrement(revivee_id, "deaths", 1)
	self._stats:decrement(revivee_id, "player_stats", "deaths", 1)
	self:_gain_xp_and_coins(reviver, "revive")

	if revivee == reviver then
		self:_gain_xp_and_coins(reviver, "revive_yourself")
	end
end

function StatsCollectorServer:player_self_bandage(player)
	return
end

function StatsCollectorServer:player_team_bandage(bandagee, bandager)
	local bandagee_id, bandager_id = bandagee:network_id(), bandager:network_id()

	self._stats:increment(bandager_id, "team_bandages", 1)
	self:_gain_xp_and_coins(bandager, "team_bandage")
end

function StatsCollectorServer:player_self_damage(player, damage, gear_name, hit_zone, damage_range_type, mirrored)
	if mirrored then
		self:player_team_damage(player, player, damage, gear_name, hit_zone)
	end
end

function StatsCollectorServer:player_team_damage(damagee, damager, damage, gear_name, hit_zone)
	local damager_id = damager:network_id()

	self._stats:increment(damager_id, "team_hits", 1)
	self._stats:increment(damager_id, "team_damage", damage)
	self:_gain_xp_and_coins(damager, "friendly_damage", ExperienceSettings.friendly_damage * damage, CurrencySettings.friendly_damage * damage)
end

function StatsCollectorServer:player_enemy_damage(damagee, damager, damage, gear_name, hit_zone, damage_range_type, range)
	local damagee_id, damager_id = damagee:network_id(), damager:network_id()

	self._stats:increment(damager_id, "enemy_damage", damage)

	if hit_zone == "head" or hit_zone == "helmet" then
		if Gear[gear_name].stat_category == "crossbow" then
			self._stats:increment(damager_id, "headshots_with_crossbow", 1)
		end

		if damage_range_type == "small_projectile" then
			if damage <= 0 then
				self._stats:increment(damager_id, "headshots_bounced", 1)
			else
				self._stats:increment(damager_id, "headshots", 1)
			end

			self:_gain_xp_and_coins(damager, "headshot")
		end
	end

	if range then
		if range > 45.72 then
			local damager_unit = damager.player_unit
			local damager_locomotion = Unit.alive(damager_unit) and ScriptUnit.extension(damager_unit, "locomotion_system")

			if damager_locomotion and damager_locomotion:has_perk("bow_zoom") then
				self:_gain_xp_and_coins(damager, "bow_zoom_longshot")
			else
				self:_gain_xp_and_coins(damager, "longshot")
			end

			self._stats:increment(damager_id, "longshots", 1)
		end

		self._stats:max(damager_id, "longshot_range", range)
	end

	self._stats:increment(damager_id, "weapon_stats", gear_name, PlayerUnitDamageSettings.hit_zones[hit_zone].hit_stat, 1)
	self._stats:increment(damager_id, "weapon_stats", gear_name, PlayerUnitDamageSettings.hit_zones[hit_zone].damage_stat, damage)
end

function StatsCollectorServer:mount_stray_kill(attacker)
	return
end

function StatsCollectorServer:mount_team_kill(attacker, rider)
	return
end

function StatsCollectorServer:mount_enemy_kill(attacker, rider)
	self._stats:increment(attacker:network_id(), "enemy_mount_kills", 1)
end

function StatsCollectorServer:player_self_dotted(victim, attacker, damage_type)
	return
end

function StatsCollectorServer:player_team_dotted(victim, attacker, damage_type)
	return
end

function StatsCollectorServer:player_enemy_dotted(victim, attacker, damage_type)
	return
end

function StatsCollectorServer:event_player_spawned_at_unit(player, squad_player)
	local squad_player_id = squad_player:network_id()

	self:_gain_xp_and_coins(squad_player, "squad_spawn")
	self._stats:increment(squad_player_id, "squad_spawns", 1)
	self._stats:increment(squad_player_id, "squad_spawns_round", 1)
end

function StatsCollectorServer:weapon_missed(player, gear_name)
	self._stats:increment(player:network_id(), "weapon_stats", gear_name, "misses", 1)
end

function StatsCollectorServer:objective_captured(capturing_player, capturing_unit, game_mode_key)
	local player_id = capturing_player:network_id()

	self._stats:increment(player_id, game_mode_key .. "_objectives_captured", 1)
	self:_gain_xp_and_coins(capturing_player, game_mode_key .. "_objective_captured")
end

function StatsCollectorServer:objective_captured_assist(assist_player, capturing_unit, game_mode_key)
	local player_id = assist_player:network_id()

	self._stats:increment(player_id, game_mode_key .. "_objectives_captured_assist", 1)
	self:_gain_xp_and_coins(assist_player, game_mode_key .. "_objective_captured_assist")
end

function StatsCollectorServer:section_cleared_payload(assist_player)
	return
end

function StatsCollectorServer:ranged_projectile_hit(victim, attacker, faster_bow_charge_active)
	if faster_bow_charge_active then
		self:_gain_xp_and_coins(attacker, "faster_bow_charge_hit")
	end
end

function StatsCollectorServer:_gain_xp_and_coins(player, reason, xp_amount, coin_amount)
	local xp_multiplier = player.is_demo and ExperienceSettings.DEMO_MULTIPLIER or ExperienceSettings.MULTIPLIER
	local coin_multiplier = player.is_demo and CurrencySettings.DEMO_MULTIPLIER or CurrencySettings.MULTIPLIER
	local base_xp_amount = xp_amount or ExperienceSettings[reason] or 99999
	local modified_xp_amount
	local network_id = player:network_id()
	local diminishing_returns_settings = ExperienceDiminishingReturnsSettings[reason]

	if diminishing_returns_settings then
		modified_xp_amount = diminishing_returns_settings.returns_function(self._stats:get(network_id, diminishing_returns_settings.stat), base_xp_amount)
	else
		modified_xp_amount = base_xp_amount
	end

	local xp

	if modified_xp_amount > 0 then
		xp = xp_multiplier * modified_xp_amount
	else
		xp = modified_xp_amount
	end

	local coins = coin_multiplier * (coin_amount or CurrencySettings[reason] or 99999)
	local admin_manager = Managers.admin

	if not Managers.state.team:stats_requirement_fulfilled() or admin_manager and admin_manager:is_server_password_protected() then
		xp, coins = 0, 0
	end

	local current_round_xp = self._stats:get(network_id, "experience_round")
	local current_xp = self._stats:get(network_id, "experience") + current_round_xp

	if xp < 0 then
		local current_rank = xp_to_rank(current_xp)
		local rank_base_xp = RANKS[current_rank].xp.base

		xp = math.max(xp, rank_base_xp - current_xp, -current_round_xp)
	end

	self._stats:increment(network_id, "experience_round", xp)
	self._stats:increment(network_id, "score_round", xp)

	local short_term_goal_end_time = self._stats:get(network_id, "short_term_goal_end_time")
	local short_term_goal_end_xp = self._stats:get(network_id, "short_term_goal_end_xp")
	local short_term_goal = self._stats:get(network_id, "short_term_goal")

	if short_term_goal_end_time < Application.utc_time() then
		self:_set_new_short_term_goal(player, 1)
	elseif short_term_goal_end_xp <= current_xp + xp then
		local next_short_term_goal = short_term_goal == #ShortTermGoals and short_term_goal or short_term_goal + 1

		self:_set_new_short_term_goal(player, next_short_term_goal)
		RPC.rpc_short_term_goal_achieved(network_id, short_term_goal)
	end

	if Managers.state.network:game() then
		xp = xp or 0
		coins = coins or 0
	end
end

function StatsCollectorServer:round_finished(game_mode_key, winning_team)
	local players = Managers.player:players()
	local round_time = Managers.time:time("round")
	local game_mode_settings = Managers.state.game_mode:game_mode_settings()
	local round_won_reward = game_mode_settings.rewards.round_won
	local round_survived_reward = game_mode_settings.rewards.round_survived
	local round_played_reward = game_mode_settings.rewards.round_played

	for player_index, player in pairs(players) do
		self:_increment_player_coins(player)

		if round_won_reward and player.team == winning_team then
			local player_unit = player.player_unit

			if round_survived_reward and Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "damage_system"):is_alive() then
				self:_gain_xp_and_coins(player, round_survived_reward)
			else
				self:_gain_xp_and_coins(player, round_won_reward)
			end
		elseif round_played_reward then
			self:_gain_xp_and_coins(player, round_played_reward)
		end
	end
end

function StatsCollectorServer:match_finished(game_mode_key, winning_team, total_victory)
	local scores = {
		red = {},
		white = {},
		all = {}
	}
	local squad_scores = {
		red = {},
		white = {}
	}
	local players = Managers.player:players()
	local round_time = Managers.time:time("round")
	local reward_settings = Managers.state.game_mode:game_mode_settings().rewards
	local match_won_reward = reward_settings.match_won
	local match_played_reward = reward_settings.match_played
	local total_victory_reward = reward_settings.match_total_victory

	for player_index, player in pairs(players) do
		local network_id = player:network_id()
		local team_name = player.team and player.team.name or nil
		local first_win_bonus = 0

		self:_increment_player_coins(player)

		if winning_team then
			local round_won = winning_team.members[player_index] ~= nil

			self._stats:set(network_id, "round_won", round_won)

			if round_won then
				self._stats:increment(network_id, "player_stats", game_mode_key .. "_round_won", 1)
				self._stats:increment(network_id, "experience_bonus", ExperienceSettings.round_won)

				local win_time = Application.utc_time()
				local last_win_time = self._stats:get(network_id, "last_win_time") or 0
				local time_diff = math.abs(os.difftime(win_time, last_win_time))

				if time_diff >= 86400 and Managers.state.team:stats_requirement_fulfilled() then
					first_win_bonus = CurrencySettings.daily_win_bonus

					print("Daily win bonus for", player:name(), last_win_time, win_time, time_diff)
					self._stats:set(network_id, "last_win_time", win_time)
				end

				if player.is_corporal then
					self._stats:set(network_id, "ragnar_lothbrok", true)
				end

				self._stats:increment(network_id, "wins_in_a_row", 1)

				if total_victory and total_victory_reward then
					self:_gain_xp_and_coins(player, total_victory_reward)
				elseif match_won_reward then
					self:_gain_xp_and_coins(player, match_won_reward)
				end
			else
				if match_played_reward then
					self:_gain_xp_and_coins(player, match_played_reward)
				end

				self._stats:set(network_id, "wins_in_a_row", 0)
			end
		elseif match_played_reward then
			self:_gain_xp_and_coins(player, match_played_reward)
		end

		self._stats:set(network_id, "round_finished", true)
		self._stats:increment(network_id, "player_stats", game_mode_key .. "_round_played", 1)

		local xp_round = self._stats:get(network_id, "experience_round")
		local xp_saved = self._stats:get(network_id, "experience_saved")
		local xp = math.clamp(self._stats:get(network_id, "experience_round") - self._stats:get(network_id, "experience_saved"), 0, math.huge)
		local xp_bonus = self._stats:get(network_id, "experience_bonus") / 100
		local bonus_xp = xp_round * (1 + xp_bonus)
		local bonus_xp_only = bonus_xp - xp_round
		local xp_final = xp + bonus_xp_only

		self._stats:set(network_id, "experience_round", xp_final)
		self._stats:set(network_id, "experience_round_final", xp_final)

		local profile_id = player.backend_profile_id

		if player.remote and profile_id ~= -1 then
			self._stats:set(network_id, "time_played", Managers.time:time("round") - (player.round_time_joined or 0))
		end

		local coins_round = self._stats:get(network_id, "coins_round")
		local coins_saved = self._stats:get(network_id, "coins_saved")
		local coins = math.clamp(self._stats:get(network_id, "coins_round") - self._stats:get(network_id, "coins_saved"), 0, math.huge)
		local coins_bonus_stat = self._stats:get(network_id, "coins_bonus")
		local coins_bonus = coins_bonus_stat / 100
		local event_bonus = CurrencySettings.MULTIPLIER
		local bonus_coins = coins_round * (1 + coins_bonus) * event_bonus
		local bonus_coins_only = bonus_coins - coins_round
		local coins_final = coins + bonus_coins_only + first_win_bonus
		local old_coin_amount = math.clamp(self._stats:get(network_id, "coins"), NetworkConstants.coins.min, NetworkConstants.coins.max)

		RPC.rpc_award_coins(network_id, old_coin_amount, coins_round, 100 + coins_bonus_stat, event_bonus * 100, first_win_bonus)
		self._stats:set(network_id, "coins_round", coins_final)

		local player_experience = self._stats:get(network_id, "experience_round")
		local player_and_exp = {
			pid = network_id,
			xp = player_experience
		}

		if team_name ~= "unassigned" then
			table.insert(scores[team_name], player_and_exp)
			table.insert(scores.all, player_and_exp)

			if player.squad_index then
				local squad = player.team.squads[player.squad_index]

				squad_scores[team_name][squad] = (squad_scores[team_name][squad] or 0) + player_experience
			end
		end
	end

	local function comparator(e1, e2)
		return e1.xp > e2.xp
	end

	table.sort(scores.red, comparator)
	table.sort(scores.white, comparator)
	table.sort(scores.all, comparator)

	for placement, player_and_exp in pairs(scores.red) do
		self._stats:set(player_and_exp.pid, "placement_team", placement)
	end

	for placement, player_and_exp in pairs(scores.white) do
		self._stats:set(player_and_exp.pid, "placement_team", placement)
	end

	for placement, player_and_exp in pairs(scores.all) do
		self._stats:set(player_and_exp.pid, "placement", placement)
	end

	local squad_placements = {
		red = {},
		white = {},
		all = {}
	}

	for squad, xp in pairs(squad_scores.red) do
		table.insert(squad_placements.red, {
			squad = squad,
			xp = xp
		})
		table.insert(squad_placements.all, {
			squad = squad,
			xp = xp
		})
	end

	for squad, xp in pairs(squad_scores.white) do
		table.insert(squad_placements.white, {
			squad = squad,
			xp = xp
		})
		table.insert(squad_placements.all, {
			squad = squad,
			xp = xp
		})
	end

	table.sort(squad_placements.red, comparator)
	table.sort(squad_placements.white, comparator)
	table.sort(squad_placements.all, comparator)

	for placement, squad_and_exp in pairs(squad_placements.all) do
		for member, _ in pairs(squad_and_exp.squad:members()) do
			self._stats:set(member:network_id(), "placement_squad", placement)
		end
	end
end

function StatsCollectorServer:_increment_player_coins(player)
	local round_time = Managers.time:time("round")
	local network_id = player:network_id()
	local team_name = player.team.name
	local admin_manager = Managers.admin
	local password_protected = admin_manager and admin_manager:is_server_password_protected()

	if self._player_team_join_times[player] and team_name ~= "unassigned" and not password_protected then
		local coin_gain = (round_time - self._player_team_join_times[player]) / 60 * CurrencySettings.COINS_PER_MINUTE

		self._stats:increment(network_id, "coins_round", coin_gain)
	end
end

function StatsCollectorServer:event_heal_on_kill_trigger_on_low_health(player)
	self:_gain_xp_and_coins(player, "kill_on_low_health")
end

function StatsCollectorServer:event_anti_cheat_status_changed(peer_id, status)
	if status == AntiCheat.USER_BANNED then
		self._stats:increment(peer_id, "anti_cheat_status_banned", 1)
	elseif status == AntiCheat.USER_DISCONNECTED then
		self._stats:increment(peer_id, "anti_cheat_status_disconnected", 1)
	elseif status == AntiCheat.USER_AUTHENTICATED then
		self._stats:increment(peer_id, "anti_cheat_status_authenticated", 1)
	end
end

function StatsCollectorServer:event_anti_cheat_connect(peer_id)
	self._stats:increment(peer_id, "anti_cheat_connects", 1)
end

function StatsCollectorServer:event_anti_cheat_kick(peer_id)
	self._stats:increment(peer_id, "anti_cheat_kicks", 1)
end
