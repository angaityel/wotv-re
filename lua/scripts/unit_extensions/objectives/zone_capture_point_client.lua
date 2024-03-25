﻿-- chunkname: @scripts/unit_extensions/objectives/zone_capture_point_client.lua

require("scripts/unit_extensions/objectives/capture_point_client_base")

ZoneCapturePointClient = class(ZoneCapturePointClient, CapturePointClientBase)
ZoneCapturePointClient.CLIENT_ONLY = true

function ZoneCapturePointClient:init(world, unit)
	ZoneCapturePointClient.super.init(self, world, unit)

	local blackboard = self._blackboard

	blackboard.capture_scale = 0
	blackboard.being_captured = false
	blackboard.object_order_id = "none"
end

function ZoneCapturePointClient:set_zone_name(name)
	self._zone_name = name
end

function ZoneCapturePointClient:update(...)
	local zone = self._zone_name

	if not zone or zone == "" then
		return
	end

	ZoneCapturePointClient.super.update(self, ...)

	local game = Managers.state.network:game()
	local id = self._id

	if game and id then
		local blackboard = self._blackboard

		blackboard.capture_scale = GameSession.game_object_field(game, id, "capture_scale")
		blackboard.being_captured = GameSession.game_object_field(game, id, "being_captured")
		blackboard.capturing_team = NetworkLookup.team[GameSession.game_object_field(game, id, "capturing_team")]
		blackboard.object_order_id = GameSession.game_object_field(game, id, "object_order_id")
		blackboard.locked = GameSession.game_object_field(game, id, "locked")
		blackboard.locked_end_time = GameSession.game_object_field(game, id, "locked_end_time")
		blackboard.instant_capture = GameSession.game_object_field(game, id, "instant_capture")

		local player_manager = Managers.player
		local level = LevelHelper:current_level(self._world)
		local zone_name = self._zone_name

		for i = 1, PlayerManager.MAX_PLAYERS do
			if player_manager:player_exists(i) then
				local player = player_manager:player(i)
				local player_unit = player.player_unit
				local objectives_blackboard

				if Unit.alive(player_unit) and player.team and self._active[player.team.side] then
					local damage_extension = ScriptUnit.extension(player_unit, "damage_system")
					local pos = Unit.world_position(player_unit, 0) + Vector3(0, 0, 0.5)

					if not damage_extension:is_knocked_down() and not damage_extension:is_dead() and Level.is_point_inside_volume(level, zone_name, pos) then
						player_manager:player(i).state_data.objectives_blackboard = blackboard
					end
				end
			end
		end
	end
end
