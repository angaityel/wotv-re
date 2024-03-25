-- chunkname: @scripts/unit_extensions/default_player_unit/player_husk_locomotion.lua

require("scripts/unit_extensions/default_player_unit/inventory/player_husk_inventory")
require("scripts/settings/hud_settings")

local MOUNT_LINK_NODE = "CharacterAttach"

PlayerHuskLocomotion = class(PlayerHuskLocomotion)
PlayerHuskLocomotion.SYSTEM = "locomotion_system"

function PlayerHuskLocomotion:init(world, unit, id, game, ghost_mode)
	self._world = world
	self._unit = unit
	self._game = game
	self._id = id

	Unit.set_animation_merge_options(unit)

	self._velocity = Vector3Box(0, 0, 0)
	self._bone_lod = 0

	if script_data.network_debug then
		print("[PlayerHuskLocomotion:init( world, unit, id, game )", world, unit, id, game)
	end

	self._look_direction_anim_var = Unit.animation_find_variable(unit, "aim_direction")
	self._move_speed_anim_var = Unit.animation_find_variable(unit, "move_speed")
	self._move_speed_multiplier_anim_var = Unit.animation_find_variable(unit, "movement_scale")
	self._aim_constraint_anim_var = Unit.animation_find_constraint_target(unit, "aim_constraint_target")
	self._camera_attach_node = Unit.node(unit, "camera_attach")

	local player_index = GameSession.game_object_field(self._game, self._id, "player")
	local player_team_name = NetworkLookup.team[GameSession.game_object_field(self._game, self._id, "team_name")]

	Unit.set_data(unit, "player_index", player_index)
	Managers.player:assign_unit_ownership(unit, player_index, true)

	local team_manager = Managers.state.team
	local team = team_manager:team_by_name(player_team_name)

	for _, team_name in ipairs(team_manager:names()) do
		if not team or team_name == player_team_name then
			local actor = Unit.actor(unit, team_name)

			if actor then
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)
			end
		end
	end

	if team then
		Unit.set_data(unit, "team_name", player_team_name)
	end

	local player = Managers.player:player(player_index)

	self:_setup_inventory(world, unit, player)
	self:_init_internal_variables(unit, player)
	Managers.state.event:trigger("player_spawned", player, unit)

	if ghost_mode then
		self.ghost_mode = true

		self:_enter_ghost_mode()
	else
		self.ghost_mode = false
	end

	if Application.build() == "dev" then
		script_data.husk = unit
		script_data.husk_locomotion = self
	end

	self.player = player
	self._ladder_anim_var = Unit.animation_find_variable(unit, "climb_time")
	self._physics_culled = false
	self._set_coat_of_arms = false

	local level_settings = LevelHelper:current_level_settings()
	local flow_event = level_settings.on_spawn_flow_event

	if flow_event then
		Unit.flow_event(unit, flow_event)
	end

	self.in_combat = GameSession.game_object_field(game, id, "in_combat")
	self._movement_collision_shape_active = true
end

function PlayerHuskLocomotion:IsHusk()
	return true
end

function PlayerHuskLocomotion:_trigger_abort_attack(reason)
	if Managers.lobby.server then
		local network_manager = Managers.state.network
		local player_unit_id = network_manager:unit_game_object_id(self._unit)

		self:abort_attack(reason)
	end

	Unit.animation_event(self._unit, "swing_attack_interrupt")
end

function PlayerHuskLocomotion:abort_attack(reason)
	self:anim_event("swing_attack_interrupt", true)
end

function PlayerHuskLocomotion:anim_event(event, force_local)
	local unit = self._unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	local event_id = NetworkLookup.anims[event]

	if not force_local and self._game and self._id then
		local network_manager = Managers.state.network

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_anim_event", event_id, self._id)
		else
			network_manager:send_rpc_server("rpc_anim_event", event_id, self._id)
		end
	end

	Unit.animation_event(unit, event)
end

function PlayerHuskLocomotion:_anim_event(unit, event)
	Unit.animation_event(unit, event)
end

function PlayerHuskLocomotion:duel_started(enemy_unit)
	return
end

function PlayerHuskLocomotion:duel_confirmed(enemy_unit)
	return
end

function PlayerHuskLocomotion:duel_denied(enemy_unit)
	return
end

function PlayerHuskLocomotion:duel_ended(enemy_unit)
	return
end

function PlayerHuskLocomotion:fake_death_start_time()
	self._fake_death_end_time = Managers.time:time("round") + Perks.fake_death.duration_exp_after_up
end

function PlayerHuskLocomotion:is_getting_fake_death_bonus()
	local time = self._fake_death_end_time
	local time_left = time and time - Managers.time:time("round")

	return time_left ~= nil and time_left > 0
end

function PlayerHuskLocomotion:gear_impact(target_type)
	if target_type == "block" then
		self:play_voice("husk_vce_block")
	end
end

function PlayerHuskLocomotion:gear_hit_by_projectile(projectile_owner)
	if Managers.lobby.server then
		RPC.rpc_gear_hit_by_projectile(self._player:network_id(), self._id, projectile_owner:player_id())
	end
end

function PlayerHuskLocomotion:_enter_ghost_mode()
	self.ghost_mode_hide = true

	local unit = self._unit

	Unit.set_unit_visibility(unit, false)

	for _, actor_name in ipairs(PlayerUnitMovementSettings.ghost_mode.husk_actors) do
		local actor = Unit.actor(unit, actor_name)

		if actor then
			Actor.set_collision_enabled(actor, false)
			Actor.set_scene_query_enabled(actor, false)
		end
	end

	local inventory = self._inventory
	local cloak_unit = inventory:cloak()

	if cloak_unit then
		Unit.set_unit_visibility(cloak_unit, false)
	end

	inventory:enter_ghost_mode()
	Unit.flow_event(unit, "disable_vfx")
end

function PlayerHuskLocomotion:_exit_ghost_mode()
	self.ghost_mode_hide = false

	local unit = self._unit

	Unit.set_unit_visibility(unit, true)

	for _, actor_name in ipairs(PlayerUnitMovementSettings.ghost_mode.husk_actors) do
		local actor = Unit.actor(unit, actor_name)

		if actor then
			Actor.set_collision_enabled(actor, true)
			Actor.set_scene_query_enabled(actor, true)
		end
	end

	local inventory = self._inventory
	local cloak_unit = inventory:cloak()

	if cloak_unit then
		Unit.set_unit_visibility(cloak_unit, true)
	end

	inventory:exit_ghost_mode()
	Unit.flow_event(unit, "enable_vfx")
end

function PlayerHuskLocomotion:set_ladder_unit(ladder_unit)
	self.ladder_unit = ladder_unit
end

function PlayerHuskLocomotion:rpc_add_instakill_push(velocity, mass, hit_zone_name)
	self._instakill_push = {
		velocity = Vector3Box(velocity),
		mass = mass,
		hit_zone_name = hit_zone_name
	}
end

function PlayerHuskLocomotion:_apply_instakill_push(instakill_table)
	local hit_zone = PlayerUnitDamageSettings.hit_zones[instakill_table.hit_zone_name]
	local ragdoll_actor = hit_zone.ragdoll_actor
	local actor = Unit.actor(self._unit, ragdoll_actor)

	Actor.push(actor, instakill_table.velocity:unbox(), instakill_table.mass)
end

function PlayerHuskLocomotion:setup_player_profile()
	local obj_id = self._id
	local inventory = self._inventory
	local unit = self._unit
	local armour_name = NetworkLookup.armours[GameSession.game_object_field(self._game, obj_id, "armour")]
	local head = NetworkLookup.heads[GameSession.game_object_field(self._game, obj_id, "head")]
	local helmet_name = NetworkLookup.helmets[GameSession.game_object_field(self._game, obj_id, "helmet")]
	local cloak_name = NetworkLookup.cloaks[GameSession.game_object_field(self._game, obj_id, "cloak")]
	local cloak_pattern = NetworkLookup.cloak_patterns[GameSession.game_object_field(self._game, obj_id, "cloak_pattern")]
	local pattern_index = GameSession.game_object_field(self._game, obj_id, "armour_pattern")
	local voice = GameSession.game_object_field(self._game, obj_id, "voice")
	local team_name = Unit.get_data(unit, "team_name")
	local archetype = NetworkLookup.archetypes[GameSession.game_object_field(self._game, obj_id, "archetype")]
	local helmet_variation = NetworkLookup.helmet_variations[GameSession.game_object_field(self._game, obj_id, "helmet_variation")]
	local beard_and_color = GameSession.game_object_field(self._game, obj_id, "beard_and_color")
	local beard, beard_color = ProfileHelper:get_beard_and_color(beard_and_color)

	if cloak_pattern == "n/a" then
		cloak_pattern = nil
	end

	inventory:add_armour(armour_name, pattern_index)
	inventory:add_head(head, NetworkLookup.voices[voice], beard, beard_color)
	inventory:add_cloak(cloak_name, cloak_pattern, team_name)
	inventory:add_helmet(helmet_name, team_name, helmet_variation)

	local damage_ext = ScriptUnit.extension(self._unit, "damage_system")

	damage_ext:setup_health_perks()
	Unit.set_data(unit, "assassin", self:has_perk("backstab") and "activated_husk" or "not_activated")
	Unit.set_data(unit, "archetype", archetype)
	self:_setup_perks()
end

function PlayerHuskLocomotion:has_perk(perk_name)
	local obj_id = self._id

	if not obj_id then
		print("[PlayerHuskLocomotion:has_perk] WARNING! husk does not yet have perk game object synchronized! Perk: " .. perk_name)

		return false
	end

	if not GameSession.game_object_exists(self._game, obj_id) then
		print("[PlayerHuskLocomotion:has_perk] WARNING! husk has already destroyed perk game object!")

		return false
	end

	for _, slot in ipairs(PerkSlots) do
		local perk_lookup = GameSession.game_object_field(self._game, obj_id, slot.game_object_field)
		local perk

		if perk_lookup ~= 0 then
			perk = NetworkLookup.perks[perk_lookup]
		end

		if perk and perk == perk_name then
			return true
		end
	end

	return false
end

function PlayerHuskLocomotion:_setup_perks()
	local obj_id = self._id

	if not obj_id then
		print("[PlayerHuskLocomotion:has_perk] WARNING! husk does not yet have perk game object synchronized! Perk: " .. perk_name)

		return false
	end

	self._perks = {}

	for i, slot in ipairs(PerkSlots) do
		local perk_lookup = GameSession.game_object_field(self._game, obj_id, slot.game_object_field)

		if perk_lookup ~= 0 then
			local perk_data = {}
			local perk = NetworkLookup.perks[perk_lookup]

			perk_data.perk_name = perk
			perk_data.state = "default"
			perk_data.timer = 0
			perk_data.slot_name = slot.name
			self._perks[i] = perk_data
		end
	end
end

function PlayerHuskLocomotion:has_perk(perk_name, perks)
	if perks then
		return perks[perk_name] and true or false
	else
		local perk = self:_get_perk(perk_name)

		return perk and true or false
	end
end

function PlayerHuskLocomotion:perk_activation_command(perk_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before retreiving the activation command")

	return "activate_" .. perk.slot_name
end

function PlayerHuskLocomotion:get_perk_state(perk_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	return perk.state
end

function PlayerHuskLocomotion:set_perk_state(perk_name, state_name)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	perk.state = state_name
end

function PlayerHuskLocomotion:set_perk_data(perk_name, key, value)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	perk[key] = value
end

function PlayerHuskLocomotion:get_perk_data(perk_name, key)
	local perk = self:_get_perk(perk_name)

	fassert(perk, "Perk does not exist, are you forgetting a has_perk check before changing the perks state")

	return perk[key]
end

function PlayerHuskLocomotion:_get_perk(perk_name)
	local perks = self._perks

	for i = 1, #perks do
		if perks[i].perk_name == perk_name then
			return perks[i]
		end
	end

	return nil
end

function PlayerHuskLocomotion:_update_ghost_mode_handling()
	local player_manager = Managers.player
	local local_player = player_manager:player_exists(1) and player_manager:player(1)
	local in_ghost_mode = GameSession.game_object_field(self._game, self._id, "ghost_mode")

	self.ghost_mode = in_ghost_mode

	local ghost_mode_hide = in_ghost_mode and (not local_player or local_player.team ~= self.player.team or local_player.spawn_data.state ~= "ghost_mode")

	if not ghost_mode_hide and self.ghost_mode_hide then
		self:_exit_ghost_mode()
	elseif ghost_mode_hide and not self.ghost_mode_hide then
		self:_enter_ghost_mode()
	end
end

function PlayerHuskLocomotion:update(unit, input, dt, context, t)
	Profiler.start("PlayerHuskLocomotion:update")

	local game = self._game
	local id = self._id

	if game and id then
		local movement_state = NetworkLookup.movement_states[GameSession.game_object_field(self._game, self._id, "movement_state")]

		self:update_movement(dt, t, unit, movement_state)
		self:update_aim_target(dt, unit)

		local player_coat_of_arms = self.player.coat_of_arms

		if player_coat_of_arms and not self._set_coat_of_arms then
			local team_name = Unit.get_data(unit, "team_name")

			self._inventory:add_coat_of_arms(player_coat_of_arms, team_name)

			self._set_coat_of_arms = true
		end

		local lean_values = GameSession.game_object_field(game, id, "pose_lean_anim_blend_value")

		self._inventory:update(dt, t)

		if script_data.husk_lean_debug then
			Managers.state.debug_text:output_screen_text(string.format("lean: %.2f height: %.2f ", lean_values.x, lean_values.y), 40, 0, Vector3(255, 255, 255))
		end

		self:_update_ghost_mode_handling()

		if not Managers.lobby.server then
			self:_update_culling(dt)
		end

		self:_update_collision(dt, unit, movement_state)

		self.in_combat = GameSession.game_object_field(game, id, "in_combat")
	end

	Profiler.stop()
end

function PlayerHuskLocomotion:in_travel_mode()
	local game, id = self._game, self._id

	return game and id and GameSession.game_object_field(game, id, "travel_mode") or false
end

function PlayerHuskLocomotion:_update_collision(dt, unit, movement_state)
	if self.ghost_mode then
		return
	end

	local actor = Unit.actor(unit, "husk")

	if not actor then
		self._movement_collision_shape_active = true

		return
	end

	if self._physics_culled then
		return
	end

	local collision_active = self._movement_collision_shape_active

	if collision_active and (movement_state == "dead" or movement_state == "knocked_down") then
		Actor.set_collision_enabled(actor, false)
		Actor.set_scene_query_enabled(actor, false)

		self._movement_collision_shape_active = false
	elseif not collision_active and movement_state ~= "dead" and movement_state ~= "knocked_down" then
		Actor.set_collision_enabled(actor, true)
		Actor.set_scene_query_enabled(actor, true)

		self._movement_collision_shape_active = true
	end
end

function PlayerHuskLocomotion:_update_culling(dt)
	local unit = self._unit
	local position = Unit.world_position(unit, 0)
	local viewport_name = Managers.player:player(1).viewport_name
	local camera_position = Managers.state.camera:camera_position(viewport_name)
	local distance = Vector3.length(position - camera_position)

	if GameSettingsDevelopment.bone_lod_husks then
		self:_update_bone_lod(dt, unit, distance)
	end

	if GameSettingsDevelopment.physics_cull_husks and not self.ghost_mode then
		self:_update_physics_culling(dt, unit, distance)
	end
end

function PlayerHuskLocomotion:_update_bone_lod(dt, unit, distance)
	local bone_lod = self._bone_lod
	local ranged_weapon = self._inventory:wielded_ranged_weapon_slot()

	if bone_lod == 0 and distance > GameSettingsDevelopment.bone_lod_husks.lod_out_range then
		self._bone_lod = ranged_weapon and 1 or 2
	elseif bone_lod > 0 and distance < GameSettingsDevelopment.bone_lod_husks.lod_in_range then
		self._bone_lod = 0
	elseif bone_lod == 2 and ranged_weapon then
		self._bone_lod = 1
	elseif bone_lod == 1 and not ranged_weapon then
		self._bone_lod = 2
	end

	Unit.set_bones_lod(unit, self._bone_lod)

	local head = self._inventory:head()

	if head then
		Unit.set_bones_lod(head, math.clamp(self._bone_lod, 0, 1))
	end
end

function PlayerHuskLocomotion:_update_physics_culling(dt, unit, distance)
	local is_in_ghost_mode = self.ghost_mode_hide

	if not self._physics_culled and (is_in_ghost_mode or distance > GameSettingsDevelopment.physics_cull_husks.cull_range) then
		Unit.flow_event(unit, "lua_disable_hit_detection")
		self._inventory:disable_hit_detection("physics_culling")

		self._physics_culled = true
	elseif self._physics_culled and not is_in_ghost_mode and distance < GameSettingsDevelopment.physics_cull_husks.uncull_range then
		Unit.flow_event(unit, "lua_enable_hit_detection")

		local helmet = self._inventory:helmet()

		if helmet then
			Unit.flow_event(helmet, "lua_enable_hit_detection")
		end

		local damage_ext = ScriptUnit.extension(unit, "damage_system")

		damage_ext:_setup_hit_zones(PlayerUnitDamageSettings.hit_zones)
		self._inventory:enable_hit_detection("physics_culling")

		self._physics_culled = false
	end
end

function PlayerHuskLocomotion:rpc_gear_dropped(unit)
	local inventory = self._inventory
	local slot_name = inventory:find_slot_by_unit(unit)

	inventory:drop_gear(slot_name)
end

function PlayerHuskLocomotion:rpc_gear_dead(unit)
	self:gear_dead(unit)
end

function PlayerHuskLocomotion:gear_dead(unit)
	local inventory = self._inventory
	local slot_name = inventory:find_slot_by_unit(unit)

	inventory:gear_dead(slot_name)
end

local POS_EPSILON = 0.01
local POS_LERP_TIME = 0.1

function PlayerHuskLocomotion:update_movement(dt, t, unit, movement_state)
	local old_pos = Unit.local_position(unit, 0)
	local new_pos = GameSession.game_object_field(self._game, self._id, "position")
	local new_rot = GameSession.game_object_field(self._game, self._id, "rotation")
	local mounted = self._mounted
	local velocity = GameSession.game_object_field(self._game, self._id, "velocity")

	if Vector3.length(velocity) < NetworkConstants.VELOCITY_EPSILON then
		velocity = Vector3(0, 0, 0)
	end

	if not mounted and movement_state ~= "mounted/dismounting" and movement_state ~= "mounted" then
		self:_extrapolation_movement(t, unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	elseif mounted and movement_state == "mounted/dismounting" then
		self:_dismount_movement(unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	elseif not mounted and movement_state == "mounted/dismounting" then
		local last_linked_mount = self._last_linked_mount
		local offset_position

		if Unit.alive(last_linked_mount) then
			local link_node = Unit.node(last_linked_mount, MOUNT_LINK_NODE)

			offset_position = Unit.world_position(last_linked_mount, link_node)
		elseif self._last_linked_mount_pos then
			offset_position = self._last_linked_mount_pos:unbox()
		end

		if offset_position then
			self:_dismount_movement(unit, dt, old_pos, new_pos + offset_position, new_rot, movement_state, mounted, velocity)
		end
	elseif mounted and movement_state == "mounted" then
		self:_mounted_movement(unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	elseif not mounted and movement_state == "mounted" then
		self:_extrapolation_movement(t, unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	end

	self._velocity:store(velocity)

	if not self._mounted then
		self:_update_speed_variable()
	end
end

function PlayerHuskLocomotion:_dismount_movement(unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	local new_dismounting_pos = Vector3.lerp(old_pos, new_pos, dt * 15)

	Unit.set_local_position(unit, 0, new_dismounting_pos)

	self._pos_lerp_time = 0

	Unit.set_data(unit, "last_lerp_position", Unit.world_position(unit, 0))
	Unit.set_data(unit, "last_lerp_position_offset", Vector3(0, 0, 0))
	Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))
end

function PlayerHuskLocomotion:_mounted_movement(unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	self._pos_lerp_time = 0

	Unit.set_data(unit, "last_lerp_position", Unit.world_position(unit, 0))
	Unit.set_data(unit, "last_lerp_position_offset", Vector3(0, 0, 0))
	Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))
end

function PlayerHuskLocomotion:_extrapolation_movement(t, unit, dt, old_pos, new_pos, new_rot, movement_state, mounted, velocity)
	local last_pos = Unit.get_data(unit, "last_lerp_position") or old_pos
	local last_pos_offset = Unit.get_data(unit, "last_lerp_position_offset") or Vector3(0, 0, 0)
	local accumulated_movement = Unit.get_data(unit, "accumulated_movement") or Vector3(0, 0, 0)
	local old_velocity = Unit.get_data(unit, "last_velocity") or Vector3(0, 0, 0)

	self._pos_lerp_time = (self._pos_lerp_time or 0) + dt

	local lerp_t = self._pos_lerp_time / POS_LERP_TIME
	local move_delta = velocity * dt
	local ping_pos_comp = self:_calculate_prediction_offset(velocity)

	accumulated_movement = accumulated_movement + move_delta

	local lerp_pos = Vector3.lerp(last_pos_offset, Vector3(0, 0, 0), math.min(lerp_t, 1))
	local pos = last_pos + accumulated_movement + lerp_pos

	self:_update_ground_adjust(pos, ping_pos_comp)
	Unit.set_data(unit, "accumulated_movement", accumulated_movement)

	self._pos_lerp_time = 0

	Unit.set_data(unit, "last_lerp_position", new_pos)
	Unit.set_data(unit, "last_lerp_position_offset", pos - new_pos)
	Unit.set_data(unit, "accumulated_movement", Vector3(0, 0, 0))
	Unit.set_data(unit, "last_velocity", velocity)
	Unit.set_local_position(unit, 0, pos + ping_pos_comp)

	local old_rot = Unit.local_rotation(unit, 0)

	Unit.set_local_rotation(unit, 0, new_rot)

	local ladder_unit = self.ladder_unit

	if Unit.alive(ladder_unit) then
		local ladder_pos = Unit.world_position(ladder_unit, 0)
		local ladder_rot = Unit.world_rotation(ladder_unit, 0)
		local ladder_dist = Vector3.dot(pos - ladder_pos, Quaternion.up(ladder_rot))
		local ladder_anim_val = ClimbHelper.ladder_anim_val(ladder_dist)

		Unit.animation_set_variable(unit, self._ladder_anim_var, ladder_anim_val)
	end
end

function PlayerHuskLocomotion:_update_ground_adjust(pos, ping_pos_comp)
	if not Unit.alive(self._unit) then
		return
	end

	local rot = Unit.local_rotation(self._unit, 0)
	local dir = Quaternion.forward(rot)
	local from = pos + ping_pos_comp + Vector3(0, 0, 0.6)
	local cb = callback(self, "front_adjust_cb", pos.x, pos.y, pos.z)
	local physics_world = World.physics_world(self._world)
	local raycast = PhysicsWorld.make_raycast(physics_world, cb, "closest", "types", "both", "collision_filter", "charge_check")

	Raycast.cast(raycast, from, dir)

	local dir = -Vector3.up()
	local from = pos + ping_pos_comp + Vector3(0, 0, 1.5)
	local cb = callback(self, "ground_adjust_cb", pos.x, pos.y, pos.z)
	local physics_world = World.physics_world(self._world)
	local raycast = PhysicsWorld.make_raycast(physics_world, cb, "closest", "types", "both", "collision_filter", "charge_check")

	Raycast.cast(raycast, from, dir)
end

function PlayerHuskLocomotion:front_adjust_cb(pos_x, pos_y, pos_z, any_hit, position, distance, normal, actor)
	local unit = self._unit

	if not Unit.alive(unit) then
		return
	end

	self._frontal_distance = distance
end

function PlayerHuskLocomotion:ground_adjust_cb(pos_x, pos_y, pos_z, any_hit, position, distance, normal, actor)
	local unit = self._unit

	if not Unit.alive(unit) then
		return
	end

	self._ground_distance = distance
	self._ground_position_x = pos_x
	self._ground_position_y = pos_y
	self._ground_position_z = pos_z
	self._ground_any_hit = any_hit
end

local PREDICTION_SPEED_LIMIT = 0.85
local TRAVELMODE_SPEED_LIMIT = 1.15
local PLUS_ONE_FRAME_COMP = 0.017
local PLUS_TWO_FRAMES_COMP = 0.034

function PlayerHuskLocomotion:_calculate_prediction_offset(velocity)
	local unit = self._unit

	if not Unit.alive(unit) then
		return
	end

	if self.special_attacking or Vector3.length(velocity) < 0.05 then
		return Vector3(0, 0, 0)
	end

	local last_lerp_position = Unit.get_data(unit, "last_lerp_position") or Vector3(0, 0, 0)
	local distance = self._ground_distance or 0
	local pos_x = self._ground_position_x or 0
	local pos_y = self._ground_position_y or 0
	local pos_z = self._ground_position_z or 0
	local any_hit = self._ground_any_hit
	local latency_husk = 0
	local player_index = GameSession.game_object_field(self._game, self._id, "player")

	latency_husk = Managers.state.network:player_latency(player_index, true) + PLUS_TWO_FRAMES_COMP

	local latency_local = 0

	if not Managers.lobby.server then
		local local_player = Managers.state.network:player_from_peer_id(Network.peer_id())
		local player_index = local_player:player_id()

		latency_local = Managers.state.network:player_latency(player_index, true)
	end

	self._ping = latency_husk + latency_local

	local ping_pos_comp = velocity * self._ping
	local z = ping_pos_comp.z

	ping_pos_comp.z = 0

	local v = Vector3.length(ping_pos_comp)

	ping_pos_comp.z = z

	if v > PREDICTION_SPEED_LIMIT then
		if v > TRAVELMODE_SPEED_LIMIT and self:in_travel_mode() then
			ping_pos_comp = Vector3.normalize(velocity) * TRAVELMODE_SPEED_LIMIT
		else
			ping_pos_comp = Vector3.normalize(velocity) * PREDICTION_SPEED_LIMIT
		end
	end

	ping_pos_comp.z = self._last_ping_z or ping_pos_comp.z

	if any_hit and not self.jumping and not self.climbing then
		local overlap_z = math.min(1.5 - distance, 0.5)

		if overlap_z > -0.1 then
			ping_pos_comp.z = ping_pos_comp.z + overlap_z
			self._last_ping_z = ping_pos_comp.z
		else
			self._last_ping_z = self._last_ping_z or ping_pos_comp.z
			self._last_ping_z = self._last_ping_z / 3
		end
	end

	local comp_length = Vector3.length(ping_pos_comp)
	local frontal_distance = self._frontal_distance or 0

	if frontal_distance < comp_length - 0.1 then
		self._front_colliding = true
	elseif comp_length <= frontal_distance then
		self._front_colliding = false
	end

	if self._front_colliding then
		local dir = Vector3.normalize(ping_pos_comp)

		frontal_distance = math.min(frontal_distance, comp_length)
	end

	return ping_pos_comp
end

function PlayerHuskLocomotion:latency()
	local player_index = GameSession.game_object_field(self._game, self._id, "player")
	local latency = Managers.state.network:player_latency(player_index, true)

	return latency
end

HIGHPINGER_LIMIT = 0.15

function PlayerMovementStateBase:highpinger()
	return self:_player_latency() >= HIGHPINGER_LIMIT
end

local WALK_THRESHOLD = 0.97
local JOG_THRESHOLD = 3.23
local RUN_THRESHOLD = 6.14

function PlayerHuskLocomotion:_update_speed_variable()
	local velocity = self._velocity:unbox()
	local flat_velocity = Vector3(velocity.x, velocity.y, 0)
	local speed = Vector3.length(flat_velocity)
	local unit = self._unit

	Unit.animation_set_variable(unit, self._move_speed_anim_var, math.max(speed, WALK_THRESHOLD))
end

function PlayerHuskLocomotion:_calculate_move_speed_var_from_mps(move_speed)
	local speed_var
	local speed_multiplier = 1

	if move_speed <= WALK_THRESHOLD then
		speed_var = 0
		speed_multiplier = move_speed / WALK_THRESHOLD
	elseif move_speed <= JOG_THRESHOLD then
		speed_var = (move_speed - WALK_THRESHOLD) / (JOG_THRESHOLD - WALK_THRESHOLD)
	elseif move_speed <= RUN_THRESHOLD then
		speed_var = 1 + (move_speed - JOG_THRESHOLD) / (RUN_THRESHOLD - JOG_THRESHOLD)
	else
		speed_var = 3
		speed_multiplier = move_speed / RUN_THRESHOLD
	end

	return speed_var, speed_multiplier
end

function PlayerHuskLocomotion:update_aim_target(dt, unit)
	local aim_target = GameSession.game_object_field(self._game, self._id, "aim_target")
	local from_pos = Unit.world_position(unit, self._camera_attach_node)

	if script_data.lerp_debug or script_data.extrapolation_debug then
		local old_target = Matrix4x4.translation(Unit.animation_get_constraint_target(unit, self._aim_constraint_anim_var))
		local new_target = from_pos + aim_target
		local lerp_aim_target = Vector3.lerp(old_target, new_target, math.min(dt * 20, 1))

		Unit.animation_set_constraint_target(unit, self._aim_constraint_anim_var, new_target)

		local anim_variable = PlayerUnitMovementSettings.block.aim_direction_pitch_function(Vector3.normalize(aim_target).z)

		Unit.animation_set_variable(unit, Unit.animation_find_variable(self._unit, "aim_direction_pitch"), anim_variable)
		self._inventory:set_eye_target(lerp_aim_target)
	else
		Unit.animation_set_constraint_target(unit, self._aim_constraint_anim_var, from_pos + aim_target)
		self._inventory:set_eye_target(from_pos + aim_target)
	end

	local new_rot = GameSession.game_object_field(self._game, self._id, "rotation")
	local fwd_dir = Quaternion.forward(new_rot)

	Vector3.set_z(fwd_dir, 0)
	Vector3.set_z(aim_target, 0)

	local fwd_flat = Vector3.normalize(fwd_dir)
	local aim_dir_flat = Vector3.normalize(aim_target)
	local aim_angle = math.atan2(aim_dir_flat.y, aim_dir_flat.x) - math.atan2(fwd_flat.y, fwd_flat.x)
	local aim_direction = -((aim_angle / math.pi + 1) % 2 - 1) * 2

	Unit.animation_set_variable(unit, self._look_direction_anim_var, aim_direction)
end

function PlayerHuskLocomotion:set_mounted(mounted)
	self._mounted = mounted

	if mounted then
		local mount_node = Unit.node(mounted, MOUNT_LINK_NODE)

		World.link_unit(self._world, self._unit, mounted, mount_node)

		self._last_linked_mount = mounted
		self._last_linked_mount_pos = Vector3Box(Unit.local_position(mounted, mount_node))
	else
		World.unlink_unit(self._world, self._unit)
	end
end

function PlayerHuskLocomotion:mounted()
	return self._mounted ~= nil
end

function PlayerHuskLocomotion:destroy(u, input)
	local unit = self._unit

	if unit == script_data.husk then
		script_data.husk = nil
	end

	if script_data.husk_locomotion == self then
		script_data.husk_locomotion = nil
	end

	local player_manager = Managers.player

	if player_manager:owner(unit) then
		player_manager:relinquish_unit_ownership(unit)
	end

	self._inventory:destroy()
	Managers.state.event:trigger("player_destroyed", unit)

	local flag = self.carried_flag

	if flag and Unit.alive(flag) and ScriptUnit.has_extension(flag, "flag_system") then
		local flag_ext = ScriptUnit.extension(flag, "flag_system")

		flag_ext:drop()
	end
end

function PlayerHuskLocomotion:_setup_inventory(world, unit, player)
	self._inventory = PlayerHuskInventory:new(world, unit, player)
end

function PlayerHuskLocomotion:inventory()
	return self._inventory
end

function PlayerHuskLocomotion:_init_internal_variables(unit, player)
	local rot = Unit.local_rotation(unit, 0)
	local pos = Unit.local_position(unit, 0)
	local t = Managers.time:time("game")

	self.couch_cooldown_time = 0
	self.current_rotation = QuaternionBox()
	self.target_rotation = QuaternionBox()
	self.camera_local_current_rotation = QuaternionBox()
	self.camera_local_target_rotation = QuaternionBox()
	self.double_time_direction = Vector3Box(Quaternion.forward(rot))
	self.move_rot = QuaternionBox(rot)
	self.riposte_time = -math.huge
	self.aim_rotation = QuaternionBox(rot)
	self.old_z = 0
	self.aim_vector = Vector3Box(Quaternion.forward(rot))
	self.velocity = Vector3Box(0, 0, 0)
	self.speed = Vector3Box(0, 0, 0)
	self.target_world_rotation = QuaternionBox(rot)
	self.move_speed = 0
	self.movement_state = nil
	self.accumulated_pose = Vector3Box(Vector3(0, 0, 0))
	self.accumulated_parry_direction = Vector3Box(Vector3(0, 0, 0))
	self.aim_target = Vector3Box(pos + Quaternion.forward(rot) * 3)
	self.look_angle = 0
	self.in_combat = false
	self._in_combat_cd_time = 0
	self.travel_mode = false
	self.backstab_charge_time = 0
	self.slope_check_last_z = -math.huge
	self.on_slope = false
	self.special_attacking = false
	self.dodging = false
	self._perks = {
		{
			slot_name = "perk_1",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_2",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_3",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		},
		{
			slot_name = "perk_4",
			timer = 0,
			hud_icon_updates = 0,
			state = "default"
		}
	}
	self.stamina = {
		value = 1,
		recharging = true,
		recharge_blocked = false,
		state = "normal",
		consecutive_block_impact_time = 0,
		consecutive_block_impacts = 0,
		fail_time = -math.huge,
		recharge_timer = t,
		swing_chain_use_data = {
			multiplier = 1,
			t = 0
		},
		dodge_chain_use_data = {
			multiplier = 1,
			t = 0
		}
	}
	self.perk_fast_pose_charge = {
		faster_melee_charge = {
			can_use = false
		}
	}
	self.perk_fast_aim_charge = {
		faster_bow_charge = {
			can_use = false,
			timer = 0
		}
	}
	self.perk_blade_master = {
		faster_moving = {
			time = 0
		}
	}
	self.dual_wield_config = {}
	self.wielding = false
	self.posing = false
	self.swinging = false
	self.aiming = false
	self.reloading = false
	self.blocking = false
	self.parrying = false
	self.dual_wield_defending = false
	self.dual_wield_attacking = false
	self.dual_wield_combo_last_slot = nil
	self.dual_wield_combo_time = -math.huge
	self.dual_wield_queued_attack_time = -math.huge
	self.dual_wield_queued_slot = nil
	self.dual_wield_queued_attack = nil
	self.block_start_time = 0
	self.pose_time = 0
	self.crouching = false
	self.attempting_parry = false
	self.pose_ready = false
	self.swing_direction = nil
	self.rush_cooldown_time = 0
	self.rush_start_time = 0
	self.double_time_timer = t + PlayerUnitMovementSettings.double_time.timer_time
	self.picking_flag = false
	self.carried_flag = nil
	self.planting_flag = false
	self.current_breathing_state = "normal"
	self.current_sway_settings = nil
	self.sway_camera = {
		pitch_angle = 0,
		previous_angle = 0,
		yaw_angle = 0
	}
	self.breathing_transition_time = 0
	self.hold_breath_timer = 0
	self.freeze = true
	self.ranged_weapon_zoom_value = 1
	self.block_broken = false
	self.tagging = false
	self.tagging_cooldown = 0
	self.tag_start_time = 0
	self.kd_tagging_cooldown = 0
	self.shield_bash_cooldown = 0
	self.push_cooldown = 0
	self.husks_in_proximity = {}
	self.current_aim_target = nil
end

function PlayerHuskLocomotion:anim_cb(callback, unit, param)
	local func = self[callback]

	if func then
		func(self, param)
	end
end

function PlayerHuskLocomotion:anim_cb_hide_wielded_weapons()
	self._inventory:anim_cb_hide_wielded_weapons(true)
end

function PlayerHuskLocomotion:anim_cb_unhide_wielded_weapons()
	self._inventory:anim_cb_hide_wielded_weapons(false)
end

function PlayerHuskLocomotion:player_knocked_down()
	self._inventory:set_kinematic_wielded_gear(false)
end

function PlayerHuskLocomotion:player_collapse()
	return
end

function PlayerHuskLocomotion:player_dead(is_instakill, damage_type, hit_zone, impact_direction, finish_off)
	local inventory = self._inventory
	local allow_armour_decapitation = not inventory._armour_definition.no_decapitation
	local vfx_type

	if allow_armour_decapitation and is_instakill and hit_zone == "head" and (damage_type == "cutting" or damage_type == "slashing") and GameSettingsDevelopment.allow_decapitation and inventory:allow_decapitation() then
		local head_unit = inventory:head()

		if head_unit and Unit.alive(head_unit) then
			Unit.set_visibility(head_unit, "head_all", false)
			Unit.set_visibility(head_unit, "head_decap", true)

			local armour_unit = self._inventory:armour_unit()
			local actor = Unit.create_actor(self._unit, "decap_head", 0.9)

			Unit.set_visibility(armour_unit, "undecapitated", false)
			Unit.set_visibility(armour_unit, "decapitated", true)

			local impulse = impact_direction * 2

			Actor.add_impulse_at(actor, impulse, Vector3(0, 0, -0.1))
			Actor.add_impulse_at(actor, Vector3(0, 0, 6), Vector3(0, 0, -0.1))
		end

		vfx_type = "decap"
	else
		vfx_type = "default"
	end

	local vfx_settings = PlayerUnitDamageSettings.death_vfx[vfx_type]

	for _, settings in ipairs(vfx_settings) do
		ScriptWorld.create_particles_linked(self._world, settings.name, self._unit, Unit.node(self._unit, settings.node), "stop")
	end
end

function PlayerHuskLocomotion:rpc_start_revive()
	return
end

function PlayerHuskLocomotion:rpc_abort_revive()
	return
end

function PlayerHuskLocomotion:rpc_completed_revive()
	self._inventory:set_kinematic_wielded_gear(true)
end

function PlayerHuskLocomotion:rpc_completed_revive_yourself()
	self._inventory:set_kinematic_wielded_gear(true)
end

function PlayerHuskLocomotion:rpc_raise_parry_block(slot_name, direction, delay)
	self.block_slot_name = slot_name
	self.block_unit = self._inventory:gear_unit(slot_name)

	if not self.block_unit then
		return
	end

	self.block_direction = direction

	local t = Managers.time:time("game")

	self.block_start_time = t
	self.block_raised_time = t + delay
	self.parrying = true

	Unit.animation_event(self._unit, "parry_pose_" .. direction)
end

function PlayerHuskLocomotion:rpc_lower_parry_block()
	self.block_slot_name = nil
	self.block_unit = nil
	self.block_direction = nil
	self.parrying = false

	Unit.animation_event(self._unit, "parry_pose_exit")
end

function PlayerHuskLocomotion:rpc_hot_join_synch_parry_block(slot_name, direction)
	self.block_slot_name = slot_name
	self.block_unit = self._inventory:gear_unit(slot_name)
	self.block_direction = direction
	self.block_raised_time = 0
	self.parrying = true
end

function PlayerHuskLocomotion:rpc_raise_shield_block(slot_name)
	self.block_slot_name = slot_name
	self.block_unit = self._inventory:gear_unit(slot_name)
	self.blocking = true

	Unit.animation_event(self._unit, "shield_up")
end

function PlayerHuskLocomotion:rpc_raise_dual_wield_block(slot_name, delay)
	self.block_slot_name = slot_name
	self.block_unit = self._inventory:gear_unit(slot_name)

	local t = Managers.time:time("game")

	self.block_start_time = t
	self.block_raised_time = t + delay
	self.dual_wield_defending = true

	Unit.animation_event(self._unit, "parry_pose")
end

function PlayerHuskLocomotion:rpc_lower_dual_wield_block()
	self.block_slot_name = nil
	self.block_unit = nil
	self.dual_wield_defending = false

	Unit.animation_event(self._unit, "parry_pose_exit")
end

function PlayerHuskLocomotion:rpc_lower_shield_block(play_animation)
	self.block_slot_name = nil
	self.block_unit = nil
	self.blocking = false

	if play_animation then
		Unit.animation_event(self._unit, "shield_down")
	end
end

function PlayerHuskLocomotion:rpc_hot_join_synch_shield_block(slot_name)
	self.block_slot_name = slot_name
	self.block_unit = self._inventory:gear_unit(slot_name)
	self.block_raised_time = 0
	self.blocking = true
end

function PlayerHuskLocomotion:rpc_pose_melee_weapon(direction)
	self.pose_direction = direction
	self.posing = true
end

function PlayerHuskLocomotion:rpc_stop_posing_melee_weapon()
	self.pose_direction = nil
	self.posing = false
end

function PlayerHuskLocomotion:rpc_hot_join_synch_pose(direction)
	self.pose_direction = direction
	self.posing = true
end

function PlayerHuskLocomotion:get_velocity()
	if self._mounted then
		local mount_locomotion = ScriptUnit.extension(self._mounted, "locomotion_system")

		return mount_locomotion:get_velocity()
	else
		return self._velocity:unbox()
	end
end

function PlayerHuskLocomotion:rpc_flag_pickup_confirmed(flag_unit)
	self.carried_flag = flag_unit
end

function PlayerHuskLocomotion:rpc_flag_plant_complete(flag_unit)
	assert(self.carried_flag == flag_unit, "Trying to plant flag not carried.")

	self.carried_flag = nil
end

function PlayerHuskLocomotion:rpc_drop_flag(flag_unit)
	self.carried_flag = nil

	local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

	flag_ext:drop()
end

function PlayerHuskLocomotion:rpc_animation_event(event)
	self.last_anim_event = event
	self.jumping = string.find(event, "jump")
	self.climbing = string.find(event, "climb")
	self.special_attacking = string.find(event, "special")

	Unit.animation_event(self._unit, event)
end

function PlayerHuskLocomotion:rpc_animation_set_variable(index, variable)
	Unit.animation_set_variable(self._unit, index, variable)
end

function PlayerHuskLocomotion:hot_join_synch(sender, player)
	local network_manager = Managers.state.network
	local player_object_id = self._id
	local unit = self._unit

	RPC.rpc_synch_player_anim_state(sender, player_object_id, Unit.animation_get_state(unit))

	if self._mounted then
		local mount_object_id = network_manager:unit_game_object_id(self._mounted)

		RPC.rpc_mounted_husk(sender, player_object_id, mount_object_id, Unit.get_data(unit, "player_index"))
	end

	if self.parrying then
		RPC.rpc_hot_join_synch_parry_block(sender, player_object_id, NetworkLookup.inventory_slots[self.block_slot_name], NetworkLookup.directions[self.block_direction])
	end

	if self.blocking then
		RPC.rpc_hot_join_synch_shield_block(sender, player_object_id, NetworkLookup.inventory_slots[self.block_slot_name])
	end

	if self.carried_flag then
		RPC.rpc_flag_pickup_confirmed(sender, player_object_id, network_manager:game_object_id(self.carried_flag))
	end

	if self.posing then
		RPC.rpc_hot_join_synch_pose(sender, player_object_id, NetworkLookup.directions[self.pose_direction])
	end

	local ladder_unit = self.ladder_unit

	if Unit.alive(ladder_unit) then
		local ladder_lvl_id = network_manager:level_object_id(ladder_unit)

		RPC.rpc_climb_ladder(sender, player_object_id, ladder_lvl_id)
	end

	self._inventory:hot_join_synch(sender, player, player_object_id)
end

function PlayerHuskLocomotion:stun()
	local timpani_world = World.timpani_world(self._world)
	local unit = self._unit

	TimpaniWorld.trigger_event(timpani_world, "stunned_husk", unit, Unit.node(unit, "Head"))

	local id = TimpaniWorld.trigger_event(timpani_world, "stunned_husk_vce", unit, Unit.node(unit, "Head"))
	local voice = self._inventory:voice()

	TimpaniWorld.set_parameter(timpani_world, id, "character_vo", voice)
end

function PlayerHuskLocomotion:play_voice(sound_event)
	local timpani_world = World.timpani_world(self._world)
	local unit = self._unit
	local id = TimpaniWorld.trigger_event(timpani_world, sound_event, unit, Unit.node(unit, "Head"))
	local voice = self._inventory:voice()

	TimpaniWorld.set_parameter(timpani_world, id, "character_vo", voice)

	local chr_state_id = GameSession.game_object_field(self._game, self._id, "stamina_state")
	local chr_state = NetworkLookup.stamina_state[chr_state_id]

	TimpaniWorld.set_parameter(timpani_world, id, "chr_state", chr_state)
end

function PlayerHuskLocomotion:received_damage()
	return
end

function PlayerHuskLocomotion:damage_interrupt(hit_zone, impact_direction, impact_type)
	WeaponHelper:player_unit_hit_reaction_animation(self._unit, hit_zone, impact_direction, self:aim_direction(), impact_type)
end

function PlayerHuskLocomotion:aim_direction()
	return GameSession.game_object_field(self._game, self._id, "aim_target")
end

function PlayerHuskLocomotion:is_dodging()
	return NetworkLookup.movement_states[GameSession.game_object_field(self._game, self._id, "movement_state")] == "dodging"
end

function PlayerHuskLocomotion:_attachment_node_linking(source_unit, target_unit, linking_setup)
	for i, attachment_nodes in ipairs(linking_setup) do
		local source_node = attachment_nodes.source
		local target_node = attachment_nodes.target
		local source_node_index = type(source_node) == "string" and Unit.node(source_unit, source_node) or source_node
		local target_node_index = type(target_node) == "string" and Unit.node(target_unit, target_node) or target_node

		World.link_unit(self._world, target_unit, target_node_index, source_unit, source_node_index)
	end
end

function PlayerHuskLocomotion:abort_execution_victim()
	ExecutionHelper.play_execution_abort_anim(self._unit)
end

function PlayerHuskLocomotion:start_execution_victim(execution_definition, attacker_unit)
	ExecutionHelper.play_execution_victim_anims(self._unit, attacker_unit, execution_definition)
end

function PlayerHuskLocomotion:start_execution_attacker(execution_definition, victim_unit)
	ExecutionHelper.play_execution_attacker_anims(self._unit, victim_unit, execution_definition)
end

function PlayerHuskLocomotion:hurt_sound_event()
	return "husk_vce_hurt"
end

function PlayerHuskLocomotion:post_update(dt)
	local push = self._instakill_push

	if push then
		self:_apply_instakill_push(push)

		self._instakill_push = nil
	end
end

function PlayerHuskLocomotion:blade_master_got_parried()
	return
end
