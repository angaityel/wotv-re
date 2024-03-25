-- chunkname: @scripts/settings/medals.lua

require("scripts/settings/prizes_medals_unlocks_ui_settings")

Medals = class(Medals)
Medals.COLLECTION = {}

function Medals:init(stats_collection)
	self._stats = stats_collection
end

function Medals:register_player(player)
	local network_id = player:network_id()

	for medal_name, props in pairs(self.COLLECTION) do
		if not self._stats:get(network_id, medal_name) then
			local stat_name, condition, value = unpack(props.stat_settings)
			local callback = callback(self, "_cb_award_medal", player, medal_name)

			self._stats:register_callback(network_id, stat_name, condition, value, callback)
		end
	end
end

function Medals:_cb_award_medal(player, medal_name)
	if Managers.state.network:game() and Managers.state.team:stats_requirement_fulfilled() then
		printf("%q got awarded %q medal!", player:network_id(), medal_name)
		self._stats:set(player:network_id(), medal_name, true)
		RPC.rpc_award_medal(player:network_id(), player.game_object_id, NetworkLookup.medals[medal_name])
	end
end
