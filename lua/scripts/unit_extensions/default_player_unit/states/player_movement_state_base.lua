-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_movement_state_base.lua

require("scripts/settings/player_effect_settings")
require("scripts/settings/player_action_settings")
require("scripts/settings/sp_tutorial_settings")
require("scripts/helpers/area_buff_helper")
require("scripts/settings/squad_settings")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_tagging_component")

PlayerMovementStateBase = class(PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.2
local PARRY_ATTEMPT_THRESHOLD = 0.003
local POSE_ATTEMPT_THRESHOLD = 0.003

ROTATION_LERP_FACTOR = 10
ROTATION_ANIM_LERP_FACTOR = 5

function PlayerMovementStateBase:init(unit, internal)
	self._unit = unit
	self._internal = internal
	self._aim_constraint_anim_var = Unit.animation_find_constraint_target(unit, "aim_constraint_target")
	self._look_direction_anim_var = Unit.animation_find_variable(unit, "aim_direction")
	self._parry_penalty_speed_anim_var = Unit.animation_find_variable(unit, "weapon_penetration")
	self._ranged_weapon_reload_functions = {
		bow = self._start_reloading_bow,
		crossbow = self._start_reloading_crossbow,
		handgonne = self._start_reloading_handgonne
	}
	self._voice_node = Unit.node(unit, "Head")

	self:_create_tagging_component(unit, internal)
	Managers.state.event:register(self, "awarded_rank", "event_awarded_rank")

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self, 10, math.pi * 2)
end

function PlayerMovementStateBase:event_awarded_rank()
	local internal = self._internal
	local unit = self._unit

	if Unit.alive(unit) then
		local world = internal.world

		ScriptWorld.create_particles_linked(world, "fx/player_level_up", unit, 0, "destroy")

		local timpani_world = World.timpani_world(world)
		local event_id = TimpaniWorld.trigger_event(timpani_world, "hud_level_up")
	end
end

function PlayerMovementStateBase:_create_tagging_component(unit, internal)
	self._tagging_component = PlayerStateTaggingComponent:new(unit, internal, self)
end

function PlayerMovementStateBase:flow_cb_footstep(foot)
	local travel_mode = self._internal.travel_mode
	local t = Managers.time:time("game")

	if travel_mode then
		local camera_manager = Managers.state.camera
		local travel_time = t - travel_mode.start_time

		for _, settings in ipairs(PlayerUnitMovementSettings.travel_mode.camera_shake) do
			if travel_time > settings.time then
				camera_manager:camera_effect_sequence_event(settings.shake .. foot, t)

				break
			end
		end
	end
end

function PlayerMovementStateBase:update(dt, t)
	self:_update_stamina(dt, t)

	self._controller = self._internal.controller

	self:_update_delayed_local_action(dt, t)
	self:_update_standing_on_other_player(dt, t)
	self:update_look_angle(dt)
	self:update_parry_helper()
	self:update_call_horse_decals(dt, t)
	self:update_last_stand_camera_effect(dt, t)
	self:update_switch_weapon_grip(dt, t)
	self:_update_tagging(dt, t)
end

function PlayerMovementStateBase:_update_delayed_local_action(dt, t)
	if not self._delayed_callback then
		return
	end

	if t < self._delayed_callback.start_time then
		return
	end

	if t > self._delayed_callback.start_time + 1 then
		self._delayed_callback = nil

		return
	end

	self:_perform_delayed_local_action(t)
end

function PlayerMovementStateBase:_perform_delayed_local_action(t)
	self._delayed_callback.callback(self, t, self._delayed_callback)

	self._delayed_callback = nil
end

function PlayerMovementStateBase:_set_delayed_local_callback(callback, paramlist)
	local t = Managers.time:time("game")
	local start_time = t + self:_player_latency()

	paramlist.start_time = start_time
	paramlist.callback = callback
	self._delayed_callback = paramlist
end

function PlayerMovementStateBase:_update_standing_on_other_player(dt, t)
	local mover = Unit.mover(self._unit)
	local internal = self._internal

	if internal.ghost_mode then
		return
	end

	local actor = Mover.actor_colliding_down(mover)

	if actor == nil then
		return
	end

	local player_unit = Actor.unit(actor)
	local player_index = Unit.get_data(player_unit, "player_index")

	if player_index == nil then
		return
	end

	local player_manager = Managers.player
	local player = player_manager:player_exists(player_index) and player_manager:player(player_index)

	if player == nil then
		return
	end

	local network_manager = Managers.state.network

	if not network_manager:game() then
		return
	end

	local object_id = network_manager:game_object_id(player_unit)
	local movement_state_index = GameSession.game_object_field(network_manager:game(), object_id, "movement_state")
	local num_movement_states = #NetworkLookup.movement_states

	if movement_state_index > 0 and movement_state_index <= num_movement_states then
		local state = NetworkLookup.movement_states[movement_state_index]

		if state ~= "collapse" and state ~= "dead" and state ~= "knocked_down" and state ~= "fakedeath" and state ~= "climbing" then
			local unit_pos = Unit.world_position(self._unit, 0)
			local player_pos = Unit.world_position(player_unit, 0)

			if unit_pos.z - player_pos.z > 0.9 then
				local state = self._internal.current_state_name

				if state ~= "collapse" and state ~= "dead" and state ~= "knocked_down" and state ~= "fakedeath" and state ~= "climbing" then
					network_manager:send_rpc_server("rpc_player_collapse", object_id)
					self:change_state("collapse")
				end
			end
		end
	end
end

function PlayerMovementStateBase:_update_stamina(dt, t)
	local stamina = self._internal.stamina
	local settings = stamina.settings
	local internal = self._internal
	local travel_mode_recharge_rate = PlayerUnitMovementSettings.travel_mode.override_recharge_rate

	travel_mode_recharge_rate = internal:has_perk("light_02") and Perks.light_02.travel_mode_stamina_recharge_rate_multiplier * travel_mode_recharge_rate or travel_mode_recharge_rate

	local recharge_rate = internal.blocking and PlayerUnitMovementSettings.block.override_recharge_rate or internal.parrying and PlayerUnitMovementSettings.parry.override_recharge_rate or internal.travel_mode and travel_mode_recharge_rate or settings.recharge_rate

	recharge_rate = internal:has_perk("heavy_01") and Perks.heavy_01.stamina_recharge_multiplier * recharge_rate or recharge_rate

	if stamina.recharge_blocked then
		stamina.recharge_timer = t + stamina.recharge_delay
	elseif stamina.recharging then
		stamina.value = math.clamp(stamina.value + recharge_rate * dt, 0, 1)
	else
		local recharge_time = t - stamina.recharge_timer

		if recharge_time > 0 then
			stamina.recharging = true
			stamina.value = math.clamp(stamina.value + recharge_rate * recharge_time, 0, 1)
		end
	end

	local timpani_world = World.timpani_world(internal.world)

	if stamina.state ~= "tired" and stamina.value < settings.tired_threshold then
		stamina.state = "tired"

		if internal.id and internal.game then
			GameSession.set_game_object_field(internal.game, internal.id, "stamina_state", NetworkLookup.stamina_state.tired)
		end
	elseif stamina.state ~= "normal" and stamina.value >= settings.tired_threshold then
		stamina.state = "normal"

		if internal.id and internal.game then
			GameSession.set_game_object_field(internal.game, internal.id, "stamina_state", NetworkLookup.stamina_state.normal)
		end
	end

	if not stamina.exhausted_threshold and stamina.value < settings.exhausted_threshold then
		stamina.exhausted_threshold = true

		TimpaniWorld.trigger_event(timpani_world, "chr_vce_tired_loop")
		Unit.set_flow_variable(self._unit, "lua_tired", true)
	elseif stamina.exhausted_threshold and stamina.value > settings.exhausted_threshold then
		stamina.exhausted_threshold = false

		TimpaniWorld.trigger_event(timpani_world, "stop_chr_vce_tired_loop")
		Unit.set_flow_variable(self._unit, "lua_tired", false)
	end
end

function PlayerMovementStateBase:stamina_can_activate(t, stamina_settings, no_sound, chain_use_data_table)
	local internal = self._internal
	local stamina_data = internal.stamina

	if internal:has_perk("endless_stamina") then
		return true
	end

	local minimum_cost

	if chain_use_data_table then
		local activation_multiplier = stamina_settings.chain_use:cost_multiplier_function(chain_use_data_table, t)

		minimum_cost = stamina_settings.minimum_activation_cost * activation_multiplier
	else
		minimum_cost = stamina_settings.minimum_activation_cost
	end

	if minimum_cost <= stamina_data.value then
		return true
	else
		if not no_sound then
			local timpani_world = World.timpani_world(self._internal.world)

			TimpaniWorld.trigger_event(timpani_world, "hud_low_stamina")
		end

		stamina_data.fail_time = t
		stamina_data.denied_activation = math.min(minimum_cost, 1)

		return false
	end
end

function PlayerMovementStateBase:stamina_activate(stamina_settings, chain_use_data_table)
	local internal = self._internal

	if internal.ghost_mode then
		return
	end

	local t = Managers.time:time("game")
	local activation_cost, minimum_cost

	if chain_use_data_table then
		local activation_multiplier = stamina_settings.chain_use:cost_multiplier_function(chain_use_data_table, t)

		stamina_settings.chain_use:update_multiplier_function(chain_use_data_table, t, activation_multiplier)

		activation_cost = activation_multiplier * stamina_settings.activation_cost
		minimum_cost = activation_multiplier * stamina_settings.minimum_activation_cost
	else
		activation_cost = stamina_settings.activation_cost
		minimum_cost = stamina_settings.minimum_activation_cost
	end

	local stamina = internal.stamina

	if internal:has_perk("endless_stamina") then
		local diff = (minimum_cost or activation_cost) - stamina.value

		if diff > 0 then
			self:_deal_endless_stamina_damage(diff)
		end
	end

	stamina.value = math.max(stamina.value - activation_cost, 0)
	stamina.recharging = false
	stamina.recharge_timer = math.max(t + (stamina_settings.recharge_delay or stamina.settings.recharge_delay), stamina.recharge_timer)

	return stamina.value
end

function PlayerMovementStateBase:_deal_endless_stamina_damage(diff)
	local network_manager = Managers.state.network
	local internal = self._internal
	local damage = diff * Perks.endless_stamina.damage_per_stamina

	internal:set_perk_state("endless_stamina", "active")

	if network_manager:game() then
		network_manager:send_rpc_server("rpc_add_damage", internal.player:player_id(), internal.id, internal.id, NetworkLookup.damage_types.endless_stamina, damage, Vector3(0, 0, 0), -Vector3.up(), NetworkLookup.damage_range_types.melee, NetworkLookup.gear_names["n/a"], NetworkLookup.weapon_hit_parameters["nil"], NetworkLookup.hit_zones["n/a"], -Vector3.up(), damage, 0, false)
	end
end

function PlayerMovementStateBase:post_update(dt, t)
	self:update_camera(dt, t)
	self:update_look_anim_var(dt)
	self:update_aim_target(dt, t)

	local internal = self._internal

	if script_data.player_debug then
		local unit = self._unit
		local mover = Unit.mover(unit)
		local pos = Mover.position(mover)

		internal.debug_drawer:sphere(pos, 0.02, Color(internal.debug_color, 0, 255 - internal.debug_color))

		internal.debug_color = (internal.debug_color + 255 * dt) % 256
	end

	if internal.id and internal.game then
		local velocity = internal.velocity:unbox()
		local velocity_min = NetworkConstants.velocity.min
		local velocity_max = NetworkConstants.velocity.max

		if script_data.slow_motion or not GameSettingsDevelopment.dev_build then
			velocity = Vector3.clamp(velocity, velocity_min, velocity_max)
		else
			local velocity_x = velocity.x
			local velocity_y = velocity.y
			local velocity_z = velocity.z

			fassert(velocity_min < velocity_x and velocity_x < velocity_max and velocity_min < velocity_y and velocity_y < velocity_max and velocity_min < velocity_z and velocity_z < velocity_max, "Player velocity overflow while in state %s", internal.current_state_name)
		end

		GameSession.set_game_object_field(internal.game, internal.id, "velocity", velocity)
	end
end

function PlayerMovementStateBase:enter(old_state)
	return
end

function PlayerMovementStateBase:exit(new_state)
	if new_state == "dead" then
		local player = self._internal.player

		Managers.state.event:trigger("event_handgonne_reload_deactivated", player)
		Managers.state.event:trigger("event_lance_recharge_deactivated", player)
		Managers.state.event:trigger("event_parry_helper_deactivated", player)
		Managers.state.event:trigger("buffs_deactivated", player)
		Managers.state.event:trigger("event_pose_charge_deactivated", player)
		self:safe_action_interrupt("dead")
	end
end

function PlayerMovementStateBase:destroy()
	return
end

function PlayerMovementStateBase:change_state(new_state, ...)
	local internal = self._internal

	self:exit(new_state)

	internal.current_state = internal._states[new_state]

	if script_data.state_debug then
		print("Transition: ", internal.current_state_name, " -> ", new_state)
	end

	fassert(internal.current_state, "[PlayerMovementStateBase:change_state] Trying to switch to non-existing state '%s'", new_state)

	if internal.game and internal.id then
		GameSession.set_game_object_field(internal.game, internal.id, "movement_state", NetworkLookup.movement_states[new_state])
	else
		internal.movement_state = new_state
	end

	local old_state = internal.current_state_name

	internal.current_state_name = new_state

	internal.current_state:enter(old_state, ...)
end

function PlayerMovementStateBase:set_local_position(new_pos)
	local internal = self._internal

	Unit.set_local_position(self._unit, 0, new_pos)

	if internal.game and internal.id and Vector3.length(new_pos) < 1000 then
		GameSession.set_game_object_field(internal.game, internal.id, "position", new_pos)
	end
end

function PlayerMovementStateBase:set_local_rotation(new_rot)
	local internal = self._internal

	Unit.set_local_rotation(self._unit, 0, new_rot)

	if internal.game and internal.id then
		GameSession.set_game_object_field(internal.game, internal.id, "rotation", new_rot)
	end
end

function PlayerMovementStateBase:aim_direction()
	local unit = self._unit
	local aim_target = self._internal.aim_target:unbox()
	local aim_from_pos = Mover.position(Unit.mover(unit)) + Unit.local_position(unit, Unit.node(unit, "camera_attach"))

	return aim_target - aim_from_pos
end

function PlayerMovementStateBase:aim_rotation()
	local camera_manager = Managers.state.camera
	local viewport_name = self._internal.player.viewport_name

	return camera_manager:aim_rotation(viewport_name)
end

function PlayerMovementStateBase:update_camera_target(dt)
	local internal = self._internal
	local old_unit_type = internal.camera_follow_unit_type
	local unit_type
	local mount = internal.mounted_unit

	unit_type = Unit.alive(mount) and not internal.aiming and "mount" or "player"

	if old_unit_type ~= unit_type then
		local unit

		if unit_type == "mount" then
			unit = mount
		elseif unit_type == "player" then
			unit = self._unit
		else
			ferror("PlayerMounted:_set_camera_unit() incorrect unit type %s", tostring(unit_type))
		end

		internal.camera_follow_unit_type = unit_type

		local player = internal.player

		player:set_camera_follow_unit(unit)
	end
end

function PlayerMovementStateBase:update_camera(dt, t)
	local camera_node = "onground"
	local internal = self._internal
	local inventory = internal:inventory()
	local unit = self._unit

	self:update_camera_target(dt)

	if internal.travel_mode then
		if t - internal.travel_mode.start_time < PlayerUnitMovementSettings.travel_mode.camera_speed_up_delay then
			camera_node = "travel_mode"
		else
			camera_node = "travel_mode_active"
		end
	elseif internal.execute_camera then
		camera_node = internal.execute_camera
	elseif internal.executed_camera then
		camera_node = internal.executed_camera
	elseif internal.current_state_name == "knocked_down" then
		camera_node = "knocked_down"
	elseif internal.current_state_name == "stunned" then
		camera_node = "stunned"
	elseif internal.landing then
		if internal.land_type == "dead" then
			camera_node = "land_dead"
		elseif internal.land_type == "knocked_down" then
			camera_node = "land_knocked_down"
		elseif internal.land_type == "heavy" then
			camera_node = "land_heavy"
		elseif internal.land_type == "light" then
			camera_node = "land_light"
		elseif internal.land_type == "attack" then
			camera_node = "land_heavy"
		end
	elseif internal.current_state_name == "climbing" then
		camera_node = "climbing"
	elseif internal.current_state_name == "planting_flag" then
		camera_node = "planting_flag"
	elseif internal.current_state_name == "reviving_teammate" then
		camera_node = "reviving_teammate"
	elseif internal.current_state_name == "bandaging_self" then
		camera_node = "bandaging_self"
	elseif internal.current_state_name == "bandaging_teamamte" then
		camera_node = "bandaging_teammate"
	elseif internal.camera_follow_unit_type == "mount" then
		unit = internal.mounted_unit

		if internal.dismounting then
			camera_node = "dismounting"
		elseif internal.couching then
			camera_node = "couch"
		elseif internal.mounting then
			camera_node = "mounting"
		elseif Unit.get_data(unit, "current_state_name") == "jumping" then
			if internal.aiming then
				camera_node = "jump_zoom"
			elseif internal.parrying then
				camera_node = "jump_parry_pose_" .. internal.block_direction
			elseif internal.posing then
				camera_node = "jump_swing_pose_" .. internal.pose_direction
			else
				camera_node = "jump"
			end
		elseif internal.aiming then
			local slot_name = inventory:wielded_ranged_weapon_slot()
			local gear = inventory:gear(slot_name)
			local extensions = gear:extensions()
			local weapon_ext = extensions.base

			camera_node = weapon_ext:zoom_camera_node()
		elseif ScriptUnit.extension(unit, "locomotion_system").charging then
			if internal.posing then
				camera_node = "charge_swing_pose_" .. internal.pose_direction
			elseif internal.attempting_pose or internal.pose_ready then
				camera_node = "charge_swing_pose_blend"
			else
				camera_node = "charge"
			end
		elseif internal.parrying then
			camera_node = "parry_pose_" .. internal.block_direction
		elseif internal.posing or internal.attempting_pose or internal.pose_ready then
			camera_node = "swing_pose_blend"
		end
	elseif internal.jumping then
		camera_node = "jump"
	elseif internal.falling then
		camera_node = "fall"
	elseif internal.aiming then
		local slot_name = inventory:wielded_ranged_weapon_slot()
		local gear = inventory:gear(slot_name)
		local extensions = gear:extensions()
		local weapon_ext = extensions.base

		camera_node = weapon_ext:zoom_camera_node()
	elseif internal.perk_blade_master.faster_moving.time - t > 1.25 then
		camera_node = "blade_master"
	elseif internal.parrying then
		camera_node = "parry_pose_" .. internal.block_direction
	elseif internal.posing or internal.attempting_pose or internal.pose_ready then
		camera_node = "swing_pose_blend"
	elseif internal.crouching then
		camera_node = "crouch"
	elseif internal.throw_data and internal.throw_data.state ~= "released_weapon" and internal.throw_data.state ~= "wielding" then
		camera_node = internal.throw_data.camera_node
	end

	if script_data.camera_debug and Unit.get_data(unit, "camera", "settings_node") ~= camera_node then
		print("PlayerMovementStateBase:update_camera() Change to camera: ", internal.camera_follow_unit_type, camera_node, Unit.get_data(unit, "camera", "settings_node"))
	end

	Unit.set_data(unit, "camera", "settings_node", camera_node)
end

function PlayerMovementStateBase:set_target_world_rotation(target_rot)
	local internal = self._internal

	internal.target_world_rotation:store(target_rot)

	local aim_vector_flat = Vector3.flat(Quaternion.forward(self:aim_rotation()))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())

	internal.target_rotation:store(Quaternion.multiply(target_rot, Quaternion.inverse(aim_rot_flat)))
end

local MIN_ANGLE_SPEED = math.pi * 2
local ASYMPTOTIC_INTERPOLATION_SPEED = 5

function PlayerMovementStateBase:set_world_rotation(new_rot)
	self:set_target_world_rotation(new_rot)
	self:_set_rotation(new_rot)
end

function PlayerMovementStateBase:_update_rotation_variable(dt, current_rot, new_rot)
	local unit = self._unit
	local anim_val = self._rot_anim_val or 0
	local diff_rotation = Quaternion.multiply(Quaternion.inverse(new_rot), current_rot)
	local diff_vector = Quaternion.forward(diff_rotation)
	local angle = -math.atan2(diff_vector.x, diff_vector.y)
	local anim_rotation_var_index = Unit.animation_find_variable(unit, "rotation_speed")
	local anim_rotation_speed = math.clamp(math.lerp(anim_val, 0, dt * 5) + angle, -1, 1)

	self:anim_set_variable(anim_rotation_var_index, anim_rotation_speed)

	self._rot_anim_val = anim_rotation_speed
end

function PlayerMovementStateBase:_set_rotation(new_rot)
	local unit = self._unit
	local internal = self._internal

	Unit.set_local_rotation(unit, 0, new_rot)

	if internal.game and internal.id then
		GameSession.set_game_object_field(internal.game, internal.id, "rotation", new_rot)
	end
end

function PlayerMovementStateBase:anim_event(event, force_local, remote_only)
	local unit = self._unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	local internal = self._internal
	local event_id = NetworkLookup.anims[event]

	if not force_local and internal.game and internal.id then
		if Managers.lobby.server then
			Managers.state.network:send_rpc_clients("rpc_anim_event", event_id, internal.id)
		else
			Managers.state.network:send_rpc_server("rpc_anim_event", event_id, internal.id)
		end
	end

	if not remote_only then
		Unit.animation_event(unit, event)
	end
end

function PlayerMovementStateBase:anim_set_variable(variable_index, variable_value)
	local unit = self._unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	if variable_value == nil then
		return
	end

	Unit.animation_set_variable(unit, variable_index, variable_value)
end

function PlayerMovementStateBase:anim_event_with_variable_float(event, variable_name, variable_value, force_local, remote_only)
	local unit = self._unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	local internal = self._internal
	local event_id = NetworkLookup.anims[event]
	local variable_id = NetworkLookup.anims[variable_name]

	if not force_local and internal.game and internal.id then
		if Managers.lobby.server then
			Managers.state.network:send_rpc_clients("rpc_anim_event_variable_float", event_id, internal.id, variable_id, variable_value)
		else
			Managers.state.network:send_rpc_server("rpc_anim_event_variable_float", event_id, internal.id, variable_id, variable_value)
		end
	end

	if not remote_only then
		local variable_index = Unit.animation_find_variable(unit, variable_name)

		Unit.animation_set_variable(unit, variable_index, variable_value)
		Unit.animation_event(unit, event)
	end
end

function PlayerMovementStateBase:_player_latency()
	local latency = 0

	if not Managers.lobby.server and self._internal.game then
		local player_index = GameSession.game_object_field(self._internal.game, self._internal.id, "player")

		latency = Managers.state.network:player_latency(player_index, true)
	end

	return latency
end

function PlayerMovementStateBase:bow_draw_animation_event(event, draw_time, tense_time, hold_time)
	local unit = self._unit

	if not Unit.has_animation_state_machine(unit) then
		return
	end

	local draw_variable_name = "bow_draw_time"
	local tense_variable_name = "bow_tense_time"
	local hold_variable_name = "bow_hold_time"
	local internal = self._internal
	local event_id = NetworkLookup.anims[event]
	local draw_time_id = NetworkLookup.anims[draw_variable_name]
	local tense_time_id = NetworkLookup.anims[tense_variable_name]
	local hold_time_id = NetworkLookup.anims[hold_variable_name]

	if internal.game and internal.id then
		if Managers.lobby.server then
			Managers.state.network:send_rpc_clients("rpc_bow_draw_animation_event", event_id, internal.id, draw_time_id, draw_time, tense_time_id, tense_time, hold_time_id, hold_time)
		else
			Managers.state.network:send_rpc_server("rpc_bow_draw_animation_event", event_id, internal.id, draw_time_id, draw_time, tense_time_id, tense_time, hold_time_id, hold_time)
		end
	end

	local draw_index = Unit.animation_find_variable(unit, draw_variable_name)
	local tense_index = Unit.animation_find_variable(unit, tense_variable_name)
	local hold_index = Unit.animation_find_variable(unit, hold_variable_name)

	self:anim_set_variable(draw_index, draw_time)
	self:anim_set_variable(tense_index, tense_time)
	self:anim_set_variable(hold_index, hold_time)
	Unit.animation_event(unit, event)
end

function PlayerMovementStateBase:update_aim_rotation(dt, t)
	local aim_rot = self:aim_rotation()

	self._internal.aim_rotation:store(aim_rot)
	self._internal.aim_vector:store(Quaternion.forward(aim_rot))
end

function PlayerMovementStateBase:_move_speed()
	local internal = self._internal
	local last_stand_active = ScriptUnit.extension(self._unit, "damage_system"):is_last_stand_active()
	local multiplier = last_stand_active and Perks.last_stand.movement_speed_multiplier or 1

	return internal.archetype_settings.movement_settings.move_speed * multiplier
end

function PlayerMovementStateBase:update_look_angle(dt)
	local unit = self._unit
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(unit, "viewport_name")

	if viewport_name then
		local u_rotation = Unit.world_rotation(unit, 0)
		local u_forward = Quaternion.forward(u_rotation)
		local u_forward_flat = Vector3(u_forward.x, u_forward.y, 0)
		local u_rotation_flat = Quaternion.look(u_forward_flat, Vector3.up())
		local aim_rotation = camera_manager:aim_rotation(viewport_name)
		local aim_forward = Quaternion.forward(aim_rotation)
		local aim_forward_flat = Vector3(aim_forward.x, aim_forward.y, 0)
		local aim_rotation_flat = Quaternion.look(aim_forward_flat, Vector3.up())
		local diff_quaternion = Quaternion.multiply(Quaternion.inverse(u_rotation_flat), aim_rotation_flat)
		local diff_forward = Quaternion.forward(diff_quaternion)
		local angle = math.atan2(diff_forward.x, diff_forward.y)

		self._internal.look_angle = angle
	end
end

function PlayerMovementStateBase:update_look_anim_var(dt)
	local internal = self._internal
	local unit = self._unit
	local aim_direction = 2 * internal.look_angle / math.pi / 10

	self:anim_set_variable(self._look_direction_anim_var, aim_direction)

	if script_data.debug_aim_direction then
		print("aim_direction", aim_direction)
	end
end

function PlayerMovementStateBase:start_aim_target_interpolation(aim_rotation, t, interpolation_time)
	self._internal.aim_rotation_interpolation_data = {
		aim_rotation = QuaternionBox(aim_rotation),
		start_time = t,
		end_time = t + interpolation_time
	}
end

local ASIN_EPSILON = 1e-06

function PlayerMovementStateBase:update_aim_target(dt, t)
	local unit = self._unit
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(unit, "viewport_name")

	if viewport_name then
		local internal = self._internal
		local aim_from_pos = Mover.position(Unit.mover(unit)) + Unit.local_position(unit, Unit.node(unit, "camera_attach"))
		local aim_rotation = camera_manager:aim_rotation(viewport_name)
		local interpolation = internal.aim_rotation_interpolation_data

		if interpolation and t > interpolation.end_time then
			internal.aim_rotation_interpolation_data = nil
		elseif interpolation then
			local lerp_t = math.smoothstep(t, interpolation.start_time, interpolation.end_time)

			aim_rotation = Quaternion.lerp(interpolation.aim_rotation:unbox(), aim_rotation, lerp_t)
		end

		local min_z = -math.huge
		local max_z = not (not internal.posing and not internal.swinging) and PlayerUnitMovementSettings.swing.maximum_aim_constraint_z or 2
		local max_z_speed = internal.archetype_settings.movement_settings.maximum_z_speed_swinging

		if internal.swinging or internal.posing or internal.dual_wield_attacking then
			local old_z = math.abs(internal.old_z) < ASIN_EPSILON and 0 or internal.old_z
			local old_z_angle = math.asin(math.clamp(old_z, -1, 1))

			min_z = math.max(min_z, math.sin(old_z_angle - dt * max_z_speed))
			max_z = math.min(max_z, math.sin(old_z_angle + dt * max_z_speed))
		end

		local dir = Quaternion.forward(aim_rotation)
		local flat_rel_aim_dir = Vector3(dir.x, dir.y, 0)
		local flat_length = Vector3.length(flat_rel_aim_dir)

		if flat_length == 0 then
			flat_length = 0.01
		end

		local unmodified_rel_aim_dir = dir / flat_length
		local new_z = math.clamp(unmodified_rel_aim_dir.z, min_z, max_z)

		internal.old_z = new_z

		local unnormalized_rel_aim_dir = Vector3(unmodified_rel_aim_dir.x, unmodified_rel_aim_dir.y, new_z)
		local rel_aim_dir = Vector3.normalize(unnormalized_rel_aim_dir) * 3
		local aim_target = aim_from_pos + rel_aim_dir

		internal.aim_target:store(aim_target)

		if script_data.aim_constraint_debug then
			local drawer = Managers.state.debug:drawer({
				mode = "retained",
				name = "constraint debug"
			})

			drawer:sphere(aim_target, 0.05, Color(255, 255, 0))
		end

		Unit.animation_set_constraint_target(unit, self._aim_constraint_anim_var, aim_target)

		local anim_variable = PlayerUnitMovementSettings.block.aim_direction_pitch_function(Vector3.normalize(rel_aim_dir).z)

		self:anim_set_variable(Unit.animation_find_variable(self._unit, "aim_direction_pitch"), anim_variable)

		if internal.game and internal.id then
			GameSession.set_game_object_field(internal.game, internal.id, "aim_target", rel_aim_dir)
		end
	end
end

function PlayerMovementStateBase:_update_weapons(dt, t)
	local dual_wielding = self._internal:inventory():is_dual_wielding()

	if dual_wielding then
		self:_update_dual_wielding(dt, t)
	else
		self:_update_block(dt, t)
		self:_update_thrown_weapon(dt, t)
		self:_update_swing(dt, t)
		self:_update_ranged_weapons(dt, t)
	end

	self:_update_weapon_wield(dt, t)
	self:_update_special_attack(dt, t)
end

function PlayerMovementStateBase:_update_thrown_weapon(dt, t)
	local thrown_component = self._thrown_weapon_component

	if thrown_component then
		thrown_component:update(dt, t, self._controller)
	end
end

function PlayerMovementStateBase:_update_special_attack(dt, t)
	local internal = self._internal
	local controller = self._controller
	local input = controller and controller:get("special_attack")
	local inventory = internal:inventory()
	local dual_wielding = internal:inventory():is_dual_wielding()

	if dual_wielding and input then
		local slot_name = "primary"
		local secondary_slot_name = "secondary"
		local gear_settings = inventory:gear(slot_name):settings()
		local secondary_gear_settings = inventory:gear(secondary_slot_name):settings()
		local attacks = gear_settings.attacks
		local dual_wield_attack = gear_settings.dual_wield_special_attacks[secondary_gear_settings.gear_type]

		if not dual_wield_attack then
			return
		end

		local primary_attack_name = dual_wield_attack.primary
		local secondary_attack_name = dual_wield_attack.secondary
		local attack = attacks[primary_attack_name]
		local stamina_settings = attack and attack.stamina_settings

		if attack and self:can_special_attack(t, stamina_settings) then
			self:anim_event("idle")

			self._transition = "dual_wield_special_attack"
			self._transition_data = {
				attack_name = primary_attack_name,
				secondary_attack_name = secondary_attack_name,
				slot_name = slot_name,
				secondary_slot_name = secondary_slot_name,
				stamina_settings = stamina_settings or PlayerUnitMovementSettings.special_attack.stamina_settings
			}
		end
	elseif input then
		local slot_name = inventory:wielded_melee_weapon_slot()
		local attacks = slot_name and inventory:gear(slot_name):settings().attacks

		if attacks then
			if internal:has_perk("shield_maiden01") and self:can_stance_special_attack(t, slot_name) then
				self:anim_event("idle")

				self._transition = "special_attack_stance"
				self._transition_data = {
					stance_settings = Perks.shield_maiden01.stance_settings,
					slot_name = slot_name
				}
			elseif not dual_wielding and self:can_special_attack(t) and attacks.special then
				self:anim_event("idle")

				self._transition = "special_attack"
				self._transition_data = {
					attack_names = {
						"special"
					},
					slot_name = slot_name,
					stamina_settings = PlayerUnitMovementSettings.special_attack.stamina_settings
				}
			end
		end
	end
end

function PlayerMovementStateBase:_update_block(dt, t)
	local internal = self._internal
	local inventory = internal:inventory()
	local controller = self._controller
	local pommel_bash_input_pressed = controller and controller:get("pommel_bash_pushed")
	local block_input = controller and controller:get("block") > BUTTON_THRESHOLD or script_data.debug_block
	local unbreak_block = controller and controller:get("raise_block")

	if unbreak_block then
		internal.block_broken = false
	end

	if block_input then
		local can_raise, slot_name = self:can_raise_block(t)

		if can_raise then
			local block_type = inventory:block_type(slot_name)

			if block_type == "shield" and internal:has_perk("dodge_block") then
				internal:set_perk_state("dodge_block", "ready")
			end

			if not internal.blocking and not internal.parrying then
				if block_type == "shield" then
					self:safe_action_interrupt("block")
					self:_raise_shield_block(slot_name)
				elseif block_type == "weapon" then
					self:safe_action_interrupt("parry_attempt")

					if internal:has_perk("auto_parry") and not internal.attempting_parry then
						self:_update_parry_attempt_auto(dt, slot_name, block_type)
					else
						self:_update_parry_attempt(dt, slot_name, block_type)
					end
				else
					assert(false, "Invalid block type: " .. tostring(block_type))
				end
			elseif pommel_bash_input_pressed then
				local can_pommel_bash, slot_name = self:can_pommel_bash(t, false)

				if can_pommel_bash and slot_name then
					local attack_name = "pommel_bash"
					local gear = inventory:gear(slot_name)
					local gear_settings = gear:settings()
					local attack_settings = gear_settings.attacks[attack_name]

					if attack_settings then
						internal.pose_slot_name = slot_name
						internal.pose_direction = attack_name

						self:safe_action_interrupt("pommel_bashing")
						self:_swing_melee_weapon(t)
					end
				end
			end
		end
	elseif internal.attempting_parry and (not block_input or internal.crouching or internal.block_unit and not Unit.alive(internal.block_unit)) then
		self:_abort_parry_attempt()
	elseif (internal.blocking or internal.parrying) and (not internal:has_perk("dodge_block") or not internal.dodging) and (not block_input or internal.block_unit and not Unit.alive(internal.block_unit) or internal.block_broken) then
		self:_lower_block()
	end
end

function PlayerMovementStateBase:_update_parry_attempt(dt, slot_name, block_type)
	if PlayerUnitMovementSettings.parry.keyboard_controlled then
		self:_update_parry_attempt_keyboard(dt, slot_name, block_type)
	else
		self:_update_parry_attempt_mouse(dt, slot_name, block_type)
	end
end

function PlayerMovementStateBase:_update_parry_attempt_keyboard(dt, slot_name, block_type)
	local move = self._controller and self._controller:get("move") or Vector3(0, 0, 0)
	local invert_x = PlayerUnitMovementSettings.parry.invert_parry_control_x
	local invert_y = PlayerUnitMovementSettings.parry.invert_parry_control_y
	local dir

	if move.x > 0 then
		dir = invert_x and "right" or "left"
	elseif move.x < 0 then
		dir = invert_x and "left" or "right"
	elseif move.y > 0 or move.y < 0 then
		dir = "up"
	end

	if dir then
		self:_raise_parry_block(slot_name, block_type, dir)
	end
end

local ATTACK_LOOKUPS = {
	up = "attack_up",
	left = "attack_left",
	right = "attack_right"
}

function PlayerMovementStateBase:_update_parry_attempt_auto(dt, slot_name, block_type)
	local internal = self._internal
	local parry_helper_blackboard = self._internal.parry_helper_blackboard.attack_direction
	local perk_settings = Perks.auto_parry

	for direction, lookup in pairs(ATTACK_LOOKUPS) do
		if parry_helper_blackboard[lookup] == 1 then
			internal:set_perk_state("auto_parry", "active")
			self:_raise_parry_block(slot_name, block_type, direction)

			return
		end
	end

	if perk_settings.default_direction then
		self:_raise_parry_block(slot_name, block_type, perk_settings.default_direction)
	else
		self:_update_parry_attempt(dt, slot_name, block_type)
	end
end

function PlayerMovementStateBase:_update_parry_attempt_mouse(dt, slot_name, block_type)
	local internal = self._internal
	local controller = self._controller
	local look_vec_raw = controller and controller:get("look") or Vector3(0, 0, 0)

	if PlayerUnitMovementSettings.parry.invert_parry_control_x then
		look_vec_raw.x = -look_vec_raw.x
	end

	if PlayerUnitMovementSettings.parry.invert_parry_control_y then
		look_vec_raw.y = -look_vec_raw.y
	end

	local y_scale = look_vec_raw.y < 0 and PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_DOWN or PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_UP
	local look_vec = Vector3(look_vec_raw.x, look_vec_raw.y * y_scale, 0)
	local acc_parry_dir = internal.accumulated_parry_direction:unbox()

	acc_parry_dir = acc_parry_dir + look_vec

	internal.accumulated_parry_direction:store(acc_parry_dir)

	internal.attempting_parry = true

	local acc_parry_dir_x_abs = math.abs(acc_parry_dir.x)
	local acc_parry_dir_y_abs = math.abs(acc_parry_dir.y)

	if Vector3.length(acc_parry_dir) > PARRY_ATTEMPT_THRESHOLD then
		local direction

		direction = acc_parry_dir_y_abs < acc_parry_dir.x and "left" or acc_parry_dir_y_abs < acc_parry_dir_x_abs and "right" or acc_parry_dir.y > 0 and "up" or "down"

		self:_raise_parry_block(slot_name, block_type, direction)
	end
end

function PlayerMovementStateBase:_update_swing_stamina(dt, t)
	local internal = self._internal
	local swing_stamina_consumed = internal.swing_stamina_consumed

	if not swing_stamina_consumed and t > internal.swing_abort_time then
		internal.swing_stamina_consumed = true

		self:stamina_activate(self:_swing_stamina_settings(internal.swing_slot_name, internal.swing_direction), internal.stamina.swing_chain_use_data)
	end
end

function PlayerMovementStateBase:_update_dual_wielding(dt, t)
	local internal = self._internal
	local controller = self._controller
	local upper_body = true
	local left_pressed = controller and controller:get("left_hand_attack_pressed")
	local left_held = controller and controller:get("left_hand_attack_held") > BUTTON_THRESHOLD or script_data.debug_block
	local right_pressed = controller and controller:get("right_hand_attack_pressed")
	local right_held = controller and controller:get("right_hand_attack_held") > BUTTON_THRESHOLD or script_data.debug_block

	if internal.swing_recovery_time and t > internal.swing_recovery_time then
		self:_end_swing_recovery()
	end

	local both_held = right_held and left_held
	local attacking = internal.dual_wield_attacking

	if attacking then
		local attack_settings = internal:inventory():gear(attacking.slot_name):settings().attacks[attacking.attack_name]
		local abort_time = attack_settings.abort_time_factor * attack_settings.attack_time
		local past_abort_time = t > attacking.start_time + abort_time

		if both_held then
			internal.dual_wield_queued_attack = nil
			internal.dual_wield_queued_slot = nil

			if not past_abort_time then
				self:_abort_dual_wield_attack("interrupt")
			end
		elseif past_abort_time and not internal.swing_stamina_consumed then
			self:_play_voice("chr_vce_charge_swing", true, "husk_vce_charge_swing")

			internal.swing_stamina_consumed = true

			local swing_stamina_settings = attack_settings.stamina_settings

			self:stamina_activate(swing_stamina_settings)
		end
	end

	local defending = internal.dual_wield_defending

	if not defending and both_held and self:can_dual_wield_defend(t) then
		self:_raise_dual_wield_block("primary")
	elseif defending and not both_held then
		self:_lower_dual_wield_block()
	end

	local attack_name, slot_name
	local in_combo_time = t < internal.dual_wield_combo_time
	local combo_slot = internal.dual_wield_combo_last_slot

	if left_pressed and not right_held and not internal.leaving_ghost_mode and not internal.ghost_mode then
		slot_name = "secondary"

		if attacking and attacking.slot_name == slot_name or not attacking and in_combo_time and slot_name == combo_slot then
			attack_name = "left_repeated"
		elseif attacking or in_combo_time and slot_name ~= combo_slot then
			attack_name = "left_alternated"
		else
			attack_name = "left_start"
		end
	elseif right_pressed and not left_held and not internal.leaving_ghost_mode and not internal.ghost_mode then
		slot_name = "primary"
		attack_name = not (not (attacking and attacking.slot_name == slot_name) and (attacking or not in_combo_time or slot_name ~= combo_slot)) and "right_repeated" or not (not attacking and (not in_combo_time or slot_name == combo_slot)) and "right_alternated" or "right_start"
	end

	if upper_body then
		attack_name = attack_name and attack_name .. "_upper_body"
	end

	if upper_body then
		if attack_name then
			internal.dual_wield_queued_attack_time = t
		end

		internal.dual_wield_queued_attack = attack_name or internal.dual_wield_queued_attack
		internal.dual_wield_queued_slot = slot_name or internal.dual_wield_queued_slot

		if t < math.max(internal.dual_wield_queued_attack_time + 0.45, internal.dual_wield_combo_time) then
			attack_name = internal.dual_wield_queued_attack
			slot_name = internal.dual_wield_queued_slot
		else
			internal.dual_wield_queued_attack = nil
			internal.dual_wield_queued_slot = nil
			attack_name = nil
			slot_name = nil
		end
	end

	if attacking and t >= attacking.end_time then
		self:dual_wield_swing_finished(nil, internal.dual_wield_queued_attack)
	end

	if attack_name then
		local can, stamina_is_decider = self:can_dual_wield_attack(t, attack_name, slot_name)

		if upper_body and can then
			internal.dual_wield_queued_attack = nil
			internal.dual_wield_queued_slot = nil

			self:safe_action_interrupt("dual_wield_attack")
			self:_dual_wield_attack(t, attack_name, slot_name)
		elseif can then
			self:anim_event("idle")

			self._transition = "dual_wield_attack"
			self._transition_data = {
				attack_names = {
					attack_name
				},
				slot_name = slot_name
			}
		elseif not can and stamina_is_decider then
			internal.dual_wield_queued_attack = nil
			internal.dual_wield_queued_slot = nil
		end
	end
end

function PlayerMovementStateBase:_dual_wield_attack(t, attack_name, slot_name, direction)
	local unit = self._unit
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local gear_settings = gear:settings()
	local attack_settings = gear_settings.attacks[attack_name]
	local attack_time = attack_settings.attack_time
	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[attack_settings.parry_direction])
		else
			network_manager:send_rpc_server("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[attack_settings.parry_direction])
		end
	end

	gear:send_start_melee_attack(0, attack_name, attack_settings, callback(self, "gear_cb_abort_dual_wield_attack"), attack_time)
	self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_time, false, true)
	self:_set_delayed_local_callback(self._local_dual_wield_attack, {
		slot_name = slot_name,
		attack_name = attack_name,
		attack_time = attack_time
	})
end

function PlayerMovementStateBase:_local_dual_wield_attack(t, params)
	local slot_name = params.slot_name
	local attack_name = params.attack_name
	local attack_time = params.attack_time
	local unit = self._unit
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local gear_settings = gear:settings()
	local attack_settings = gear_settings.attacks[attack_name]

	internal.dual_wield_attacking = {
		attack_name = attack_name,
		slot_name = slot_name,
		end_time = t + attack_time,
		start_time = t
	}
	internal.swing_stamina_consumed = false

	gear:start_melee_attack(0, attack_name, attack_settings, callback(self, "gear_cb_abort_dual_wield_attack"), attack_time)
	self:anim_event_with_variable_float(attack_settings.anim_event, "attack_time", attack_time, true)
end

function PlayerMovementStateBase:dual_wield_swing_finished(reason)
	local unit = self._unit
	local internal = self._internal
	local inventory = internal:inventory()
	local attack = internal.dual_wield_attacking
	local swing_recovery, swing_recovery_parry_penalty, penalty_animation_speed = inventory:end_melee_attack(attack.slot_name, reason)

	self:anim_set_variable(self._parry_penalty_speed_anim_var, penalty_animation_speed)

	local t = Managers.time:time("game")
	local swing_recovery_time = t + swing_recovery

	internal.dual_wield_attacking = false

	if reason == "interrupt" then
		internal.dual_wield_combo_last_slot = nil
	else
		internal.dual_wield_combo_last_slot = attack.slot_name
	end

	internal.dual_wield_combo_time = swing_recovery_time + 0.5
	internal.swing_recovery_time = swing_recovery_time
	internal.swing_parry_recovery_time = t + swing_recovery_parry_penalty

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(self._unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_stop_posing_melee_weapon", user_object_id)
		else
			network_manager:send_rpc_server("rpc_stop_posing_melee_weapon", user_object_id)
		end
	end

	if reason ~= "interrupt" and not internal.swing_stamina_consumed then
		internal.swing_stamina_consumed = true

		local attack_settings = internal:inventory():gear(attack.slot_name):settings().attacks[attack.attack_name]
		local swing_stamina_settings = attack_settings.stamina_settings

		self:stamina_activate(swing_stamina_settings)
	end
end

function PlayerMovementStateBase:_abort_dual_wield_attack(reason)
	self:anim_event("swing_attack_interrupt")
	self:dual_wield_swing_finished(reason)
end

function PlayerMovementStateBase:gear_cb_abort_dual_wield_attack(reason)
	self:_abort_dual_wield_attack(reason)
end

function PlayerMovementStateBase:_update_swing(dt, t)
	local internal = self._internal
	local controller = self._controller
	local pose_input = controller and controller:get("melee_pose") > BUTTON_THRESHOLD or script_data.debug_attack
	local pose_cancel_input = controller and controller:get("block") > BUTTON_THRESHOLD
	local pose_input_pressed = controller and controller:get("melee_pose_pushed")
	local swing_input = not controller or controller:get("melee_swing")

	if internal.swinging then
		self:_update_swing_stamina(dt, t)

		if internal.end_swing then
			self:swing_finished()
		elseif t > internal.swing_end_time then
			internal.end_swing = true
		end
	end

	if internal.swing_recovery_time and t > internal.swing_recovery_time then
		self:_end_swing_recovery()
	end

	if internal:has_perk("faster_melee_charge") and internal.perk_fast_pose_charge.faster_melee_charge.can_use then
		internal:set_perk_state("faster_melee_charge", "active")
	end

	local can_pose, pose_slot_name = self:can_pose_melee_weapon()
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()
	local gear_settings = slot_name and inventory:gear_settings(slot_name)

	if self._controller and not pose_cancel_input and (pose_input or internal.attempting_pose and gear_settings and gear_settings.only_thrust) and self:can_attempt_pose_melee_weapon(t, not pose_input_pressed) then
		self:_update_pose_attempt(dt)
	elseif can_pose then
		self:_pose_melee_weapon(pose_slot_name, t)
	elseif not pose_cancel_input and not pose_input and self:can_swing_melee_weapon() then
		if self:_swing_ready(t) then
			self:_swing_melee_weapon(t)
		else
			self:_update_pose(dt, t)
		end
	elseif (not pose_input or pose_cancel_input) and (internal.posing or internal.attempting_pose) then
		self:_abort_pose()
	elseif internal.posing then
		self:_update_pose(dt, t)
	end
end

function PlayerMovementStateBase:_swing_ready(t)
	local internal = self._internal
	local posed_time = t - internal.pose_time

	return posed_time > internal.minimum_pose_time
end

function PlayerMovementStateBase:_update_pose_attempt(dt)
	if PlayerUnitMovementSettings.swing.keyboard_controlled then
		self:_update_pose_attempt_keyboard(dt)
	else
		self:_update_pose_attempt_mouse(dt)
	end
end

function PlayerMovementStateBase:_update_pose_attempt_keyboard(dt)
	local internal = self._internal
	local move = self._controller and self._controller:get("move")
	local invert_x = PlayerUnitMovementSettings.swing.invert_pose_control_x
	local invert_y = PlayerUnitMovementSettings.swing.invert_pose_control_y
	local dir
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()
	local gear_settings = inventory:gear_settings(slot_name)
	local has_shield = inventory:wielded_block_slot() ~= slot_name

	if gear_settings.only_thrust then
		if move.y < 0 then
			dir = invert_y and "up" or "down"
		elseif move.y > 0 then
			dir = invert_y and "down" or "up"
		elseif move.x ~= 0 then
			dir = "down"
		end
	elseif move.x > 0 then
		dir = invert_x and "left" or "right"
	elseif move.x < 0 then
		dir = invert_x and "right" or "left"
	elseif move.y < 0 or move.y > 0 then
		dir = "up"
	end

	Managers.state.camera:set_variable(internal.player.viewport_name, "swing_x", 1)
	Managers.state.camera:set_variable(internal.player.viewport_name, "swing_y", 1)

	if dir then
		internal.pose_ready = true
		internal.pose_direction = dir

		self:anim_event("swing_pose_blend")
	end
end

function PlayerMovementStateBase:_update_pose_attempt_mouse(dt)
	local internal = self._internal

	if not internal.attempting_pose then
		self:safe_action_interrupt("attempting_pose")
	end

	local inventory = internal:inventory()
	local slot_name = inventory:wielded_melee_weapon_slot()
	local gear_settings = inventory:gear_settings(slot_name)
	local acc_pose = internal.accumulated_pose:unbox()
	local has_shield = inventory:wielded_block_slot() ~= slot_name
	local look_vec_raw = self._controller:get("look")

	if PlayerUnitMovementSettings.swing.invert_pose_control_x then
		look_vec_raw.x = -look_vec_raw.x
	end

	if PlayerUnitMovementSettings.swing.invert_pose_control_y then
		look_vec_raw.y = -look_vec_raw.y
	end

	local y_val, x_val, z_val

	if gear_settings.only_thrust then
		y_val = look_vec_raw.y <= 0 and 0 or look_vec_raw.y * PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_UP
		x_val = 0
		z_val = dt * PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE / PlayerUnitMovementSettings.swing.THRUST_TIMER
	elseif gear_settings.controller_test then
		y_val = dt * PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE / PlayerUnitMovementSettings.swing.THRUST_TIMER
		x_val = look_vec_raw.x
		z_val = 0
	else
		y_val = math.max(look_vec_raw.y * PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE_SCALE_Y_UP, 0)
		x_val = look_vec_raw.x
		z_val = 0
	end

	local look_vec = Vector3(x_val, y_val, z_val)

	internal.accumulated_pose:store(acc_pose + look_vec)

	internal.attempting_pose = true

	local acc_pose_x_abs = math.abs(acc_pose.x)
	local acc_pose_y_abs = math.abs(acc_pose.y)
	local length = Vector3.length(acc_pose)

	if length > PlayerUnitMovementSettings.swing.REQUIRED_MOVEMENT_TO_POSE then
		internal.pose_ready = true
		internal.attempting_pose = false

		internal.accumulated_pose:store(Vector3(0, 0, 0))

		if acc_pose_y_abs < acc_pose.x then
			internal.pose_direction = "right"
		elseif acc_pose_y_abs < acc_pose_x_abs then
			internal.pose_direction = "left"
		elseif acc_pose.y > 0 then
			internal.pose_direction = "up"
		else
			internal.pose_direction = "down"
		end
	end
end

function PlayerMovementStateBase:_update_pose(dt, t)
	local internal = self._internal
	local pose_duration = t - internal.pose_time
	local charge_time = internal.pose_charge_time
	local charge_buffer_multiplier = internal:has_perk("faster_melee_charge") and Perks.faster_melee_charge.charge_buffer_multiplier or 1
	local charge_factor, charge_value, overcharge_value = WeaponHelper:charge_factor(pose_duration, internal.minimum_pose_time, charge_time, charge_buffer_multiplier)
	local bb = internal.charge_blackboard

	bb.minimum_charge_value = internal.minimum_pose_time / (charge_time + internal.minimum_pose_time)
	bb.charge_value = charge_value
	bb.posing = true
	bb.overcharge_value = overcharge_value

	if charge_value > 0.5 and bb.previous_charge_value <= 0.5 then
		local timpani_world = World.timpani_world(internal.world)

		TimpaniWorld.trigger_event(timpani_world, "hud_full_charge_swing")
	end

	bb.previous_charge_value = charge_value
end

function PlayerMovementStateBase:_update_ranged_weapons(dt, t)
	local controller = self._controller
	local aim_input = controller and controller:get("ranged_weapon_aim") > BUTTON_THRESHOLD
	local aim_input_pressed = controller and controller:get("ranged_weapon_aim_pressed")
	local fire_input = controller and controller:get("ranged_weapon_fire")
	local internal = self._internal

	if internal:has_perk("faster_bow_charge") and t < internal.perk_fast_aim_charge.faster_bow_charge.timer then
		internal:set_perk_state("faster_bow_charge", "active")
	end

	local inventory = internal:inventory()
	local slot_name = inventory:wielded_ranged_weapon_slot()

	if slot_name then
		local gear = inventory:gear(slot_name)
		local extensions = gear:extensions()
		local weapon_ext = extensions.base

		if weapon_ext:loaded() and internal.reloading then
			self:_finish_reloading_weapon(true)
		elseif weapon_ext:loaded() then
			if aim_input and not internal.aiming and not internal.reloading and self:can_aim_ranged_weapon(not aim_input_pressed) then
				self:_aim_ranged_weapon(slot_name, t)
			end

			if fire_input and self:can_fire_ranged_weapon() then
				self:_fire_ranged_weapon(t)

				local camera_manager = Managers.state.camera

				camera_manager:camera_effect_sequence_event("fired_" .. weapon_ext:category(), t)
			end
		elseif self:can_reload(slot_name, aim_input) then
			if internal.reloading then
				weapon_ext:update_reload(dt, t, fire_input)
			else
				self:_start_reloading_weapon(dt, t, slot_name)
			end
		elseif internal.reloading then
			self:_finish_reloading_weapon(false)
		end

		if internal.aiming and not aim_input or weapon_ext:needs_unaiming() then
			weapon_ext:set_needs_unaiming(false)
			self:_unaim_ranged_weapon()

			internal.hold_breath_timer = 0
			internal.breathing_transition_time = 0
			internal.current_breathing_state = "normal"

			if weapon_ext:can_steady() then
				local settings = gear:settings()

				internal.current_sway_settings = nil
			end
		elseif internal.aiming and weapon_ext:can_steady() then
			if not internal.current_sway_settings then
				local settings = gear:settings()

				internal.current_sway_settings = table.clone(settings.sway.breath_normal)
			end

			self:_update_breathing_state(dt, t, slot_name)
		end

		if internal.aiming then
			self:_update_ranged_weapon_zoom(dt, t, slot_name)
		end
	end
end

function PlayerMovementStateBase:_update_weapon_wield(dt, t)
	local inventory = self._internal:inventory()
	local controller = self._controller

	for slot_name, slot in pairs(inventory:slots()) do
		local wield_input = controller and controller:get(slot.settings.wield_input)

		if wield_input then
			if self:can_wield_weapon(slot_name, t) then
				self:safe_action_interrupt("wield")

				if self._internal:has_perk("berserk_01") and slot_name == "secondary" then
					self:_wield_weapon("primary")
				else
					self:_wield_weapon(slot_name)
				end
			elseif self:can_toggle_weapon(slot_name, t) then
				self:safe_action_interrupt("wield")
				self:_set_slot_wielded_instant(slot_name, false)
			end
		end
	end
end

function PlayerMovementStateBase:_update_tagging(dt, t)
	self._tagging_component:update(dt, t)
end

function PlayerMovementStateBase:_can_tag(t, tagging_player)
	local internal = self._internal

	return not internal.duel_challenge and t >= internal.tagging_cooldown and tagging_player.squad_index and not internal.ghost_mode
end

function PlayerMovementStateBase:not_entertained()
	return
end

function PlayerMovementStateBase:_can_switch_weapon_grip(t)
	local internal = self._internal

	return not internal.posing and not internal.swinging and (not internal.swing_recovery_time or t > internal.swing_recovery_time or true) and not internal.parrying and not internal.attempting_parry
end

function PlayerMovementStateBase:can_wield_weapon()
	return false
end

function PlayerMovementStateBase:can_toggle_weapon()
	return false
end

function PlayerMovementStateBase:can_pommel_bash()
	return false, nil
end

function PlayerMovementStateBase:can_attempt_pose_melee_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_pose_melee_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_swing_melee_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_abort_melee_swing()
	return false, nil
end

function PlayerMovementStateBase:can_aim_ranged_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_unaim_ranged_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_fire_ranged_weapon()
	return false, nil
end

function PlayerMovementStateBase:can_raise_block()
	return false, nil
end

function PlayerMovementStateBase:can_lower_block()
	return false, nil
end

function PlayerMovementStateBase:can_crouch()
	return false
end

function PlayerMovementStateBase:can_rush()
	return false
end

function PlayerMovementStateBase:can_mount()
	return false
end

function PlayerMovementStateBase:can_unmount()
	return false
end

function PlayerMovementStateBase:can_unsheath_weapon()
	return false
end

function PlayerMovementStateBase:can_jump()
	return false
end

function PlayerMovementStateBase:can_pickup_flag()
	return false
end

function PlayerMovementStateBase:can_drop_flag()
	return false
end

function PlayerMovementStateBase:can_plant_flag()
	return false
end

function PlayerMovementStateBase:can_shield_bash()
	return false
end

function PlayerMovementStateBase:can_backstab(t)
	return false
end

function PlayerMovementStateBase:can_push()
	return false
end

function PlayerMovementStateBase:can_dual_wield_attack(t)
	return false
end

function PlayerMovementStateBase:can_dual_wield_defend(t)
	return
end

function PlayerMovementStateBase:can_special_attack(t)
	return false
end

function PlayerMovementStateBase:can_stance_special_attack(t, slot_name)
	return false
end

function PlayerMovementStateBase:can_call_horse()
	return false
end

function PlayerMovementStateBase:can_plant_squad_flag(t)
	return false
end

function PlayerMovementStateBase:_dual_wield_right_hand_fallback()
	local fallback_slot
	local inventory = self._internal:inventory()

	for _, slot_name in ipairs(InventorySlotPriority) do
		if inventory:is_equipped(slot_name) and inventory:is_right_handed(slot_name) then
			if inventory:is_wielded(slot_name) then
				return nil
			else
				fallback_slot = fallback_slot or slot_name
			end
		end
	end

	return fallback_slot
end

function PlayerMovementStateBase:_wield_weapon(slot_name, instant_wield)
	local internal = self._internal
	local inventory = internal:inventory()

	self:_unwield_slots_on_wield(slot_name)

	local left_hand_wielded = inventory:is_left_handed(slot_name)
	local right_hand_wielded = inventory:is_right_handed(slot_name)
	local one_handed_wielded = inventory:is_one_handed(slot_name)

	internal.dual_wield_config.right = inventory:best_one_handed_weapon_slot()

	local left_config = internal.dual_wield_config.left
	local right_config = internal.dual_wield_config.right
	local left_hand_slot = one_handed_wielded and left_hand_wielded and slot_name or left_config and inventory:is_equipped(left_config) and inventory:is_left_handed(left_config) and left_config
	local right_hand_slot = one_handed_wielded and (right_hand_wielded and slot_name or right_config and inventory:is_equipped(right_config) and right_config or self:_dual_wield_right_hand_fallback())
	local can_dual_wield = internal:has_perk("berserk_01")

	if left_hand_slot and right_hand_slot and not inventory:is_wielded(right_hand_slot) and not inventory:is_wielded(left_hand_slot) then
		if instant_wield then
			self:_set_slot_wielded_instant(right_hand_slot, true)
			self:_set_slot_wielded_instant(left_hand_slot, true)

			return
		end

		local left_wield_time = inventory:weapon_wield_time(left_hand_slot, can_dual_wield)
		local right_wield_time = inventory:weapon_wield_time(right_hand_slot, can_dual_wield)

		if right_wield_time < left_wield_time then
			self:anim_event_with_variable_float(inventory:weapon_wield_anim(left_hand_slot, can_dual_wield), "wield_time", left_wield_time)
		else
			self:anim_event_with_variable_float(inventory:weapon_wield_anim(right_hand_slot, can_dual_wield), "wield_time", right_wield_time)
		end

		internal.wielding = true
		internal.wield_slot_name = right_hand_slot
		internal.secondary_wield_slot_name = left_hand_slot
	else
		if instant_wield then
			self:_set_slot_wielded_instant(slot_name, true)

			return
		end

		local wield_anim_event = inventory:weapon_wield_anim(slot_name, can_dual_wield)
		local wield_time = inventory:weapon_wield_time(slot_name, can_dual_wield)

		self:anim_event_with_variable_float(wield_anim_event, "wield_time", wield_time)

		internal.wielding = true
		internal.wield_slot_name = slot_name
	end
end

function PlayerMovementStateBase:_unwield_slots_on_wield(wield_slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local unwield_slots = inventory:unwield_slots_on_wield(wield_slot_name)

	for _, unwield_slot_name in ipairs(unwield_slots) do
		if inventory:can_unwield(unwield_slot_name) then
			self:_set_slot_wielded_instant(unwield_slot_name, false)

			if inventory:is_one_handed(unwield_slot_name) and inventory:is_two_handed(wield_slot_name) and inventory:is_left_handed(unwield_slot_name) then
				internal.dual_wield_config.left = unwield_slot_name
			end
		end
	end
end

function PlayerMovementStateBase:_set_slot_wielded_instant(slot_name, wielded)
	local internal = self._internal
	local inventory = internal:inventory()

	if not wielded and slot_name ~= "shield" then
		self:anim_event("weapon_unflip")
		inventory:set_grip_switched(false)
	end

	local can_dual_wield = internal:has_perk("berserk_01")
	local main_body_state, hand_anim = inventory:set_gear_wielded(slot_name, wielded, false, can_dual_wield)

	if main_body_state then
		self:anim_event(main_body_state, true)
	end

	if hand_anim then
		self:anim_event(hand_anim, true)
	end
end

function PlayerMovementStateBase:anim_cb_wield()
	local internal = self._internal
	local unsheathing = internal.unsheathing

	if unsheathing then
		self:_unsheathe_weapon_instant(unsheathing.slot_name)

		return
	end

	local slot_name = internal.wield_slot_name
	local secondary_slot_name = internal.secondary_wield_slot_name

	if not slot_name and not secondary_slot_name then
		assert(not internal.wielding, "PlayerMovementStateBase:anim_cb_wield(), no wield slots assigned but player is wielding.")

		return
	end

	local inventory = internal:inventory()

	self:_set_slot_wielded_instant(slot_name, true)

	if secondary_slot_name then
		self:_set_slot_wielded_instant(secondary_slot_name, true)
	end
end

function PlayerMovementStateBase:anim_cb_wield_finished()
	local internal = self._internal

	if not internal.unsheathing and not internal.wielding then
		return
	end

	local inventory = internal:inventory()
	local slot_name
	local unsheathing = internal.unsheathing

	if unsheathing then
		slot_name = unsheathing.slot_name
		internal.unsheathing = nil
	else
		slot_name = internal.wield_slot_name
		internal.wielding = false
		internal.wield_slot_name = nil
		internal.secondary_wield_slot_name = nil
	end

	self:anim_event("wield_finished")

	local gear = inventory:gear(slot_name)
	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local finish_wield_anim = weapon_ext:wield_finished_anim_name()
	local category = weapon_ext:category()

	if category == "bow" and self:can_reload(slot_name) then
		self:_start_reloading_bow(nil, nil, slot_name)
	elseif finish_wield_anim and not category == "bow" then
		self:anim_event(finish_wield_anim)
	end
end

local POSE_ANIMS = {
	down = "swing_pose_down",
	up = "swing_pose_up",
	left = "swing_pose_left",
	right = "swing_pose_right"
}

function PlayerMovementStateBase:_pose_melee_weapon(slot_name, t)
	local internal = self._internal
	local inventory = internal:inventory()
	local unit = self._unit
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local direction = internal.pose_direction

	self:safe_action_interrupt("pose")

	internal.posing = true
	internal.pose_slot_name = slot_name
	internal.pose_time = t

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[direction])
		else
			network_manager:send_rpc_server("rpc_pose_melee_weapon", user_object_id, NetworkLookup.directions[direction])
		end
	end

	local event = POSE_ANIMS[direction]
	local gear_settings = inventory:gear_settings(slot_name)
	local attack_settings = gear_settings.attacks[direction]
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local charge_speed_multiplier = 1
	local blackboard = internal.perk_fast_pose_charge

	for perk_name, perk_blackboard in pairs(blackboard) do
		local perk_settings = Perks[perk_name]

		if internal:has_perk(perk_name) and perk_blackboard.can_use then
			charge_speed_multiplier = charge_speed_multiplier * perk_settings.charge_speed_multiplier
		end
	end

	local riposte = t < internal.riposte_time + PlayerUnitMovementSettings.riposte.time_window
	local charge_time = attack_settings.charge_time * charge_speed_multiplier

	if riposte then
		charge_time = charge_time * PlayerUnitMovementSettings.riposte.charge_time_multiplier
	else
		internal.riposte_time = -math.huge
	end

	internal.pose_charge_time = charge_time
	internal.pose_riposte = riposte

	local animation_value_multiplier = attack_settings.animation_value_multiplier or 1
	local minimum_pose_time = attack_settings.minimum_pose_time

	if riposte then
		minimum_pose_time = minimum_pose_time * PlayerUnitMovementSettings.riposte.minimum_charge_time_multiplier
	end

	minimum_pose_time = minimum_pose_time * PlayerUnitMovementSettings.stamina.minimum_pose_time_function(internal.stamina.value)
	internal.minimum_pose_time = minimum_pose_time

	self:anim_event_with_variable_float(event, "swing_pose_time", (charge_time + minimum_pose_time) * animation_value_multiplier)
	Unit.flow_event(unit, "lua_enter_weapon_pose")
end

function PlayerMovementStateBase:_play_voice(event, network_synch, husk_version)
	local internal = self._internal
	local voice = internal:inventory():voice()
	local unit = self._unit
	local timpani_world = World.timpani_world(internal.world)
	local stamina = internal.stamina
	local state = stamina.state

	if script_data.voice_debug then
		printf("Playing event %q on node %i with character_vo %q and chr_state %q. sync: %s", event, self._voice_node, voice, state, tostring(network_synch and true or false))
	end

	local id = TimpaniWorld.trigger_event(timpani_world, event, unit, self._voice_node)

	TimpaniWorld.set_parameter(timpani_world, id, "character_vo", voice)
	TimpaniWorld.set_parameter(timpani_world, id, "chr_state", state)

	local network_manager = Managers.state.network
	local game = network_manager:game()

	if network_synch and internal.id and internal.game then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_play_voice", internal.id, NetworkLookup.voice[husk_version or event])
		else
			network_manager:send_rpc_server("rpc_play_voice", internal.id, NetworkLookup.voice[husk_version or event])
		end
	end
end

function PlayerMovementStateBase:_swing_melee_weapon(t)
	if self._delayed_callback then
		return
	end

	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = internal.pose_slot_name
	local network_manager = Managers.state.network
	local attack_name = internal.pose_direction
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local gear_settings = gear:settings()
	local attack_settings = gear_settings.attacks[attack_name]
	local charge_buffer_multiplier = internal:has_perk("faster_melee_charge") and Perks.faster_melee_charge.charge_buffer_multiplier or 1
	local charge_factor = attack_settings.uncharged_attack and 1 or WeaponHelper:charge_factor(t - internal.pose_time, internal.minimum_pose_time, internal.pose_charge_time, charge_buffer_multiplier)
	local swing_speed_multiplier = PlayerUnitMovementSettings.stamina.swing_time_function(internal.stamina.value)
	local attack_time = attack_settings.uncharged_attack_time and attack_settings.charged_attack_time and math.lerp(attack_settings.uncharged_attack_time, attack_settings.charged_attack_time, charge_factor) * swing_speed_multiplier or attack_settings.attack_time * swing_speed_multiplier
	local riposte = internal.pose_riposte

	internal.pre_swing = true

	gear:send_start_melee_attack(charge_factor, attack_name, attack_settings, callback(self, "gear_cb_abort_swing"), attack_time, attack_settings.abort_on_hit, riposte)

	local swing_anim = "swing_attack_" .. attack_name

	self:anim_event_with_variable_float(swing_anim, "attack_time", attack_time, false, true)
	self:_set_delayed_local_callback(self._local_swing_melee_weapon, {
		slot_name = slot_name,
		attack_name = attack_name,
		attack_time = attack_time,
		charge_factor = charge_factor,
		riposte = riposte
	})

	if GameSettingsDevelopment.tutorial_mode then
		self:_perform_delayed_local_action(t)
	end
end

function PlayerMovementStateBase:_local_swing_melee_weapon(t, params)
	local slot_name = params.slot_name
	local attack_name = params.attack_name
	local attack_time = params.attack_time
	local charge_factor = params.charge_factor
	local riposte = params.riposte
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local gear_settings = gear:settings()
	local attack_settings = gear_settings.attacks[attack_name]
	local swing_anim = "swing_attack_" .. attack_name

	self:anim_event_with_variable_float(swing_anim, "attack_time", attack_time, true)
	self:_end_pose()
	gear:start_melee_attack(charge_factor, attack_name, attack_settings, callback(self, "gear_cb_abort_swing"), attack_time, attack_settings.abort_on_hit, riposte)

	internal.pre_swing = false
	internal.swinging = true
	internal.swing_stamina_consumed = false
	internal.swing_direction = attack_name
	internal.swing_slot_name = slot_name
	internal.swing_abort_time = t + attack_time * gear:settings().attacks[attack_name].abort_time_factor
	internal.swing_end_time = t + attack_time

	for perk_name, perk_blackboard in pairs(internal.perk_fast_pose_charge) do
		perk_blackboard.can_use = false
	end

	if charge_factor >= 1 then
		self:_play_voice("chr_vce_charge_swing", true, "husk_vce_charge_swing")
	else
		self:_play_voice("chr_vce_swing", true, "husk_vce_swing")
	end

	Unit.flow_event(self._unit, "lua_exit_weapon_pose")
end

function PlayerMovementStateBase:anim_cb_swing_finished()
	if not self._internal.swinging then
		return
	end
end

function PlayerMovementStateBase:gear_cb_abort_swing(reason)
	self:_abort_swing(reason)
end

function PlayerMovementStateBase:gear_cb_abort_shield_bash_swing(reason)
	self:_abort_shield_bash_swing(reason)
end

function PlayerMovementStateBase:gear_cb_abort_push_swing(reason)
	self:_abort_push_swing(reason)
end

function PlayerMovementStateBase:swing_finished(reason)
	local internal = self._internal

	assert(internal.swinging, "PlayerMovementStateBase:swing_finished() Trying to finish swing when not swinging")

	local inventory = internal:inventory()
	local swing_recovery, swing_recovery_parry_penalty, penalty_animation_speed = inventory:end_melee_attack(internal.swing_slot_name, reason)

	if swing_recovery == nil then
		return
	end

	local unit = self._unit

	self:anim_set_variable(self._parry_penalty_speed_anim_var, penalty_animation_speed)

	local t = Managers.time:time("game")

	internal.swing_recovery_time = t + swing_recovery
	internal.swing_parry_recovery_time = t + swing_recovery_parry_penalty
	internal.swinging = false
	internal.pre_swing = false
	internal.swing_slot_name = nil
	internal.swing_direction = nil
	internal.swing_end_time = nil
	internal.end_swing = false

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(self._unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_stop_posing_melee_weapon", user_object_id)
		else
			network_manager:send_rpc_server("rpc_stop_posing_melee_weapon", user_object_id)
		end
	end
end

function PlayerMovementStateBase:shield_bash_swing_finished(reason)
	local internal = self._internal
	local inventory = internal:inventory()

	if reason == "abort" then
		self:change_state("onground")
	end

	local swing_recovery = inventory:end_melee_attack(inventory:wielded_block_slot(), reason)

	internal.swinging_shield_bash = false

	if reason == "hard" then
		self:anim_event_with_variable_float("shield_bash_hit_hard", "shield_bash_hit_hard_penalty_time", swing_recovery)
	elseif reason == "soft" then
		self:anim_event("shield_bash_hit", "shield_bash_hit_penalty_time", PlayerUnitDamageSettings.stun_shield_bash.hit_penalty)
	else
		self:anim_event_with_variable_float("shield_bash_miss", "shield_bash_miss_penalty_time", swing_recovery)
	end

	internal.shield_bash_cooldown = Managers.time:time("game") + PlayerUnitDamageSettings.stun_shield_bash.cooldown
end

function PlayerMovementStateBase:push_swing_finished(reason)
	local internal = self._internal
	local inventory = internal:inventory()
	local swing_recovery = inventory:end_melee_attack(inventory:wielded_block_slot(), reason)

	internal.swinging_push = false

	if reason == "hard" then
		self:anim_event_with_variable_float("push_hit_hard", "push_hit_hard_penalty_time", swing_recovery)
	elseif reason == "soft" then
		self:anim_event("push_hit")
	else
		self:anim_event_with_variable_float("push_miss", "push_miss_penalty_time", swing_recovery)
	end

	internal.push_cooldown = Managers.time:time("game") + PlayerUnitDamageSettings.stun_push.cooldown
end

function PlayerMovementStateBase:_aim_ranged_weapon(slot_name, t)
	local internal = self._internal
	local inventory = internal:inventory()
	local draw_time = inventory:ranged_weapon_draw_time(slot_name)
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	self:safe_action_interrupt("aim")

	local anim_name, anim_var_name = weapon_ext:aim(t)

	if weapon_ext:category() == "bow" then
		local settings = gear:settings()
		local attack_settings = settings.attacks.ranged
		local tense_time = attack_settings.bow_tense_time
		local hold_time = 0.3

		self:bow_draw_animation_event(anim_name, draw_time, tense_time, hold_time)

		if t < internal.perk_fast_aim_charge.faster_bow_charge.timer then
			internal.perk_fast_aim_charge.faster_bow_charge.can_use = true
		end
	elseif anim_name then
		if anim_var_name then
			self:anim_event_with_variable_float(anim_name, anim_var_name, draw_time)
		else
			self:anim_event(anim_name)
		end
	end

	internal.aiming = true
	internal.aim_slot_name = slot_name
	internal.aim_time = t
	internal.aim_unit = inventory:gear_unit(slot_name)
	internal.ranged_weapon_zoom_value = 1

	if self._internal:has_perk("auto_aim") then
		local tagged_unit_id = GameSession.game_object_field(internal.game, internal.player.game_object_id, "tagged_player_object_id")
		local tagged_unit = Managers.state.network:game_object_unit(tagged_unit_id)

		if tagged_unit and ScriptUnit.has_extension(tagged_unit, "locomotion_system") then
			Managers.state.event:trigger("auto_aim_enabled", tagged_unit)
		end
	end

	local timpani_world = World.timpani_world(internal.world)
	local event_id = TimpaniWorld.trigger_event(timpani_world, "enter_stance_foley", self._unit)
end

function PlayerMovementStateBase:_unaim_ranged_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_ranged_weapon_slot()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local anim_name = weapon_ext:unaim()

	if anim_name then
		self:anim_event(anim_name)
	end

	internal.aiming = false
	internal.aim_slot_name = nil
	internal.aim_time = nil
	internal.aim_unit = nil
	internal.perk_fast_aim_charge.faster_bow_charge.can_use = false

	local timpani_world = World.timpani_world(internal.world)
	local event_id = TimpaniWorld.trigger_event(timpani_world, "Stop_enter_stance_foley", self._unit)

	self:_play_voice("chr_vce_aim_choke_new_stop")

	local event_id = TimpaniWorld.trigger_event(timpani_world, "Stop_bow_aim_fatigue")
end

function PlayerMovementStateBase:_fire_ranged_weapon(t)
	local internal = self._internal
	local inventory = internal:inventory()
	local draw_time = t - internal.aim_time
	local slot_name = internal.aim_slot_name
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local stamina_settings = table.clone(gear:settings().attacks.ranged.stamina_settings)
	local reduced_stamina_multiplier = internal:has_perk("light_01") and Perks.light_01.bow_stamina_multiplier or 1

	stamina_settings.activation_cost = stamina_settings.activation_cost * 1.25 * reduced_stamina_multiplier

	self:stamina_activate(stamina_settings)
	World.create_particles(internal.world, "fx/screenspace_bow_release_distortion", Vector3(0, 0, 0))

	if weapon_ext:firing_event() then
		local callback = callback(self, "_firing_event_callback")

		weapon_ext:start_release_projectile(slot_name, draw_time, callback, t)
	else
		weapon_ext:release_projectile(slot_name, draw_time)
	end

	local anim_name = weapon_ext:fire_anim_name()

	if anim_name then
		self:anim_event(anim_name)
	elseif weapon_ext:category() == "bow" then
		internal.release_reload = true
	end

	if t >= internal.perk_fast_aim_charge.faster_bow_charge.timer then
		internal.perk_fast_aim_charge.faster_bow_charge.can_use = false
	end
end

function PlayerMovementStateBase:_firing_event_callback(gear_category)
	if gear_category == "handgonne" then
		self:anim_event("handgonne_recoil")
	elseif gear_category == "bow" then
		self:_unaim_ranged_weapon()
	end
end

function PlayerMovementStateBase:_start_reloading_bow_on_wield_or_new_ammo(slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local reload_time = inventory:ranged_weapon_reload_time(slot_name)
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local finish_wield_anim = extensions.base:wield_finished_anim_name()

	self:anim_event_with_variable_float(finish_wield_anim, "bow_reload_time", reload_time)
end

function PlayerMovementStateBase:_start_reloading_bow_on_release(slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local reload_time = inventory:ranged_weapon_reload_time(slot_name)

	self:anim_event_with_variable_float("bow_release_reload", "bow_reload_time", reload_time)
end

function PlayerMovementStateBase:_start_reloading_bow(dt, t, slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local reload_time = inventory:ranged_weapon_reload_time(slot_name)
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:set_loaded(false)

	internal.reloading = true
	internal.reload_slot_name = slot_name

	if internal.release_reload then
		self:_start_reloading_bow_on_release(slot_name)

		internal.release_reload = false
	else
		self:_start_reloading_bow_on_wield_or_new_ammo(slot_name)
	end

	return reload_time
end

function PlayerMovementStateBase:_start_reloading_crossbow(dt, t, slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local blackboard = internal.crossbow_reload_blackboard

	internal.reloading = true
	internal.reload_slot_name = slot_name

	self:safe_action_interrupt("reload")
	self:_unaim_ranged_weapon()
	self:anim_event("crossbow_hand_reload")
	Managers.state.event:trigger("event_crossbow_minigame_activated", dt, t, internal.player, blackboard)

	local timpani_world = World.timpani_world(self._internal.world)
	local event_id = TimpaniWorld.trigger_event(timpani_world, "crossbow_load_loop")

	return inventory:ranged_weapon_reload_time(slot_name), blackboard
end

function PlayerMovementStateBase:_start_reloading_handgonne(dt, t, slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local fallback_slot = inventory:fallback_slot()

	internal.reload_slot_name = slot_name

	self:_unaim_ranged_weapon()
	self:_wield_weapon(fallback_slot)

	local blackboard = internal.handgonne_reload_blackboard
	local timer = t + inventory:ranged_weapon_reload_time(slot_name)

	return timer, blackboard
end

function PlayerMovementStateBase:_start_reloading_weapon(dt, t, slot_name)
	local inventory = self._internal:inventory()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local reload_time, reload_blackboard = self._ranged_weapon_reload_functions[weapon_ext:category()](self, dt, t, slot_name)

	weapon_ext:start_reload(reload_time, reload_blackboard)
end

function PlayerMovementStateBase:_finish_reloading_weapon(reloading_successful)
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name = inventory:wielded_ranged_weapon_slot()
	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base
	local anim_name = weapon_ext:finish_reload(reloading_successful, slot_name)

	if anim_name then
		self:anim_event(anim_name)
	end

	local player = internal.player

	Managers.state.event:trigger("event_crossbow_minigame_deactivated", player)

	internal.reloading = false

	if internal.aiming and self:can_aim_ranged_weapon() then
		self:_aim_ranged_weapon(internal.aim_slot_name, Managers.time:time("game"))
	elseif internal.aiming then
		weapon_ext:set_needs_unaiming(true)
	end
end

function PlayerMovementStateBase:anim_cb_ready_arrow()
	local internal = self._internal

	if not internal.reload_slot_name then
		return
	end

	local inventory = internal:inventory()
	local gear = inventory:gear(internal.reload_slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:ready_projectile(internal.reload_slot_name)
end

function PlayerMovementStateBase:anim_cb_bow_ready()
	local internal = self._internal
	local inventory = internal:inventory()
	local gear = inventory:gear(internal.reload_slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions and extensions.base

	weapon_ext:set_loaded(true)

	internal.reload_slot_name = nil

	self:anim_event("bow_action_finished")
end

function PlayerMovementStateBase:anim_cb_bow_action_finished()
	self:anim_event("bow_action_finished")
end

function PlayerMovementStateBase:_raise_dual_wield_block(slot_name)
	self:safe_action_interrupt("dual_wield_defend")

	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit
	local block_unit = inventory:gear_unit(slot_name)
	local t = Managers.time:time("game")
	local delay_time = PlayerUnitMovementSettings.parry.raise_delay

	internal.block_start_time = t
	internal.block_raised_time = t + delay_time
	internal.block_unit = block_unit
	internal.dual_wield_defending = true
	internal.block_slot_name = slot_name
	internal.block_type = "dual_wield"

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_raise_dual_wield_block", user_object_id, NetworkLookup.inventory_slots[slot_name], delay_time)
		else
			network_manager:send_rpc_server("rpc_raise_dual_wield_block", user_object_id, NetworkLookup.inventory_slots[slot_name], delay_time)
		end
	end

	self:_set_delayed_local_callback(self._local_raise_dual_wield_block, {
		slot_name = slot_name
	})
end

function PlayerMovementStateBase:_local_raise_dual_wield_block(t, params)
	local slot_name = params.slot_name
	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit
	local block_unit = inventory:gear_unit(slot_name)
	local t = Managers.time:time("game")
	local delay_time = PlayerUnitMovementSettings.parry.raise_delay

	internal.block_start_time = t
	internal.block_raised_time = t + delay_time
	internal.block_unit = block_unit
	internal.dual_wield_defending = true
	internal.block_slot_name = slot_name
	internal.block_type = "dual_wield"

	self:anim_event("parry_pose", true)
end

function PlayerMovementStateBase:_lower_dual_wield_block()
	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_lower_dual_wield_block", user_object_id)
		else
			network_manager:send_rpc_server("rpc_lower_dual_wield_block", user_object_id)
		end
	end

	self:anim_event("parry_pose_exit", true)

	internal.block_slot_name = nil
	internal.block_type = nil
	internal.dual_wield_defending = false
	internal.block_unit = nil
end

function PlayerMovementStateBase:_raise_shield_block(slot_name)
	local internal = self._internal
	local network_manager = Managers.state.network
	local unit = self._unit
	local block_unit = internal:inventory():gear_unit(slot_name)

	if not block_unit then
		return
	end

	local t = Managers.time:time("game")

	internal.block_start_time = t
	internal.block_raised_time = t
	internal.block_unit = block_unit
	internal.blocking = true
	internal.block_slot_name = slot_name
	internal.block_type = "shield"

	Unit.set_data(self._unit, "camera", "dynamic_pitch_scale", 1)
	Unit.set_data(self._unit, "camera", "dynamic_yaw_scale", 1)

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)
		local block_object_id = network_manager:unit_game_object_id(block_unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_raise_shield_block", user_object_id, NetworkLookup.inventory_slots[slot_name])
		else
			network_manager:send_rpc_server("rpc_raise_shield_block", user_object_id, NetworkLookup.inventory_slots[slot_name])
		end
	end

	self:_set_delayed_local_callback(self._local_raise_shield_block, {
		slot_name = slot_name
	})
end

function PlayerMovementStateBase:_local_raise_shield_block(t, params)
	local slot_name = params.slot_name
	local internal = self._internal
	local unit = self._unit
	local block_unit = internal:inventory():gear_unit(slot_name)

	if not block_unit then
		return
	end

	internal.block_start_time = t
	internal.block_raised_time = t
	internal.block_unit = block_unit
	internal.blocking = true
	internal.block_slot_name = slot_name
	internal.block_type = "shield"

	Unit.set_data(self._unit, "camera", "dynamic_pitch_scale", 1)
	Unit.set_data(self._unit, "camera", "dynamic_yaw_scale", 1)
	self:anim_event("shield_up", true)
end

function PlayerMovementStateBase:_raise_parry_block(slot_name, block_type, direction)
	self:safe_action_interrupt("parry")

	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit
	local block_unit = inventory:gear_unit(slot_name)

	if not block_unit then
		return
	end

	local t = Managers.time:time("game")
	local delay_time = PlayerUnitMovementSettings.parry.raise_delay - self:_player_latency()

	internal.block_start_time = t
	internal.block_raised_time = t + delay_time
	internal.block_unit = block_unit
	internal.block_direction = direction
	internal.parrying = true
	internal.block_slot_name = slot_name
	internal.block_type = block_type

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)
		local block_object_id = network_manager:unit_game_object_id(block_unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_raise_parry_block", user_object_id, NetworkLookup.inventory_slots[slot_name], NetworkLookup.directions[direction], delay_time)
		else
			network_manager:send_rpc_server("rpc_raise_parry_block", user_object_id, NetworkLookup.inventory_slots[slot_name], NetworkLookup.directions[direction], delay_time)
		end
	end

	self:_set_delayed_local_callback(self._local_raise_parry_block, {
		slot_name = slot_name,
		block_type = block_type,
		direction = direction
	})

	if GameSettingsDevelopment.tutorial_mode then
		self:_perform_delayed_local_action(t)
	end
end

function PlayerMovementStateBase:_local_raise_parry_block(t, params)
	local slot_name = params.slot_name
	local block_type = params.block_type
	local direction = params.direction
	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit
	local block_unit = inventory:gear_unit(slot_name)
	local delay_time = PlayerUnitMovementSettings.parry.raise_delay

	internal.block_start_time = t
	internal.block_raised_time = t + delay_time
	internal.block_unit = block_unit
	internal.block_direction = direction
	internal.parrying = true
	internal.block_slot_name = slot_name
	internal.block_type = block_type

	local gear = inventory:gear(slot_name)

	if not gear then
		return
	end

	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:parry(direction, internal.block_raised_time, delay_time)
	Unit.set_data(self._unit, "camera", "dynamic_pitch_scale", 1)
	Unit.set_data(self._unit, "camera", "dynamic_yaw_scale", 1)

	local parry_dir = "parry_pose_" .. direction

	self:anim_event(parry_dir, true)
end

function PlayerMovementStateBase:_lower_block()
	local internal = self._internal

	if internal.block_type == "shield" then
		self:_lower_shield_block(internal.block_slot_name)
	elseif internal.block_type == "weapon" then
		self:_lower_parry_block(internal.block_slot_name)
	end

	internal.block_or_parry = false
	internal.block_slot_name = nil
	internal.block_type = nil
end

function PlayerMovementStateBase:_lower_shield_block()
	local internal = self._internal
	local network_manager = Managers.state.network
	local unit = self._unit
	local play_animation = internal.current_state_name ~= "special_attack_stance" and internal.current_state_name ~= "special_attack"

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_lower_shield_block", user_object_id, play_animation)
		else
			network_manager:send_rpc_server("rpc_lower_shield_block", user_object_id, play_animation)
		end
	end

	if play_animation then
		self:anim_event("shield_down", true)
	end

	internal.blocking = false
	internal.block_unit = nil
end

function PlayerMovementStateBase:_lower_parry_block(slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local network_manager = Managers.state.network
	local unit = self._unit
	local gear = inventory:gear(slot_name)
	local extensions = gear:extensions()
	local weapon_ext = extensions.base

	weapon_ext:stop_parry()

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_lower_parry_block", user_object_id)
		else
			network_manager:send_rpc_server("rpc_lower_parry_block", user_object_id)
		end
	end

	self:anim_event("parry_pose_exit", true)

	internal.parrying = false
	internal.block_unit = nil
	internal.block_direction = nil
end

function PlayerMovementStateBase:_inair_check(dt, t)
	local mover = Unit.mover(self._unit)
	local physics_world = World.physics_world(self._internal.world)
	local actor_list = PhysicsWorld.overlap(physics_world, nil, "shape", "sphere", "position", Mover.position(mover), "size", 0.45, "types", "both", "collision_filter", "landing_overlap")
	local inair = false

	if #actor_list == 0 and not Mover.collides_down(mover) then
		inair = true
	end

	return inair
end

function PlayerMovementStateBase:safe_action_interrupt(interrupting_action, ...)
	local internal = self._internal
	local inventory = internal:inventory()
	local t = Managers.time:time("game")

	if interrupting_action == "hit_by_pommel_bash" then
		if internal.swinging then
			self:_abort_swing("interrupt")
		elseif internal.posing or internal.attempting_pose or internal.pose_ready then
			self:_abort_pose()
		else
			return
		end
	end

	if internal.dual_wield_defending and interrupting_action ~= "melee_damage" then
		self:_lower_dual_wield_block()
	end

	if (internal.blocking or internal.parrying) and interrupting_action ~= "block" and interrupting_action ~= "crouch" and interrupting_action ~= "parry" and interrupting_action ~= "rush" and interrupting_action ~= "melee_damage" and interrupting_action ~= "projectile_damage" and (not internal:has_perk("dodge_block") or inventory:wielded_block_slot() ~= "shield" or interrupting_action ~= "state_dodging") then
		self:_lower_block()
	end

	if internal.interacting and interrupting_action ~= "dead" then
		self:change_state("onground")
	end

	if internal.travel_mode and (interrupting_action == "melee_damage" or interrupting_action == "projectile_damage") then
		self:_exit_travel_mode(interrupting_action, ...)
	elseif internal.travel_mode and interrupting_action ~= "state_inair" and interrupting_action ~= "state_jumping" and interrupting_action ~= "state_dodging" then
		self:_exit_travel_mode()
	end

	if internal.sheathing then
		self:_abort_sheathing()
	end

	if internal.unsheathing then
		self:_abort_unsheathing()
	end

	if internal.double_time_timer and interrupting_action ~= "rush" and interrupting_action ~= "state_inair" and interrupting_action ~= "state_onground" and interrupting_action ~= "state_jumping" and interrupting_action ~= "pose" and interrupting_action ~= "attempting_pose" and interrupting_action ~= "reload" and interrupting_action ~= "wield" and interrupting_action ~= "pose_weapon_throw" and interrupting_action ~= "wield_weapon_after_throw" then
		internal.double_time_timer = t + PlayerUnitMovementSettings.double_time.timer_time
	end

	if internal.attempting_parry and interrupting_action ~= "parry_attempt" and interrupting_action ~= "crouch" and interrupting_action ~= "parry" then
		self:_abort_parry_attempt()
	end

	if (internal.posing or internal.attempting_pose or internal.pose_ready) and interrupting_action ~= "pose" and interrupting_action ~= "attempting_pose" and interrupting_action ~= "crouch" and interrupting_action ~= "rush" then
		self:_abort_pose()
	end

	if internal.dual_wield_attacking then
		self:_abort_dual_wield_attack("interrupt")
	end

	if not internal.pre_swing and not internal.swinging and interrupting_action ~= "rush" and interrupting_action ~= "parry" then
		self:_abort_swing("interrupt")
	end

	if internal.swinging_shield_bash then
		self:_abort_shield_bash_swing("abort")
	end

	if internal.posing_shield_bash then
		self:_abort_shield_bash_pose()
	end

	if internal.swinging_push then
		self:_abort_push_swing()
	end

	if internal.calling_horse then
		self:_abort_calling_horse()
	end

	if internal.wielding and interrupting_action ~= "wield" and interrupting_action ~= "block" then
		self:_abort_wield()
	end

	if internal.reloading and interrupting_action ~= "reload" then
		self:_abort_reload()
	end

	if internal.aiming and interrupting_action ~= "aim" then
		self:_unaim_ranged_weapon()
	end

	if internal.couching then
		self:_end_couch(t)
	end

	if internal.swing_recovery_time and interrupting_action ~= "rush" then
		self:_end_swing_recovery()
	end

	if internal.crouching and interrupting_action ~= "crouch" and interrupting_action ~= "parry_attempt" and interrupting_action ~= "block" then
		self:_abort_crouch()
	end

	if internal.carried_flag and (interrupting_action == "knocked_down" or interrupting_action == "dead") then
		self:_drop_flag()
	end

	if internal.tagging and (interrupting_action == "state_jumping" or interrupting_action == "knocked_down" or interrupting_action == "dead") then
		self:_abort_tagging()
	end

	if internal.throw_data and interrupting_action ~= "pose_weapon_throw" then
		self._thrown_weapon_component:abort_throw()
	end

	if internal.dodging and interrupting_action ~= "dead" then
		if interrupting_action == "melee_damage" then
			internal.swing_recovery_time = math.max(internal.swing_recovery_time or 0, t + internal.archetype_settings.movement_settings.dodge_interrupt_swing_recovery)
		end

		self:change_state("onground")
	end

	if internal.special_attacking and interrupting_action ~= "dead" then
		if interrupting_action == "melee_damage" then
			internal.swing_recovery_time = math.max(internal.swing_recovery_time or 0, t + internal.archetype_settings.movement_settings.special_attack.interrupt_swing_recovery)
		end

		self:change_state("onground")
	end
end

function PlayerMovementStateBase:_enter_travel_mode(dt, t, input_mode)
	self:safe_action_interrupt("travel_mode")

	local internal = self._internal
	local slot = self:sheathe_wielded_weapon()

	internal.travel_mode = {
		start_time = t,
		sheathed_slot = slot,
		input_mode = input_mode
	}

	local game, id = internal.game, internal.id

	if game and id then
		GameSession.set_game_object_field(game, id, "travel_mode", true)
	end

	local network_manager = Managers.state.network

	if network_manager:game() then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_travel_mode_entered", network_manager:game_object_id(self._unit))
		else
			network_manager:send_rpc_server("rpc_travel_mode_entered", network_manager:game_object_id(self._unit))
		end
	end
end

function PlayerMovementStateBase:sheathe_wielded_weapon()
	local internal = self._internal
	local inventory = internal:inventory()
	local slot_name, anim, anim_time = inventory:sheathe_wielded_weapon()

	internal.sheathing = {
		slot_name = slot_name,
		time = anim_time
	}

	self:anim_event_with_variable_float(anim, "wield_time", anim_time)

	return slot_name
end

function PlayerMovementStateBase:anim_cb_unwield()
	local internal = self._internal

	if not internal.sheathing then
		return
	end

	local inventory = internal:inventory()
	local main_body_state = inventory:set_gear_sheathed(internal.sheathing.slot_name, true, false)

	self:anim_event(main_body_state)
end

function PlayerMovementStateBase:anim_cb_unwield_finished()
	local internal = self._internal

	if not internal.sheathing then
		return
	end

	internal.sheathing = nil

	self:anim_event("wield_finished")
end

function PlayerMovementStateBase:_abort_unsheathing()
	local internal = self._internal
	local unsheathing_data = internal.unsheathing
	local inventory = internal:inventory()
	local slot_name = unsheathing_data.slot_name

	if inventory:is_sheathed(slot_name) then
		self:_unsheathe_weapon(slot_name, true)
	end

	internal.unsheathing = false

	self:anim_event("wield_finished")
end

function PlayerMovementStateBase:_abort_sheathing()
	local internal = self._internal
	local sheathing_data = internal.sheathing
	local inventory = internal:inventory()
	local slot_name = sheathing_data.slot_name

	if not inventory:is_sheathed(slot_name) then
		local inventory = internal:inventory()
		local main_body_state = inventory:set_gear_sheathed(slot_name, true, false)

		self:anim_event(main_body_state)
	end

	internal.sheathing = false

	self:anim_event("wield_finished")
end

function PlayerMovementStateBase:_unsheathe_weapon(slot_name, instant)
	local internal = self._internal

	if instant then
		self:_unsheathe_weapon_instant(slot_name)
	else
		self:_start_unsheathe_weapon(slot_name)
	end
end

function PlayerMovementStateBase:_start_unsheathe_weapon(slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local can_dual_wield = internal:has_perk("berserk_01")
	local wield_anim_event = inventory:weapon_wield_anim(slot_name, can_dual_wield)
	local wield_time = inventory:weapon_wield_time(slot_name, can_dual_wield)

	self:anim_event_with_variable_float(wield_anim_event, "wield_time", wield_time)

	internal.unsheathing = {
		slot_name = slot_name
	}
end

function PlayerMovementStateBase:_unsheathe_weapon_instant(slot_name)
	local internal = self._internal
	local inventory = internal:inventory()
	local main_body_state, hand_anim = inventory:set_gear_sheathed(slot_name, false, false)

	self:anim_event(main_body_state, true)

	if hand_anim then
		self:anim_event(hand_anim, true)
	end
end

function PlayerMovementStateBase:_exit_travel_mode(impact_type, hit_zone, impact_direction)
	local internal = self._internal
	local sheathed_slot = internal.travel_mode.sheathed_slot
	local inventory = internal:inventory()

	if internal.sheathing then
		self:_abort_sheathing()
	end

	if impact_type == "melee_damage" or impact_type == "projectile_damage" then
		self:_unsheathe_weapon(sheathed_slot, true)
		internal:stun(nil, impact_direction, "travel_mode_damage")
	elseif self:can_unsheath_weapon() then
		self:_unsheathe_weapon(internal.travel_mode.sheathed_slot, false)
	else
		self:_unsheathe_weapon(internal.travel_mode.sheathed_slot, true)
	end

	internal.travel_mode = false

	local game, id = internal.game, internal.id

	if game and id then
		GameSession.set_game_object_field(game, id, "travel_mode", false)
	end
end

function PlayerMovementStateBase:_end_swing_recovery()
	self._internal.swing_recovery_time = nil

	self:anim_event("swing_attack_penalty_finished")
end

function PlayerMovementStateBase:_abort_pose()
	local internal = self._internal

	if internal.accumulated_pose then
		internal.accumulated_pose:store(Vector3(0, 0, 0))
	end

	if internal.posing or internal.attempting_pose then
		self:anim_event("swing_pose_exit")
	end

	self:_end_pose()
	self:_play_voice("stop_chr_vce_charge_swing")
	Unit.flow_event(self._unit, "lua_exit_weapon_pose")

	local network_manager = Managers.state.network

	if network_manager:game() then
		local user_object_id = network_manager:unit_game_object_id(self._unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_stop_posing_melee_weapon", user_object_id)
		else
			network_manager:send_rpc_server("rpc_stop_posing_melee_weapon", user_object_id)
		end
	end
end

function PlayerMovementStateBase:_end_pose()
	local internal = self._internal
	local network_manager = Managers.state.network

	internal.pose_riposte = false
	internal.pose_ready = false
	internal.pose_slot_name = nil
	internal.pose_direction = nil
	internal.attempting_pose = false
	internal.posing = false
	internal.charge_blackboard.posing = false
end

function PlayerMovementStateBase:_abort_parry_attempt()
	local internal = self._internal

	if internal.accumulated_parry_direction then
		internal.accumulated_parry_direction:store(Vector3(0, 0, 0))
	end

	internal.attempting_parry = false
end

function PlayerMovementStateBase:_abort_swing(reason)
	local internal = self._internal

	if not internal.swinging then
		return
	end

	local swing_stamina_settings = self:_swing_stamina_settings(internal.swing_slot_name)

	self:anim_event("swing_attack_interrupt", not Managers.lobby.server)

	if reason ~= "hard" then
		self:_play_voice("stop_chr_vce_charge_swing")
	end

	self:swing_finished(reason)

	if reason ~= "interrupt" and not internal.swing_stamina_consumed then
		internal.swing_stamina_consumed = true

		self:stamina_activate(swing_stamina_settings)
	end
end

function PlayerMovementStateBase:_swing_stamina_settings(slot_name)
	return self._internal:inventory():gear(slot_name):settings().swing_stamina_settings or PlayerUnitMovementSettings.swing.stamina_settings
end

function PlayerMovementStateBase:_abort_shield_bash_swing(reason)
	self:shield_bash_swing_finished(reason)
end

function PlayerMovementStateBase:_abort_shield_bash_pose()
	return
end

function PlayerMovementStateBase:_abort_push_swing(reason)
	self:push_swing_finished(reason)
end

function PlayerMovementStateBase:_abort_calling_horse()
	self:finish_calling_horse("interupted")
end

function PlayerMovementStateBase:_abort_reload()
	self:_finish_reloading_weapon(false)
end

function PlayerMovementStateBase:_abort_crouch()
	self:anim_event("to_uncrouch")

	self._internal.crouching = false
end

function PlayerMovementStateBase:wielded_weapon_destroyed(slot_name)
	self:safe_action_interrupt("wielded_weapon_destroyed")

	local inventory = self._internal:inventory()

	if slot_name == "shield" then
		self:anim_event("to_unshield")
	else
		local fallback_slot = inventory:fallback_slot()

		if self:can_wield_weapon(fallback_slot, Managers.time:time("game")) then
			self:_wield_weapon(fallback_slot, false)
		else
			self:_wield_weapon(fallback_slot, true)
		end
	end
end

function PlayerMovementStateBase:_abort_wield()
	local internal = self._internal

	internal.wielding = false

	local primary_wield_slot = internal.wield_slot_name
	local secondary_wield_slot = internal.secondary_wield_slot_name

	internal.secondary_wield_slot_name = nil
	internal.wield_slot_name = nil

	local inventory = internal:inventory()

	if primary_wield_slot and not inventory:is_wielded(primary_wield_slot) then
		self:_set_slot_wielded_instant(primary_wield_slot, true)

		local wield_reload_anim = inventory:wield_reload_anim(primary_wield_slot)

		if wield_reload_anim and inventory:can_reload(primary_wield_slot) then
			internal.reload_slot_name = primary_wield_slot

			self:anim_cb_ready_arrow()
		end
	elseif primary_wield_slot then
		local wield_reload_anim = inventory:wield_reload_anim(primary_wield_slot)

		if wield_reload_anim and inventory:can_reload(primary_wield_slot) then
			internal.reload_slot_name = primary_wield_slot

			self:anim_cb_ready_arrow()
		end
	end

	if secondary_wield_slot and not inventory:is_wielded(secondary_wield_slot) then
		self:_set_slot_wielded_instant(secondary_wield_slot, true)
	end

	internal.wielding = false
	internal.wield_slot_name = nil
	internal.secondary_wield_slot_name = nil

	self:anim_event("wield_finished")
end

function PlayerMovementStateBase:_abort_tagging()
	self._tagging_component:abort_tagging()
end

function PlayerMovementStateBase:_drop_flag()
	local internal = self._internal
	local flag_unit = internal.carried_flag
	local flag_ext = ScriptUnit.extension(flag_unit, "flag_system")

	flag_ext:drop()

	internal.carried_flag = nil

	if internal.id and internal.game then
		local network_manager = Managers.state.network
		local flag_id = network_manager:game_object_id(flag_unit)

		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_drop_flag", internal.id, flag_id)
		else
			network_manager:send_rpc_server("rpc_drop_flag", internal.id, flag_id)
		end
	end
end

function PlayerMovementStateBase:_plant_squad_flag()
	local internal = self._internal

	if internal.game and internal.id then
		local team_id = NetworkLookup.team[internal.player.team.name]
		local squad_id = internal.player.squad_index
		local position = Unit.local_position(self._unit, 0)
		local rotation = Unit.local_rotation(self._unit, 0)

		if Managers.lobby.server or not Managers.state.network:game() then
			local team = internal.player.team
			local squad = team:squad(squad_id)

			squad:server_create_squad_flag(team_id, squad_id, position, rotation)
		end

		if false then
			-- block empty
		end
	end
end

function PlayerMovementStateBase:update_last_stand_camera_effect(dt, t)
	local unit = self._unit
	local internal = self._internal
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	if damage_ext:is_last_stand_active() and not damage_ext.last_stand_camera_effect_active then
		local world = internal.world
		local camera_manager = Managers.state.camera

		damage_ext.last_stand_camera_particle_effect_id = World.create_particles(world, "fx/screenspace_damage_indicator", Vector3(0, 0, 0))

		camera_manager:camera_effect_sequence_event("last_stand_activated", t)

		damage_ext.last_stand_camera_shake_effect_id = camera_manager:camera_effect_shake_event("last_stand_activated", t)
		damage_ext.last_stand_camera_effect_active = true
	elseif not damage_ext:is_last_stand_active() and damage_ext.last_stand_camera_effect_active then
		local camera_manager = Managers.state.camera
		local world = internal.world

		World.destroy_particles(world, damage_ext.last_stand_camera_particle_effect_id)

		damage_ext.last_stand_camera_particle_effect_id = nil

		camera_manager:stop_camera_effect_shake_event(damage_ext.last_stand_camera_shake_effect_id)

		damage_ext.last_stand_camera_shake_effect_id = nil
		damage_ext.last_stand_camera_effect_active = false
	end
end

function PlayerMovementStateBase:update_switch_weapon_grip(dt, t)
	local controller = self._controller
	local inventory = self._internal:inventory()
	local switch_grip_input = controller and controller:get("switch_weapon_grip")

	if switch_grip_input and inventory:can_switch_weapon_grip() and self:_can_switch_weapon_grip(t) then
		if inventory:weapon_grip_switched() then
			self:anim_event("weapon_unflip")
			inventory:set_grip_switched(false)
		else
			self:anim_event("weapon_flip")
			inventory:set_grip_switched(true)
		end
	end
end

function PlayerMovementStateBase:update_call_horse_decals(dt, t)
	local internal = self._internal

	if internal.display_call_horse_overlap_fail == true and t >= internal.call_horse_overlap_fail_timer then
		World.destroy_unit(internal.world, internal.call_horse_top_projector)

		internal.display_call_horse_overlap_fail = false
		internal.call_horse_top_projector = nil
	end
end

function PlayerMovementStateBase:update_parry_helper(dt, t)
	local physics_world = World.physics_world(self._internal.world)
	local callback = callback(self, "cb_near_human")
	local mover = Unit.mover(self._unit)
	local position = Mover.position(mover)

	PhysicsWorld.overlap(physics_world, callback, "position", position, "size", HUDSettings.parry_helper.scan_radius, "types", "dynamics", "collision_filter", "ai_husk_scan")
end

function PlayerMovementStateBase:_clear_parry_helper_direction()
	local parry_helper_blackboard = self._internal.parry_helper_blackboard.attack_direction

	parry_helper_blackboard.attack_left = nil
	parry_helper_blackboard.attack_right = nil
	parry_helper_blackboard.attack_up = nil
end

function PlayerMovementStateBase:_set_parry_helper_direction(unit, level)
	local parry_helper_blackboard = self._internal.parry_helper_blackboard.attack_direction
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	if locomotion.pose_direction == "down" then
		parry_helper_blackboard[ATTACK_LOOKUPS.left] = parry_helper_blackboard[ATTACK_LOOKUPS.left] or level
		parry_helper_blackboard[ATTACK_LOOKUPS.right] = parry_helper_blackboard[ATTACK_LOOKUPS.right] or level
	elseif locomotion.pose_direction then
		parry_helper_blackboard[ATTACK_LOOKUPS[locomotion.pose_direction]] = parry_helper_blackboard[ATTACK_LOOKUPS[locomotion.pose_direction]] or level
	end
end

function PlayerMovementStateBase:cb_near_human(actors)
	self:_clear_parry_helper_direction()

	if HUDSettings.parry_helper.only_show_if_can_parry then
		local inventory = self._internal:inventory()
		local slot_name = inventory:wielded_block_slot()

		if not slot_name or not Application.user_setting("attack_indicators_with_shield") and inventory:block_type(slot_name) ~= "weapon" then
			return
		end
	end

	local nearest_enemy, second_nearest_enemy, third_nearest_enemy = self:_calculate_closest_enemy(actors)

	if nearest_enemy then
		self:_set_parry_helper_direction(nearest_enemy, 1)
	end

	if second_nearest_enemy then
		self:_set_parry_helper_direction(second_nearest_enemy, 2)
	end

	if third_nearest_enemy then
		self:_set_parry_helper_direction(third_nearest_enemy, 3)
	end
end

function PlayerMovementStateBase:_calculate_closest_enemy(actors)
	local own_pos = Unit.world_position(self._unit, 0)
	local nearest_player, nearest_distance = nil, math.huge
	local second_nearest_player, second_nearest_distance = nil, math.huge
	local third_nearest_player, third_nearest_distance = nil, math.huge

	for _, actor in ipairs(actors) do
		local unit = Actor.unit(actor)
		local damage_ext = ScriptUnit.has_extension(unit, "damage_system") and ScriptUnit.extension(unit, "damage_system")

		if damage_ext and damage_ext:is_alive() and Managers.player:owner(unit).team ~= self._internal.player.team then
			local target_pos = Unit.world_position(unit, 0)
			local distance = Vector3.distance(own_pos, target_pos)

			if distance < nearest_distance then
				if self:_parry_helper_eligble(unit, distance) then
					third_nearest_player = second_nearest_player
					third_nearest_distance = second_nearest_distance
					second_nearest_player = nearest_player
					second_nearest_distance = nearest_distance
					nearest_player = unit
					nearest_distance = distance
				end
			elseif distance < second_nearest_distance then
				if self:_parry_helper_eligble(unit, distance) then
					third_nearest_player = second_nearest_player
					third_nearest_distance = second_nearest_distance
					second_nearest_player = unit
					second_nearest_distance = distance
				end
			elseif distance < third_nearest_distance and self:_parry_helper_eligble(unit, distance) then
				third_nearest_player = unit
				third_nearest_distance = distance
			end
		end
	end

	return nearest_player, second_nearest_player, third_nearest_player
end

function PlayerMovementStateBase:_parry_helper_eligble(unit, distance)
	local locomotion = ScriptUnit.extension(unit, "locomotion_system")

	return (HUDSettings.parry_helper.count_not_attacking_enemies or locomotion.pose_direction) and self:_looking_at_eachother(unit, locomotion, distance)
end

function PlayerMovementStateBase:_looking_at_eachother(target_unit, target_locomotion, distance)
	local locomotion = self._internal
	local target_aim_dir = target_locomotion:aim_direction()
	local target_aim_dir_flat = Vector3.normalize(Vector3.flat(target_aim_dir))
	local mover = Unit.mover(self._unit)
	local position = Mover.position(mover)
	local target_position = Unit.world_position(target_unit, 0)
	local difference_vector_flat = Vector3.normalize(Vector3.flat(target_position - position))
	local enemy_looking = Vector3.dot(target_aim_dir_flat, difference_vector_flat) < 0

	if not enemy_looking then
		return false
	end

	local aim_dir = locomotion:aim_direction()
	local aim_dir_flat = Vector3.normalize(Vector3.flat(aim_dir))
	local inner_angle = HUDSettings.parry_helper.inner_activation_angle
	local outer_angle = HUDSettings.parry_helper.activation_angle
	local outer_radius = HUDSettings.parry_helper.scan_radius
	local inner_radius = HUDSettings.parry_helper.inner_activation_radius
	local self_vision_angle = math.auto_lerp(inner_radius, outer_radius, inner_angle, outer_angle, math.clamp(distance, inner_radius, outer_radius))
	local relative_angle = ((math.atan2(aim_dir_flat.x, aim_dir_flat.y) - math.atan2(difference_vector_flat.x, difference_vector_flat.y) + math.pi) % (math.pi * 2) - math.pi) * (180 / math.pi)

	if script_data.parry_debug then
		Managers.state.debug_text:output_screen_text(string.format("relative: %.2f allowed: %.2f", relative_angle, self_vision_angle), 14, nil)
	end

	return math.abs(relative_angle) < self_vision_angle * 0.5
end

function PlayerMovementStateBase:_update_ranged_weapon_zoom(dt, t, slot_name)
	local internal = self._internal
	local perk_name = "bow_zoom"

	if internal:has_perk(perk_name) then
		internal:set_perk_state(perk_name, "ready")

		local perk_activation_command = internal:perk_activation_command(perk_name)
		local controller = self._controller
		local zoom_input = controller and controller:get(perk_activation_command)
		local current_value = internal.ranged_weapon_zoom_value

		if zoom_input then
			if current_value == 0 then
				internal.ranged_weapon_zoom_value = 1
			elseif current_value == 1 then
				internal.ranged_weapon_zoom_value = 0
			end
		end
	end

	local viewport_name = internal.player.viewport_name
	local camera_manager = Managers.state.camera

	camera_manager:set_variable(viewport_name, "aim_zoom", internal.ranged_weapon_zoom_value)

	if self._internal:has_perk("auto_aim") then
		local tagged_unit_id = GameSession.game_object_field(internal.game, internal.player.game_object_id, "tagged_player_object_id")
		local tagged_unit = Managers.state.network:game_object_unit(tagged_unit_id)

		if tagged_unit and ScriptUnit.has_extension(tagged_unit, "locomotion_system") then
			local inventory = internal:inventory()
			local gear = inventory:gear(slot_name)
			local gear_unit = gear:unit()
			local gear_settings = Unit.get_data(gear_unit, "attacks").ranged
			local projectile_speed = gear_settings.speed_max
			local projectile_name = gear:extensions().base:projectile_name()
			local projectile_pos = WeaponHelper:projectile_fire_position_from_ranged_weapon(gear_unit, self._unit, projectile_name)
			local aim_unit = tagged_unit
			local aim_node = Unit.node(aim_unit, "Neck")
			local aim_unit_pos = Unit.world_position(aim_unit, aim_node) + Vector3(0, 0, 0.15)
			local offset_to_target = aim_unit_pos - projectile_pos
			local travel_time = Vector3.length(offset_to_target) / projectile_speed
			local target_vel = ScriptUnit.extension(aim_unit, "locomotion_system"):get_velocity()
			local target = aim_unit_pos + target_vel * travel_time
			local angle_1, angle_2 = WeaponHelper:wanted_projectile_angle(offset_to_target, ProjectileSettings.gravity:unbox()[3], projectile_speed)
			local projectile_angle = angle_1 and angle_2 and math.min(angle_1, angle_2) or nil
			local current_angle = math.atan2(target.z - projectile_pos.z, Vector3.length(Vector3.flat(target) - Vector3.flat(projectile_pos)))
			local extra_angle = projectile_angle - current_angle
			local target_height = math.tan(extra_angle) * Vector3.length(Vector3.flat(target) - Vector3.flat(projectile_pos))

			target = Vector3(target.x, target.y, target.z + target_height)

			local drawer = Managers.state.debug:drawer({
				mode = "immediate",
				name = "target sphere"
			})

			drawer:sphere(target, 0.12, Color(255, 255, 0))
		end
	end
end

function PlayerMovementStateBase:_update_breathing_state(dt, t, slot_name)
	local controller = self._controller
	local hold_breath_input = controller and controller:get("hold_breath") > BUTTON_THRESHOLD
	local internal = self._internal
	local inventory = internal:inventory()
	local current_breathing_state = internal.current_breathing_state
	local next_breathing_state = current_breathing_state
	local gear = inventory:gear(slot_name)
	local settings = gear:settings()
	local timpani_world = World.timpani_world(self._internal.world)

	if t >= internal.breathing_transition_time then
		if current_breathing_state == "normal" and hold_breath_input then
			next_breathing_state = "held"
			internal.hold_breath_timer = t + settings.length_of_breath_hold

			self:_play_voice("chr_vce_aim_enter")
		elseif current_breathing_state == "held" and not hold_breath_input then
			next_breathing_state = "normal"

			self:_play_voice("chr_vce_aim_exit_new")
		elseif current_breathing_state == "held" and t >= internal.hold_breath_timer then
			next_breathing_state = "fast"

			self:_play_voice("chr_vce_aim_choke_new")
		elseif current_breathing_state == "fast" then
			next_breathing_state = "normal"
		end
	end

	self:_update_sway_camera(dt, t, settings, current_breathing_state, next_breathing_state)
end

function PlayerMovementStateBase:_update_sway_camera(dt, t, settings, current_breathing_state, next_breathing_state)
	local internal = self._internal

	if current_breathing_state ~= next_breathing_state then
		local transition_time = settings.sway["breath_" .. current_breathing_state].transition_time_to["breath_" .. next_breathing_state]

		internal.breathing_transition_time = t + transition_time
		internal.breathing_transition_increments = self:_calculate_transition_increments(t, settings, current_breathing_state, next_breathing_state, transition_time)
		internal.breathing_transition = true
		internal.current_breathing_state = next_breathing_state
	end

	if internal.breathing_transition and t >= internal.breathing_transition_time then
		internal.breathing_transition = false
		internal.current_sway_settings = table.clone(settings.sway["breath_" .. next_breathing_state])
	elseif internal.breathing_transition then
		self:_update_breathing_transition(dt)
	end

	local current_sway_settings = internal.current_sway_settings
	local sway_camera_settings = internal.sway_camera
	local current_pitch_angle = sway_camera_settings.pitch_angle
	local current_yaw_angle = sway_camera_settings.yaw_angle
	local pitch_speed = self:_calculate_pitch_speed(current_pitch_angle)

	sway_camera_settings.pitch_angle = self:_increment_angle(dt, current_pitch_angle, pitch_speed, current_sway_settings.time.vertical)
	sway_camera_settings.yaw_angle = self:_increment_angle(dt, current_yaw_angle, 360, current_sway_settings.time.horizontal)

	local pitch_angle = sway_camera_settings.pitch_angle
	local yaw_angle = sway_camera_settings.yaw_angle

	self:_update_breathing_sounds(pitch_angle, internal.current_breathing_state)

	local offset_pitch = current_sway_settings.distance.vertical * (math.sin(pitch_angle) / 180) * math.pi
	local offset_yaw = current_sway_settings.distance.horizontal * (math.sin(yaw_angle) / 180) * math.pi
	local offset_pitch_rot = Quaternion(Vector3.right(), offset_pitch)
	local offset_yaw_rot = Quaternion(Vector3.up(), offset_yaw)
	local final_rot = QuaternionBox()

	final_rot:store(Quaternion.multiply(offset_yaw_rot, offset_pitch_rot))
	Managers.state.camera:set_variable(internal.player.viewport_name, "final_rotation", final_rot)
end

function PlayerMovementStateBase:_calculate_transition_increments(t, settings, current_breathing_state, next_breathing_state, transition_time)
	local transition_increments = {}
	local current_sway_settings = settings.sway["breath_" .. current_breathing_state]
	local next_sway_settings = settings.sway["breath_" .. next_breathing_state]

	for modifier, modifier_table in pairs(current_sway_settings) do
		if modifier == "time" or modifier == "distance" then
			transition_increments[modifier] = {}

			for direction, current_value in pairs(modifier_table) do
				local new_value = next_sway_settings[modifier][direction]
				local difference = new_value - current_value

				transition_increments[modifier][direction] = difference / transition_time
			end
		end
	end

	return transition_increments
end

function PlayerMovementStateBase:_update_breathing_transition(dt)
	local internal = self._internal

	for modifier, modifier_table in pairs(internal.breathing_transition_increments) do
		for direction, value in pairs(modifier_table) do
			internal.current_sway_settings[modifier][direction] = internal.current_sway_settings[modifier][direction] + value * dt
		end
	end
end

function PlayerMovementStateBase:_increment_angle(dt, angle, increment_value, sway_time)
	local value = increment_value * (1 / sway_time)

	if angle >= math.pi * 2 then
		return value / 180 * math.pi * dt
	else
		return angle + value / 180 * math.pi * dt
	end
end

function PlayerMovementStateBase:_calculate_pitch_speed()
	local internal = self._internal
	local pitch_angle = internal.sway_camera.pitch_angle
	local pitch_speed = 0

	pitch_speed = pitch_angle > math.pi / 2 and pitch_angle < math.pi * 3 / 2 and 720 or pitch_angle > math.pi / 2 - math.pi / 4 and pitch_angle < math.pi / 2 and 450 or 360

	return pitch_speed
end

function PlayerMovementStateBase:anim_cb_knockdown_finished()
	return
end

function PlayerMovementStateBase:_update_breathing_sounds(angle, state)
	local internal = self._internal
	local value = math.pi / 2
	local timpani_world = World.timpani_world(internal.world)
	local sway_camera_settings = internal.sway_camera
	local previous_angle = sway_camera_settings.previous_angle

	if state == "normal" and not internal.breathing_transition then
		if value <= angle and previous_angle < value then
			local event_id = TimpaniWorld.trigger_event(timpani_world, "chr_vce_breathe_down")
		elseif angle >= math.pi + value and previous_angle < math.pi + value then
			local event_id = TimpaniWorld.trigger_event(timpani_world, "chr_vce_breathe_up")
		end
	end

	sway_camera_settings.previous_angle = angle
end

function PlayerMovementStateBase:react_to_blademaster_parry()
	self:_wield_weapon("dagger")
end
