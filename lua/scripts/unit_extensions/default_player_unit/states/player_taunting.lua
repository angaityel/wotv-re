-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_taunting.lua

require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component")

PlayerTaunting = class(PlayerTaunting, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerTaunting:init(unit, internal, world)
	PlayerTaunting.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerTaunting:update(dt, t)
	PlayerTaunting.super.update(self, dt, t)

	local attack_settings = self._attack_settings

	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	local move = self._controller and Vector3.length(self._controller:get("move")) > 0

	if (t > self._end_time or t > self._voluntary_end_time and move) and not self._transition then
		self._transition = "onground"
	end

	if self:_inair_check(dt, t) then
		self:anim_event("to_inair")

		self._transition = "inair"
	end

	if self._transition then
		self:change_state(self._transition)

		self._transition = nil
	end
end

function PlayerTaunting:enter(old_state, data)
	PlayerTaunting.super.enter(self, old_state)

	local stamina_settings = data.stamina_settings or {
		minimum_activation_cost = 0,
		activation_delay = 0,
		activation_cost = 0
	}
	local internal = self._internal
	local t = Managers.time:time("game")

	self._start_time = t
	self._end_time = data.loop and math.huge or data.duration + t
	self._voluntary_end_time = data.minimum_duration + t

	self:anim_event(data.start_anim_event)

	self._data = data

	self:_align_to_camera()
	self:stamina_activate(stamina_settings)

	if data.starting_rotation then
		self:set_target_world_rotation(data.starting_rotation)
	end

	self:_unwield_shield()
end

function PlayerTaunting:_unwield_shield()
	local inventory = self._internal:inventory()

	self._shield_wielded = inventory:is_wielded("shield")

	if self._shield_wielded then
		self._shield_wielded = true

		self:_set_slot_wielded_instant("shield", false)
	end
end

function PlayerTaunting:exit(new_state)
	PlayerTaunting.super.exit(self, new_state)
	self:anim_event(self._data.end_anim_event)

	if self._shield_wielded and self._internal:inventory():gear("shield") then
		self:_set_slot_wielded_instant("shield", true)
	end
end

function PlayerTaunting:update_movement(dt)
	local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerTaunting:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerTaunting:update_aim_target(dt, t)
	local unit = self._unit
	local camera_manager = Managers.state.camera
	local viewport_name = Unit.get_data(unit, "viewport_name")

	if viewport_name and self._attacking then
		local internal = self._internal
		local aim_from_pos = Mover.position(Unit.mover(unit)) + Unit.local_position(unit, Unit.node(unit, "camera_attach"))
		local aim_rotation = camera_manager:aim_rotation(viewport_name)

		aim_rotation = self:_constrain_to_character_rotation(aim_rotation)

		self._aim_target_interpolation_source:store(aim_rotation)

		local max_z = 2
		local dir = Quaternion.forward(aim_rotation)
		local flat_rel_aim_dir = Vector3(dir.x, dir.y, 0)
		local flat_length = Vector3.length(flat_rel_aim_dir)
		local unmodified_rel_aim_dir = dir / flat_length
		local unnormalized_rel_aim_dir = Vector3(unmodified_rel_aim_dir.x, unmodified_rel_aim_dir.y, math.min(unmodified_rel_aim_dir.z, max_z))
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

		if internal.game and internal.id then
			GameSession.set_game_object_field(internal.game, internal.id, "aim_target", rel_aim_dir)
		end
	end
end

function PlayerTaunting:_constrain_to_character_rotation(aim_rotation)
	local relative_rotation = Quaternion.multiply(Quaternion.inverse(Unit.local_rotation(self._unit, 0)), aim_rotation)
	local direction = Quaternion.forward(relative_rotation)
	local angle = math.atan2(direction.x, direction.y)
	local pi = math.pi
	local max_angle = pi * 0.25
	local error_angle

	if angle < -max_angle then
		error_angle = -max_angle - angle
	elseif max_angle < angle then
		error_angle = max_angle - angle
	else
		return aim_rotation
	end

	return Quaternion.multiply(aim_rotation, Quaternion(Vector3.up(), -error_angle))
end

function PlayerTaunting:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
