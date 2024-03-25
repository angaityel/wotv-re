-- chunkname: @scripts/managers/stats/stats_synchronizer.lua

StatsSynchronizer = class(StatsSynchronizer)
StatsSynchronizer.STATS_TO_SYNC = {
	domination_objectives_captured = "stat_domination_objectives_captured",
	experience_round = "stat_experience_round",
	deaths = "stat_deaths",
	enemy_kills = "stat_enemy_kills",
	enemy_damage = "stat_enemy_damage",
	headshots = "stat_headshots",
	domination_objectives_captured_assist = "stat_domination_objectives_captured_assist",
	con_objectives_captured = "stat_con_objectives_captured",
	longshots = "stat_longshots",
	longshot_range = "stat_longshot_range",
	con_objectives_captured_assist = "stat_con_objectives_captured_assist",
	longest_kill_streak = "stat_longest_kill_streak",
	kill_streak = "stat_kill_streak",
	developer = "stat_developer",
	rank = "stat_rank",
	team_bandages = "stat_team_bandages",
	assists = "stat_assists",
	score_round = "stat_score_round"
}

function StatsSynchronizer:init(stats_collection)
	self._stats = stats_collection
	self._players = Managers.player:players()

	if Managers.lobby.server then
		self._is_client = false
	else
		self._is_client = true
	end

	Managers.state.event:register(self, "player_stats_object_created", "event_player_stats_object_created")
end

function StatsSynchronizer:update(dt, t, network_game)
	Profiler.start("StatsSynchronizer")

	if self._is_client then
		self:_client_update(network_game)
	else
		self:_server_update(network_game)
	end

	Profiler.stop()
end

function StatsSynchronizer:event_player_stats_object_created(network_game, player, stat_game_object_id)
	local network_id = player:network_id()

	for stat_name, _ in pairs(self.STATS_TO_SYNC) do
		local stat_value = GameSession.game_object_field(network_game, stat_game_object_id, stat_name)

		if stat_value ~= self._stats:get(network_id, stat_name) then
			self._stats:raw_set(network_id, stat_name, stat_value)
		end
	end
end

function StatsSynchronizer:_client_update(network_game)
	for _, player in pairs(self._players) do
		local network_id = player:network_id()
		local game_object_id = player.stat_game_object_id

		if game_object_id then
			for stat_name, _ in pairs(self.STATS_TO_SYNC) do
				local stat_value = GameSession.game_object_field(network_game, game_object_id, stat_name)

				if stat_value ~= self._stats:get(network_id, stat_name) then
					self._stats:set(network_id, stat_name, stat_value)
				end
			end
		end
	end
end

local function vector3_clamp_i(v, min, max)
	v.x = math.clamp(v.x, min, max)
	v.y = math.clamp(v.y, min, max)
	v.z = math.clamp(v.z, min, max)
end

function StatsSynchronizer:_server_update(network_game)
	Profiler.start("StatsSynchronizer:_server_update")

	for _, player in pairs(self._players) do
		local network_id = player:network_id()
		local game_object_id = player.stat_game_object_id

		if game_object_id then
			for stat_name, stat_type in pairs(self.STATS_TO_SYNC) do
				local stat_value = self._stats:get(network_id, stat_name)
				local network_info = NetworkConstants[stat_type]
				local network_type = network_info.type

				if network_type == Network.INT or network_type == Network.FLOAT then
					stat_value = math.clamp(stat_value, network_info.min, network_info.max)
				elseif network_type == Network.VECTOR3 then
					vector3_clamp_i(stat_value, network_info.min, network_info.max)
				end

				GameSession.set_game_object_field(network_game, game_object_id, stat_name, stat_value)
			end
		end
	end

	Profiler.stop()
end
