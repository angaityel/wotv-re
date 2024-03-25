-- chunkname: @scripts/managers/battle_chatter/battle_chatter_collector.lua

require("scripts/managers/battle_chatter/battle_chatter_helper")
require("scripts/settings/battle_chatters")

BattleChatterCollector = class(BattleChatterCollector)

function BattleChatterCollector:init(world, handler, player)
	self._world = world
	self._handler = handler
	self._player = player
	self._response_counter = {}

	Managers.state.event:register(self, "player_killed", "event_player_killed", "player_parried", "event_player_parried", "headshot_response", "event_headshot_response", "rush_impact_character", "event_rush_impact_character", "shield_break", "event_shield_break", "revive_started", "event_revive_started", "revive_completed", "event_revive_completed", "tagged_player", "event_tagged_player", "gm_event_objective_captured", "event_gm_event_objective_captured", "teammate_capture_point_response", "event_teammate_capture_point_response", "enemy_capture_point_response", "event_enemy_capture_point_response", "travel_mode_entered", "event_travel_mode_entered", "round_started", "event_round_started", "round_started_response", "event_round_started_response", "bc_projectile_hit_afro", "event_bc_projectile_hit_afro", "player_bandaging", "event_player_bandaging", "player_bandaging_response", "event_player_bandaging_response", "player_damaged", "event_player_damaged", "player_friendly_fire", "event_player_friendly_fire", "player_friendly_fire_response", "event_player_friendly_fire_response", "received_help_request", "event_received_help_request", "enemy_revive_started_response", "event_enemy_revive_started_response")
end

function BattleChatterCollector:event_player_killed(victim_unit, attacker_unit, gear_name, is_instakill, finish_off, damage_type, range, hit_zone, is_knocked_down, victim_kill_streak, damage_range_type, first_kill)
	if attacker_unit == victim_unit or not Unit.alive(attacker_unit) then
		return
	end

	local gear_type = Gear[gear_name].gear_type
	local is_melee = damage_range_type == "melee"
	local is_bow = gear_type == "longbow" or gear_type == "hunting_bow" or gear_type == "short_bow"
	local is_throwing = not is_bow and damage_range_type == "small_projectile"

	if self:_cleanup_conditions(attacker_unit) then
		self:_player_cleanup(attacker_unit)
	elseif is_knocked_down then
		if first_kill then
			-- block empty
		elseif victim_kill_streak >= 3 then
			self:_player_killed_kill_streak(victim_unit, attacker_unit, victim_kill_streak)
		elseif is_bow and (hit_zone == "head" or hit_zone == "helmet") then
			self:_player_killed_headshot(victim_unit, attacker_unit, range)
		elseif is_melee then
			-- block empty
		elseif is_throwing then
			self:_player_killed_throwing_kill(victim_unit, attacker_unit)
		end
	elseif is_instakill then
		if first_kill then
			-- block empty
		elseif victim_kill_streak >= 3 then
			self:_player_killed_kill_streak(victim_unit, attacker_unit, victim_kill_streak)
		elseif is_bow then
			self:_player_killed_headshot(victim_unit, attacker_unit, range)
		elseif is_melee then
			local locomotion = ScriptUnit.extension(victim_unit, "locomotion_system")
			local inventory = locomotion:inventory()
			local is_decap = hit_zone == "head" and (damage_type == "cutting" or damage_type == "slashing") and GameSettingsDevelopment.allow_decapitation and inventory:allow_decapitation()

			if is_decap then
				self:_player_killed_decap(victim_unit, attacker_unit)
			else
				self:_player_killed_instakill(victim_unit, attacker_unit)
			end
		elseif is_throwing then
			self:_player_killed_throwing_kill(victim_unit, attacker_unit)
		end
	elseif finish_off and (is_melee or is_bow or is_throwing) then
		self:_player_killed_finish_off(victim_unit, attacker_unit)
	end

	if false then
		-- block empty
	end
end

function BattleChatterCollector:event_player_parried(hit_gear_unit, gear_unit)
	local parry_user_unit = Unit.get_data(hit_gear_unit, "user_unit")
	local parry_master = Unit.get_data(parry_user_unit, "parry_master") or {}
	local parries = parry_master.parries or 0
	local parry_time = parry_master.parry_time or 0
	local hitters = parry_master.hitters or {}
	local game_time = Managers.time:time("game")
	local time_interval = 5

	parries = parries + 1

	if not table.find(hitters, Unit.get_data(gear_unit, "user_unit")) then
		hitters[#hitters + 1] = Unit.get_data(gear_unit, "user_unit")
	end

	if game_time > parry_time + time_interval then
		parry_master.parries = 1
		parry_master.parry_time = game_time
		parry_master.hitters = {
			Unit.get_data(gear_unit, "user_unit")
		}

		Unit.set_data(parry_user_unit, "parry_master", parry_master)
	elseif parries < 4 then
		parry_master.parries = parries
		parry_master.parry_time = game_time
		parry_master.hitters = hitters

		Unit.set_data(parry_user_unit, "parry_master", parry_master)
	else
		local battle_chatter_name = "parry_master"
		local config = BattleChatters[battle_chatter_name]

		if not BattleChatterHelper.trigger(config.trigger_chance) then
			return
		end

		parry_master.parries = 0
		parry_master.parry_time = game_time
		parry_master.hitters = {}

		Unit.set_data(parry_user_unit, "parry_master", parry_master)

		local local_unit = self._player.player_unit

		if not BattleChatterHelper.relevant_distance(local_unit, parry_user_unit, config.relevant_distance) then
			return
		end

		local exclude_list = {
			local_unit,
			parry_user_unit
		}
		local talker = BattleChatterHelper.get_talker(config.talker, self._world, parry_user_unit, exclude_list, config.talker_distance)

		if not talker then
			if BattleChatterHelper.talk_eligible(parry_user_unit) then
				talker = parry_user_unit
				config.timpani_events = config.player_events
			else
				return
			end
		else
			config.timpani_events = config.teammate_events
		end

		local relevant = local_unit == parry_user_unit or table.contains(hitters, local_unit)
		local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

		self._handler:add_chatter(data)
	end
end

function BattleChatterCollector:event_headshot_response(data)
	local responders = data.responders

	if responders then
		local battle_chatter_name = "headshot_response"
		local config = BattleChatters[battle_chatter_name]

		fassert(config, "No Battle Chatter named %q", battle_chatter_name)

		if not Unit.alive(data.attacker.player_unit) then
			return
		end

		local talker, responders = BattleChatterHelper[config.talker](data.attacker.player_unit, responders)

		if not talker then
			return
		end

		local response_data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, data.relevant)

		self._handler:add_chatter(response_data)
	end

	if false then
		-- block empty
	end
end

function BattleChatterCollector:event_rush_impact_character(aggressor_unit, victim_unit)
	local battle_chatter_name = "intercept"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, aggressor_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.talk_eligible(aggressor_unit) then
		return
	end

	local local_unit = self._player.player_unit
	local relevant = local_unit == aggressor_unit or local_unit == victim_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(aggressor_unit, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_shield_break(aggressor_unit, victim_unit)
	local battle_chatter_name = "shield_break"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, victim_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.talk_eligible(victim_unit) then
		return
	end

	local victim_owner = Managers.player:owner(victim_unit)
	local unit = self._player.player_unit
	local relevant = unit == victim_unit or unit == aggressor_unit or victim_owner.team == self._player.team and BattleChatterHelper.relevant_distance(unit, victim_unit, config.relevant_distance / 2)
	local data = BattleChatterHelper.setup_generic_chatter_data(victim_unit, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_revive_started(reviver_id, revivee_id)
	self:_revive_started(reviver_id, revivee_id)
	self:_enemy_revive_started(reviver_id, revivee_id)
end

function BattleChatterCollector:event_revive_completed(reviver_unit, revivee_unit)
	if reviver_unit == revivee_unit then
		return
	end

	local battle_chatter_name = "revive_completed"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, revivee_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(reviver_unit, revivee_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.talk_eligible(revivee_unit) then
		return
	end

	local unit = self._player.player_unit
	local relevant = unit == reviver_unit or unit == revivee_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(revivee_unit, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_tagged_player(tagger_unit, tagged_unit)
	local tagger_owner = Managers.player:owner(tagger_unit)
	local tagged_owner = Managers.player:owner(tagged_unit)

	if tagger_owner.team == tagged_owner.team then
		return
	end

	local battle_chatter_name = "tagged_enemy"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, tagger_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.talk_eligible(tagger_unit) then
		return
	end

	local same_squad = self._player.squad_index == tagger_owner.squad_index
	local relevant = self._player.player_unit == tagger_unit or same_squad
	local data = BattleChatterHelper.setup_generic_chatter_data(tagger_unit, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_gm_event_objective_captured(capturing_player, captured_unit)
	self:_teammate_capture_point(capturing_player)
	self:_enemy_capture_point(capturing_player)
end

function BattleChatterCollector:event_teammate_capture_point_response(data)
	local battle_chatter_name = "teammate_capture_point_response"
	local response_count = self._response_counter[battle_chatter_name] or 0

	response_count = response_count + 1
	self._response_counter[battle_chatter_name] = response_count

	if response_count > 4 then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local player_unit = self._player.player_unit

	if not player_unit then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	if data.responders and #data.responders == 0 or data.responders == nil then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local previous_talker = Managers.player:owner(data.talker)
	local relevant = previous_talker.team == self._player.team
	local talker, responders

	if relevant then
		talker, responders = BattleChatterHelper.get_talker_random_teammate(player_unit, data.responders)
	else
		talker, responders = BattleChatterHelper.get_talker_random_enemy(player_unit, data.responders)
	end

	if not talker then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local response_data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(response_data)
end

function BattleChatterCollector:event_enemy_capture_point_response(data)
	local battle_chatter_name = "enemy_capture_point_response"
	local response_count = self._response_counter[battle_chatter_name] or 0

	response_count = response_count + 1
	self._response_counter[battle_chatter_name] = response_count

	if response_count > 4 then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local player_unit = self._player.player_unit

	if not player_unit then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	if data.responders and #data.responders == 0 or data.responders == nil then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local previous_talker = Managers.player:owner(data.talker)
	local relevant = previous_talker.team == self._player.team
	local talker, responders

	if relevant then
		talker, responders = BattleChatterHelper.get_talker_random_teammate(player_unit, data.responders)
	else
		talker, responders = BattleChatterHelper.get_talker_random_enemy(player_unit, data.responders)
	end

	if not talker then
		self._response_counter[battle_chatter_name] = 0

		return
	end

	local response_data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_travel_mode_entered(travel_unit)
	local travel_owner = Managers.player:owner(travel_unit)

	if travel_owner.team ~= self._player.team then
		return
	end

	if not BattleChatterHelper.talk_eligible(travel_unit) then
		return
	end

	local battle_chatter_name = "travel_mode_entered"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, travel_unit, config.relevant_distance) then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(travel_unit, nil, config, true)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_round_started()
	if not self._player.player_unit then
		return
	end

	local battle_chatter_name = "round_started"
	local config = BattleChatters[battle_chatter_name]
	local trigger_relevant = BattleChatterHelper.trigger(config.trigger_chance)
	local trigger_irrelevant = BattleChatterHelper.trigger(config.trigger_chance)

	if not trigger_relevant and not trigger_irrelevant then
		return
	end

	if trigger_relevant then
		local exclude_list = {
			self._player.player_unit
		}
		local possible_talkers = BattleChatterHelper.get_close_units(self._world, self._player.player_unit, exclude_list, config.talker_distance)

		if #possible_talkers == 0 then
			return
		end

		local talker, responders = BattleChatterHelper.get_talker_random_teammate(self._player.player_unit, possible_talkers)

		if not talker then
			return
		end

		local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, true)

		self._handler:add_chatter(data)
	end

	if trigger_irrelevant then
		local exclude_list = {
			self._player.player_unit
		}
		local possible_talkers = BattleChatterHelper.get_close_units(self._world, self._player.player_unit, exclude_list, config.talker_distance)

		if #possible_talkers == 0 then
			return
		end

		local talker, responders = BattleChatterHelper.get_talker_random_enemy(self._player.player_unit, possible_talkers)

		if not talker then
			return
		end

		local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, false)

		self._handler:add_chatter(data)
	end
end

function BattleChatterCollector:event_round_started_response(data)
	if not data.responders or not (#data.responders > 0) then
		return
	end

	if not self._player.player_unit then
		return
	end

	local battle_chatter_name = "round_started_response"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local prev_talker_owner = Managers.player:owner(data.talker)
	local relevant = prev_talker_owner.team == self._player.team
	local talker, responders

	if relevant then
		talker, responders = BattleChatterHelper.get_talker_random_teammate(self._player.player_unit, data.responders)
	else
		talker, responders = BattleChatterHelper.get_talker_random_enemy(self._player.player_unit, data.responders)
	end

	if not talker then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_bc_projectile_hit_afro(victim, attacker)
	local battle_chatter_name = "under_enemy_fire"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, victim.player_unit, config.relevant_distance) then
		return
	end

	local talker = victim.player_unit

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local is_teammate = self._player.team == victim.team
	local relevant = is_teammate and BattleChatterHelper.relevant_distance(self._player.player_unit, talker, 10)
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_player_bandaging(bandager)
	if Managers.player:owner(bandager) == self._player then
		return
	end

	local battle_chatter_name = "bandage"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.cooldown(self._handler:history(bandager), battle_chatter_name) then
		return
	end

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local bandager_owner = Managers.player:owner(bandager)
	local talker = bandager

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, talker, config.relevant_distance) then
		return
	end

	local exclude_list = {
		self._player.player_unit,
		talker
	}
	local units = BattleChatterHelper.get_close_units(self._world, talker, exclude_list, config.relevant_distance)
	local responders = BattleChatterHelper.teammates(talker, units)
	local relevant = self._player.team == bandager_owner.team
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_player_bandaging_response(data)
	if not self._player.player_unit then
		return
	end

	local battle_chatter_name = "bandage_response"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local talker = BattleChatterHelper.get_talker_random(self._player.player_unit, data.responders)

	if not talker then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, data.relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_player_damaged(victim, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)
	if victim.team ~= attacking_player.team or not gear_name or mirrored then
		return
	end

	local network_manager = Managers.state.network

	if network_manager:game() then
		local victim_id = victim:player_id()
		local attacking_player_id = attacking_player:player_id()
		local gear_name_id = NetworkLookup.gear_names[gear_name or "n/a"]
		local hit_zone_id = NetworkLookup.hit_zones[hit_zone or "n/a"]
		local damage_range_type_id = NetworkLookup.damage_range_types[damage_range_type]

		network_manager:send_rpc_clients("rpc_player_friendly_fire", victim_id, attacking_player_id, damage, gear_name_id, hit_zone_id, damage_range_type_id, range, mirrored)
	end

	self:_player_damaged_friendly_fire(victim, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)
end

function BattleChatterCollector:event_player_friendly_fire(victim, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)
	self:_player_damaged_friendly_fire(victim, attacking_player, damage, gear_name, hit_zone, damage_range_type)
end

function BattleChatterCollector:event_player_friendly_fire_response(data)
	local battle_chatter_name

	if data.type == "melee" then
		battle_chatter_name = "friendly_fire_melee_response"
	elseif data.type == "bow" then
		battle_chatter_name = "friendly_fire_bow_response"
	elseif data.type == "throwing" then
		battle_chatter_name = "friendly_fire_throwing_response"
	end

	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local talker = data.responders[1]

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local response_data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, data.relevant)

	self._handler:add_chatter(response_data)
end

function BattleChatterCollector:event_received_help_request(tagger)
	local config = BattleChatters.help_request

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, tagger, config.relevant_distance) then
		return
	end

	local talker = tagger

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, true)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:event_enemy_revive_started_response(data)
	if not data.responders then
		return
	end

	local config = BattleChatters.enemy_revive_started_response

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, data.talker, config.relevant_distance) then
		return
	end

	local talker = BattleChatterHelper.get_talker_closest_teammate(data.talker, data.responders)

	if not talker then
		return
	end

	local response_data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, data.relevant)

	self._handler:add_chatter(response_data)
end

function BattleChatterCollector:_revive_started(reviver_id, revivee_id)
	if reviver_id == revivee_id then
		return
	end

	local battle_chatter_name = "revive_started"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local reviver_unit = Managers.state.network:game_object_unit(reviver_id)
	local revivee_unit = Managers.state.network:game_object_unit(revivee_id)

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, reviver_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.talk_eligible(reviver_unit) then
		return
	end

	local unit = self._player.player_unit
	local relevant = unit == reviver_unit or unit == revivee_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(reviver_unit, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_enemy_revive_started(reviver_id, revivee_id)
	local battle_chatter_name = "enemy_revive_started"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local reviver_unit = Managers.state.network:game_object_unit(reviver_id)
	local revivee_unit = Managers.state.network:game_object_unit(revivee_id)

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, reviver_unit, config.relevant_distance) then
		return
	end

	local exclude_list = {
		self._player.player_unit,
		reviver_unit,
		revivee_unit
	}
	local close_units = BattleChatterHelper.get_close_units(self._world, self._player.player_unit, nil, config.relevant_distance)
	local is_enemy = self._player.team ~= Managers.player:owner(reviver_unit).team
	local talker, responders

	if is_enemy then
		talker, responders = BattleChatterHelper.get_talker_closest_teammate(self._player.player_unit, close_units)
	else
		talker, responders = BattleChatterHelper.get_talker_closest_enemy(self._player.player_unit, close_units)
	end

	if not talker then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, is_enemy)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_cleanup_conditions(attacker_unit)
	local config = BattleChatters.cleanup
	local cleanup_data = Unit.get_data(attacker_unit, "bc_cleanup") or {
		time = 0,
		kills = 0
	}
	local time = Managers.time:time("round")

	if time >= cleanup_data.time then
		cleanup_data.kills = 1
	else
		cleanup_data.kills = cleanup_data.kills + 1
	end

	cleanup_data.time = time + 10

	Unit.set_data(attacker_unit, "bc_cleanup", cleanup_data)

	if cleanup_data.kills >= 2 then
		local enemies = BattleChatterHelper.enemies(attacker_unit, BattleChatterHelper.get_close_units(self._world, attacker_unit, nil, config.relevant_distance))

		if BattleChatterHelper.num_alive(enemies) == 0 then
			return true
		end
	end

	return false
end

function BattleChatterCollector:_player_cleanup(attacker_unit)
	local config = BattleChatters.cleanup

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	local talker = attacker_unit

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local attacker = Managers.player:owner(attacker_unit)
	local relevant = attacker.team == self._player.team or false
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_damaged_friendly_fire(victim, attacker, damage, gear_name, hit_zone, damage_range_type)
	local gear_type = Gear[gear_name].gear_type
	local is_melee = damage_range_type == "melee"
	local is_bow = gear_type == "longbow" or gear_type == "hunting_bow" or gear_type == "short_bow"
	local is_throwing = not is_bow and damage_range_type == "small_projectile"

	if is_melee then
		self:_player_damaged_friendly_fire_melee(victim, attacker)
	elseif is_bow then
		self:_player_damaged_friendly_fire_bow(victim, attacker)
	elseif is_throwing then
		self:_player_damaged_friendly_fire_throwing(victim, attacker)
	end
end

function BattleChatterCollector:_player_damaged_friendly_fire_melee(victim, attacker)
	if self._player == victim then
		return
	end

	local battle_chatter_name = "friendly_fire_melee"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, victim.player_unit, config.relevant_distance) then
		return
	end

	local talker = victim.player_unit

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local relevant = attacker == self._player or victim == self._player or false
	local responders = {
		attacker.player_unit
	}
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	data.type = "melee"

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_damaged_friendly_fire_bow(victim, attacker)
	if self._player == victim then
		return
	end

	local battle_chatter_name = "friendly_fire_bow"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, victim.player_unit, config.relevant_distance) then
		return
	end

	local exclude_list = {
		victim.player_unit,
		attacker.player_unit,
		self._player.player_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker.player_unit, exclude_list, config.relevant_distance)

	if not talker then
		return
	end

	local relevant = attacker == self._player or victim == self._player or false
	local responders = {
		attacker.player_unit
	}
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	data.type = "bow"

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_damaged_friendly_fire_throwing(victim, attacker)
	if self._player == victim then
		return
	end

	local battle_chatter_name = "friendly_fire_throwing"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, victim.player_unit, config.relevant_distance) then
		return
	end

	local talker = victim.player_unit

	if not BattleChatterHelper.talk_eligible(talker) then
		return
	end

	local relevant = attacker == self._player or false
	local responders = {
		attacker.player_unit
	}
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	data.type = "throwing"

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_headshot(victim_unit, attacker_unit, range)
	local battle_chatter_name

	battle_chatter_name = range > 45.72 and "longshot_headshot" or "headshot"

	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local exclude_list = {
		self._player.player_unit,
		attacker_unit,
		victim_unit
	}
	local talker, responders = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		return
	end

	local relevant = attacker_unit == self._player.player_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	data.attacker = Managers.player:owner(attacker_unit)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_instakill(victim_unit, attacker_unit)
	local battle_chatter_name = "instakill"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	if not BattleChatterHelper.relevant_distance(self._player.player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local exclude_list = {
		self._player.player_unit,
		attacker_unit,
		victim_unit
	}
	local talker, responders = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		return
	end

	local relevant = attacker_unit == self._player.player_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	data.attacker = Managers.player:owner(attacker_unit)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_finish_off(victim_unit, attacker_unit)
	local battle_chatter_name = "finishing_blow"
	local config = BattleChatters[battle_chatter_name]

	fassert(config, "No Battle Chatter named %q", battle_chatter_name)

	local local_unit = self._player.player_unit

	if not BattleChatterHelper.relevant_distance(local_unit, attacker_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local exclude_list = {
		local_unit,
		victim_unit,
		attacker_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		if BattleChatterHelper.talk_eligible(attacker_unit) then
			talker = attacker_unit
		else
			return
		end
	end

	local relevant = local_unit == victim_unit or local_unit == attacker_unit or local_unit == talker
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_decap(victim_unit, attacker_unit)
	local battle_chatter_name = "decapitation"
	local config = BattleChatters[battle_chatter_name]
	local player_unit = self._player.player_unit

	if not BattleChatterHelper.relevant_distance(player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local exclude_list = {
		player_unit,
		victim_unit,
		attacker_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		return
	end

	local relevant = player_unit == attacker_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_kill_streak(victim_unit, attacker_unit, kill_streak)
	local battle_chatter_name = "kill_streak_kill"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local player_unit = self._player.player_unit

	if not BattleChatterHelper.relevant_distance(player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	local exclude_list = {
		player_unit,
		victim_unit,
		attacker_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		if BattleChatterHelper.talk_eligible(attacker_unit) then
			talker = attacker_unit
			config.timpani_events = config.player_events
		else
			return
		end
	else
		config.timpani_events = config.teammate_events
	end

	local relevant = player_unit == attacker_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_throwing_kill(victim_unit, attacker_unit)
	local battle_chatter_name = "throwing_kill"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local player_unit = self._player.player_unit

	if not BattleChatterHelper.relevant_distance(player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	local exclude_list = {
		player_unit,
		attacker_unit,
		victim_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		if BattleChatterHelper.talk_eligible(attacker_unit) then
			talker = attacker_unit
			config.timpani_events = config.player_events
		else
			return
		end
	else
		config.timpani_events = config.teammate_events
	end

	local relevant = player_unit == attacker_unit
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_player_killed_first_blood(victim_unit, attacker_unit)
	local battle_chatter_name = "first_blood"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local player_unit = self._player.player_unit

	if not BattleChatterHelper.relevant_distance(player_unit, attacker_unit, config.relevant_distance) then
		return
	end

	local exclude_list = {
		attacker_unit,
		victim_unit,
		player_unit
	}
	local talker = BattleChatterHelper.get_talker(config.talker, self._world, attacker_unit, exclude_list, config.talker_distance)

	if not talker then
		if BattleChatterHelper.talk_eligible(attacker_unit) then
			talker = attacker_unit
		else
			return
		end
	end

	local talker_owner = Managers.player:owner(talker)
	local relevant = self._player.team == talker_owner.team
	local data = BattleChatterHelper.setup_generic_chatter_data(talker, nil, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_teammate_capture_point(capturing_player)
	if not self._player.player_unit then
		return
	end

	local battle_chatter_name = "teammate_capture_point"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local relevant = capturing_player.team == self._player.team
	local talker, responders

	if relevant then
		talker, responders = BattleChatterHelper.get_talker("get_talker_random_teammate", self._world, self._player.player_unit, {
			self._player.player_unit
		}, config.relevant_distance)
	else
		talker, responders = BattleChatterHelper.get_talker("get_talker_random_enemy", self._world, self._player.player_unit, {
			self._player.player_unit
		}, config.relevant_distance)
	end

	if not talker then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:_enemy_capture_point(capturing_player)
	if not self._player.player_unit then
		return
	end

	local battle_chatter_name = "enemy_capture_point"
	local config = BattleChatters[battle_chatter_name]

	if not BattleChatterHelper.trigger(config.trigger_chance) then
		return
	end

	local relevant = capturing_player.team ~= self._player.team
	local talker, responders

	if relevant then
		talker, responders = BattleChatterHelper.get_talker("get_talker_random_teammate", self._world, self._player.player_unit, {
			self._player.player_unit
		}, config.relevant_distance)
	else
		talker, responders = BattleChatterHelper.get_talker("get_talker_random_enemy", self._world, self._player.player_unit, {
			self._player.player_unit
		}, config.relevant_distance)
	end

	if not talker then
		return
	end

	local data = BattleChatterHelper.setup_generic_chatter_data(talker, responders, config, relevant)

	self._handler:add_chatter(data)
end

function BattleChatterCollector:destroy()
	Managers.state.event:unregister("player_parried", self)
	Managers.state.event:unregister("headshot_response", self)
	Managers.state.event:unregister("rush_impact_character", self)
	Managers.state.event:unregister("shield_break", self)
end
