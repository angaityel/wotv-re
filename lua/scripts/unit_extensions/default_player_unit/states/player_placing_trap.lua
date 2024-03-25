-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_placing_trap.lua

require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component")

PlayerPlacingTrap = class(PlayerPlacingTrap, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerPlacingTrap:init(unit, internal, world)
	PlayerPlacingTrap.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerPlacingTrap:update(dt, t)
	PlayerPlacingTrap.super.update(self, dt, t)
	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	if t > self._end_time then
		self._transition = "onground"

		local network_manager = Managers.state.network
		local position = Unit.world_position(self._unit, 0)
		local player = self._internal.player

		if Managers.lobby.server then
			Managers.state.trap:add_trap_server(player, position)
		else
			local player_id = player:player_id()

			network_manager:send_rpc_server("rpc_place_alert_trap", player_id, position, NetworkLookup.trap_names["n/a"])
		end
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

function PlayerPlacingTrap:enter(old_state, data)
	PlayerPlacingTrap.super.enter(self, old_state)

	local internal = self._internal
	local t = Managers.time:time("game")

	self._end_time = t + 1.5

	self:anim_event_with_variable_float("revive_team_mate", "revive_team_mate_time", 1.5)
	self:_align_to_camera()
	self:_unwield_shield()
end

function PlayerPlacingTrap:_unwield_shield()
	local inventory = self._internal:inventory()

	self._shield_wielded = inventory:is_wielded("shield")

	if self._shield_wielded then
		self._shield_wielded = true

		self:_set_slot_wielded_instant("shield", false)
	end
end

function PlayerPlacingTrap:exit(new_state)
	PlayerPlacingTrap.super.exit(self, new_state)
	self:anim_event("revive_team_mate_end")

	if self._shield_wielded and self._internal:inventory():gear("shield") then
		self:_set_slot_wielded_instant("shield", true)
	end
end

function PlayerPlacingTrap:update_movement(dt)
	local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerPlacingTrap:update_rotation(dt, t)
	self:update_aim_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerPlacingTrap:update_aim_target(dt, t)
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

function PlayerPlacingTrap:_constrain_to_character_rotation(aim_rotation)
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

function PlayerPlacingTrap:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end
