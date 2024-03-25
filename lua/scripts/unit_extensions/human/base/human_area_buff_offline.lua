-- chunkname: @scripts/unit_extensions/human/base/human_area_buff_offline.lua

HumanAreaBuffOffline = class(HumanAreaBuffOffline, HumanAreaBuffServer)
HumanAreaBuffOffline.SERVER_ONLY = false
HumanAreaBuffOffline.OFFLINE_ONLY = true

function HumanAreaBuffOffline:init(world, unit)
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
