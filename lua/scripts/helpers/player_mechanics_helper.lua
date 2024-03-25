-- chunkname: @scripts/helpers/player_mechanics_helper.lua

PlayerMechanicsHelper = PlayerMechanicsHelper or {}

function PlayerMechanicsHelper.suicide(internal)
	local network_manager = Managers.state.network

	if network_manager:game() then
		network_manager:send_rpc_server("rpc_suicide", internal.id)
	elseif not Managers.lobby.lobby then
		ScriptUnit.extension(internal.unit, "damage_system"):die(internal.player, nil, true)
	end
end

function PlayerMechanicsHelper.player_unit_tagged(local_player, other_player_unit)
	local squad = local_player.team.squads[local_player.squad_index]
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if squad and game then
		local members = squad:members()

		for player, _ in pairs(members) do
			local tagged_unit_id = GameSession.game_object_field(game, player.game_object_id, "tagged_player_object_id")
			local tagged_unit = network_manager:game_object_unit(tagged_unit_id)

			if tagged_unit == other_player_unit then
				return true, player
			end
		end
	end

	return false, nil
end

function PlayerMechanicsHelper.squads_tagged_units(local_player)
	local tagged_units = {}
	local squad = local_player.team.squads[local_player.squad_index]
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if squad and game then
		local members = squad:members()

		for player, _ in pairs(members) do
			local tagged_unit_id = GameSession.game_object_field(game, player.game_object_id, "tagged_player_object_id")
			local tagged_unit = network_manager:game_object_unit(tagged_unit_id)

			if tagged_unit then
				tagged_units[tagged_unit] = true
			end
		end
	end

	return tagged_units
end

function PlayerMechanicsHelper.tag_valid(tagging_player, tagged_unit, self_kd)
	local is_player = ScriptUnit.has_extension(tagged_unit, "locomotion_system")
	local is_objective = ScriptUnit.has_extension(tagged_unit, "objective_system") and ScriptUnit.extension(tagged_unit, "objective_system").level_index
	local is_valid

	if tagging_player.is_corporal then
		local tagged_player = Managers.player:owner(tagged_unit)

		is_valid = is_player and (tagged_player.team ~= tagging_player.team or self_kd) or is_objective
	else
		local tagged_player = Managers.player:owner(tagged_unit)

		is_valid = is_player and tagged_player.team ~= tagging_player.team or self_kd
	end

	if is_valid and (is_objective or not ScriptUnit.extension(tagged_unit, "damage_system"):is_dead()) then
		return true
	end

	return false
end

function PlayerMechanicsHelper.calculate_fall_distance(internal, fall_height, landing_position)
	local height = fall_height - landing_position.z
	local height_multiplier = internal:has_perk("cat_burglar") and Perks.cat_burglar.height_multiplier or 1

	return height / height_multiplier
end

function PlayerMechanicsHelper._pick_landing(internal, fall_distance)
	local heights = PlayerUnitMovementSettings.fall.heights

	if fall_distance >= heights.knocked_down then
		return "knocked_down"
	elseif fall_distance >= heights.heavy * PlayerUnitMovementSettings.encumbrance.functions.heavy_landing_height(internal:inventory():encumbrance()) then
		return "heavy"
	else
		return "light"
	end
end

function PlayerMechanicsHelper:horse_update_movement_inair(unit, internal, dt)
	local mover = Unit.mover(unit)
	local velocity = internal.velocity:unbox()
	local current_position = Unit.local_position(unit, 0)
	local fall_velocity = velocity.z - 9.82 * dt

	velocity.z = fall_velocity

	local speed = Vector3.length(velocity)
	local dir = Vector3.normalize(velocity)
	local drag = 0.0225 * speed * speed
	local dragged_speed = speed - drag * dt
	local dragged_velocity = dir * dragged_speed
	local delta = dragged_velocity * dt

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	internal.velocity:store(dragged_velocity)

	return final_position
end

function PlayerMechanicsHelper:velocity_driven_update_movement(unit, internal, dt, allow_upward_velocity)
	local mover = Unit.mover(unit)
	local velocity = internal.velocity:unbox()
	local speed = Vector3.length(velocity)
	local drag_force = 0.00225 * speed * speed * Vector3.normalize(-velocity)
	local dragged_velocity = velocity + drag_force * dt
	local z_velocity = Vector3.z(dragged_velocity)
	local fall_velocity = z_velocity - 9.82 * dt

	if not allow_upward_velocity and fall_velocity > 0 then
		fall_velocity = 0
	end

	Vector3.set_z(dragged_velocity, fall_velocity)

	local delta = dragged_velocity * dt
	local current_position = Unit.local_position(unit, 0)

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	internal.velocity:store(delta / dt)

	internal.move_speed = Vector3.length(Vector3.flat(internal.velocity))

	return final_position
end

function PlayerMechanicsHelper:scaled_animation_driven_update_movement(unit, internal, dt, allow_upward_velocity, scale)
	local mover = Unit.mover(unit)
	local wanted_pose = Unit.animation_wanted_root_pose(unit)
	local current_position = Unit.local_position(unit, 0)
	local wanted_position = (Matrix4x4.translation(wanted_pose) - current_position) * scale + current_position
	local velocity = internal.velocity:unbox()
	local speed = Vector3.length(velocity)
	local drag_force = 0.00225 * speed * speed * Vector3.normalize(-velocity)
	local dragged_velocity = velocity + drag_force * dt
	local z_velocity = Vector3.z(dragged_velocity)
	local fall_velocity = z_velocity - 9.82 * dt

	if not allow_upward_velocity and fall_velocity > 0 then
		fall_velocity = 0
	end

	local anim_delta = wanted_position - current_position
	local anim_delta_length = Vector3.length(anim_delta)
	local delta = anim_delta + Vector3(0, 0, fall_velocity) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)
	local move_delta = final_position - current_position

	if self:_moving_on_slope(unit, internal, mover, final_position) then
		move_delta.z = fall_velocity * dt
	end

	internal.velocity:store(move_delta / dt)

	return final_position, wanted_pose
end

function PlayerMechanicsHelper:animation_driven_update_movement(unit, internal, dt, allow_upward_velocity)
	local mover = Unit.mover(unit)
	local wanted_pose = Unit.animation_wanted_root_pose(unit)
	local wanted_position = Matrix4x4.translation(wanted_pose)
	local current_position = Unit.local_position(unit, 0)
	local velocity = internal.velocity:unbox()
	local speed = Vector3.length(velocity)
	local drag_force = 0.00225 * speed * speed * Vector3.normalize(-velocity)
	local dragged_velocity = velocity + drag_force * dt
	local z_velocity = Vector3.z(dragged_velocity)
	local fall_velocity = z_velocity - 9.82 * dt

	if not allow_upward_velocity and fall_velocity > 0 then
		fall_velocity = 0
	end

	local anim_delta = wanted_position - current_position
	local anim_delta_length = Vector3.length(anim_delta)
	local delta = anim_delta + Vector3(0, 0, fall_velocity) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)
	local move_delta = final_position - current_position

	if self:_moving_on_slope(unit, internal, mover, final_position) then
		move_delta.z = fall_velocity * dt
	end

	internal.velocity:store(move_delta / dt)

	return final_position, wanted_pose
end

local DISTANCE_BETWEEN_PLAYERS = 1.1
local PLAYER_HEIGHT = 1.7

function PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)
	local actors = internal.husks_in_proximity

	for actor_box, unit in pairs(actors) do
		local actor = ActorBox.unbox(actor_box)

		if Unit.alive(unit) and actor then
			local position = Actor.position(actor)

			if math.abs(current_position.z + PLAYER_HEIGHT * 0.5 - position.z) < PLAYER_HEIGHT * 0.5 then
				local offset = position - current_position

				offset.z = 0

				local dir = Vector3.normalize(offset)
				local length = Vector3.length(offset)
				local delta_dot = Vector3.dot(delta, dir)

				if delta_dot > 0 then
					local dist = length - delta_dot
					local overlap = dist - DISTANCE_BETWEEN_PLAYERS

					if overlap < 0 then
						overlap = math.max(-delta_dot, overlap)
						delta = delta + overlap * dir
					end
				end
			end
		end
	end

	return delta
end

local MAX_CLIMB_TIME = 0.2

function PlayerMechanicsHelper:_moving_on_slope(unit, internal, mover, final_position)
	local pos = Unit.local_position(unit, 0)
	local slope_traversion_settings = PlayerUnitMovementSettings.slope_traversion
	local slope_angle = slope_traversion_settings.max_angle

	Mover.set_max_slope_angle(mover, slope_angle)

	local on_slope = Mover.standing_frames(mover) < slope_traversion_settings.standing_frames

	if not on_slope then
		internal.slope_check_last_z = final_position.z
	elseif internal.slope_check_last_z > final_position.z then
		internal.slope_check_last_z = -math.huge
	end

	if script_data.debug_moving_slope then
		Managers.state.debug_text:output_screen_text(string.format("%.2f %.2f", internal.slope_check_last_z, final_position.z), 14, nil)
	end

	internal.on_slope = Mover.flying_frames(mover) > slope_traversion_settings.jump_disallowed_frames

	if not on_slope then
		local mover = Unit.mover(unit)

		if Mover.collides_down(mover) and Mover.flying_frames(mover) == 0 then
			local actor = Mover.actor_colliding_down(mover)
			local unit = Actor.unit(actor)

			if unit and Unit.id(unit) == 2073982794 then
				internal.on_slope = true
				on_slope = true
			end
		end
	end

	local crouch_step_up = internal.crouching and internal.slope_check_last_z + slope_traversion_settings.crouch_step_up > final_position.z
	local aim_step_up = internal.aiming and internal.slope_check_last_z + slope_traversion_settings.aim_step_up > final_position.z

	return on_slope and not crouch_step_up and not aim_step_up
end

function PlayerMechanicsHelper:script_driven_camera_relative_update_movement(unit, internal, dt, allow_upward_velocity)
	local mover = Unit.mover(unit)
	local current_position = Unit.local_position(unit, 0)
	local velocity = internal.velocity:unbox()
	local speed = Vector3.length(velocity)
	local drag_force = 0.00225 * speed * speed * Vector3.normalize(-velocity)
	local dragged_velocity = velocity + drag_force * dt
	local z_velocity = Vector3.z(dragged_velocity)
	local fall_velocity = z_velocity - 9.82 * dt

	if not allow_upward_velocity and fall_velocity > 0 then
		fall_velocity = 0
	end

	local fwd = Quaternion.forward(internal.move_rot:unbox())
	local move_velocity

	move_velocity = internal.move_speed * fwd

	local delta = (move_velocity + Vector3(0, 0, fall_velocity)) * dt

	delta = PlayerMechanicsHelper.clamp_delta_vs_husks(current_position, delta, internal)

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	if self:_moving_on_slope(unit, internal, mover, final_position) then
		delta.z = fall_velocity * dt
	end

	internal.velocity:store(delta / dt)

	return final_position
end
