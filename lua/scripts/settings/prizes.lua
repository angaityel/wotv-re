-- chunkname: @scripts/settings/prizes.lua

require("scripts/settings/prizes_medals_unlocks_ui_settings")

Prizes = class(Prizes)
Prizes.COLLECTION = {}

function Prizes:init(stats_collection)
	self._stats = stats_collection
end

function Prizes:register_player(player)
	local network_id = player:network_id()

	for prize_name, props in pairs(self.COLLECTION) do
		local stat_name, condition, value = unpack(props.stat_settings)
		local callback = callback(self, "_cb_award_prize", player, prize_name)

		self._stats:register_callback(network_id, stat_name, condition, value, callback)
	end
end

function Prizes:_cb_award_prize(player, prize_name)
	if Managers.state.network:game() and Managers.state.team:stats_requirement_fulfilled() then
		printf("%q got awarded %q prize!", player:network_id(), prize_name)
		self._stats:increment(player:network_id(), prize_name, 1)
		RPC.rpc_award_prize(player:network_id(), player.game_object_id, NetworkLookup.prizes[prize_name])
	end
end
