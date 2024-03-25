-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_inair.lua

PlayerInair = class(PlayerInair, PlayerMovementStateBase)

function PlayerInair:init(unit, internal, world)
	PlayerInair.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerInair:update(dt, t)
	PlayerInair.super.update(self, dt, t)
	self:_update_movement(dt, t)
	self:_update_rotation(dt, t)
	self:_update_attack_ready(dt, t)
	self:_update_transition(dt, t)
end

local SWEEP_HEIGHT = 5
local ATTACK_HEIGHT = 1.5
local BLEND_TIME = 0.2

function PlayerInair:_update_attack_ready(dt, t)
	local physics_world = World.physics_world(self._internal.world)
	local unit = self._unit
	local from = Unit.local_position(unit, 0)
	local from_z = from.z
	local to = Vector3(from.x, from.y, from_z - SWEEP_HEIGHT)
	local hits = PhysicsWorld.linear_sphere_sweep(physics_world, from, to, 0.25, 50, "types", "statics", "collision_filter", "landing_overlap")
	local height = SWEEP_HEIGHT

	if hits then
		for _, hit in ipairs(hits) do
			local hit_height = from_z - hit.position.z

			if hit_height < height then
				height = hit_height
			end
		end
	end

	if not self._attack_ready and height >= ATTACK_HEIGHT and self:can_inair_attack(t) then
		self._attack_ready = t + BLEND_TIME

		self:anim_event("falling_attack")
	end
end

function PlayerInair:_update_transition(dt, t)
	local unit = self._unit
	local mover = Unit.mover(unit)
	local internal = self._internal
	local pos = Mover.position(mover)
	local fall_distance = PlayerMechanicsHelper.calculate_fall_distance(internal, self._fall_height, pos)

	if fall_distance > PlayerUnitMovementSettings.fall.heights.dead and not self._suicided then
		PlayerMechanicsHelper.suicide(internal)

		self._suicided = true
	elseif Mover.collides_down(mover) and Mover.flying_frames(mover) == 0 then
		local landing = PlayerMechanicsHelper._pick_landing(internal, fall_distance)

		self:change_state("landing", landing)
	end

	local controller = self._controller
	local can_attack, slot = self:can_inair_attack(t)

	if controller and controller:get("falling_attack") and can_attack then
		self._attack_triggered = true
	end

	local attack_name = "falling"

	if can_attack and self._attack_ready and t > self._attack_ready and self._attack_triggered then
		self:change_state("falling_attack", {
			attack_name = attack_name,
			slot_name = slot,
			stamina_settings = PlayerUnitMovementSettings.special_attack.stamina_settings,
			fall_height = self._fall_height
		})
	end
end

function PlayerInair:can_inair_attack(t)
	local internal = self._internal
	local inventory = internal:inventory()
	local slot = inventory:wielded_melee_weapon_slot()
	local attack_name = "falling"
	local attack_name = "falling"

	return slot and inventory:gear(slot):settings().attacks[attack_name] and not internal.ghost_mode and not internal.travel_mode, slot
end

function PlayerInair:enter(old_state, fall_height)
	local internal = self._internal

	internal.falling = true
	self._fall_height = fall_height or Unit.local_position(internal.unit, 0).z
	self._suicided = false
	self._attack_ready = false
	self._attack_triggered = false

	self:set_target_world_rotation(Quaternion.look(Vector3.flat(Quaternion.forward(Unit.local_rotation(self._unit, 0))), Vector3.up()))
end

function PlayerInair:exit(new_state)
	PlayerInair.super.exit(self, new_state)

	self._internal.falling = false
	self._suicided = false
end

function PlayerInair:_update_movement(dt)
	local final_position = PlayerMechanicsHelper:velocity_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerInair:_update_rotation(dt, t)
	self:update_aim_rotation(dt, t)

	local internal = self._internal
	local aim_vector = internal.aim_vector:unbox()
	local aim_vector_flat = Vector3.normalize(Vector3.flat(aim_vector))
	local aim_rot_flat = Quaternion.look(aim_vector_flat, Vector3.up())
	local velocity = internal.velocity:unbox()

	internal.speed:store(Vector3(Vector3.dot(Quaternion.right(aim_rot_flat), velocity), Vector3.dot(Quaternion.forward(aim_rot_flat), velocity), 0) / self:_move_speed())
	self._rotation_component:update(dt, t)
end
