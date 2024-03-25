-- chunkname: @scripts/managers/spawn/squad_point_spawn_component.lua

SquadPointSpawnComponent = class(SquadPointSpawnComponent)

function SquadPointSpawnComponent:init(spawn_manager, world)
	self._spawn_manager = spawn_manager
	self._world = world
	self._points = {}
	self._squad_spawn_points = nil

	Managers.state.event:register(self, "event_round_started", "event_server_round_started")
end

function SquadPointSpawnComponent:flow_cb_add_squad_point(point)
	local points = self._points

	points[#points + 1] = point
end

function SquadPointSpawnComponent:event_server_round_started()
	self:_random_assign_squad_points()
end

function SquadPointSpawnComponent:_random_assign_squad_points()
	if #self._points < 2 then
		print("SquadPointSpawnComponent:_random_assign_squad_points(): Missing squad spawn points!")

		return
	end

	local team_manager = Managers.state.team
	local squads = {}
	local sides = team_manager:sides()
	local num_sides = 0

	for _, _ in pairs(sides) do
		num_sides = num_sides + 1
	end

	local points = table.clone(self._points)
	local num_points_per_side = math.floor(#points / num_sides)

	for _, side in pairs(sides) do
		local team = team_manager:team_by_side(side)
		local squad_list = {}

		squads[team.name] = squad_list

		local team_points = {}

		for i = 1, num_points_per_side do
			local index = Math.random(1, #points)

			team_points[#team_points + 1] = points[index]

			table.remove(points, index)
		end

		for index, squad in ipairs(team.squads) do
			squad_list[index] = team_points[(index - 1) % #team_points + 1]
		end
	end

	self._squad_spawn_points = squads
end

function SquadPointSpawnComponent:can_spawn(player)
	return player.spawn_data.spawn_squad_point_unit and #self._points >= 2 or false
end

function SquadPointSpawnComponent:spawn(player)
	self._spawn_manager:_spawn_player_unit_at_unit(player, player.spawn_data.spawn_squad_point_unit, true, true)
end

function SquadPointSpawnComponent:valid_spawn_target(player, unit)
	local points = player.team and self._squad_spawn_points[player.team.name]

	if not points then
		return false
	end

	local squad_index = player.squad_index

	if squad_index and unit ~= points[squad_index] then
		return false
	end

	return true
end

function SquadPointSpawnComponent:set_spawn_target(player)
	local spawn_data = player.spawn_data

	if Managers.lobby.server or not Managers.lobby.lobby then
		if spawn_data.state == "ghost_mode" then
			self._spawn_manager:despawn_player_unit(player)
		end

		spawn_data.mode = "squad_point"
		spawn_data.spawn_squad_point_unit = self:find_point(player)
	elseif Managers.state.network:game() then
		fassert(player.team.name ~= "unassigned", "[SquadPointSpawnComponent:set_spawn_target()] Client tried to request a squad point spawn while still in team unassigned.")

		spawn_data.mode = "unconfirmed_squad_point"

		Managers.state.network:send_rpc_server("rpc_request_squad_point_spawn_target", player:player_id())
	end
end

function SquadPointSpawnComponent:request_spawn(player)
	if #self._points < 2 then
		print("SquadPointSpawnComponent:request_spawn(): Missing squad spawn points!")

		return
	end

	self:set_spawn_target(player)
end

function SquadPointSpawnComponent:find_point(player)
	local team = player.team
	local squad_index = player.squad_index or Math.random(1, #team.squads)

	return self._squad_spawn_points[team.name][squad_index]
end
