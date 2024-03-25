-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_onground.lua

require("scripts/unit_extensions/human/base/states/human_onground")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_weapon_throw_component")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_local_rotation_component")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_world_rotation_component")
require("scripts/unit_extensions/default_player_unit/states/state_components/player_state_travel_mode_rotation_component")

PlayerOnground = class(PlayerOnground, HumanOnground)

local BUTTON_THRESHOLD = 0.5
local PARRY_ATTEMPT_THRESHOLD = 0.001
local POSE_ATTEMPT_THRESHOLD = 0.001

function PlayerOnground:init(unit, internal, world)
	PlayerOnground.super.init(self, unit, internal, world)

	self._thrown_weapon_component = PlayerStateWeaponThrowComponent:new(unit, internal, self)
	self._rotation_component = PlayerStateLocalRotationComponent:new(unit, internal, self)
	self._travel_mode_rotation_component = PlayerStateTravelModeRotationComponent:new(unit, internal, self, 5, math.pi * 2, 15, math.pi * 4)
	self._transition_data = nil
	self._lootable_weapon = nil
	self._force_crouch = nil
	self._collapsed = nil
end

function PlayerOnground:update(dt, t)
	PlayerOnground.super.update(self, dt, t)
	self:update_aim_rotation(dt, t)
	self:_update_animation(dt, t)
	self:_update_rotation(dt, t)
	self:_update_travel_mode(dt, t)
	self:_update_weapons(dt, t)
	self:_update_crouch(dt, t)
	self:_update_perks(dt, t)
	self:_update_movement(dt, t)
	self:_update_stamina(dt, t)
	self:_update_transition(dt, t)

	self._transition = nil
end

local HOLD_THRESHOLD = 0.25
local BUTTON_THRESHOLD = 0.5

function PlayerOnground:_update_travel_mode(dt, t)
	local internal = self._internal
	local travel_mode = internal.travel_mode
	local controller = self._controller
	local travel_input = controller and controller:get("travel_mode")
	local travel_input_held = controller and controller:get("travel_mode_held") > BUTTON_THRESHOLD
	local swing_input = controller and controller:get("melee_pose") > BUTTON_THRESHOLD
	local block_input = controller and controller:get("block") > BUTTON_THRESHOLD
	local move_forward = controller and controller:get("move").y > 0
	local start_mode = Application.user_setting("travel_mode_input_mode") or "undecided"

	if travel_mode and not travel_input_held and travel_mode.input_mode == "undecided" and t < travel_mode.start_time + HOLD_THRESHOLD then
		travel_mode.input_mode = "pressed"
	elseif travel_mode and travel_input_held and travel_mode.input_mode == "undecided" and t > travel_mode.start_time + HOLD_THRESHOLD then
		travel_mode.input_mode = "hold"
	end

	if not travel_mode and (travel_input or not internal.unsheathing and travel_input_held) and move_forward and not swing_input and not block_input and self:can_travel_mode(t, PlayerUnitMovementSettings.travel_mode.stamina_settings) then
		self:_enter_travel_mode(dt, t, start_mode)
	elseif travel_mode and (travel_input and travel_mode.input_mode == "pressed" or not move_forward or not (not swing_input and not block_input) and travel_mode.input_mode ~= "hold" or travel_mode.input_mode == "hold" and not travel_input_held) then
		self:_exit_travel_mode()
	end
end

function PlayerOnground:_check_taunt(dt, t)
	local taunt_name = self._internal.taunt_name
	local settings = PlayerUnitMovementSettings.taunts[taunt_name]

	if settings and not self._transition and self._controller and self._controller:get("taunt") and self:can_taunt(t, settings) then
		self._transition = "taunting"
		self._transition_data = settings
	end
end

function PlayerOnground:_can_heal_taunt(dt, t)
	local unit = self._unit
	local damage_ext = ScriptUnit.extension(unit, "damage_system")

	return damage_ext:is_at_full_health() == false
end

function PlayerOnground:_check_heal_taunt(dt, t)
	local internal = self._internal
	local perk_name = "heal_on_taunt"
	local unit = self._unit

	if not internal:has_perk(perk_name) then
		return
	end

	if self:_can_heal_taunt() then
		internal:set_perk_state(perk_name, "default")

		local controller = self._controller
		local perk_activation_key = internal:perk_activation_command(perk_name)
		local perk_input = controller and controller:get(perk_activation_key)

		if perk_input then
			self:activate_heal_taunt(dt, t)
		end
	end
end

function PlayerOnground:activate_heal_taunt(dt, t)
	local internal = self._internal
	local unit = self._unit
	local taunt_name = Perks.heal_on_taunt.animation_name
	local settings = PlayerUnitMovementSettings.taunts[taunt_name]

	if not self:can_taunt(t, settings) then
		return
	end

	local players = Managers.player:players()
	local my_pos = Unit.local_position(unit, 0)
	local my_player = internal.player
	local my_team = Unit.get_data(unit, "team_name")

	for s, player in pairs(players) do
		if player.player_unit and my_team ~= Unit.get_data(player.player_unit, "team_name") then
			local unit_pos = Unit.local_position(player.player_unit, 0)
			local length_to_self = Vector3.distance(unit_pos, my_pos)

			if length_to_self < Perks.heal_on_taunt.length then
				self._transition = "heal_on_taunting"
				self._transition_data = settings

				return
			end
		end
	end
end

function PlayerOnground:dance()
	return
end

function PlayerOnground:whistle()
	local settings = PlayerUnitMovementSettings.taunts.whistle
	local t = Managers.time:time("game")

	if self:can_taunt(t, settings) then
		self:change_state("taunting", settings)
	end
end

function PlayerOnground:_calculate_speed(dt, current_speed, target_speed, encumbrance)
	local x = current_speed.x
	local y = current_speed.y
	local internal = self._internal
	local movement_settings = self._internal.archetype_settings.movement_settings
	local encumbrance_factor = PlayerUnitMovementSettings.encumbrance.functions.movement_acceleration(encumbrance)
	local new_x = movement_settings.movement_acceleration(dt, current_speed.x, target_speed.x, encumbrance_factor)
	local new_y = movement_settings.movement_acceleration(dt, current_speed.y, target_speed.y, encumbrance_factor)
	local ret = Vector3(new_x, new_y, 0)

	return ret
end

function PlayerOnground:enter(old_state, movement_type)
	PlayerOnground.super.enter(self, old_state)

	self._movement_type = movement_type

	if old_state ~= "inair" and old_state ~= "jumping" and old_state ~= "landing" then
		self._internal.double_time_timer = Managers.time:time("game") + PlayerUnitMovementSettings.double_time.timer_time
	end
end

function PlayerOnground:exit(new_state)
	PlayerOnground.super.exit(self, new_state)

	local internal = self._internal

	internal.double_time_recovery = false
	self._inair_timer = nil
	self._transition = nil
	self._transition_data = nil
	self._movement_type = nil
	self._movement_dir = nil

	self:_remove_lootable_weapon()
	self:safe_action_interrupt("state_" .. new_state)
end

function PlayerOnground:_add_lootable_weapon(unit)
	self._lootable_weapon = unit

	local channel = HUDSettings.outline_colors.point_of_interest.channel
	local color = Color(channel[1], channel[2], channel[3], channel[4])

	Managers.state.outline:outline_unit(unit, "outline_unit", true, color)
end

function PlayerOnground:_remove_lootable_weapon()
	local unit = self._lootable_weapon

	self._lootable_weapon = nil

	if Unit.alive(unit) and Managers.state.outline then
		Managers.state.outline:outline_unit(unit, "outline_unit", false)
	end
end

function PlayerOnground:_check_jump(dt, t)
	local internal = self._internal
	local jump_settings = PlayerUnitMovementSettings.jump
	local stamina_settings = jump_settings.stamina_settings
	local has_light_02 = internal:has_perk("light_02")

	if self._controller and self._controller:get("jump") and not self._transition and (has_light_02 or self:can_jump(t, stamina_settings)) then
		local wanted_animation_event

		if self._movement_type == "running_fwd" or self._movement_type == "running_bwd" then
			wanted_animation_event = "jump_fwd"
			self._transition = "jumping"

			local velocity = internal.velocity:unbox()

			Vector3.set_z(velocity, 0)

			local fwd_move_vector = Quaternion.forward(internal.move_rot:unbox())
			local fwd_length = Vector3.dot(fwd_move_vector, velocity)

			if fwd_length < jump_settings.forward_jump.minimum_horizontal_velocity then
				velocity = velocity + (jump_settings.forward_jump.minimum_horizontal_velocity - fwd_length) * fwd_move_vector
			end

			Vector3.set_z(velocity, jump_settings.forward_jump.initial_vertical_velocity)
			internal.velocity:store(velocity)

			if has_light_02 then
				internal:set_perk_state("light_02", "active")
			else
				self:stamina_activate(stamina_settings)
			end

			self:anim_event(wanted_animation_event)
		elseif self._movement_type == "idle" then
			wanted_animation_event = "jump_idle"
			self._transition = "jumping"

			internal.velocity:store(internal.velocity:unbox() + Vector3(0, 0, jump_settings.stationary_jump.initial_vertical_velocity))
			self:stamina_activate(stamina_settings)
			self:anim_event(wanted_animation_event)
		end
	end
end

function PlayerOnground:_check_perks(dt, t)
	local internal = self._internal
	local controller = self._controller

	if controller and not self._transition then
		if controller:get("call_horse_released") then
			internal.call_horse_release_button = false
		end

		local perk_activation_key = internal:has_perk("are_you_not_entertained") and internal:perk_activation_command("are_you_not_entertained")
		local settings = PlayerUnitMovementSettings.taunts.the_what

		if perk_activation_key and self._controller:get(perk_activation_key) and self:can_taunt(t, settings) then
			self._transition = "taunting"
			self._transition_data = settings

			local network_manager = Managers.state.network

			if network_manager:game() then
				local object_id = network_manager:game_object_id(self._unit)

				if Managers.lobby.server then
					network_manager:send_rpc_clients("rpc_dev_not_entertained", object_id)
				elseif Managers.lobby.lobby then
					network_manager:send_rpc_server("rpc_dev_not_entertained", object_id)
				end
			end
		end

		if internal:has_perk("fake_death") then
			internal:set_perk_data("fake_death", "state", "default")

			perk_activation_key = internal:perk_activation_command("fake_death")

			if perk_activation_key and self._controller:get(perk_activation_key) then
				self._transition = "fakedeath"
			end
		end

		perk_activation_key = internal:has_perk("alert_trap") and internal:perk_activation_command("alert_trap")

		if perk_activation_key and self._controller:get(perk_activation_key) and self:can_place_alert_trap(t) then
			self._transition = "placing_trap"
		end
	end
end

function PlayerOnground:not_entertained(target_unit)
	local settings = PlayerUnitMovementSettings.taunts.praise_god
	local self_pos = Unit.world_position(self._unit, 0)
	local entertainer_pos = Unit.world_position(target_unit, 0)
	local difference = entertainer_pos - self_pos
	local rot = Quaternion.look(difference)
	local length = Vector3.length(difference)

	if length <= 15 then
		self._transition = "taunting"
		self._transition_data = settings
		self._transition_data.starting_rotation = rot
	end
end

function PlayerOnground:_check_interact(dt, t)
	local controller = self._controller
	local internal = self._internal
	local interaction_ext = ScriptUnit.extension(self._unit, "interaction_system")

	for index, interaction in ipairs(PlayerUnitMovementSettings.interaction) do
		local target, interact_type = interaction_ext:get_interaction_target(index)
		local activation_command = interact_type == "backstab" and internal:perk_activation_command("backstab") or interaction.key
		local interact = controller and controller:get(activation_command)

		if interaction.settings.loot and target ~= self._lootable_weapon then
			self:_remove_lootable_weapon()

			if interact_type == "loot" and self:can_loot(target, t) or interact_type == "loot_trap" and self:can_loot_trap(target, t) or interact_type == "switch_item" and self:can_switch_item(target, t) then
				self:_add_lootable_weapon(target)
			end
		end

		if not self._transition and target and interact and target then
			if interact_type == "travel_mode_tackle" and self:can_rush(t, PlayerUnitMovementSettings.travel_mode.tackle.stamina_settings) then
				self._transition = "charging"
				self._transition_data = {
					settings = PlayerUnitMovementSettings.travel_mode.tackle,
					target_unit = target
				}
			elseif interact_type == "backstab" and self:can_backstab(t) then
				self._transition = "charging"
				self._transition_data = {
					settings = PlayerUnitMovementSettings.backstab,
					target_unit = target
				}
			elseif interact_type == "revive" and self:can_revive(t) then
				self._transition = "reviving_teammate"
				self._transition_data = target
			elseif interact_type == "climb" and self:can_climb(t) then
				self._transition = "climbing"
				self._transition_data = target

				print(activation_command, interact)
			elseif interact_type == "bandage" and self:can_bandage(t) then
				self._transition = "bandaging_teammate"
				self._transition_data = target
			elseif interact_type == "trigger" and self:can_trigger(t) then
				self._transition = "triggering"
				self._transition_data = target
			elseif interact_type == "loot" and self:can_loot(target, t) then
				self._transition = "looting"
				self._transition_data = target
			elseif interact_type == "loot_trap" and self:can_loot_trap(target, t) then
				self._transition = "looting_trap"
				self._transition_data = target
			elseif interact_type == "switch_item" and self:can_switch_item(target, t) then
				local inventory = internal:inventory()
				local gear_name = Unit.get_data(target, "gear")
				local slot_name = inventory:pick_best_equip_slot(gear_name)
				local gear_settings = Gear[gear_name]
				local replace_slot = inventory:resolve_shield_conflict(slot_name, gear_settings)

				if replace_slot then
					self:_set_slot_wielded_instant(replace_slot, false)
					inventory:replace_gear(replace_slot, true)
				end

				local _, _, _ = inventory:add_gear(gear_name, nil, slot_name, self._internal, nil, true)

				if inventory:can_wield(slot_name, "onground") then
					self:_unwield_slots_on_wield(slot_name)
					self:_wield_weapon(slot_name, false)
				end

				Unit.flow_event(target, "lua_picked_up")
			end
		end
	end
end

function PlayerOnground:_check_bandage(dt, t)
	local bandage = self._controller and self._controller:get("bandage_start")
	local damage_ext = ScriptUnit.extension(self._unit, "damage_system")

	if not self._transition and bandage and self:can_bandage(t) then
		self:change_state("bandaging_self", self._unit, t)

		return true
	end
end

function PlayerOnground:_pick_dodge(dodge_settings)
	local move_input = self._controller and self._controller:get("move")

	if not move_input or Vector3.length(move_input) < 0.3 then
		return dodge_settings.backward
	end

	local angle = math.atan2(move_input.x, move_input.y)

	if math.abs(angle) < math.pi / 8 then
		return dodge_settings.forward
	elseif angle > 0 and angle < math.pi * 3 / 8 then
		return dodge_settings.forward_right
	elseif angle > 0 and angle < math.pi * 5 / 8 then
		return dodge_settings.right
	elseif angle > 0 and angle < math.pi * 7 / 8 then
		return dodge_settings.backward_right
	elseif angle < 0 and angle > -math.pi * 3 / 8 then
		return dodge_settings.forward_left
	elseif angle < 0 and angle > -math.pi * 5 / 8 then
		return dodge_settings.left
	elseif angle < 0 and angle > -math.pi * 7 / 8 then
		return dodge_settings.backward_left
	else
		return dodge_settings.backward
	end
end

function PlayerOnground:_check_dodge(dt, t)
	local internal = self._internal
	local double_tap_dodge = Application.user_setting("double_tap_dodge")
	local controller = self._controller
	local inventory = internal:inventory()
	local slot_name = "shield"
	local has_shield = inventory:gear(slot_name) and inventory:is_wielded(slot_name)

	if not controller then
		return
	end

	if self._force_crouch then
		return
	end

	local block = internal:has_perk("dodge_block")
	local player_unit_movement_settings = self._internal.archetype_settings.movement_settings
	local dodge_settings = block and has_shield and player_unit_movement_settings.dodge_block or player_unit_movement_settings.dodge
	local settings

	if double_tap_dodge then
		local direction

		if controller:get("double_tap_dodge_left") then
			settings = dodge_settings.left
		elseif controller:get("double_tap_dodge_right") then
			settings = dodge_settings.right
		elseif controller:get("double_tap_dodge_forward") then
			settings = dodge_settings.forward
		elseif controller:get("double_tap_dodge_backward") then
			settings = dodge_settings.backward
		end
	end

	local input = controller:get("dodge")

	settings = settings or input and self:_pick_dodge(dodge_settings)

	if settings and self:can_dodge(t, settings.stamina_settings) then
		self._transition = "dodging"
		self._transition_data = settings

		if block and has_shield then
			if not internal.blocking then
				self:_raise_shield_block("shield")
			end

			internal:set_perk_state("dodge_block", "active")
		end
	end
end

function PlayerOnground:_update_transition(dt, t)
	self:_check_taunt(dt, t)
	self:_check_heal_taunt(dt, t)
	self:_check_dodge(dt, t)
	self:_check_jump(dt, t)
	self:_check_perks(dt, t)

	if not self:_check_bandage(dt, t) then
		self:_check_interact(dt, t)
	end

	if self._transition then
		self:change_state(self._transition, self._transition_data, t)

		return
	end

	local mover = Unit.mover(self._unit)

	local function callback(actors)
		self:cb_evaluate_inair_transition(actors)
	end

	local physics_world = World.physics_world(self._internal.world)

	PhysicsWorld.overlap(physics_world, callback, "shape", "sphere", "position", Mover.position(mover) - Vector3(0, 0, 0.2), "size", 0.4, "types", "both", "collision_filter", "landing_overlap")
end

function PlayerOnground:cb_evaluate_inair_transition(actor_list)
	if self._internal.current_state_name ~= "onground" then
		return
	end

	local unit = self._unit

	if #actor_list == 0 and not Mover.collides_down(Unit.mover(unit)) then
		self:change_state("inair")
		self:anim_event("to_inair")
	end
end

function PlayerOnground:_update_crouch(dt, t)
	if self._controller and self._controller:get("crouch") and not self._force_crouch or self._force_crouch and not self._internal.crouching then
		local internal = self._internal

		if internal.crouching then
			self:_abort_crouch()
		elseif self:can_crouch(t) then
			self:safe_action_interrupt("crouch")
			self:_crouch()
		end
	end
end

function PlayerOnground:_crouch()
	self:anim_event("to_crouch")

	self._internal.crouching = true
end

local WALK_THRESHOLD = 0.97
local JOG_THRESHOLD = 3.23
local RUN_THRESHOLD = 6.14
local CROUCH_SPEED = 0.96

function PlayerOnground:_calculate_move_speed_var_from_mps(move_speed)
	local speed_var
	local speed_multiplier = 1

	if self._internal.crouching then
		speed_var = 1
		speed_multiplier = move_speed / CROUCH_SPEED
	elseif move_speed <= WALK_THRESHOLD then
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

function PlayerOnground:_update_animation(dt, t)
	local internal = self._internal
	local inventory = internal:inventory()
	local unit = self._unit
	local controller = self._controller
	local move = controller and controller:get("move") or Vector3(0, 0, 0)
	local anim_move_var_index = Unit.animation_find_variable(unit, "move_speed")
	local movement_settings = internal.archetype_settings.movement_settings
	local anim_move_multiplier_var_index = Unit.animation_find_variable(unit, "movement_scale")
	local encumbrance = inventory:encumbrance()
	local target_speed = Vector3.normalize(move)
	local multiplier, back_multiplier
	local strafe_multiplier = 1

	if internal.blocking or internal.parrying then
		multiplier, back_multiplier = inventory:weapon_pose_movement_multiplier(internal.block_slot_name)
	elseif internal.posing then
		multiplier, back_multiplier = inventory:weapon_pose_movement_multiplier(internal.pose_slot_name)
	elseif internal.aiming then
		multiplier, back_multiplier = inventory:weapon_pose_movement_multiplier(internal.aim_slot_name)
	else
		multiplier = 1
		back_multiplier = 1
	end

	if ScriptUnit.extension(self._unit, "damage_system"):is_last_stand_active() then
		back_multiplier = Perks.last_stand.back_movement_speed_multiplier
		strafe_multiplier = Perks.last_stand.strafe_movement_speed_multiplier
	end

	if target_speed.y < 0 then
		Vector3.set_y(target_speed, target_speed.y * back_multiplier * movement_settings.backward_move_scale)
	end

	Vector3.set_x(target_speed, target_speed.x * movement_settings.strafe_move_scale)

	local wanted_animation_event

	target_speed = target_speed * multiplier

	local travel_mode = internal.travel_mode

	if travel_mode then
		local lerp_t = math.smoothstep((t - travel_mode.start_time) / movement_settings.travel_mode.ramp_up_time, 0, 1)

		target_speed = target_speed * math.lerp(1, movement_settings.travel_mode.speed / self:_move_speed(), lerp_t)
	end

	local chase_mode = internal.chase_mode

	if chase_mode and Unit.alive(chase_mode.target_unit) then
		local normalized_target_speed = Vector3.normalize(target_speed)
		local move_rot = internal.move_rot:unbox()
		local world_target_speed = Quaternion.right(move_rot) * target_speed.x + Quaternion.forward(move_rot) * target_speed.y
		local target_vector = Vector3.normalize(Vector3.flat(Unit.world_position(chase_mode.target_unit, 0) - Unit.local_position(self._unit, 0)))
		local lerp_t = math.max(Vector3.dot(target_vector, world_target_speed), 0)
		local multiplier_lerp_t = math.smoothstep((t - chase_mode.last_hit_time) / movement_settings.chase_mode.last_hit_timeout, 1, 0)
		local chase_mode_multiplier = movement_settings.chase_mode.movement_multiplier * (internal:has_perk("chase_faster") and Perks.chase_faster.chase_mode_speed_multiplier or 1)
		local lerped_multiplier = math.lerp(1, chase_mode_multiplier, multiplier_lerp_t)

		target_speed = math.lerp(target_speed, target_speed * lerped_multiplier, lerp_t)
	end

	if internal:has_perk("blade_master") then
		local perk_time = internal.perk_blade_master.faster_moving.time - t

		if perk_time > 0 then
			local settings = Perks.blade_master.speed_boost

			target_speed = self:_calculate_perk_boost(target_speed, perk_time, settings)
		end
	end

	local new_movement_state
	local current_speed = internal.speed:unbox()
	local speed = self:_calculate_speed(dt, current_speed, target_speed, encumbrance)
	local move_length = Vector3.length(speed)
	local move_speed = internal.crouching and move_length * movement_settings.crouch_move_speed or move_length * self:_move_speed()
	local moving = move_length > 0.1
	local moving_fwd, moving_bwd

	internal.speed:store(speed)

	if moving then
		moving_fwd = speed.y > 0 or math.abs(speed.x) > 0.1 and math.abs(speed.y) < 0.1
		moving_bwd = not moving_fwd
		internal.movement_state = "onground/moving"
		new_movement_state = NetworkLookup.movement_states["onground/moving"]
	else
		internal.movement_state = "onground/idle"
		new_movement_state = NetworkLookup.movement_states["onground/idle"]
	end

	if internal.game and internal.id and new_movement_state ~= GameSession.game_object_field(internal.game, internal.id, "movement_state") then
		GameSession.set_game_object_field(internal.game, internal.id, "movement_state", new_movement_state)
	end

	if moving_bwd and self._movement_type ~= "running_bwd" then
		wanted_animation_event = "move_bwd"
		self._movement_type = "running_bwd"
	elseif moving_fwd and self._movement_type ~= "running_fwd" then
		wanted_animation_event = "move_fwd"
		self._movement_type = "running_fwd"
	elseif not moving and self._movement_type ~= "idle" then
		wanted_animation_event = "idle"
		self._movement_type = "idle"
	end

	self:anim_set_variable(anim_move_var_index, move_speed)

	if internal.crouching then
		self:anim_set_variable(Unit.animation_find_variable(unit, "movement_scale"), move_speed / 1.4)
	else
		self:anim_set_variable(Unit.animation_find_variable(unit, "movement_scale"), 1)
	end

	internal.move_speed = move_speed

	if wanted_animation_event then
		self:anim_event(wanted_animation_event)
	end
end

function PlayerOnground:_calculate_perk_boost(target_speed, duration_left, perk_settings)
	local t_value = 1 - duration_left / perk_settings.duration
	local thresh1 = perk_settings.threshold_1
	local thresh2 = perk_settings.threshold_2
	local t2_value

	if t_value < thresh1 then
		t2_value = math.smoothstep(t_value / thresh1, 0, 1)
	else
		t2_value = t_value < thresh2 and 1 or 1 - (t_value - thresh2) / (1 - thresh2)
	end

	local speed = Vector3(0, 0, 0)

	speed.x = target_speed.x * math.lerp(1, perk_settings.multiplier_x, t2_value)
	speed.y = target_speed.y * math.lerp(1, perk_settings.multiplier_y, t2_value)

	return speed
end

function PlayerOnground:_update_movement(dt, t)
	if self._thrown_weapon_component:full_body_animation() then
		local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

		self:set_local_position(final_position)
	elseif not self._internal.leaving_ghost_mode then
		local final_position = PlayerMechanicsHelper:script_driven_camera_relative_update_movement(self._unit, self._internal, dt, false)

		self:set_local_position(final_position)
	end
end

function PlayerOnground:_update_squad_flag(dt, t)
	local internal = self._internal
	local interaction = ScriptUnit.extension(self._unit, "interaction_system")
	local target, _ = interaction:get_interaction_target(1)
	local do_plant_flag = self._controller and self._controller:get("plant_squad_flag")

	if not target and do_plant_flag and self:can_plant_squad_flag(t) then
		self:_plant_squad_flag()
	end
end

function PlayerOnground:_update_perks(dt, t)
	local internal = self._internal

	if internal:has_perk("backstab") then
		self:_update_backstab(dt, t)
	end
end

function PlayerOnground:_update_backstab(dt, t)
	local internal = self._internal
	local target_unit = internal.chase_mode and internal.chase_mode.target_unit
	local target_unit_alive = target_unit and Unit.alive(target_unit)
	local distance = target_unit_alive and Vector3.distance(Unit.world_position(target_unit, 0), Unit.world_position(self._unit, 0))
	local perk_settings = Perks.backstab
	local bb = internal.charge_blackboard

	if target_unit_alive and self:can_backstab(t) and distance <= perk_settings.charge_range then
		if internal.charging_backstab then
			local charge_value = math.min((t - internal.start_backstab_charge_time) / perk_settings.charge_time, 1)

			bb.minimum_charge_value = 1
			bb.charge_value = charge_value
			bb.charging_backstab = true
			bb.overcharge_value = charge_value / 1
		else
			internal.charging_backstab = true
			internal.start_backstab_charge_time = t
		end
	else
		internal.charging_backstab = false
		bb.charging_backstab = false
	end
end

function PlayerOnground:_update_rotation(dt, t)
	local internal = self._internal

	if internal.travel_mode or self._attacking then
		self._travel_mode_rotation_component:update(dt, t)
	else
		self._rotation_component:update(dt, t)
	end
end
