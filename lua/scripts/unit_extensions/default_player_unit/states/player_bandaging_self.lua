-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_bandaging_self.lua

require("scripts/unit_extensions/default_player_unit/states/player_bandaging_teammate")

PlayerBandagingSelf = class(PlayerBandagingSelf, PlayerBandagingTeammate)

local BUTTON_THRESHOLD = 0.5

function PlayerBandagingSelf:init(unit, internal, world)
	PlayerBandagingSelf.super.super.init(self, unit, internal, world, "bandage_self")
end

function PlayerBandagingSelf:_key_mapping(settings, hold)
	if hold then
		return "bandage"
	else
		return "bandage_start"
	end
end

function PlayerBandagingSelf:interaction_confirmed()
	PlayerBandagingSelf.super.interaction_confirmed(self)

	if Managers.state.network:game() then
		Managers.state.network:player_bandaging(self._unit)
	else
		Managers.state.event:trigger("player_bandaging", self._unit)
	end
end

function PlayerBandagingSelf:_duration()
	local internal = self._internal
	local interaction_settings = self:_interaction_settings()

	return PlayerBandagingSelf.super.super._duration(self, interaction_settings)
end
