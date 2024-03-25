-- chunkname: @scripts/settings/achievements.lua

Achievements = class(Achievements)
Achievements.COLLECTION = {
	{
		"revives",
		"=",
		1
	},
	{
		"saxon_squad_leader_kills",
		"=",
		10
	},
	{
		"viking_squad_leader_kills",
		"=",
		10
	},
	{
		"throwing_dagger_kills",
		"=",
		1
	},
	{
		"mark_it_zero",
		"=",
		true
	},
	{
		"ragnar_lothbrok",
		"=",
		true
	},
	{
		"rank",
		"=",
		60
	},
	{
		"wins_in_a_row",
		"=",
		10
	},
	{
		"rank",
		"=",
		10
	},
	{
		"rank",
		"=",
		20
	},
	{
		"rank",
		"=",
		30
	},
	{
		"rank",
		"=",
		40
	},
	{
		"rank",
		"=",
		50
	}
}

function Achievements:init(stats_collection)
	self._stats = stats_collection
end

function Achievements:register_player(player)
	local network_id = player:network_id()

	for achievement_id, props in pairs(self.COLLECTION) do
		if not self._stats:get(network_id, "achievement_" .. achievement_id) then
			local stat_name, condition, value = unpack(props)
			local callback = callback(self, "_cb_award_achievement", player, achievement_id)

			self._stats:register_callback(network_id, stat_name, condition, value, callback)
		end
	end
end

function Achievements:_cb_award_achievement(player, achievement_id)
	if Managers.state.network:game() and Managers.state.team:stats_requirement_fulfilled() then
		printf("%q got awarded achievement %d", player:network_id(), achievement_id)
		self._stats:set(player:network_id(), "achievement_" .. achievement_id, true)
		RPC.rpc_award_achievement(player:network_id(), player.game_object_id, achievement_id)
	end
end
