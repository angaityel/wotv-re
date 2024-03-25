-- chunkname: @scripts/unit_extensions/human/base/human_area_buff_server.lua

HumanAreaBuffServer = class(HumanAreaBuffServer)
HumanAreaBuffServer.SYSTEM = "area_buff_system"
HumanAreaBuffServer.SERVER_ONLY = true

function HumanAreaBuffServer:init(world, unit)
	self._world = world
	self._unit = unit

	local player = Managers.player:owner(unit)

	self._hud_buff_blackboard = {
		courage = {
			end_time = 0,
			level = 0
		}
	}

	Managers.state.event:trigger("buffs_activated", player, self._hud_buff_blackboard)
end

function HumanAreaBuffServer:set_game_object_id(obj_id, game)
	self._id = obj_id
	self._game = game
end

function HumanAreaBuffServer:update(dt, t)
	return
end

function HumanAreaBuffServer:cb_game_session_disconnect()
	self._id = nil
	self._game = nil
end

function HumanAreaBuffServer:buff_multiplier(buff_type)
	if self._game then
		local level = GameSession.game_object_field(self._game, self._id, Buffs[buff_type].game_obj_level_key)
		local multiplier = BuffLevelMultiplierFunctions[buff_type](level)

		return multiplier
	end

	return BuffLevelMultiplierFunctions[buff_type](0)
end

function HumanAreaBuffServer:buff_level(buff_type)
	if self._game then
		return GameSession.game_object_field(self._game, self._id, Buffs[buff_type].game_obj_level_key)
	else
		return 0
	end
end

function HumanAreaBuffServer:end_time(buff_type)
	if self._game then
		return GameSession.game_object_field(self._game, self._id, Buffs[buff_type].game_obj_end_time_key)
	else
		return 0
	end
end

function HumanAreaBuffServer:set_buff_level(buff_type, value)
	self._hud_buff_blackboard[buff_type].level = value

	if self._game then
		GameSession.set_game_object_field(self._game, self._id, Buffs[buff_type].game_obj_level_key, value)
	end
end

function HumanAreaBuffServer:set_end_time(buff_type, value)
	self._hud_buff_blackboard[buff_type].end_time = value

	if self._game then
		GameSession.set_game_object_field(self._game, self._id, Buffs[buff_type].game_obj_end_time_key, value)
	end
end

function HumanAreaBuffServer:remove_game_object_id()
	self._id = nil
	self._game = nil
end

function HumanAreaBuffServer:destroy()
	return
end
