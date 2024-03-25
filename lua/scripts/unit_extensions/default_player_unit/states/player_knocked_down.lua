-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_knocked_down.lua

PlayerKnockedDown = class(PlayerKnockedDown, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function PlayerKnockedDown:init(unit, internal, world)
	PlayerKnockedDown.super.init(self, unit, internal, world)

	self._unit = unit
	self._internal = internal
	self._yielded = false
	self._execution_time = nil
	self._falling = false
	self._knocked_down_time = 0
	self._revive_yourself_activated = false
	self._resend_revive_yourself_rpc = false
end

function PlayerKnockedDown:_create_tagging_component(unit, internal)
	self._tagging_component = KnockedDownTaggingComponent:new(unit, internal, self)
end

function PlayerKnockedDown:stun()
	return
end

function PlayerKnockedDown:update(dt, t)
	PlayerKnockedDown.super.update(self, dt, t)
	self:update_movement(dt, t)

	local execution_time = self._execution_time
	local internal = self._internal

	if execution_time then
		self:update_execution(t - execution_time, dt)
	end

	if not self._yielded then
		self:update_yield(dt, t)
	end

	if self:can_revive_yourself(t) and (internal.game or internal.id) then
		InteractionHelper:request("revive_yourself", internal, internal.id)
	end

	if self._resend_revive_yourself_rpc and InteractionHelper:can_request("revive_yourself", internal) then
		InteractionHelper:request("revive_yourself", internal, internal.id)

		self._resend_revive_yourself_rpc = nil
	end
end

function PlayerKnockedDown:anim_cb_knockdown_finished()
	self._falling = false
end

function PlayerKnockedDown:update_execution(execution_t, dt)
	local curve_data = self._animation_curves_data

	if curve_data then
		curve_data.t = execution_t

		local camera_manager = Managers.state.camera
		local viewport_name = self._internal.player.viewport_name

		if not viewport_name then
			return
		end

		camera_manager:set_variable(viewport_name, "execution_victim_anim_curves", curve_data)
	end
end

function PlayerKnockedDown:begin_execution(execution_definition, attacker_unit)
	local internal = self._internal

	internal.being_executed = true
	internal.executed_camera = execution_definition.victim_camera
	self._execution_time = Managers.time:time("game")
	self._animation_curves_data = table.clone(execution_definition.victim_animation_curves_data)
	self._animation_curves_data.resource = AnimationCurves(self._animation_curves_data.resource)

	ExecutionHelper.play_execution_victim_anims(internal.unit, attacker_unit, execution_definition)
end

function PlayerKnockedDown:abort_execution()
	local internal = self._internal

	internal.being_executed = false
	internal.executed_camera = nil
	self._execution_time = nil
	self._animation_curves_data = nil

	ExecutionHelper.play_execution_abort_anim(internal.unit)
end

function PlayerKnockedDown:yield_confirmed()
	self:anim_event("death")

	self._internal.yielded = true

	Managers.state.event:trigger("ready_for_respawn", self._internal.player)
end

function PlayerKnockedDown:yield_denied()
	self._yielded = false
end

function PlayerKnockedDown:can_revive_yourself(t)
	local internal = self._internal

	return internal:has_perk("revive_yourself") and InteractionHelper:can_request("revive_yourself", internal) and t > self._knocked_down_time + Perks.revive_yourself.time_start_revive
end

function PlayerKnockedDown:can_yield(t)
	local internal = self._internal

	return InteractionHelper:can_request("yield", internal) and not self._yielded and t > self._knocked_down_time + PlayerUnitMovementSettings.yield.delay
end

function PlayerKnockedDown:update_yield(dt, t)
	local player = self._internal.player
	local yield_input = self._controller and self._controller:get("yield") or GameSettingsDevelopment.enable_robot_player

	if yield_input and self:can_yield(t) then
		self._yielded = true

		local internal = self._internal

		if internal.game and internal.id then
			local network_manager = Managers.state.network

			InteractionHelper:request("yield", internal, internal.id)
		end
	end
end

function PlayerKnockedDown:update_movement(dt)
	if self._falling then
		local final_position, wanted_animation_pose = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

		self:set_local_position(final_position)
		self:_set_rotation(Matrix4x4.rotation(wanted_animation_pose))
	else
		local internal = self._internal

		internal.speed:store(Vector3(0, 0, 0))
		internal.velocity:store(Vector3(0, 0, 0))
	end
end

function PlayerKnockedDown:start_revive(revide_yourself)
	self:anim_event_with_variable_float("revive_start", "revive_time", PlayerUnitDamageSettings.REVIVE_TIME)

	if revide_yourself and not self._revive_yourself_activated then
		local settings = Perks.revive_yourself

		self:_play_voice(settings.voice_unit_first_revive, true, settings.voice_husk_first_revive)

		self._revive_yourself_activated = true
	end
end

function PlayerKnockedDown:abort_revive()
	self:anim_event("revive_abort")

	if self._revive_yourself_activated then
		local internal = self._internal

		if internal.game or internal.id then
			self._resend_revive_yourself_rpc = true
		end
	end
end

function PlayerKnockedDown:revived(revided_yourself)
	self:anim_event("revive_complete")
	self:recover_wielded_gear()
	self:change_state("onground")

	if revided_yourself then
		local settings = Perks.revive_yourself

		self:_play_voice(settings.voice_unit_successful_revive, true, settings.voice_husk_successful_revive)
	end
end

function PlayerKnockedDown:enter(old_state, hit_zone, impact_direction, damage_type)
	PlayerKnockedDown.super.enter(self, old_state)
	self:safe_action_interrupt("knocked_down")

	local anim_event = self:_pick_knock_down_anim_event(hit_zone, impact_direction, damage_type)

	self:anim_event(anim_event)

	local t = Managers.time:time("game")
	local camera_manager = Managers.state.camera

	camera_manager:camera_effect_sequence_event("knocked_down", t)

	self._knocked_down_camera_effect_id = camera_manager:camera_effect_shake_event("knocked_down", t)
	self._knocked_down_time = t

	self:drop_wielded_gear()

	self._falling = true
	self._revive_yourself_activated = false
	self._resend_revive_yourself_rpc = nil

	Managers.state.event:trigger("local_player_kd", self._internal.player)
end

function PlayerKnockedDown:drop_wielded_gear()
	self._internal:inventory():set_kinematic_wielded_gear(false)
end

function PlayerKnockedDown:recover_wielded_gear()
	self._internal:inventory():set_kinematic_wielded_gear(true)
end

function PlayerKnockedDown:_pick_knock_down_anim_event(hit_zone, impact_direction, damage_type)
	local direction = self:_calculate_knock_down_direction(impact_direction)
	local animation_names = PlayerUnitMovementSettings.knocked_down_anim
	local front_face_events = animation_names.front_facing
	local bleed_out_events = animation_names.bleed_out
	local back_slash_events = animation_names.back_slash
	local back_cut_events = animation_names.back_cut
	local front_piercing_events = animation_names.front_piercing
	local front_torso_events = animation_names.front_torso

	if direction == "none" then
		local event = bleed_out_events[math.random(1, #bleed_out_events)]

		return event
	elseif (direction == "front" or direction == "left_front" or direction == "right_front") and (hit_zone == "torso" or hit_zone == "stomach") and (damage_type == "piercing" or damage_type == "piercing_projectile") then
		local event = front_piercing_events[math.random(1, #front_piercing_events)]

		return event
	elseif (direction == "back" or direction == "left_back" or direction == "right_back") and (hit_zone == "torso" or hit_zone == "stomach" or hit_zone == "arms" or hit_zone == "forearms" or hit_zone == "hands") and (damage_type == "piercing" or damage_type == "piercing_projectile") then
		return "knocked_down_torso_front_stomach_pierce_03"
	elseif (direction == "front" or direction == "left_front" or direction == "right_front") and (hit_zone == "head" or hit_zone == "helmet") and (damage_type == "piercing" or damage_type == "piercing_projectile" or damage_type == "cutting" or damage_type == "slashing") then
		local event = front_face_events[math.random(1, #front_face_events)]

		return event
	elseif (direction == "front" or direction == "left_front" or direction == "right_front") and (hit_zone == "torso" or hit_zone == "stomach" or hit_zone == "arms" or hit_zone == "forearms" or hit_zone == "hands") and (damage_type == "cutting" or damage_type == "slashing") then
		local event = front_torso_events[math.random(1, #front_torso_events)]

		return event
	elseif (direction == "back" or direction == "left_back" or direction == "right_back") and (hit_zone == "torso" or hit_zone == "stomach" or hit_zone == "arms" or hit_zone == "forearms" or hit_zone == "hands") and damage_type == "slashing" then
		local event = back_slash_events[math.random(1, #back_slash_events)]

		return event
	elseif (direction == "back" or direction == "left_back" or direction == "right_back") and (hit_zone == "torso" or hit_zone == "stomach" or hit_zone == "arms" or hit_zone == "forearms" or hit_zone == "hands") and damage_type == "cutting" then
		local event = back_cut_events[math.random(1, #back_cut_events)]

		return event
	else
		local event = bleed_out_events[math.random(1, #bleed_out_events)]

		return event
	end
end

local KD_DIR_SIDE_THRESHOLD = math.cos(math.pi / 3)

function PlayerKnockedDown:_calculate_knock_down_direction(impact_direction)
	local internal = self._internal
	local unit_rotation = Unit.local_rotation(internal.unit, 0)
	local fwd = Vector3.normalize(Vector3.flat(Quaternion.forward(unit_rotation)))
	local right = Quaternion.right(unit_rotation)
	local flat_impact_dir = Vector3.normalize(Vector3.flat(impact_direction))
	local impact_length_right = Vector3.dot(right, flat_impact_dir)
	local impact_length_fwd = Vector3.dot(fwd, flat_impact_dir)
	local direction

	direction = Vector3.length(impact_direction) < 0.5 and "none" or impact_length_fwd > 0 and (impact_length_right < -KD_DIR_SIDE_THRESHOLD and "left_back" or impact_length_right > KD_DIR_SIDE_THRESHOLD and "right_back" or "back") or impact_length_right < -KD_DIR_SIDE_THRESHOLD and "left_front" or impact_length_right > KD_DIR_SIDE_THRESHOLD and "right_front" or "front"

	return direction
end

function PlayerKnockedDown:tag_valid(tagged_unit)
	local player = self._internal.player
	local is_player = ScriptUnit.has_extension(tagged_unit, "locomotion_system")
	local is_valid = false

	if is_player then
		local tagged_player = Managers.player:owner(tagged_unit)

		is_valid = tagged_player.team == player.team
	end

	return is_valid and not ScriptUnit.extension(tagged_unit, "damage_system"):is_dead()
end

function PlayerKnockedDown:exit(new_state)
	PlayerKnockedDown.super.exit(self, new_state)

	local internal = self._internal

	self._animation_curves_data = nil
	self._execution_time = nil
	self._yielded = false

	local camera_manager = Managers.state.camera

	if camera_manager then
		camera_manager:stop_camera_effect_shake_event(self._knocked_down_camera_effect_id)
	end

	Managers.state.event:trigger("local_player_no_longer_kd", internal.player)

	if new_state == "dead" then
		self:_play_voice("chr_vce_finish_off", true, "chr_vce_finish_off")

		if self._knocked_down_time + 1.5 < Managers.time:time("game") then
			local network_manager = Managers.state.network
			local id = internal.id

			if internal.game and id then
				if Managers.lobby.server then
					network_manager:send_rpc_clients("rpc_finish_off_blood", id)
				else
					network_manager:send_rpc_server("rpc_finish_off_blood", id)
				end
			end
		end

		Managers.state.event:trigger("finish_off_blood", self._unit)
	end

	self._tagging_component:reset_aid_requested_targets()
end

function PlayerKnockedDown:destroy()
	PlayerKnockedDown.super.destroy(self)
end
