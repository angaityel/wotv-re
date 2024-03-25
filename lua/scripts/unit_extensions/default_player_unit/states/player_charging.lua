-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_charging.lua

PlayerCharging = class(PlayerCharging, PlayerMovementStateBase)

function PlayerCharging:init(unit, internal, world)
	PlayerCharging.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)

	local charge_raycast_callback = callback(self, "cb_charge_raycast_result")

	self._charge_raycast = PhysicsWorld.make_raycast(World.physics_world(world), charge_raycast_callback, "closest", "types", "both", "collision_filter", "charge_check")
	self._charge_raycast_length = math.huge
	self._world = world
end

function PlayerCharging:enter(old_state, data)
	local settings = data.settings

	self._settings = settings

	local target = data.target_unit

	self._target_unit = target
	self._attack_settings = data.attack_settings

	if target then
		self:_align_to_target()
	else
		self:_align_to_camera()
	end

	local internal = self._internal
	local inventory = internal:inventory()

	self._last_sweep_position = Vector3Box(self:_sweep_back_position())

	self:_play_charge_animation("start")
	self:_play_voice(settings.sounds.start)
	self:stamina_activate(settings.stamina_settings)

	self._end_t = Managers.time:time("game") + settings.duration
	self._start_speed = Vector3.dot(internal.velocity:unbox(), Quaternion.forward(Unit.local_rotation(self._unit, 0)))
end

function PlayerCharging:update(dt, t)
	PlayerCharging.super.update(self, dt, t)
	self:update_rotation(dt, t)
	self:update_movement(dt, t)

	local internal = self._internal

	if self._settings.charge_type == "rush" and internal:has_perk("no_knockdown") then
		internal:set_perk_state("no_knockdown", "active")
	end

	if self._soft_hit_timer and t > self._soft_hit_timer or self._hard_hit_timer and t > self._hard_hit_timer then
		self:_play_charge_animation("finish")

		self._transition = "onground"
		self._soft_hit_timer = nil
		self._hard_hit_timer = nil
	end

	if self._end_t then
		if t > self._end_t then
			self:_play_charge_animation("finish")

			self._transition = "onground"
		else
			self:_update_sweep(dt, t)

			if self._settings.charge_type == "rush" then
				self:_update_ray_cast(dt, t)
			end
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

function PlayerCharging:update_rotation(dt, t)
	if Unit.alive(self._target_unit) then
		self:_align_to_target()
	else
		self._target_unit = nil
	end

	self:update_aim_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerCharging:update_movement(dt, t)
	local internal = self._internal
	local unit = self._unit
	local mover = Unit.mover(unit)
	local wanted_pose = Unit.animation_wanted_root_pose(unit)
	local wanted_position = Matrix4x4.translation(wanted_pose)
	local current_position = Unit.local_position(unit, 0)
	local z_velocity = Vector3.z(internal.velocity:unbox())
	local inv_drag_force = 0.00225 * math.abs(z_velocity) * z_velocity
	local fall_velocity = z_velocity - (9.82 + inv_drag_force) * dt

	if fall_velocity > 0 then
		fall_velocity = 0
	end

	local anim_delta

	if self._end_t then
		anim_delta = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(unit, 0)))) * self:_speed(self._end_t - t) * dt
	else
		anim_delta = Vector3.flat(wanted_position - current_position)
	end

	local delta = anim_delta + Vector3(0, 0, fall_velocity) * dt

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)

	delta = final_position - current_position

	internal.velocity:store(delta / dt)
	self:set_local_position(final_position)
end

function PlayerCharging:_speed(time_left)
	local settings = self._settings
	local duration = settings.duration
	local max_speed = settings.max_speed
	local max_at = settings.max_at
	local falloff_at = settings.falloff_at
	local falloff_to = settings.falloff_to
	local t = 1 - time_left / duration
	local speed

	if t < max_at then
		local lerp_t = math.smoothstep(t, 0, max_at)

		speed = math.lerp(self._start_speed, max_speed, lerp_t)
	elseif falloff_at < t then
		local lerp_t = math.smoothstep(t, falloff_at, 1)

		speed = math.lerp(max_speed, falloff_to, lerp_t)
	else
		speed = max_speed
	end

	return speed
end

function PlayerCharging:_align_to_target()
	local internal = self._internal

	self:update_aim_rotation()

	local target = self._target_unit
	local damage_ext = ScriptUnit.has_extension(target, "damage_system") and ScriptUnit.extension(target, "damage_system")

	if not damage_ext or not damage_ext:is_alive() then
		self._target_unit = nil

		return
	end

	local dir = Vector3.flat(Unit.local_position(target, 0) - Unit.local_position(self._unit, 0))
	local rot = Quaternion.look(dir, Vector3.up())

	self:set_target_world_rotation(rot)
end

local SWEEP_EPSILON = 0.001

function PlayerCharging:_update_sweep(dt, t)
	local settings = self._settings
	local old_pos = self._last_sweep_position:unbox()
	local new_pos = self:_sweep_front_position()
	local sweep_vector = new_pos - old_pos

	if Vector3.length(sweep_vector) < SWEEP_EPSILON then
		return
	end

	local physics_world = World.physics_world(self._internal.world)
	local extents = Vector3(0.3, 0.01, 0.8)
	local rot = Quaternion.look(sweep_vector, Vector3.up())
	local types = settings.can_hit_statics and "both" or "dynamics"
	local collision_filter = settings.collision_filter
	local hits = PhysicsWorld.linear_obb_sweep(physics_world, old_pos, new_pos, extents, rot, 100, "types", types, "collision_filter", collision_filter)

	if script_data.rush_sweep_debug then
		local drawer = Managers.state.debug:drawer({
			mode = "retained",
			name = "weapon"
		})
		local pose = Matrix4x4.from_quaternion_position(rot, old_pos)

		drawer:box_sweep(pose, extents, sweep_vector)
	end

	if not hits then
		return
	end

	local hard_hit = false
	local impact_direction = Vector3.normalize(sweep_vector)
	local unit = self._unit

	for i, hit in ipairs(hits) do
		local hit_unit = Actor.unit(hit.actor)
		local actor = hit.actor
		local normal = hit.normal
		local position = hit.position

		hit_unit, actor = WeaponHelper:helmet_hack(hit_unit, actor)

		if settings.charge_type == "rush" and self._charge_raycast_length >= 1 or hit_unit ~= unit and Unit.get_data(hit_unit, "user_unit") ~= unit and self:_charge_hit(hit_unit, actor, normal, position, impact_direction) then
			break
		end
	end

	self._last_sweep_position:store(self:_sweep_back_position())
end

function PlayerCharging:_update_ray_cast(dt, t)
	local internal = self._internal
	local unit = self._unit
	local aim_vector = internal.velocity:unbox()
	local aim_dir = Vector3.normalize(Vector3.flat(aim_vector))
	local pos = Unit.world_position(unit, Unit.node(unit, "Hips"))

	self._charge_raycast:cast(pos, aim_dir)
end

function PlayerCharging:cb_charge_raycast_result(hit, position, distance, normal, actor)
	local unit = self._unit
	local hips_pos = Unit.world_position(unit, Unit.node(unit, "Hips"))
	local distance = Vector3.distance(position, hips_pos)

	self._charge_raycast_length = distance
end

function PlayerCharging:exit(new_state)
	PlayerCharging.super.exit(self, new_state)

	local internal = self._internal

	if self._settings.charge_type == "rush" and internal:has_perk("no_knockdown") then
		internal:set_perk_state("no_knockdown", "clockwipe")
	end

	local aim_vector = internal.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())
	local velocity = internal.velocity:unbox()

	internal.speed:store(Vector3(Vector3.dot(Quaternion.right(aim_rot_flat), velocity), Vector3.dot(Quaternion.forward(aim_rot_flat), velocity), 0) / self:_move_speed())

	self._charge_raycast_length = math.huge
end

function PlayerCharging:_charge_hit(hit_unit, actor, normal, position, impact_direction)
	if not hit_unit or not Unit.alive(hit_unit) then
		return
	end

	local hit_type
	local settings = self._settings

	if ScriptUnit.has_extension(hit_unit, "locomotion_system") then
		local victim_locomotion = ScriptUnit.extension(hit_unit, "locomotion_system")

		if victim_locomotion.parrying and self:_check_parry(victim_locomotion) then
			hit_type = "hard_hit"
		elseif victim_locomotion.blocking and self:_check_blocking(victim_locomotion) then
			hit_type = "hard_hit"
		else
			self["_" .. settings.charge_type .. "_impact_character"](self, hit_unit, position, normal, actor, impact_direction)

			hit_type = "soft_hit"
		end
	elseif Unit.has_data(hit_unit, "gear_name") then
		local gear_settings = Gear[Unit.get_data(hit_unit, "gear_name")]
		local gear_user = Unit.get_data(hit_unit, "user_unit")

		if not Unit.alive(gear_user) then
			return
		end

		local gear_user_locomotion = ScriptUnit.extension(gear_user, "locomotion_system")

		if gear_user_locomotion.parrying and gear_user_locomotion.block_unit == hit_unit and self:_check_parry(gear_user_locomotion) then
			hit_type = "hard_hit"
		elseif gear_user_locomotion.blocking and gear_user_locomotion.block_unit == hit_unit and self:_check_blocking(gear_user_locomotion) then
			hit_type = "hard_hit"
		else
			return
		end
	else
		hit_type = Unit.get_data(hit_unit, "soft_target") and "soft_hit" or "hard_hit"
	end

	self:_play_charge_animation(hit_type)

	self["_" .. hit_type .. "_timer"] = Managers.time:time("game") + settings[hit_type .. "_penalty_time"]
	self._end_t = nil

	return true
end

function PlayerCharging:_check_parry(victim_locomotion)
	if victim_locomotion.block_direction ~= "down" or not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	local attacker_aim = self._internal:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3(attacker_aim.x, attacker_aim.y, 0)
	local victim_aim_flat = Vector3(victim_aim.x, victim_aim.y, 0)
	local dot = Vector3.dot(attacker_aim_flat, victim_aim_flat)

	return dot < 0
end

function PlayerCharging:_check_blocking(victim_locomotion)
	if not Unit.alive(victim_locomotion.block_unit) then
		return false
	end

	local attacker_aim = self._internal:aim_direction()
	local victim_aim = victim_locomotion:aim_direction()
	local attacker_aim_flat = Vector3.flat(attacker_aim)
	local victim_aim_flat = Vector3.flat(victim_aim)
	local dot = Vector3.dot(attacker_aim_flat, victim_aim_flat)

	return dot < 0
end

function PlayerCharging:_sweep_front_position()
	local unit = self._unit

	return Unit.local_position(unit, 0) + Quaternion.forward(Unit.local_rotation(unit, 0)) * 1.3 + Vector3(0, 0, 1)
end

function PlayerCharging:_sweep_back_position()
	local unit = self._unit

	return Unit.local_position(unit, 0) + Quaternion.forward(Unit.local_rotation(unit, 0)) * 0.3 + Vector3(0, 0, 1)
end

function PlayerCharging:_align_to_camera()
	local internal = self._internal

	self:update_aim_rotation()

	local rot = Quaternion.look(Vector3.flat(internal.aim_vector:unbox()), Vector3.up())

	self:set_target_world_rotation(rot)
end

function PlayerCharging:_play_charge_animation(animation_type)
	local animation_settings = self._settings.animations[animation_type]
	local animation_variable = animation_settings.variable

	if animation_variable then
		self:anim_event_with_variable_float(animation_settings.name, animation_variable.name, animation_variable.value)
	else
		local animation_name = animation_settings

		self:anim_event(animation_name)
	end
end

function PlayerCharging:_rush_impact_character(hit_unit, position, normal, actor, impact_direction)
	self:_tackle_impact_character(hit_unit, position, normal, actor, impact_direction)
end

function PlayerCharging:_tackle_impact_character(hit_unit, position, normal, actor, impact_direction)
	local network_manager = Managers.state.network
	local internal = self._internal
	local world = self._world
	local unit = self._unit

	WeaponHelper:rush_impact_character(hit_unit, position, normal, world, impact_direction, unit)
	internal.velocity:store(Vector3(0, 0, 0))

	if internal.game and internal.id then
		if Managers.lobby.server then
			network_manager:send_rpc_clients("rpc_rush_impact_character", internal.id, network_manager:game_object_id(hit_unit), position, normal, impact_direction, unit)
		else
			network_manager:send_rpc_server("rpc_rush_impact_character", internal.id, network_manager:game_object_id(hit_unit), position, normal, impact_direction, unit)
		end
	end
end

function PlayerCharging:_backstab_impact_character(hit_unit, position, normal, actor, impact_direction)
	local network_manager = Managers.state.network
	local internal = self._internal
	local inventory = internal:inventory()
	local world = self._world
	local unit = self._unit
	local user_unit = self._user_unit
	local player = internal.player
	local gear_unit = inventory:gear_unit("dagger")
	local gear_name = Unit.get_data(gear_unit, "gear_name")
	local perk_settings = Perks.backstab

	internal.velocity:store(Vector3(0, 0, 0))
	internal:set_perk_state("backstab", "active")
	WeaponHelper:add_damage(world, hit_unit, player, player.player_unit, "backstab", perk_settings.damage, position, normal, actor, "melee", gear_name, "backstab", "torso", impact_direction, perk_settings.damage, true, nil, false)

	local timpani_world = World.timpani_world(world)

	TimpaniWorld.trigger_event(timpani_world, "perk_backstab_self")
end
