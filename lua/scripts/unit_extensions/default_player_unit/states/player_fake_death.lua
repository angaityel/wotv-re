-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_fake_death.lua

PlayerFakeDeath = class(PlayerFakeDeath, PlayerMovementStateBase)

function PlayerFakeDeath:init(unit, internal, world)
	PlayerFakeDeath.super.init(self, unit, internal, world)

	self._rotation_component = PlayerStateWorldRotationComponent:new(unit, internal, self)
end

function PlayerFakeDeath:update(dt, t)
	self:update_movement(dt, t)
	self:update_rotation(dt, t)

	if self._update_function then
		self[self._update_function](self, dt, t)
	end
end

function PlayerFakeDeath:update_movement(dt)
	local final_position = PlayerMechanicsHelper:animation_driven_update_movement(self._unit, self._internal, dt, false)

	self:set_local_position(final_position)
end

function PlayerFakeDeath:update_rotation(dt, t)
	self._rotation_component:update(dt, t)
end

function PlayerFakeDeath:_update_death(dt, t)
	local internal = self._internal
	local time_end = self._death_time_end

	if time_end and time_end < t then
		internal:set_perk_data("fake_death", "state", "default")

		local controller = internal.controller
		local perk_activation_key = internal:perk_activation_command("fake_death")
		local perk_walk = controller and controller:get("move")
		local perk_input = controller and controller:get(perk_activation_key)

		if perk_input or perk_walk and Vector3.length(perk_walk) ~= 0 then
			internal:set_perk_data("fake_death", "state", "active")
			Managers.state.network:send_rpc_server("rpc_fake_death_activated", internal.id)
			self:anim_event("revive_start")

			self._revive_time_end = t + self._perk_data.duration_getting_up
			self._update_function = "_update_getting_up"
		end
	end
end

function PlayerFakeDeath:_update_getting_up(dt, t)
	local internal = self._internal
	local time_end = self._revive_time_end

	if time_end < t then
		self:anim_event("revive_complete")
		self:change_state("onground")
		internal:set_perk_data("fake_death", "state", "active")
	end
end

function PlayerFakeDeath:enter(old_state)
	local internal = self._internal
	local t = Managers.time:time("game")

	self._perk_data = Perks.fake_death
	self._death_time_end = t + self._perk_data.duration_before_controll

	internal:set_perk_data("fake_death", "time_start", t)
	internal:set_perk_data("fake_death", "time_end", self._death_time_end)
	self:anim_event(self:_pick_anim())

	self._update_function = "_update_death"

	self:_play_voice("chr_vce_perk_fake_death", true, "chr_vce_perk_fake_death")
end

function PlayerFakeDeath:_pick_anim()
	local animation_table = PlayerUnitMovementSettings.knocked_down_anim
	local animation_event_types = animation_table.names
	local anim_type = animation_event_types[math.random(1, #animation_event_types)]

	return animation_table[anim_type][math.random(1, #animation_table[anim_type])]
end
