-- chunkname: @scripts/managers/tagging/tagging_manager.lua

TaggingManagerBase = class(TaggingManagerBase)

function TaggingManagerBase:init(world)
	self._world = world
	self._selected_units = {}
	self._tagging_active = {}
	self._challenging_active = {}
end

function TaggingManagerBase:set_tagging_active(player, active)
	self._tagging_active[player.index] = active
end

function TaggingManagerBase:set_challenging_active(player, active)
	self._challenging_active[player.index] = active
end

function TaggingManagerBase:set_icon_active_units(player, camera, ui_taggable_units)
	local best_value = -math.huge
	local best_unit
	local old_selected_unit = self:selected_unit(player)
	local player_unit = player.player_unit

	if not Unit.alive(player_unit) or not self._tagging_active[player.index] and not self._challenging_active[player.index] then
		self:set_selected_unit(player, nil)

		return
	end

	if not ScriptUnit.has_extension(player_unit, "locomotion_system") then
		self:set_selected_unit(player, nil)

		return
	end

	local locomotion = ScriptUnit.extension(player_unit, "locomotion_system")
	local self_kd = locomotion.current_state_name == "knocked_down"

	for _, unit in ipairs(ui_taggable_units) do
		if PlayerMechanicsHelper.tag_valid(player, unit, self_kd) then
			local world_position = Unit.world_position(unit, 0) + Vector3(0, 0, 1)
			local screen_coords = Camera.world_to_screen(camera, world_position)
			local res_width, res_height = Gui.resolution()
			local middle_offset = Vector3(res_width * 0.5 - screen_coords.x, res_height * 0.5 - screen_coords.z, 0)
			local distance = Vector3.length(middle_offset) / res_width

			if old_selected_unit == unit then
				distance = distance * 0.8
			end

			local zone = 0.15

			if distance < zone then
				local scaled_distance = distance / zone
				local score_value = math.sqrt(1 - scaled_distance^2)
				local depth_scaled_score_value = (score_value - 1) * screen_coords.y * 0.6

				if best_value < depth_scaled_score_value then
					best_value = depth_scaled_score_value
					best_unit = unit
				end
			end
		end
	end

	self:set_selected_unit(player, best_unit)

	return best_unit
end

function TaggingManagerBase:set_selected_unit(player, unit)
	local player_index = player.index

	self._selected_units[player_index] = unit
end

function TaggingManagerBase:selected_unit(player)
	local player_index = player.index

	return self._selected_units[player_index]
end

TaggingManagerClient = class(TaggingManagerClient, TaggingManagerBase)
TaggingManagerServer = class(TaggingManagerServer, TaggingManagerBase)

function TaggingManagerServer:init(world)
	TaggingManagerServer.super.init(self, world)

	self._tags = {}

	Managers.state.event:register(self, "player_unit_dead", "event_player_unit_dead", "remote_player_destroyed", "event_remote_player_destroyed", "player_no_longer_corporal", "event_player_no_longer_corporal")
end

function TaggingManagerServer:event_remote_player_destroyed(player)
	self:_remove_tag(player, "player_disconect")
end

function TaggingManagerServer:event_player_no_longer_corporal(player)
	self:_remove_tag(player, "player_no_longer_corporal")
end

function TaggingManagerServer:event_player_unit_dead(player)
	self:_remove_tag(player, "player_unit_dead")
end

function TaggingManagerServer:update(dt, t)
	local round_t = Managers.time:time("round")

	for tagging_player, tag in pairs(self._tags) do
		if round_t >= tag.end_time then
			self:_remove_tag(tagging_player, "player_tag_timed_out")
		end
	end

	if script_data.tagging_debug then
		for _, tag in pairs(self._tags) do
			table.dump(tag)
		end
	end
end

function TaggingManagerServer:can_tag_player_unit(player, tagged_unit)
	local tagger_unit = player.player_unit

	if Unit.alive(tagger_unit) and Unit.alive(tagged_unit) then
		local tagger_damage_ext = ScriptUnit.extension(tagger_unit, "damage_system")
		local tagee_damage_ext = ScriptUnit.extension(tagged_unit, "damage_system")

		if not tagger_damage_ext:is_dead() and not tagee_damage_ext:is_dead() then
			return true
		end
	end

	return false
end

function TaggingManagerServer:can_tag_objective(player, tagged_unit)
	local tagger_unit = player.player_unit

	if Unit.alive(tagger_unit) and Unit.alive(tagged_unit) then
		local tagger_locomotion_ext = ScriptUnit.extension(tagger_unit, "locomotion_system")
		local tagger_damage_ext = ScriptUnit.extension(tagger_unit, "damage_system")

		if player.is_corporal and not tagger_damage_ext:is_dead() and tagger_locomotion_ext:has_perk("officer_training") then
			return true
		end
	end

	return false
end

function TaggingManagerServer:add_player_unit_tag(tagging_player, tagged_unit, end_time)
	local tags = self._tags

	if not tags[tagging_player] then
		tags[tagging_player] = {}
	end

	local player_tag = tags[tagging_player]

	player_tag.tagged_unit = tagged_unit
	player_tag.end_time = end_time

	local game = Managers.state.network:game()

	if game then
		local tagged_player_object_id = Unit.get_data(tagged_unit, "game_object_id")

		GameSession.set_game_object_field(game, tagging_player.game_object_id, "tagged_player_object_id", tagged_player_object_id)
		GameSession.set_game_object_field(game, tagging_player.game_object_id, "tagged_objective_level_id", 0)
	end
end

function TaggingManagerServer:add_objective_tag(tagging_player, tagged_unit, end_time)
	local tags = self._tags

	if not tags[tagging_player] then
		tags[tagging_player] = {}
	end

	local player_tag = tags[tagging_player]

	player_tag.tagged_unit = tagged_unit
	player_tag.end_time = end_time

	local game = Managers.state.network:game()

	if game then
		local objective_system = ScriptUnit.extension(tagged_unit, "objective_system")
		local tagged_objective_level_id = objective_system:level_index()

		GameSession.set_game_object_field(game, tagging_player.game_object_id, "tagged_objective_level_id", tagged_objective_level_id)
		GameSession.set_game_object_field(game, tagging_player.game_object_id, "tagged_player_object_id", 0)
	end
end

function TaggingManagerServer:_remove_tag(player, reason)
	local player_manager = Managers.player
	local tags = self._tags
	local player_tag = tags[player]

	if reason == "player_disconect" then
		for tagging_player, tag in pairs(tags) do
			if player_manager:owner(tag.tagged_unit) == player then
				tag.end_time = 0
				tag.tagged_unit = nil
			end
		end

		tags[player] = nil
	elseif reason == "player_tag_timed_out" or reason == "player_no_longer_corporal" then
		if player_tag then
			player_tag.end_time = 0
			player_tag.tagged_unit = nil
		end
	elseif reason == "player_unit_dead" then
		for tagging_player, tag in pairs(tags) do
			if player_manager:owner(tag.tagged_unit) == player then
				tag.end_time = 0
				tag.tagged_unit = nil
			end
		end

		if player_tag and not player.is_corporal then
			player_tag.end_time = 0
			player_tag.tagged_unit = nil
		end
	end

	local game = Managers.state.network:game()

	if game then
		GameSession.set_game_object_field(game, player.game_object_id, "tagged_player_object_id", 0)
		GameSession.set_game_object_field(game, player.game_object_id, "tagged_objective_level_id", 0)
	end
end

function TaggingManagerServer:tagger_by_tagged_unit(tagged_unit)
	for player, tag_info in pairs(self._tags) do
		if tag_info.tagged_unit == tagged_unit then
			return player
		end
	end
end
