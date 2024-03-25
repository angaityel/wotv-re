-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_collapse.lua

PlayerCollapse = class(PlayerCollapse, PlayerMovementStateBase)

local collapse_animations = {
	"knocked_down_torso_front_cut_02",
	"knocked_down_torso_front_cut_03",
	"knocked_down_face_front_blunt",
	"knocked_down_torso_front_stomach_pierce_03",
	"knocked_down_torso_back_cut_02",
	"knocked_down_torso_back_cut_03",
	"knocked_down_face_left_front_cut",
	"knocked_down_face_right_front_cut",
	"knocked_down_face_front_blunt"
}

function PlayerCollapse:init(unit, internal, world)
	PlayerCollapse.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerCollapse:update(dt, t)
	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	if self._update_function then
		self[self._update_function](self, dt, t)
	end
end

function PlayerCollapse:update_movement(dt)
	local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerCollapse:update_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerCollapse:_update_collapse(dt, t)
	local time_end = self._collapse_time_end

	if time_end < t then
		self:anim_event("revive_start")

		self._getting_up_time_end = t + 1.5
		self._update_function = "_update_getting_up"
	end
end

function PlayerCollapse:_update_getting_up(dt, t)
	local time_end = self._getting_up_time_end

	if time_end < t then
		self:anim_event("revive_complete")
		self:change_state("onground")
	end
end

function PlayerCollapse:enter(old_state)
	local internal = self._internal
	local t = Managers.time:time("game")

	self._collapse_time_end = t + 1.5

	self:anim_event(self:_pick_anim())

	self._update_function = "_update_collapse"

	self:_play_voice("chr_vce_perk_fake_death", true, "chr_vce_perk_fake_death")
end

function PlayerCollapse:_pick_anim()
	local anim_index = math.random(1, #collapse_animations)

	self.anim_index = self.anim_index or 0

	if self.anim_index >= #collapse_animations then
		self.anim_index = 0
	end

	self.anim_index = self.anim_index + 1
	anim_index = self.anim_index

	return collapse_animations[self.anim_index]
end
