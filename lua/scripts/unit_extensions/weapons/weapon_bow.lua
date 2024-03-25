-- chunkname: @scripts/unit_extensions/weapons/weapon_bow.lua

require("scripts/helpers/weapon_helper")
require("scripts/unit_extensions/weapons/weapon_bow_base")

WeaponBow = class(WeaponBow, WeaponBowBase)

function WeaponBow:init(world, unit, user_unit, player, id, user_locomotion)
	WeaponBow.super.init(self, world, unit, user_unit, player, id, user_locomotion)

	self._ai_gear = false
	self._player_gear = true
	self._firing_event = true
	self._properties = {}
	self._stop_aim_timer = nil
	self._aim_start_time = 0
	self._aim_shake_start_time = nil
	self._loaded = false
	self._breath_up_sound = true
	self._arm_shake_sound = true
end

function WeaponBow:ready_projectile(slot_name)
	WeaponBow.super.ready_projectile(self, slot_name)

	local projectile_name = self:projectile_name()
	local network_manager = Managers.state.network
	local user_unit_game_object_id = network_manager:game_object_id(self._user_unit)

	if user_unit_game_object_id and network_manager:game() then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_ready_projectile", user_unit_game_object_id, NetworkLookup.inventory_slots[slot_name], NetworkLookup.projectiles[projectile_name])
		else
			network_manager:send_rpc_server("rpc_ready_projectile", user_unit_game_object_id, NetworkLookup.inventory_slots[slot_name], NetworkLookup.projectiles[projectile_name])
		end
	end

	self._breath_up_sound = true
	self._arm_shake_sound = true
	self._aim_shake_start_time = nil
end

function WeaponBow:start_release_projectile(slot_name, draw_time, callback, t)
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
	local attack_settings = self._settings.attacks.ranged
	local bow_charge_time_multiplier = locomotion:has_perk("light_02") and Perks.light_02.bow_charge_time_multiplier or 1
	local charge_speed_multiplier = locomotion.perk_fast_aim_charge.faster_bow_charge.can_use and Perks.faster_bow_charge.charge_speed_multiplier or 1
	local ready_bow_time = attack_settings.bow_draw_time * charge_speed_multiplier * bow_charge_time_multiplier
	local draw_bow_time = attack_settings.bow_tense_time * charge_speed_multiplier
	local bow_shake_time = attack_settings.bow_shake_time * charge_speed_multiplier
	local hold_time = locomotion:has_perk("piercing_shots") and attack_settings.hold_time * Perks.piercing_shots.charge_buffer_multiplier or attack_settings.hold_time
	local charge_factor, charge_value = self:_charge_factor(draw_time, ready_bow_time, draw_bow_time, bow_shake_time, hold_time)

	if self._ai_gear or charge_factor > 0 then
		self:release_projectile(slot_name, charge_factor)
	else
		local timpani_world = self._timpani_world
		local fail_fire_sound_event = self._fail_fire_sound_event
		local event_id = TimpaniWorld.trigger_event(timpani_world, fail_fire_sound_event)

		TimpaniWorld.set_parameter(timpani_world, event_id, "shot", "shot_stereo")
		callback(self._weapon_category)
	end
end

function WeaponBow:release_projectile(slot_name, charge_factor)
	WeaponBow.super.release_projectile(self, slot_name, charge_factor)

	local gear_unit = self._unit
	local user_unit = self._user_unit
	local projectile_name = self:projectile_name()
	local projectile_position, projectile_velocity, dir

	if not self._ai_gear then
		projectile_position = WeaponHelper:projectile_fire_position_from_camera(gear_unit, user_unit, self._projectile_settings)
		projectile_velocity, dir = WeaponHelper:bow_projectile_fire_velocity_from_camera(gear_unit, user_unit)
	else
		local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
		local ai_profile = ScriptUnit.extension(user_unit, "ai_system"):profile()
		local accuracy = 1 - ai_profile.properties.accuracy
		local error_pitch = accuracy * ai_profile.properties.max_vertical_spread
		local error_yaw = accuracy * ai_profile.properties.max_horizontal_spread
		local look_target = locomotion:look_target()

		projectile_position = WeaponHelper:projectile_fire_position_from_ranged_weapon(gear_unit, user_unit, self._projectile_settings)

		local aim_direction = Vector3.normalize(look_target - projectile_position)
		local aim_direction_flat = Vector3.flat(aim_direction)
		local rotator = Quaternion.multiply(Quaternion(Vector3.right(), locomotion.projectile_angle), Quaternion(Vector3.right(), (Math.random() - 0.5) * 2 * (error_pitch / 180 * math.pi)))
		local aim_look = Quaternion.multiply(Quaternion.look(aim_direction_flat, Vector3.up()), Quaternion(Vector3.up(), (Math.random() - 0.5) * 2 * (error_yaw / 180 * math.pi)))
		local aim_look_rotated = Quaternion.multiply(aim_look, rotator)
		local aim_look_rotated_forward = Quaternion.forward(aim_look_rotated)

		dir = aim_look_rotated_forward
		projectile_velocity = WeaponHelper:projectile_fire_velocity_from_bow(gear_unit, aim_look_rotated_forward, draw_time)
	end

	self:fire(projectile_position, projectile_velocity, dir, charge_factor)

	local network_manager = Managers.state.network
	local user_unit_game_object_id = network_manager:game_object_id(self._user_unit)

	if user_unit_game_object_id then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_release_projectile", user_unit_game_object_id, NetworkLookup.inventory_slots[slot_name])
		else
			network_manager:send_rpc_server("rpc_release_projectile", user_unit_game_object_id, NetworkLookup.inventory_slots[slot_name])
		end
	end
end

function WeaponBow:fire(projectile_position, projectile_velocity, forward_direction, charge_value)
	local projectile_name = self:projectile_name()
	local gear_name = self._gear_name
	local network_manager = Managers.state.network
	local unit = self._unit
	local user_unit = self._user_unit
	local user_velocity = WeaponHelper:locomotion_velocity(user_unit)
	local exit_velocity = projectile_velocity + forward_direction * Vector3.dot(user_velocity, forward_direction)
	local gravity_multiplier = 1
	local player = self._player

	self._aiming = false

	local locomotion = ScriptUnit.extension(user_unit, "locomotion_system")
	local faster_bow_charge_active = locomotion.perk_fast_aim_charge.faster_bow_charge.can_use

	if network_manager:game() then
		local user_object_id = network_manager:game_object_id(user_unit)
		local bow_object_id = network_manager:game_object_id(unit)
		local projectile_name_id = NetworkLookup.projectiles[projectile_name]
		local gear_name_id = NetworkLookup.inventory_gear[gear_name]
		local player_index = player:player_id()

		network_manager:send_rpc_server("rpc_spawn_projectile", player_index, user_object_id, bow_object_id, projectile_name_id, gear_name_id, projectile_position, exit_velocity, gravity_multiplier, charge_value, self:_projectile_properties_id(self._properties), faster_bow_charge_active)
	else
		local projectile_unit_name = self._projectile_settings.unit
		local projectile_rotation = Quaternion.look(exit_velocity, Vector3.up())
		local projectile_unit = World.spawn_unit(self._world, projectile_unit_name, projectile_position, projectile_rotation)
		local player_index = player.index

		Managers.state.entity:register_unit(self._world, projectile_unit, player_index, user_unit, unit, false, network_manager:game(), projectile_name, gear_name, exit_velocity, gravity_multiplier, charge_value, self:_projectile_properties_id(self._properties), faster_bow_charge_active)
	end
end

function WeaponBow:_play_fire_sound(charge_factor)
	if self._ai_gear then
		WeaponBow.super._play_fire_sound(self, charge_factor)
	else
		local timpani_world = self._timpani_world
		local fire_sound_event = charge_factor == 1 and self._fire_sound_event_full_charge or self._fire_sound_event
		local event_id = TimpaniWorld.trigger_event(timpani_world, fire_sound_event)

		TimpaniWorld.set_parameter(timpani_world, event_id, "shot", "shot_stereo")

		local event_id = TimpaniWorld.trigger_event(timpani_world, "Stop_draw_bow", self._unit)
	end
end

function WeaponBow:update(dt, t)
	WeaponBow.super.update(self, dt, t)
	self:_update_ammunition(dt, t)

	if self._aiming then
		self:update_aim(dt, t)
	end

	if self._stop_aim_timer and t >= self._stop_aim_timer then
		self._stop_aim_timer = nil
	end
end

function WeaponBow:can_aim()
	return not self._stop_aim_timer
end

function WeaponBow:unaim()
	if not self._ai_gear then
		local user_unit_locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")

		self:_end_charge(user_unit_locomotion)

		self._aiming = false
	end

	self._aim_shake_start_time = nil

	return WeaponBow.super.unaim(self)
end

function WeaponBow:aim(t)
	if not self._ai_gear then
		local user_unit = self._user_unit

		self._aiming = true

		local user_unit_locomotion = ScriptUnit.extension(user_unit, "locomotion_system")

		self:_start_charge(user_unit_locomotion)

		self._aim_start_time = t
		self._tighten_sound_played = false
		self._loosen_sound_played = false
		self._draw_bow_ready_sound_played = false
	end

	return WeaponBow.super.aim(self)
end

function WeaponBow:_start_charge(locomotion)
	local blackboard = locomotion.charge_blackboard

	blackboard.aiming = true
end

function WeaponBow:_end_charge(locomotion)
	local blackboard = locomotion.charge_blackboard

	blackboard.aiming = false
end

function WeaponBow:_charge_factor(aim_time, ready_bow_time, draw_bow_time, bow_shake_time, hold_time)
	local t = Managers.time:time("game")
	local charge_factor, charge_value
	local total_aim_time = ready_bow_time + draw_bow_time
	local overcharge_value = 0

	if total_aim_time < aim_time then
		local extra_aim_time = (aim_time - total_aim_time) % (bow_shake_time + hold_time)

		if extra_aim_time <= hold_time then
			charge_factor = 1
			charge_value = 1
			overcharge_value = 2 * (0.5 - math.abs(0.5 - extra_aim_time / hold_time))
		else
			extra_aim_time = extra_aim_time - hold_time
			charge_factor = 1 - 0.55 * (0.5 + 0.5 * math.cos((1 + 2 * extra_aim_time / bow_shake_time) * math.pi))
			charge_value = math.lerp(ready_bow_time / total_aim_time, 1, charge_factor)
		end
	else
		charge_factor = math.max((aim_time - ready_bow_time) / draw_bow_time, 0)
		charge_value = aim_time / total_aim_time
	end

	return charge_factor, charge_value, overcharge_value
end

function WeaponBow:_update_charge(dt, t, locomotion, aim_start_time, ready_bow_time, draw_bow_time, bow_shake_time, hold_time)
	local blackboard = locomotion.charge_blackboard
	local aim_time = t - aim_start_time
	local charge_factor, charge_value, overcharge_value = self:_charge_factor(aim_time, ready_bow_time, draw_bow_time, bow_shake_time, hold_time)

	if charge_value == 1 and locomotion:has_perk("piercing_shots") then
		locomotion:set_perk_state("piercing_shots", "active")
	end

	local timpani_world = World.timpani_world(self._world)

	if not self._draw_bow_ready_sound_played and t > aim_start_time + ready_bow_time then
		local event_id = TimpaniWorld.trigger_event(timpani_world, "draw_bow_ready")

		self._draw_bow_ready_sound_played = true
	end

	if not self._tighten_sound_played and t > aim_start_time + ready_bow_time + draw_bow_time - self._settings.attacks.ranged.tighten_sound_length then
		self._tighten_sound_played = true

		local event_id = TimpaniWorld.trigger_event(timpani_world, "draw_bow_tighten")
	elseif self._tighten_sound_played and not self._loosen_sound_played and t > aim_start_time + ready_bow_time + draw_bow_time + hold_time then
		self._loosen_sound_played = true

		local event_id = TimpaniWorld.trigger_event(timpani_world, "draw_bow_loosen")

		self._sound_state = "loose"
	end

	if self._tighten_sound_played and self._loosen_sound_played then
		local remaining_time = aim_time - (ready_bow_time + draw_bow_time + hold_time)
		local loop_time = remaining_time % (bow_shake_time + hold_time)

		if self._sound_state == "loose" and loop_time > bow_shake_time - self._settings.attacks.ranged.tighten_sound_length then
			self._sound_state = "tight"

			local event_id = TimpaniWorld.trigger_event(timpani_world, "draw_bow_tighten")
		elseif self._sound_state == "tight" and loop_time < bow_shake_time - self._settings.attacks.ranged.tighten_sound_length then
			self._sound_state = "loose"

			local event_id = TimpaniWorld.trigger_event(timpani_world, "draw_bow_loosen")
		end
	end

	blackboard.aiming = true
	blackboard.minimum_charge_value = ready_bow_time / (ready_bow_time + draw_bow_time)
	blackboard.charge_value = charge_value
	blackboard.overcharge_value = overcharge_value
end

function WeaponBow:update_aim(dt, t)
	local attack_settings = self._settings.attacks.ranged
	local locomotion = ScriptUnit.extension(self._user_unit, "locomotion_system")
	local bow_charge_time_multiplier = locomotion:has_perk("light_02") and Perks.light_02.bow_charge_time_multiplier or 1
	local charge_speed_multiplier = locomotion.perk_fast_aim_charge.faster_bow_charge.can_use and Perks.faster_bow_charge.charge_speed_multiplier or 1
	local ready_bow_time = attack_settings.bow_draw_time * charge_speed_multiplier * bow_charge_time_multiplier
	local draw_bow_time = attack_settings.bow_tense_time * charge_speed_multiplier
	local bow_shake_time = attack_settings.bow_shake_time * charge_speed_multiplier
	local hold_time = locomotion:has_perk("piercing_shots") and attack_settings.hold_time * Perks.piercing_shots.charge_buffer_multiplier or attack_settings.hold_time
	local aim_start_time = self._aim_start_time

	self:_update_charge(dt, t, locomotion, aim_start_time, ready_bow_time, draw_bow_time, bow_shake_time, hold_time)

	if t <= aim_start_time + draw_bow_time + ready_bow_time and self._breath_up_sound then
		local timpani_world = World.timpani_world(self._world)
		local event_id = TimpaniWorld.trigger_event(timpani_world, "chr_vce_breathe_up")

		self._breath_up_sound = false
	end
end

function WeaponBow:_bow_shake_speed(t, hit_section_halved, bow_shake_time)
	if self._arm_shake_sound then
		local timpani_world = World.timpani_world(self._world)

		self._arm_shake_sound = false
		self._aim_shake_start_time = t
	end

	return hit_section_halved / bow_shake_time * -1
end

function WeaponBow:_force_lower_aim(t)
	local timpani_world = World.timpani_world(self._world)

	self._stop_aim_timer = t + 0.4
	self._needs_unaiming = true

	local event_id = TimpaniWorld.trigger_event(timpani_world, "chr_vce_breathe_down")
end

function WeaponBow:set_wielded(wielded)
	WeaponBow.super.set_wielded(self, wielded)

	if not self._husk_gear then
		local player = self._player

		if wielded then
			Managers.state.event:trigger("bow_wielded", player, self._hud_ammo_counter_blackboard)
		else
			Managers.state.event:trigger("bow_unwielded", player)

			self._loaded = false
		end
	end
end

function WeaponBow:set_sheathed(sheathed)
	WeaponBow.super.set_sheathed(self, sheathed)

	if not self._husk_gear and sheathed then
		self._loaded = false
	end
end

function WeaponBow:fire_anim_name()
	return not self:can_reload() and WeaponBow.super.fire_anim_name(self)
end
