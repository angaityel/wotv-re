﻿-- chunkname: @scripts/unit_extensions/human/base/states/human_interacting.lua

require("scripts/unit_extensions/default_player_unit/states/player_movement_state_base")
require("scripts/helpers/interaction_helper")

HumanInteracting = class(HumanInteracting, PlayerMovementStateBase)

local BUTTON_THRESHOLD = 0.5

function HumanInteracting:init(unit, internal, world, interaction_type)
	HumanInteracting.super.init(self, unit, internal, world, interaction_type)

	self._complete_time = nil
	self._interaction_type = interaction_type
	self._player = internal.player
	self._interaction_confirmed = false
	self._interaction_denied = false
end

function HumanInteracting:update(dt, t)
	HumanInteracting.super.update(self, dt, t)

	local controller = self._internal.controller
	local settings, interaction = self:_interaction_settings()
	local interacting_input = settings.lock_player or controller and controller:get(self:_key_mapping(interaction, true)) > BUTTON_THRESHOLD

	self._player.state_data.interaction_progress = self._complete_time - t
	self._player.state_data.interaction_duration = self._duration_time
	self._player.state_data.interaction_type = self._interaction_type

	self:_update_movement(dt, t)

	if t > self._complete_time and self._interaction_confirmed then
		self:_exit_on_complete()
		self:change_state("onground")
	elseif not interacting_input and self._interaction_confirmed then
		self:_exit_on_fail()
		self:change_state("onground")
	end
end

function HumanInteracting:_key_mapping(settings, hold)
	if hold then
		return settings.key_hold
	else
		return settings.key
	end
end

function HumanInteracting:_update_movement(dt, t)
	local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function HumanInteracting:_interaction_settings()
	for _, interaction in ipairs(PlayerUnitMovementSettings.interaction) do
		local settings = interaction.settings[self._interaction_type]

		if settings then
			return settings, interaction
		end
	end
end

function HumanInteracting:post_update(dt, t)
	self:update_camera(dt, t)

	local internal = self._internal

	if internal.id and internal.game then
		GameSession.set_game_object_field(internal.game, internal.id, "velocity", internal.velocity:unbox())
	end
end

function HumanInteracting:_exit_on_fail()
	self._internal.interacting = false
end

function HumanInteracting:_exit_on_complete()
	self._internal.interacting = false
end

function HumanInteracting:_duration()
	return self:_interaction_settings().duration
end

function HumanInteracting:enter(old_state, t)
	local internal = self._internal

	internal.velocity:store(Vector3(0, 0, internal.velocity:unbox().z))

	local interaction_settings = self:_interaction_settings()
	local duration = self:_duration(interaction_settings)

	self._complete_time = t + duration
	self._duration_time = duration
	internal.interacting = true
	self._interaction_confirmed = false
	self._interaction_denied = false

	local begin_anim_event = self:_begin_anim_event(interaction_settings)
	local animation_time_var = interaction_settings.animation_time_var

	if begin_anim_event and animation_time_var then
		self:anim_event_with_variable_float(begin_anim_event, animation_time_var, duration)
	elseif begin_anim_event then
		self:anim_event(begin_anim_event)
	end
end

function HumanInteracting:_begin_anim_event(settings)
	local internal = self._internal
	local anim_event = settings.begin_anim_event
	local inventory = internal:inventory()
	local shield_gear = inventory:gear("shield")

	if internal:has_perk("shield_maiden02") and shield_gear and shield_gear:wielded() then
		if self._interaction_type == "bandage_self" then
			anim_event = Perks.shield_maiden02.protective_bandage_self_animation
		elseif self._interaction_type == "revive" then
			anim_event = Perks.shield_maiden02.protective_revive_animation
		end
	end

	return anim_event
end

function HumanInteracting:_end_anim_event(settings)
	return settings.end_anim_event
end

function HumanInteracting:_duration(settings)
	return settings.duration
end

function HumanInteracting:interaction_confirmed()
	self._interaction_confirmed = true
end

function HumanInteracting:interaction_denied()
	self._interaction_denied = true
end

function HumanInteracting:exit(new_state)
	HumanInteracting.super.exit(self, new_state)

	local internal = self._internal
	local settings = self:_interaction_settings()
	local end_anim_event = self:_end_anim_event(settings)

	if end_anim_event then
		self:anim_event(end_anim_event)
	end

	if internal.interacting and not self._interaction_denied then
		self:_exit_on_fail()
	elseif internal.interacting then
		internal.interacting = false
	end

	self._player.state_data.interaction_progress = nil
end

function HumanInteracting:destroy()
	return
end
