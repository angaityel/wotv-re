-- chunkname: @scripts/unit_extensions/default_player_unit/states/state_components/player_state_tagging_component.lua

PlayerStateTaggingComponent = class(PlayerStateTaggingComponent)

local BUTTON_THRESHOLD = 0.5

function PlayerStateTaggingComponent:init(unit, internal, state)
	self._data = internal
	self._state = state
	self._unit = unit
end

function PlayerStateTaggingComponent:update(dt, t, controller)
	local data = self._data
	local state = self._state
	local player = self._data.player
	local can_tag = state:_can_tag(t, player)
	local tagging_input = self:_tagging_input()

	if can_tag and not data.tagging and tagging_input then
		self:_start_tagging()
	elseif can_tag and data.tagging and not tagging_input then
		local selected_unit = Managers.state.tagging:selected_unit(player)

		if Unit.alive(selected_unit) then
			self:_tag(player, selected_unit)
		end

		self:abort_tagging()
	elseif not can_tag and data.tagging then
		self:abort_tagging()
	end
end

function PlayerStateTaggingComponent:_tagging_input()
	local controller = self._data.controller

	return controller and controller:get("activate_tag") > 0.5
end

function PlayerStateTaggingComponent:abort_tagging()
	local data = self._data

	Managers.state.tagging:set_tagging_active(data.player, false)

	data.tagging = false
end

function PlayerStateTaggingComponent:_start_tagging()
	local data = self._data

	Managers.state.tagging:set_tagging_active(data.player, true)

	data.tagging = true
end

function PlayerStateTaggingComponent:_tag(player, unit_being_tagged)
	local network_manager = Managers.state.network
	local player_game_object_id = player.game_object_id
	local has_objective_system = ScriptUnit.has_extension(unit_being_tagged, "objective_system")

	if has_objective_system then
		local objective_system = ScriptUnit.extension(unit_being_tagged, "objective_system")
		local level_index_id = objective_system:level_index()

		network_manager:send_rpc_server("rpc_request_to_tag_objective", player_game_object_id, level_index_id)
	else
		local tagged_unit_id = network_manager:game_object_id(unit_being_tagged)

		network_manager:send_rpc_server("rpc_request_to_tag_player_unit", player_game_object_id, tagged_unit_id)
	end

	local data = self._data
end

KnockedDownTaggingComponent = class(KnockedDownTaggingComponent, PlayerStateTaggingComponent)

function KnockedDownTaggingComponent:init(...)
	self.super.init(self, ...)

	self._aid_requested_targets = {}
end

function KnockedDownTaggingComponent:_tagging_input()
	local controller = self._data.controller

	return controller and (controller:get("activate_tag") > 0.5 or controller:get("request_revive") > 0.5)
end

function KnockedDownTaggingComponent:reset_aid_requested_targets()
	table.clear(self._aid_requested_targets)
end

function KnockedDownTaggingComponent:_tag(player, tagged_unit)
	local owner = Managers.player:owner(tagged_unit)

	if player and owner and player.team == owner.team then
		if self._aid_requested_targets[tagged_unit] then
			return
		else
			self._aid_requested_targets[tagged_unit] = true
		end

		local data = self._data
		local network_manager = Managers.state.network
		local tagged_unit_id = network_manager:game_object_id(tagged_unit)
		local own_unit_id = network_manager:game_object_id(self._unit)

		network_manager:send_rpc_server("rpc_request_knocked_down_help", own_unit_id, tagged_unit_id)
	else
		self.super._tag(self, player, tagged_unit)
	end
end
