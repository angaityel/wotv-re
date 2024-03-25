-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_healtaunting.lua

PlayerHealTaunting = class(PlayerHealTaunting, PlayerTaunting)

function PlayerHealTaunting:update(dt, t)
	PlayerHealTaunting.super.super.update(self, dt, t)
	self:update_movement(dt, t)

	local internal = self._internal

	if t > self._end_time then
		Managers.state.network:send_rpc_server("rpc_heal_on_taunt", internal.id)
		internal:set_perk_state("heal_on_taunt", "active")

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

function PlayerHealTaunting:enter(old_state, data)
	PlayerHealTaunting.super.super.enter(self, old_state)

	local internal = self._internal
	local t = Managers.time:time("game")

	self._start_time = t
	self._end_time = data.duration + t

	self:anim_event(data.start_anim_event)

	self._data = data

	self:_align_to_camera()
	internal:set_perk_data("heal_on_taunt", "time_start", t)
	internal:set_perk_data("heal_on_taunt", "time_end", data.duration + t)
	self:_unwield_shield()
end
