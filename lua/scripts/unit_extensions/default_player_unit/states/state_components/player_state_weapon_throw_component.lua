-- chunkname: @scripts/unit_extensions/default_player_unit/states/state_components/player_state_weapon_throw_component.lua

PlayerStateWeaponThrowComponent = class(PlayerStateWeaponThrowComponent)

local BUTTON_THRESHOLD = 0.5

function PlayerStateWeaponThrowComponent:init(unit, internal, state)
	self._data = internal
	self._state = state
	self._unit = unit
end

function PlayerStateWeaponThrowComponent:update(dt, t, controller)
	local data = self._data
	local inventory = data:inventory()
	local has_perk = data:has_perk("throw_all_weps")
	local can_throw, slot = inventory:can_throw(has_perk)
	local throw_input = controller and (controller:get("throw_weapon") > BUTTON_THRESHOLD or can_throw and inventory:is_wielded(slot) and inventory:gear(slot):settings().category == "throwing_weapon" and controller:get("melee_pose") > BUTTON_THRESHOLD)
	local throw_cancel_input = controller and controller:get("block") > BUTTON_THRESHOLD

	if data.throw_data and data.throw_data.state ~= "wielding" and throw_cancel_input then
		self:abort_throw()

		return
	end

	if can_throw and not throw_cancel_input then
		if has_perk then
			if throw_input then
				data:set_perk_state("throw_all_weps", "active")
			elseif self:can_pose_weapon_throw(t) then
				data:set_perk_state("throw_all_weps", "ready")
			else
				data:set_perk_state("throw_all_weps", "default")
			end
		end

		if not inventory:is_wielded(slot) and self._state:can_wield_weapon(slot, t) and self:can_pose_weapon_throw(t) and throw_input then
			self._state:safe_action_interrupt("wield")
			self._state:_wield_weapon(slot)

			data.throw_data = {
				state = "wielding"
			}

			return
		end
	end

	if (throw_input and not throw_cancel_input or data.throw_data and data.throw_data.state == "wielding") and can_throw and self:can_pose_weapon_throw(t) then
		self:_pose_weapon_throw(dt, t, slot)
	elseif not throw_input and self:can_start_weapon_throw(t) then
		self:_start_weapon_throw(dt, t)
	elseif self:can_release_weapon_throw(t) then
		self:_release_weapon_throw(dt, t)
	elseif self:throw_finished(t) then
		self:_end_throw(t)
	end

	if script_data.throw_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "immediate",
			name = "throw"
		})
		local state = data.throw_data and data.throw_data.state or "none"
		local color = state == "none" and Color(125, 125, 125) or state == "posing" and (t > data.throw_data.pose_time and Color(255, 0, 0) or Color(125, 0, 0)) or state == "throwing" and Color(255, 0, 255) or state == "released_weapon" and Color(0, 255, 0) or Color(0, 0, 0)

		drawer:sphere(Unit.local_position(self._unit, 0) + Vector3(0, 0, 2), 0.05, color)
	end
end

function PlayerStateWeaponThrowComponent:can_pose_weapon_throw(t)
	local data = self._data
	local can_pose = not data.travel_mode and not data.unsheathing and not data.sheathing and (not data.throw_data or data.throw_data.state == "wielding") and t > data.anim_forced_upper_body_block and not data.wielding and not data.posing and not data.swinging and not data.pose_ready and not data.blocking and not data.parrying and not data.attempting_parry and (not data.swing_recovery_time or t > data.swing_recovery_time) and not data.ghost_mode

	return can_pose
end

function PlayerStateWeaponThrowComponent:can_start_weapon_throw(t)
	local data = self._data
	local throw_data = data.throw_data

	return throw_data and throw_data.state == "posing" and t > throw_data.pose_time
end

function PlayerStateWeaponThrowComponent:can_release_weapon_throw(t)
	local data = self._data
	local throw_data = data.throw_data

	return throw_data and throw_data.state == "throwing" and t > throw_data.throw_release_time
end

function PlayerStateWeaponThrowComponent:throw_finished(t)
	local data = self._data
	local throw_data = data.throw_data

	return throw_data and throw_data.state == "released_weapon" and t > throw_data.throw_end_time
end

function PlayerStateWeaponThrowComponent:_pose_weapon_throw(dt, t, slot, multiple_throw)
	local data = self._data

	self._state:safe_action_interrupt("pose_weapon_throw")

	local throw_settings = data:inventory():gear(slot):settings().attacks.throw

	data.throw_data = {
		state = "posing",
		multiple_throw = not data.throw_data and true,
		pose_time = t + throw_settings.pose_duration,
		throw_duration = throw_settings.throw_duration,
		release_factor = throw_settings.release_factor,
		throw_release_time = math.huge,
		throw_end_time = math.huge,
		slot = slot,
		camera_node = throw_settings.camera_node,
		full_body = throw_settings.full_body
	}

	self._state:anim_event_with_variable_float("throw_pose_start", "throw_pose_time", throw_settings.pose_duration)
end

function PlayerStateWeaponThrowComponent:full_body_animation()
	local throw_data = self._data.throw_data

	return throw_data and throw_data.full_body and (throw_data.state == "throwing" or throw_data.state == "released_weapon")
end

function PlayerStateWeaponThrowComponent:_start_weapon_throw(dt, t)
	local data = self._data
	local throw_data = data.throw_data
	local throw_duration = throw_data.throw_duration
	local release_factor = throw_data.release_factor

	throw_data.state = "throwing"
	throw_data.throw_release_time = t + throw_duration * release_factor
	throw_data.throw_end_time = t + throw_duration

	self._state:anim_event_with_variable_float("throw", "throw_time", throw_duration)
end

function PlayerStateWeaponThrowComponent:_release_weapon_throw(dt, t)
	local data = self._data
	local throw_data = data.throw_data

	throw_data.state = "released_weapon"

	local inventory = data:inventory()
	local gear = inventory:gear(throw_data.slot)
	local gear_unit = gear:unit()
	local gear_position = Unit.world_position(gear_unit, 0)
	local camera_rot = Managers.state.camera:camera_rotation(data.player.viewport_name)
	local camera_pos = Managers.state.camera:camera_position(data.player.viewport_name)
	local camera_right = Quaternion.right(camera_rot)
	local offset = Vector3.dot(camera_pos, camera_right) - Vector3.dot(gear_position, camera_right)
	local position = gear_position + offset * camera_right
	local throw_settings = inventory:gear(throw_data.slot):settings().attacks.throw
	local speed = throw_settings.speed_max
	local exit_velocity = Quaternion.forward(Quaternion.multiply(Managers.state.camera:aim_rotation(data.player.viewport_name), Quaternion(Vector3.right(), throw_settings.rotation_offset))) * speed
	local rotation = Quaternion.multiply(Quaternion.look(exit_velocity, Vector3.up()), throw_settings.initial_rotation_offset:unbox())

	gear:throw(position, rotation, exit_velocity)
end

function PlayerStateWeaponThrowComponent:_end_throw()
	local data = self._data
	local inventory = data:inventory()

	self._state:anim_event("throw_pose_exit")

	local multiple_throw = data.throw_data.multiple_throw

	if data.throw_data.state ~= "released_weapon" then
		data.throw_data = nil

		if not multiple_throw then
			local fallback_slot = inventory:fallback_slot()

			if self._state:can_wield_weapon(fallback_slot, Managers.time:time("game")) then
				self._state:_wield_weapon(fallback_slot)
			else
				self._state:_set_slot_wielded_instant(fallback_slot, true)
			end
		end

		return
	end

	local gear = inventory:gear(data.throw_data.slot)

	gear:_set_thrown(false)

	data.throw_data = nil

	if gear:ammo() <= 0 or not multiple_throw then
		local fallback_slot = inventory:fallback_slot()

		if self._state:can_wield_weapon(fallback_slot, Managers.time:time("game")) then
			self._state:_wield_weapon(fallback_slot)
		else
			self._state:_set_slot_wielded_instant(fallback_slot, true)
		end
	end
end

function PlayerStateWeaponThrowComponent:abort_throw()
	self:_end_throw()
end
