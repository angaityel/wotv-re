-- chunkname: @scripts/unit_extensions/default_player_unit/player_unit_damage.lua

require("scripts/settings/player_unit_damage_settings")
require("scripts/settings/squad_settings")
require("scripts/settings/blood_settings")

PlayerUnitDamage = class(PlayerUnitDamage)
PlayerUnitDamage.SYSTEM = "damage_system"

function PlayerUnitDamage:init(world, unit, player_index)
	self._world = world
	self._unit = unit
	self._damage = 0
	self._knocked_down = false
	self._dead = false
	self._last_stand_active = false
	self._was_last_stand_active = false
	self._last_stand_timer = 0
	self._health = PlayerUnitDamageSettings.MAX_HP
	self._dead_threshold = PlayerUnitDamageSettings.MAX_HP + PlayerUnitDamageSettings.KD_MAX_HP
	self._game_object_id = nil
	self._revived_by = nil
	self._revive_time = 0
	self._bandaged_by = nil
	self._bandage_time = 0
	self._damagers = {}
	self._effect_ids = {}
	self._was_instakilled = false
	self._damage_over_time_sources = table.clone(PlayerUnitDamageSettings.dot_types)
	self.last_stand_camera_effect_active = false
	self.last_stand_camera_shake_effect_id = nil
	self.last_stand_camera_particle_effect_id = nil
	self._heal_over_time_start = nil

	if Managers.lobby.server then
		self:_create_game_object()
		self:setup_health_perks()

		self._is_client = false
	elseif not Managers.lobby.lobby then
		self._is_client = false
	end

	self._revive_yourself_active = false
	self._revive_yourself_time = nil
	self._is_husk = false

	local player_manager = Managers.player
	local player = player_manager:player(player_index)

	player.state_data.health = self._health
	player.state_data.damage = self._damage
	self._player = player
	self._invulnerable = player.spawn_as_invulnerable
	self._last_damager = nil
	self._drawer = Managers.state.debug:drawer()

	self:_setup_hit_zones(PlayerUnitDamageSettings.hit_zones)
	self:_setup_blood_zones(BloodSettings.blood_zones)

	self._hud_debuff_blackboard = {
		last_stand = {
			end_time = 0,
			level = 0
		},
		burning = {
			end_time = 0,
			level = 0
		},
		bleeding = {
			end_time = 0,
			level = 0
		},
		arrow = {
			end_time = 0,
			level = 0
		}
	}
	self._damage_force_synched = true

	Managers.state.event:trigger("debuffs_activated", player, self._hud_debuff_blackboard)
end

function PlayerUnitDamage:was_instakilled()
	return self._was_instakilled
end

function PlayerUnitDamage:_setup_hit_zones(hit_zones)
	local actor_table = {}
	local unit = self._unit

	for zone_name, data in pairs(hit_zones) do
		local hit_zone_table = {
			name = zone_name,
			damage_multiplier = data.damage_multiplier,
			damage_multiplier_ranged = data.damage_multiplier_ranged,
			forward = data.forward
		}

		for _, actor_name in ipairs(data.actors) do
			local actor = Unit.actor(unit, actor_name)

			assert(not actor_table[actor], "Actor exists in multiple hit zones, fix in PlayerUnitDamageSettings.hit_zones")

			actor_table[actor] = hit_zone_table
		end

		actor_table[zone_name] = hit_zone_table
	end

	Unit.set_data(unit, "hit_zone_lookup_table", actor_table)
end

function PlayerUnitDamage:_setup_blood_zones(blood_zones)
	local actor_table = {}
	local unit = self._unit

	for zone_name, data in pairs(blood_zones) do
		for _, actor_name in ipairs(data.actors) do
			local actor = Unit.actor(unit, actor_name)

			assert(not actor_table[actor], "Actor exists in multiple hit zones, fix in BloodSettings.blood_zones")

			actor_table[actor] = data.bit_value
		end
	end

	Unit.set_data(unit, "blood_zones_lookup_table", actor_table)
	Unit.set_data(unit, "wound_settings", 0)
end

function PlayerUnitDamage:_create_game_object()
	local data_table = {
		courage_level = 0,
		burning_end_time = 0,
		burning_level = 0,
		bleeding_end_time = 0,
		bleeding_level = 0,
		arrow_level = 0,
		last_stand_end_time = 0,
		arrow_end_time = 0,
		courage_end_time = 0,
		game_object_created_func = NetworkLookup.game_object_functions.cb_player_damage_extension_game_object_created,
		object_destroy_func = NetworkLookup.game_object_functions.cb_player_damage_extension_game_object_destroyed,
		owner_destroy_func = NetworkLookup.game_object_functions.cb_do_nothing,
		player_unit_game_object_id = Unit.get_data(self._unit, "game_object_id"),
		last_stand_active = self._last_stand_active,
		dead = self._dead,
		health = self._health,
		damage = self._damage
	}
	local callback = callback(self, "cb_game_session_disconnect")

	self._game_object_id = Managers.state.network:create_game_object("player_unit_damage", data_table, callback)
	self._game = Managers.state.network:game()

	local area_buff_ext = ScriptUnit.extension(self._unit, "area_buff_system")

	area_buff_ext:set_game_object_id(self._game_object_id, self._game)
end

function PlayerUnitDamage:cb_game_session_disconnect()
	self._frozen = true

	self:remove_game_object_id()
end

function PlayerUnitDamage:setup_health_perks()
	local locomotion_ext = ScriptUnit.extension(self._unit, "locomotion_system")

	if locomotion_ext:has_perk("heavy_01") then
		self._health = self._health + Perks.heavy_01.health_change_amount
	elseif locomotion_ext:has_perk("light_01") then
		self._health = self._health + Perks.light_01.health_change_amount
	end
end

function PlayerUnitDamage:set_invulnerable(invulnerable)
	self._invulnerable = invulnerable
end

function PlayerUnitDamage:set_game_object_id(game_object_id, game)
	self._game_object_id = game_object_id
	self._game = game
	self._is_client = true
end

function PlayerUnitDamage:remove_game_object_id()
	self._game_object_id = nil
	self._game = nil
	self._is_client = nil
end

function PlayerUnitDamage:network_recieve_add_damage(attacker_player, attacker_unit, damage_type, damage, position, normal, damage_range_type, gear_name, attack_name, hit_zone, impact_direction, real_damage, range, riposte, mirrored)
	if damage_range_type == "melee" and (not Unit.alive(attacker_unit) or not ScriptUnit.has_extension(attacker_unit, "damage_system") or not ScriptUnit.extension(attacker_unit, "damage_system"):is_alive()) then
		return
	end

	local dealt_damage = self:add_damage(attacker_player, attacker_unit, damage_type, damage, position, normal, nil, damage_range_type, gear_name, attack_name, hit_zone, impact_direction, real_damage, range, riposte, mirrored)

	if Managers.lobby.server and attacker_player then
		local player_network_id = attacker_player:network_id()
		local player_id = attacker_player:player_id()

		RPC.rpc_show_damage_number(player_network_id, player_id, NetworkLookup.damage_types[damage_type], math.floor(dealt_damage), position, NetworkLookup.damage_range_types[damage_range_type], NetworkLookup.hit_zones[hit_zone])
	end
end

function PlayerUnitDamage:add_damage(attacking_player, attacking_unit, damage_type, damage, position, normal, actor, damage_range_type, gear_name, attack_name, hit_zone, impact_direction, real_damage, range, riposte, mirrored)
	local own_player = self._player

	Managers.state.event:trigger("player_hit_by_damaging_source", own_player, attacking_player, attack_name)

	if self._executed_by or script_data.disable_damage or self._invulnerable then
		return 0
	end

	if Perks.last_stand.ignore_ranged_damage and self._last_stand_active and damage_range_type == "small_projectile" then
		RPC.rpc_show_perk_combat_text(attacking_player:network_id(), attacking_player:player_id(), NetworkLookup.perks.last_stand, position)

		return 0
	end

	if not self._knocked_down and not self._dead then
		Managers.state.event:trigger("player_damaged", own_player, attacking_player, damage, gear_name, hit_zone, damage_range_type, range, mirrored)

		if Managers.lobby.server and Managers.state.network:game() and own_player.remote then
			local peer = own_player:network_id()
			local player_id = own_player:player_id()
			local attacking_player_id = attacking_player:player_id()

			range = range or 0
			mirrored = mirrored or false

			RPC.rpc_client_player_damaged(peer, player_id, attacking_player_id, damage, NetworkLookup.gear_names[gear_name or "n/a"], NetworkLookup.hit_zones[hit_zone or "n/a"], NetworkLookup.damage_range_types[damage_range_type], range, mirrored)
		end
	end

	local locomotion = ScriptUnit.extension(self._unit, "locomotion_system")
	local remaining_health = self._health - self._damage

	self._damage = self._damage + damage

	if attacking_player and attacking_player ~= own_player then
		self:set_last_damager(attacking_player, gear_name, attack_name, damage)
	end

	if self._revived_by and attacking_player.team ~= self._player.team then
		local id = Unit.get_data(self._unit, "game_object_id")

		self:abort_revive(self._revived_by, id)
	end

	if script_data.damage_debug then
		print("damage:", damage, "real damage:", real_damage, "instakill threshold: ", remaining_health * PlayerUnitDamageSettings.INSTAKILL_HEALTH_FACTOR + PlayerUnitDamageSettings.INSTAKILL_THRESHOLD)
	end

	local squad_instakill = self:_check_squad_instakill()
	local instakill_by_damage = real_damage >= remaining_health * PlayerUnitDamageSettings.INSTAKILL_HEALTH_FACTOR + PlayerUnitDamageSettings.INSTAKILL_THRESHOLD
	local t = Managers.time:time("game")

	if self._damage >= self._health and not self._knocked_down and not self._dead and locomotion:has_perk("last_stand") and not self._last_stand_active and not instakill_by_damage then
		self._last_stand_active = true
		self._damage = self._health - 1

		self:_clear_damage_over_time()

		self._last_stand_timer = Managers.time:time("round") + Perks.last_stand.duration

		self:_set_hud_blackboard_end_time("last_stand", self._last_stand_timer)
		RPC.rpc_show_perk_combat_text(attacking_player:network_id(), attacking_player:player_id(), NetworkLookup.perks.last_stand, position)
	elseif not squad_instakill and not self._knocked_down and not self._dead and self._damage >= self._health and not instakill_by_damage then
		local damager = attacking_player ~= own_player and attacking_player or self._last_damager or own_player

		self:knocked_down(damager, gear_name, attack_name, hit_zone, impact_direction, damage_type, riposte, range, damage_range_type)
		self:_apply_attackers_perk_bonuses(own_player, attacking_player, false)
	elseif not self._knocked_down and not self._dead and self._damage >= self._health and (squad_instakill or SquadSettings.instakill_within_range and instakill_by_damage) then
		local damager = attacking_player ~= own_player and attacking_player or self._last_damager or own_player

		self:die(damager, gear_name, true, damage_type, attack_name, hit_zone, impact_direction, riposte, nil, range, damage_range_type)
		self:_apply_attackers_perk_bonuses_finishoff(own_player, attacking_player)
		Managers.state.event:trigger("player_instakilled", self._player, damager, gear_name, self._damagers, damage_type)

		if attacking_player == own_player or attacking_player.team == own_player.team or not Managers.lobby.lobby then
			-- block empty
		elseif not own_player.remote then
			Managers.state.event:trigger("player_killed_by_enemy", own_player, attacking_player)
			self:_apply_attackers_perk_bonuses(own_player, attacking_player)
		elseif Managers.state.network:game() then
			RPC.rpc_player_killed_by_enemy(own_player:network_id(), own_player:player_id(), attacking_player:player_id())
			self:_apply_attackers_perk_bonuses(own_player, attacking_player)
		end
	elseif not self._knocked_down and not self._dead and self._damage >= self._health then
		local damager = attacking_player ~= own_player and attacking_player or self._last_damager or own_player

		self:knocked_down(damager, gear_name, attack_name, hit_zone, impact_direction, damage_type, riposte, range, damage_range_type)
		self:_apply_attackers_perk_bonuses(own_player, attacking_player)
	elseif not self._dead and self._damage >= self._dead_threshold then
		local damager = attacking_player ~= own_player and attacking_player or self._last_damager or own_player

		self:die(damager, gear_name, squad_instakill or instakill_by_damage, damage_type, attack_name, hit_zone, impact_direction, true, riposte, range, damage_range_type)
		self:_apply_attackers_perk_bonuses_finishoff(own_player, attacking_player)

		if not squad_instakill or damager == own_player or damager.team == own_player.team or not Managers.lobby.lobby then
			-- block empty
		elseif not own_player.remote then
			Managers.state.event:trigger("player_killed_by_enemy", own_player, damager)
			self:_apply_attackers_perk_bonuses(own_player, damager)
		elseif Managers.state.network:game() then
			RPC.rpc_player_killed_by_enemy(own_player:network_id(), own_player:player_id(), damager:player_id())
			self:_apply_attackers_perk_bonuses(own_player, damager)
		end
	end

	if script_data.damage_debug then
		print("[PlayerUnitDamage] add_damage " .. self._damage .. "/" .. self._health)
	end

	return damage
end

function PlayerUnitDamage:set_last_damager(attacking_player, gear_name, attack_name, damage)
	self._last_damager = attacking_player
	self._last_damagers_gear_name = gear_name
	self._last_damagers_attack_name = attack_name
	self._damagers[attacking_player] = (self._damagers[attacking_player] or 0) + damage
end

function PlayerUnitDamage:_apply_attackers_perk_bonuses(own_player, attacking_player)
	local attacker_unit = attacking_player.player_unit
	local attacker_locomotion = Unit.alive(attacker_unit) and ScriptUnit.extension(attacker_unit, "locomotion_system")
	local attacker_damage = Unit.alive(attacker_unit) and ScriptUnit.extension(attacker_unit, "damage_system")

	if not attacker_damage or not attacker_locomotion or own_player == attacking_player or own_player.team == attacking_player.team then
		return
	end

	if attacker_locomotion:has_perk("last_stand") and attacker_damage:is_last_stand_active() then
		attacker_damage:kill_during_last_stand()
	end
end

function PlayerUnitDamage:_apply_attackers_perk_bonuses_finishoff(own_player, attacking_player)
	local attacker_unit = attacking_player.player_unit
	local attacker_locomotion = Unit.alive(attacker_unit) and ScriptUnit.extension(attacker_unit, "locomotion_system")
	local attacker_damage = Unit.alive(attacker_unit) and ScriptUnit.extension(attacker_unit, "damage_system")

	if own_player == attacking_player or own_player.team == attacking_player.team then
		return
	end

	if attacker_damage and attacker_locomotion and attacker_locomotion:has_perk("heal_on_kill") and attacker_damage:is_alive() then
		attacker_damage:blood_thirst_activated()

		local network_manager = Managers.state.network

		if attacking_player.remote then
			if network_manager:game() then
				RPC.rpc_perk_triggered(attacking_player:network_id(), network_manager:game_object_id(attacker_unit), NetworkLookup.perks.heal_on_kill)
			end
		else
			attacker_locomotion:perk_triggered("heal_on_kill")
		end

		if attacker_damage:current_health() < Perks.heal_on_kill.xp_heal_requirement then
			Managers.state.event:trigger("heal_on_kill_trigger_on_low_health", attacking_player)
		end
	end
end

function PlayerUnitDamage:blood_thirst_activated()
	self:add_healing_over_time(Perks.heal_on_kill.duration, Perks.heal_on_kill.health_per_sec)
end

function PlayerUnitDamage:heal_on_taunt_activated()
	local heal_amount = Perks.heal_on_taunt.heal_amount
	local position = Unit.world_position(self._unit, Unit.node(self._unit, "Neck"))

	self:heal(heal_amount, position)
end

function PlayerUnitDamage:blade_master_activated()
	local heal_amount = Perks.blade_master.heal_amount
	local position = Unit.world_position(self._unit, Unit.node(self._unit, "Neck"))

	self:heal(heal_amount, position)
end

function PlayerUnitDamage:heal(healing_amount, position)
	local heal = healing_amount
	local damage_after = self._damage - heal

	if heal == 0 or damage_after < 0 - heal then
		return
	end

	if damage_after < 0 then
		heal = heal - math.abs(damage_after)

		if heal <= 0 then
			return
		end
	end

	if position then
		if Managers.lobby.server then
			Managers.state.network:send_rpc_clients("rpc_show_healing_number", heal, position)
			self:apply_healing(heal)
		else
			local object_id = Unit.get_data(self._unit, "game_object_id")

			Managers.state.network:send_rpc_server("rpc_show_healing_number", heal, position)
			Managers.state.network:send_rpc_server("rpc_add_generic_heal", heal, object_id)
		end

		Managers.state.event:trigger("show_healing_number", heal, position)
	end
end

function PlayerUnitDamage:is_last_stand_active()
	return self._last_stand_active
end

function PlayerUnitDamage:was_last_stand_active()
	return self._was_last_stand_active
end

function PlayerUnitDamage:kill_during_last_stand()
	self:_end_last_stand()

	local unit = self._unit
	local health_back_on_kill = Perks.last_stand.health_back_on_kill
	local position = Unit.world_position(unit, Unit.node(unit, "Neck"))

	self:heal(health_back_on_kill, position)
end

function PlayerUnitDamage:_end_last_stand()
	self._last_stand_active = false

	local timpani_world = World.timpani_world(self._world)

	TimpaniWorld.trigger_event(timpani_world, "Stop_chr_heartbeat_loop")
end

function PlayerUnitDamage:_check_squad_instakill()
	if not GameSettingsDevelopment.squad_first then
		return false
	end

	local squad_index = self._player.squad_index

	if not squad_index then
		return true
	end

	if not SquadSettings.instakill_corporal and self._player.is_corporal then
		return false
	end

	local in_range = self[SquadSettings.range_check](self, squad_index)

	return not in_range
end

function PlayerUnitDamage:_update_in_squad_range()
	local squad_index = self._player.squad_index
	local in_range = squad_index and self._in_range or false

	if squad_index then
		in_range = self[SquadSettings.range_check](self, squad_index)
	end

	if self._in_range ~= in_range then
		self._in_range = in_range
	end
end

function PlayerUnitDamage:in_squad_range()
	return self._in_range
end

function PlayerUnitDamage:squad_members_range_check(squad_index)
	local squad = self._player.team.squads[squad_index]
	local members = squad:members()
	local player_pos = Unit.local_position(self._unit, 0)
	local member_pos

	for player, _ in pairs(members) do
		if Unit.alive(player.player_unit) and player ~= self._player then
			local damage_ext = ScriptUnit.extension(player.player_unit, "damage_system")

			if not damage_ext:is_dead() then
				member_pos = Unit.local_position(player.player_unit, 0)

				local distance = Vector3.length(player_pos - member_pos)

				if distance < SquadSettings.far_range then
					return true
				end
			end
		end
	end

	if SquadSettings.use_flag_in_range_check then
		local squad_flag_unit = squad:squad_flag_unit()

		if squad_flag_unit then
			local flag_pos = Unit.local_position(squad_flag_unit, 0)
			local distance = Vector3.length(player_pos - flag_pos)

			if distance < SquadSettings.far_range then
				return true
			end
		end
	end

	return false
end

function PlayerUnitDamage:corporal_range_check(squad_index)
	local squad = self._player.team.squads[squad_index]
	local members = squad:members()
	local player_pos = Unit.local_position(self._unit, 0)
	local corporal = squad:corporal()
	local corporal_unit = corporal.player_unit

	if Unit.alive(corporal_unit) then
		local damage_ext = ScriptUnit.extension(corporal_unit, "damage_system")

		if not damage_ext:is_dead() then
			local corporal_pos = Unit.local_position(corporal_unit, 0)
			local distance = Vector3.length(player_pos - corporal_pos)

			if distance < SquadSettings.far_range then
				return true
			end
		end
	end

	if SquadSettings.use_flag_in_range_check then
		local squad_flag_unit = squad:squad_flag_unit()

		if squad_flag_unit then
			local flag_pos = Unit.local_position(squad_flag_unit, 0)
			local distance = Vector3.length(player_pos - flag_pos)

			if distance < SquadSettings.far_range then
				return true
			end
		end
	end

	return false
end

function PlayerUnitDamage:network_recieve_add_damage_over_time(attacking_player, damage_type)
	self:add_damage_over_time(attacking_player, damage_type)
end

function PlayerUnitDamage:network_recieve_add_custom_damage_over_time(attacking_player, damage_type, duration, dps)
	self:add_damage_over_time(attacking_player, damage_type, duration, dps)
end

function PlayerUnitDamage:add_damage_over_time(attacking_player, damage_type, duration, dps)
	local locomotion = ScriptUnit.extension(self._unit, "locomotion_system")

	if locomotion:has_perk("oblivious") or script_data.disable_damage then
		return
	end

	local settings = Debuffs[damage_type]
	local dots = self._damage_over_time_sources[damage_type]
	local dot_to_replace
	local duration = duration or settings.duration
	local dps = dps or settings.dps
	local end_time = duration + Managers.time:time("round")
	local own_player = self._player

	if attacking_player and attacking_player ~= own_player then
		self._damagers[attacking_player] = (self._damagers[attacking_player] or 0) + dps
	end

	local dot_applied = false

	for i = 1, settings.max_dot_amount do
		local dot = dots[i]

		if dot then
			dot.end_time = end_time
			dot.applier = attacking_player
			dot.dps = dps
		elseif not dot_applied then
			dot_applied = true

			self:_increment_hud_blackboard_level(damage_type, 1)

			dots[i] = {
				dps = dps,
				end_time = end_time,
				applier = attacking_player
			}
		end
	end

	self:_set_hud_blackboard_end_time(damage_type, end_time)
	Managers.state.event:trigger("player_dotted", self._player, attacking_player, damage_type)
end

function PlayerUnitDamage:add_healing_over_time(duration, health_per_sec)
	self._heal_over_time_start = Managers.time:time("game")
	self._heal_over_time_count = 1
	self._heal_over_time_duration = duration
	self._heal_over_time_heal_per_sec = health_per_sec
end

function PlayerUnitDamage:apply_healing(heal)
	self._damage = math.max(0, self._damage - heal)
end

function PlayerUnitDamage:_update_dot_effects()
	if self._game then
		for dot_name, dot_data in pairs(Debuffs) do
			if dot_data.fx_name then
				local dot_level = GameSession.game_object_field(self._game, self._game_object_id, dot_name .. "_level")

				if dot_level > 0 and not self._effect_ids[dot_name] then
					self:play_dot_effect(dot_name, dot_data.fx_name, dot_data.fx_node)
				elseif dot_level == 0 and self._effect_ids[dot_name] then
					self:stop_dot_effect(dot_name)
				end
			end
		end
	end
end

function PlayerUnitDamage:play_dot_effect(damage_over_time_type, effect_name, node_name)
	if effect_name and node_name then
		if not GameSettingsDevelopment.allow_multiple_dot_effects then
			for dot_name, id in pairs(self._effect_ids) do
				self:stop_dot_effect(dot_name)
			end
		end

		local node = Unit.node(self._unit, node_name)

		self._effect_ids[damage_over_time_type] = ScriptWorld.create_particles_linked(self._world, "fx/fire_dot", self._unit, node, "stop", Matrix4x4.identity())
	end
end

function PlayerUnitDamage:stop_dot_effect(damage_over_time_type)
	local effect_id = self._effect_ids[damage_over_time_type]

	World.stop_spawning_particles(self._world, effect_id)

	self._effect_ids[damage_over_time_type] = nil
end

function PlayerUnitDamage:update(unit, input, dt, context, t)
	local player = self._player

	if player and player.state_data and self._unit == player.player_unit then
		self._player.state_data.damage = self._damage
		self._player.state_data.health = self._health
	end

	self:_update_in_squad_range()
	self:_update_dot_effects()

	if self._is_client then
		self:_update_client_variables(t, dt)
	elseif self._is_client == false then
		self:_update_server_variables(t, dt)
	end

	if self._dead or self._frozen then
		return
	end

	if self._is_client == false then
		self:_server_update(t, dt)
	elseif self._is_client == nil then
		-- block empty
	end

	if self._last_stand_active and not self._was_last_stand_active then
		local locomotion_ext = ScriptUnit.extension(self._unit, "locomotion_system")

		if self._is_husk then
			locomotion_ext:play_voice("chr_vce_taunt_war_cry")
		else
			if locomotion_ext.current_state._play_voice then
				locomotion_ext.current_state:_play_voice("chr_vce_berserk_frenzy")
			end

			if not self._last_stand_sound_id then
				local timpani_world = World.timpani_world(self._world)

				self._last_stand_sound_id = TimpaniWorld.trigger_event(timpani_world, "chr_heartbeat_loop")
			end
		end
	elseif not self._last_stand_active and self._was_last_stand_active and self._last_stand_sound_id then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, "Stop_chr_heartbeat_loop")

		self._last_stand_sound_id = nil
	end

	self._was_last_stand_active = self._last_stand_active
	self._prev_damage = self._damage
end

function PlayerUnitDamage:_update_client_variables(t, dt)
	if self._game and self._game_object_id then
		self._health = GameSession.game_object_field(self._game, self._game_object_id, "health")
		self._damage = GameSession.game_object_field(self._game, self._game_object_id, "damage")
		self._last_stand_active = GameSession.game_object_field(self._game, self._game_object_id, "last_stand_active")

		if not self._is_husk then
			self:_set_debuff_blackboard_fields()
		end
	end
end

function PlayerUnitDamage:_update_server_variables(t, dt)
	if self._game and self._game_object_id then
		local health_constants = NetworkConstants.health
		local force_synch

		if self._damage == 0 then
			force_synch = not self._damage_force_synched
			self._damage_force_synched = true
		else
			self._damage_force_synched = false
			force_synch = false
		end

		GameSession.set_game_object_field(self._game, self._game_object_id, "health", self._health)
		GameSession.set_game_object_field(self._game, self._game_object_id, "damage", math.clamp(self._damage, health_constants.min, health_constants.max), force_synch)
		GameSession.set_game_object_field(self._game, self._game_object_id, "last_stand_active", self._last_stand_active)
	end
end

function PlayerUnitDamage:_server_update(t, dt)
	local locomotion = ScriptUnit.extension(self._unit, "locomotion_system")

	if self:can_heal() then
		self:_update_buff_regeneration(t, dt)
	end

	if self._heal_over_time_start then
		local prev_time = self._heal_over_time_start
		local time_gone = self._heal_over_time_count
		local diff = t - prev_time

		if time_gone < diff then
			local heal_amount = self._heal_over_time_heal_per_sec
			local position = Unit.world_position(self._unit, Unit.node(self._unit, "Neck"))

			self:heal(heal_amount, position)

			self._heal_over_time_count = time_gone + 1

			local duration = self._heal_over_time_duration

			if self._damage < 0 or duration <= time_gone then
				self._heal_over_time_start = nil
				self._heal_over_time_count = nil
			end
		end
	end

	local has_dot_applied = self:_has_damage_over_time_applied()

	if self._last_stand_active and self._last_stand_timer <= Managers.time:time("round") then
		local squad_instakill = self:_check_squad_instakill()

		if squad_instakill then
			self:die(self._last_damager, self._last_damagers_gear_name, self._last_damagers_attack_name, true, "damage_over_time", "torso", Vector3(0, 0, 0))
		else
			self:knocked_down(self._last_damager, self._last_damagers_gear_name, self._last_damagers_attack_name, nil, Vector3(0, 0, 0), "damage_over_time")
		end

		self:_apply_attackers_perk_bonuses(self._player, self._last_damager or self._player)
	end

	if self._knocked_down and self._executed_by then
		if t >= self._execution_time then
			self:die(self._executor_id, "execution", false)
		end
	elseif self._knocked_down and self._revived_by then
		if t >= self._revive_time then
			self:completed_revive()
		end
	elseif self._knocked_down and not self._revived_by and not self._executed_by then
		self._damage = self._damage + PlayerUnitDamageSettings.kd_bleeding.dps * dt

		if self._damage >= self._dead_threshold then
			self:die(self._player, nil, false, "damage_over_time")
		end
	elseif self._bandaged_by then
		if t >= self._bandage_time then
			self:completed_bandage()
		end
	elseif has_dot_applied then
		self._damage = self._damage + self:_calculate_current_dot_damage(t, dt)

		if self._damage >= self._health then
			self:knocked_down(self._last_damager, self._last_damagers_gear_name, self._last_damagers_attack_name, nil, Vector3(0, 0, 0), "damage_over_time")
		end
	end

	if false then
		-- block empty
	end
end

function PlayerUnitDamage:_has_damage_over_time_applied()
	for dot_type, instances in pairs(self._damage_over_time_sources) do
		for _, instance in ipairs(instances) do
			return true
		end
	end
end

function PlayerUnitDamage:_calculate_current_dot_damage(t, dt)
	local t = Managers.time:time("round")
	local total_dps = 0

	for dot_type, instances in pairs(self._damage_over_time_sources) do
		for i = #instances, 1, -1 do
			if t >= instances[i].end_time then
				self:_increment_hud_blackboard_level(dot_type, -1)
				table.remove(instances, i)
			else
				total_dps = total_dps + instances[i].dps
			end
		end
	end

	return total_dps * dt
end

function PlayerUnitDamage:self_knock_down()
	if not self:is_dead() and not self:is_knocked_down() then
		self:knocked_down(self._player, nil, nil, nil, Vector3(0, 0, 0), "kinetic")
	end
end

function PlayerUnitDamage:knocked_down(attacker, gear_name, attack_name, hit_zone, impact_direction, damage_type, riposte, range, damage_range_type)
	if self._last_stand_active then
		self:_end_last_stand()
	end

	if attacker == self._player and self._last_damager then
		attacker = self._last_damager
		gear_name = self._last_damagers_gear_name
		attack_name = self._last_damagers_attack_name
	end

	if not attacker or not attacker:alive() then
		attacker = nil
		gear_name = nil
	end

	local network_manager = Managers.state.network
	local area_buff_ext = ScriptUnit.extension(self._unit, "area_buff_system")

	if Managers.lobby.lobby == nil then
		self:die(attacker, gear_name, false)

		return
	end

	local game = network_manager:game()

	if attacker and game then
		local unit = self._unit
		local locomotion = ScriptUnit.extension(unit, "locomotion_system")
		local id = network_manager:game_object_id(unit)

		if id and game then
			local movement_state_index = GameSession.game_object_field(game, id, "movement_state")
			local movement_state = NetworkLookup.movement_states[movement_state_index]

			if movement_state == "fakedeath" then
				local player_id = attacker:player_id()
				local position = Unit.world_position(unit, Unit.node(unit, "Neck"))

				network_manager:send_rpc_clients("rpc_show_perk_combat_text", player_id, NetworkLookup.perks.fake_death, position)
			end
		end
	end

	self._damage = self._health

	self:player_knocked_down()

	self._heal_over_time_start = nil
	self._heal_over_time_count = nil
	self._heal_over_time_duration = nil
	self._heal_over_time_heal_per_sec = nil

	if game then
		local object_id = Unit.get_data(self._unit, "game_object_id")

		network_manager:send_rpc_clients("rpc_player_knocked_down", object_id, NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction, NetworkLookup.damage_types[damage_type])
		network_manager:update_combat_log(attacker or self._player, self._player, gear_name or "n/a", hit_zone)
	end

	local locomotion = ScriptUnit.extension(self._unit, "locomotion_system")

	locomotion:player_knocked_down(hit_zone, impact_direction, damage_type)

	if attacker and Managers.player:player_exists(attacker.index) then
		local kill_streak = Managers.state.stats_collection:get(self._player:network_id(), "kill_streak")

		Managers.state.event:trigger("player_knocked_down", self._player, attacker, gear_name, self._damagers, damage_type, attack_name, riposte)

		if gear_name and Unit.alive(attacker.player_unit) then
			self:_player_killed(attacker, gear_name, false, false, damage_type, range, hit_zone, true, kill_streak, damage_range_type)
		end
	end
end

function PlayerUnitDamage:can_yield()
	return self._knocked_down and not self._dead and not self._executed_by and not self._revived_by
end

function PlayerUnitDamage:yield()
	self:die(self._player, nil, false, "yield")
end

function PlayerUnitDamage:die(attacker, gear_name, is_instakill, damage_type, attack_name, hit_zone, impact_direction, finish_off, riposte, range, damage_range_type)
	self._was_instakilled = is_instakill

	if self._last_stand_active then
		self:_end_last_stand()
	end

	if attacker == self._player and self._last_damager then
		attacker = self._last_damager
		gear_name = self._last_damagers_gear_name
		attack_name = self._last_damagers_attack_name
	end

	if not attacker or not attacker:alive() then
		attacker = nil
		gear_name = nil
	end

	self:player_dead()

	local network_manager = Managers.state.network

	if network_manager:game() then
		local owner = Managers.player:owner(self._unit)

		Managers.state.trap:remove_player_traps_server(owner)

		local object_id = Unit.get_data(self._unit, "game_object_id")

		network_manager:send_rpc_clients("rpc_player_dead", object_id, is_instakill or false, NetworkLookup.damage_types[damage_type or "kinetic"], NetworkLookup.hit_zones[hit_zone or "n/a"], impact_direction or Vector3(0, 0, 0), finish_off or false)

		if not finish_off and is_instakill then
			network_manager:update_combat_log(attacker or self._player, self._player, gear_name or "n/a", hit_zone)
		end
	end

	self._heal_over_time_start = nil
	self._heal_over_time_count = nil
	self._heal_over_time_duration = nil
	self._heal_over_time_heal_per_sec = nil
	self._revive_yourself_time = nil

	if attacker and Managers.player:player_exists(attacker.index) then
		local kill_streak = Managers.state.stats_collection:get(self._player:network_id(), "kill_streak")

		Managers.state.event:trigger("player_unit_died", self._player, attacker, gear_name, not finish_off and is_instakill, self._damagers, damage_type, attack_name, riposte, range, hit_zone)

		if gear_name and Unit.alive(attacker.player_unit) then
			self:_player_killed(attacker, gear_name, not finish_off and is_instakill, finish_off or false, damage_type, range, hit_zone, false, kill_streak, damage_range_type)
		end
	end

	local locomotion = ScriptUnit.extension(self._unit, "locomotion_system")

	locomotion:player_dead(is_instakill, damage_type, hit_zone, impact_direction, finish_off)
end

function PlayerUnitDamage:_player_killed(attacker, gear_name, instakill, finish_off, damage_type, range, hit_zone, knocked_down, kill_streak, damage_range_type)
	local network_manager = Managers.state.network
	local player_object_id = Unit.get_data(self._unit, "game_object_id")
	local attacker_object_id = Unit.get_data(attacker.player_unit, "game_object_id")
	local gear_name_id = NetworkLookup.gear_names[gear_name]
	local damage_type_id = NetworkLookup.damage_types[damage_type or "n/a"]
	local hit_zone_id = NetworkLookup.hit_zones[hit_zone or "n/a"]
	local damage_range_type_id = NetworkLookup.damage_range_types[damage_range_type or "n/a"]
	local first_kill = BattleChatterHelper.first_kill_of_round(self._unit, attacker.player_unit)

	network_manager:send_rpc_clients("rpc_player_killed", player_object_id, attacker_object_id, gear_name_id, instakill, finish_off, damage_type_id, range or 0, hit_zone_id, knocked_down, kill_streak, damage_range_type_id, first_kill)
	Managers.state.event:trigger("player_killed", self._unit, attacker.player_unit, gear_name, instakill, finish_off, damage_type, range or 0, hit_zone, knocked_down, kill_streak, damage_range_type, first_kill)
end

function PlayerUnitDamage:is_dead()
	return self._dead
end

function PlayerUnitDamage:is_knocked_down()
	return self._knocked_down
end

function PlayerUnitDamage:is_alive()
	return not self._knocked_down and not self._dead
end

function PlayerUnitDamage:is_reviving()
	return self._revive_time and self._revive_time > Managers.time:time("game")
end

function PlayerUnitDamage:destroy()
	if Managers.lobby.server and self._game and self._game_object_id then
		Managers.state.network:destroy_game_object(self._game_object_id)
	end

	WeaponHelper:remove_projectiles(self._unit)
end

function PlayerUnitDamage:player_dead()
	local player = self._player
	local unit = self._unit

	if player.player_unit == unit then
		Managers.state.event:trigger("player_unit_dead", player, Unit.local_position(unit, 0))

		if not Managers.lobby.lobby then
			local level = LevelHelper:current_level(self._world)

			Level.trigger_event(level, "sp_player_died")
		end
	end

	Unit.flow_event(unit, "lua_player_dead")

	if self._last_stand_sound_id then
		local timpani_world = World.timpani_world(self._world)

		TimpaniWorld.trigger_event(timpani_world, "Stop_chr_heartbeat_loop")

		self._last_stand_sound_id = nil
	end

	self._dead = true
end

function PlayerUnitDamage:player_knocked_down()
	Unit.flow_event(self._unit, "lua_player_knocked_down")

	self._knocked_down = true
end

function PlayerUnitDamage:can_be_executed()
	return not self._dead and self._knocked_down and not self._revived_by and not self._executed_by
end

function PlayerUnitDamage:start_execution(executor_id, player_id)
	self._executed_by = executor_id
	self._executor_id = player_id
	self._execution_time = Managers.time:time("game") + PlayerUnitMovementSettings.interaction[1].settings.execute.duration
end

function PlayerUnitDamage:abort_execution(executor_id)
	if self._executed_by == executor_id then
		self._executed_by = nil
		self._executor_id = nil

		return true
	end
end

function PlayerUnitDamage:can_be_team_bandaged()
	return not self._dead and not self._knocked_down and not self._bandaged_by and self._damage > 0
end

function PlayerUnitDamage:can_be_self_bandaged()
	return not self._bandaged_by
end

function PlayerUnitDamage:can_be_revived()
	return not self._dead and self._knocked_down and not self._revived_by and not self._executed_by
end

function PlayerUnitDamage:start_revive(reviver_id, revivee_id, is_reviving_self)
	local t = Managers.time:time("game")

	self._revived_by = reviver_id
	self._revive_time = t + PlayerUnitDamageSettings.REVIVE_TIME
	self._revive_yourself_active = is_reviving_self

	Managers.state.event:trigger("revive_started", reviver_id, revivee_id)

	local locomotion_ext = ScriptUnit.extension(self._unit, "locomotion_system")

	locomotion_ext:rpc_start_revive()

	if Managers.state.network:game() and Managers.lobby.server then
		Managers.state.network:send_rpc_clients("rpc_start_revive_teammate", reviver_id, revivee_id)
	end
end

function PlayerUnitDamage:is_getting_revive_yourself()
	return self._revive_yourself_time and Managers.time:time("game") < self._revive_yourself_time
end

function PlayerUnitDamage:start_bandage(bandager_id, bandagee_id)
	self._bandaged_by = bandager_id

	local interaction_type

	if bandager_id == bandagee_id then
		interaction_type = "bandage_self"
	else
		interaction_type = "bandage"

		local network_manager = Managers.state.network

		if Managers.lobby.lobby then
			local network_id = self._player:network_id()

			RPC.rpc_being_squad_bandaged(network_id, bandager_id)
		end
	end

	self._bandage_time = Managers.time:time("game") + PlayerUnitMovementSettings.interaction[1].settings[interaction_type].duration
end

function PlayerUnitDamage:completed_revive()
	local locomotion_ext = ScriptUnit.extension(self._unit, "locomotion_system")
	local revived_yourself = self._revive_yourself_active

	locomotion_ext:rpc_completed_revive()
	WeaponHelper:remove_projectiles(self._unit)

	if Managers.lobby.server then
		local reviver_unit = Managers.state.network:game_object_unit(self._revived_by)
		local revived_hp = PlayerUnitDamageSettings.REVIVED_HP

		if Unit.alive(reviver_unit) then
			local reviver_locomotion = ScriptUnit.extension(reviver_unit, "locomotion_system")

			revived_hp = reviver_locomotion:has_perk("sterilised_bandages") and self._health or revived_hp

			local reviver_player = Managers.player:owner(reviver_unit)

			Managers.state.stats_collector:player_revived(self._player, reviver_player)
		end

		self._damage = math.max(self._health - revived_hp, 0)

		self:_clear_damagers()
		self:_clear_damage_over_time()

		if revived_yourself and self._game then
			local t = Managers.time:time("game")
			local exp_time = Perks.revive_yourself.time_revived_and_kill_exp_bonus

			self._revive_yourself_time = t + exp_time
			self._revive_yourself_active = false

			Managers.state.network:send_rpc_clients("rpc_completed_revive_yourself", Unit.get_data(self._unit, "game_object_id"))
		elseif self._game then
			Managers.state.network:send_rpc_clients("rpc_completed_revive", Unit.get_data(self._unit, "game_object_id"))
		end
	end

	local reviver_unit = Managers.state.network:game_object_unit(self._revived_by)

	if revived_yourself then
		-- block empty
	else
		Managers.state.event:trigger("revive_completed", reviver_unit, self._unit)
	end

	self._revived_by = nil
	self._knocked_down = false
end

function PlayerUnitDamage:_clear_damagers()
	table.clear(self._damagers)
end

function PlayerUnitDamage:_clear_damage_over_time()
	for damage_type, instances in pairs(self._damage_over_time_sources) do
		table.clear(instances)

		if not self._is_husk then
			local blackboard = self._hud_debuff_blackboard[damage_type]

			blackboard.level = 0
		end

		if self._game then
			GameSession.set_game_object_field(self._game, self._game_object_id, damage_type .. "_level", 0)
		end
	end
end

function PlayerUnitDamage:rpc_bandage_completed_client(bandagee_unit)
	local unit = self._unit
	local locomotion_ext = ScriptUnit.extension(unit, "locomotion_system")

	WeaponHelper:remove_projectiles(unit)

	if self._is_husk then
		Managers.state.event:trigger("show_healing_number", self._health, Unit.world_position(unit, Unit.node(unit, "Neck")))
		locomotion_ext:play_voice("chr_vce_health_boost")
	elseif locomotion_ext.current_state._play_voice then
		locomotion_ext.current_state:_play_voice("chr_vce_health_boost")
	end
end

function PlayerUnitDamage:completed_bandage()
	if Managers.lobby.lobby then
		Managers.state.network:send_rpc_clients("rpc_bandage_completed_client", Unit.get_data(self._unit, "game_object_id"))
	end

	WeaponHelper:remove_projectiles(self._unit)

	local bandager_unit

	if Managers.lobby.lobby then
		bandager_unit = Managers.state.network:game_object_unit(self._bandaged_by)
	else
		bandager_unit = self._bandaged_by
	end

	self._bandaged_by = nil

	local bandaged_hp = PlayerUnitDamageSettings.BANDAGED_HP

	if Unit.alive(bandager_unit) then
		local bandager_player = Managers.player:owner(bandager_unit)

		Managers.state.event:trigger("player_bandaged", self._player, bandager_player)

		local locomotion_ext = ScriptUnit.extension(bandager_unit, "locomotion_system")

		if locomotion_ext:has_perk("sterilised_bandages") then
			self._damage = 0
		else
			self._damage = math.max(0, self._damage - PlayerUnitDamageSettings.BANDAGED_HP)
		end
	else
		self._damage = math.max(0, self._damage - PlayerUnitDamageSettings.BANDAGED_HP)
	end

	if self._last_stand_active then
		self:_end_last_stand()
	end

	self:_clear_damagers()
	self:_clear_damage_over_time()
end

function PlayerUnitDamage:abort_bandage(bandager_id, bandagee_id)
	if self._bandaged_by ~= bandager_id then
		return
	end

	self._bandaged_by = nil
end

function PlayerUnitDamage:abort_revive(reviver_id, revivee_id)
	if self._revived_by ~= reviver_id then
		return
	end

	self._revived_by = nil

	if not self._dead then
		local locomotion_ext = ScriptUnit.extension(self._unit, "locomotion_system")

		locomotion_ext:rpc_abort_revive()

		if Managers.lobby.server and self._game then
			Managers.state.network:send_rpc_clients("rpc_abort_revive_teammate", reviver_id, revivee_id)
		end
	end
end

function PlayerUnitDamage:_set_hud_blackboard_end_time(debuff_type, value)
	if not self._is_husk then
		self._hud_debuff_blackboard[debuff_type].end_time = value
	end

	if self._game then
		GameSession.set_game_object_field(self._game, self._game_object_id, debuff_type .. "_end_time", value)
	end
end

function PlayerUnitDamage:can_heal()
	return not self._last_stand_active and not self._knocked_down
end

function PlayerUnitDamage:_increment_hud_blackboard_level(debuff_type, modifier)
	if not self._is_husk then
		local blackboard = self._hud_debuff_blackboard[debuff_type]

		blackboard.level = blackboard.level + modifier
	end

	local level = GameSession.game_object_field(self._game, self._game_object_id, debuff_type .. "_level") + modifier

	if self._game then
		GameSession.set_game_object_field(self._game, self._game_object_id, debuff_type .. "_level", level)
	end
end

function PlayerUnitDamage:_update_buff_regeneration(t, dt)
	local area_buff_ext = ScriptUnit.extension(self._unit, "area_buff_system")
	local regen_val = area_buff_ext:buff_multiplier("courage") * dt

	self._damage = math.max(0, self._damage - regen_val)
end

function PlayerUnitDamage:_set_debuff_blackboard_fields()
	local blackboard = self._hud_debuff_blackboard

	blackboard.last_stand.level = GameSession.game_object_field(self._game, self._game_object_id, "last_stand_active") and 1 or 0
	blackboard.last_stand.end_time = GameSession.game_object_field(self._game, self._game_object_id, "last_stand_end_time")
	blackboard.bleeding.level = GameSession.game_object_field(self._game, self._game_object_id, "bleeding_level")
	blackboard.bleeding.end_time = GameSession.game_object_field(self._game, self._game_object_id, "bleeding_end_time")
	blackboard.burning.level = GameSession.game_object_field(self._game, self._game_object_id, "burning_level")
	blackboard.burning.end_time = GameSession.game_object_field(self._game, self._game_object_id, "burning_end_time")
	blackboard.arrow.level = GameSession.game_object_field(self._game, self._game_object_id, "arrow_level")
	blackboard.arrow.end_time = GameSession.game_object_field(self._game, self._game_object_id, "arrow_end_time")
end

function PlayerUnitDamage:current_health()
	return self._health - self._damage
end

function PlayerUnitDamage:is_at_full_health()
	return self._damage == 0
end

function PlayerUnitDamage:debuff_blackboard()
	return self._hud_debuff_blackboard
end
