-- chunkname: @scripts/managers/command_parser/command_parser_manager.lua

CommandParserManager = class(CommandParserManager)

local COMMAND_PREFIX = "/"
local ARGUMENT_PREFIX = " "

function CommandParserManager:init()
	return
end

function CommandParserManager:execute(command_line, player)
	local command, argument = self:_parse_command_line(command_line)
	local command_func = Commands[command]
	local success, message

	if command_func then
		success, message = command_func(self, argument, player)
	elseif not command then
		message = sprintf("Missing command, eg: /say <message>")
	else
		message = sprintf("Invalid command %q", command)
	end

	return success, message, command, argument
end

function CommandParserManager:_is_valid_command_line(command_line)
	if string.sub(command_line, 1, string.len(COMMAND_PREFIX)) == COMMAND_PREFIX then
		return true
	end
end

function CommandParserManager:_parse_command_line(command_line)
	if self:_is_valid_command_line(command_line) then
		local cmd_prefix_start, cmd_prefix_end = string.find(command_line, COMMAND_PREFIX)
		local arg_prefix_start, arg_prefix_end = string.find(command_line, ARGUMENT_PREFIX, cmd_prefix_end)
		local command, argument

		if arg_prefix_start then
			command = string.sub(command_line, cmd_prefix_end + 1, arg_prefix_start - 1)
		else
			command = string.sub(command_line, cmd_prefix_end + 1)
		end

		if arg_prefix_end then
			argument = string.sub(command_line, arg_prefix_end + 1)
		end

		return command, argument
	end
end

function CommandParserManager:build_command_line(command, argument)
	local cmd_line = COMMAND_PREFIX .. command

	if argument then
		cmd_line = cmd_line .. ARGUMENT_PREFIX .. argument
	end

	return cmd_line
end

function CommandParserManager:destroy()
	return
end

Commands = {}

function Commands:script(lua_code, player)
	if Application.build() ~= "dev" then
		return false, ""
	end

	local code_function = loadstring(lua_code)

	if code_function then
		local ret = {
			code_function()
		}

		if #ret == 0 then
			Managers.state.hud:output_console_text("nil")
		else
			for _, val in ipairs(ret) do
				Managers.state.hud:output_console_text(tostring(val))
			end
		end
	else
		local code_function2 = loadstring("return " .. lua_code)

		if code_function2 then
			Managers.state.hud:output_console_text(tostring(code_function2()))
		end
	end

	return true, ""
end

function Commands:lag(text)
	if Managers.lobby.lobby and text then
		Network.write_dump_tag(text)
		Managers.state.hud:output_console_text("Lag description '" .. text .. "' written to network dump.")
	elseif Managers.lobby.lobby then
		Managers.state.hud:output_console_text("No lag description written to network dump.")
	else
		Managers.state.hud:output_console_text("Lag description '" .. text .. "' not written to network dump since network is not initialized.")
	end

	return true, ""
end

function Commands:location(text)
	if Managers.lobby.server then
		return false, ""
	end

	Managers.state.event:trigger("location_print_requested")
end

function Commands:say(text, player)
	if text and text ~= "" then
		local channel_name = "all"

		if Managers.state and Managers.state.game_mode and player then
			local spawn_state = player.spawn_data.state

			channel_name = not (not Managers.state.game_mode:allow_ghost_talking() and (spawn_state == "dead" or spawn_state == "not_spawned")) and "all" or "dead"
		end

		local channel_id = NetworkLookup.chat_channels[channel_name]

		Managers.chat:send_chat_message(channel_id, text)

		return true
	end

	return false, "Missing text for /say"
end

function Commands:say_team(text, player)
	if text and text ~= "" and player and player.team then
		local spawn_state = player.spawn_data.state
		local dead = not Managers.state.game_mode:allow_ghost_talking() and (spawn_state == "dead" or spawn_state == "not_spawned")
		local channel_id = player.team:team_chat_channel_id(dead)

		Managers.chat:send_chat_message(channel_id, text)

		return true, ""
	end

	return false, "Missing text or team for /say_team"
end

function Commands:say_admin(text, player)
	if Managers.lobby.server then
		if text and text ~= "" then
			Managers.chat:send_chat_message(1, text, "rpc_admin_chat_message")

			return true
		else
			return false, sprintf("Missing text for /say_admin")
		end
	else
		return false, sprintf("Server command only.")
	end
end

function Commands:kill(text, player)
	local network_manager = Managers.state.network
	local unit = player.player_unit

	if unit and Unit.alive(unit) then
		if Managers.lobby.server or not Managers.lobby.lobby then
			local damage = ScriptUnit.extension(unit, "damage_system")

			if not damage:is_knocked_down() and not damage:is_dead() and not damage:is_last_stand_active() then
				damage:die(Managers.player:owner(unit), nil, true)

				return true, "Your wish is my command."
			end

			return false, "No character to kill."
		elseif Managers.state.network:game() then
			local damage = ScriptUnit.extension(unit, "damage_system")

			if not damage:is_knocked_down() and not damage:is_dead() and not damage:is_last_stand_active() then
				local object_id = network_manager:game_object_id(unit)

				network_manager:send_rpc_server("rpc_suicide", object_id)

				return true
			end

			return false, "No character to kill."
		else
			return false
		end
	else
		return false, "No character to kill."
	end
end

function Commands:console(args, player)
	if Application.build() ~= "dev" or not args then
		return false
	end

	local args_table = string.split(args, " ")
	local console_command_name = table.remove(args_table, 1)

	if #args_table > 0 then
		Application.console_command(console_command_name, unpack(args_table))
	else
		Application.console_command(console_command_name)
	end

	return true, ""
end

function Commands:game_speed(args, player)
	if Application.build() ~= "dev" then
		return false
	end

	if not args then
		return false, "Missing speed value."
	end

	local args_table = string.split(args, " ")
	local multiplier = tonumber(args_table[1])

	if not multiplier then
		return false, "Speed value not a valid number."
	end

	if type(multiplier) == "number" and Managers.state.network:game() then
		multiplier = math.clamp(multiplier, NetworkConstants.time_multiplier.min, NetworkConstants.time_multiplier.max)

		Managers.state.network:send_rpc_server("rpc_set_game_speed", multiplier)

		return true, sprintf("Game speed changed to %q.", args_table[1])
	end

	return false, "Speed value not a valid number."
end

function Commands:fov(args, player)
	if Application.build() ~= "dev" then
		return false
	end

	if not args then
		return false, "Missing value for fov."
	end

	local args_table = string.split(args, " ")
	local fov = tonumber(args_table[1])

	if fov then
		script_data.fov_override = fov

		return true, sprintf("Changed fov to %q", fov)
	else
		return false, sprintf("Invalid fov %q", args_table[1])
	end
end

function Commands:free_flight_settings(args, player)
	if Application.build() ~= "dev" or not player then
		return
	end

	if not args then
		return false, "Missing free flight options."
	end

	local args_table = string.split(args, " ")
	local translation_acceleration = tonumber(args_table[1])
	local rotation_speed = tonumber(args_table[2])
	local return_string = "f8 free flight:"

	if translation_acceleration then
		player.free_flight_acceleration_factor = translation_acceleration
		return_string = return_string .. " translation acceleration: " .. translation_acceleration
	end

	if rotation_speed then
		player.free_flight_movement_filter_speed = rotation_speed
		return_string = return_string .. " rotation speed: " .. rotation_speed
	end

	return true, return_string
end

function Commands:rcon(args, player)
	if Managers.lobby.server then
		return false, "Can't rcon at server."
	end

	if player.rcon_admin then
		Managers.state.hud:output_console_text(sprintf("[rcon]: ***** %s", args))
		Managers.state.network:send_rpc_server("rpc_rcon", "", args)
	elseif args then
		local b, e = args:find("%s")

		if b and e then
			local hash = Application.make_hash(args:sub(1, b - 1))
			local command = args:sub(e + 1)

			Managers.state.hud:output_console_text(sprintf("[rcon]: ***** %s", command))
			Managers.state.network:send_rpc_server("rpc_rcon", hash, command)
		else
			local hash = Application.make_hash(args:sub(1))

			Managers.state.hud:output_console_text(sprintf("[rcon]: *****"))
			Managers.state.network:send_rpc_server("rpc_rcon", hash, "")
		end
	end
end

function Commands:next_level()
	Managers.state.event:trigger("next_level")

	return true, "Next level..."
end

function Commands:list_players()
	if Managers.lobby.server then
		return false, "Does not work through rcon interface"
	end

	local players = Managers.player:players()

	for _, player in pairs(players) do
		Managers.state.hud:output_console_text(player:name() .. " ID = \t\t" .. player:network_id())
	end
end

function Commands:kick_player(args)
	if Managers.lobby.server then
		if not args then
			return false, "Missing arguments"
		end

		args = string.split(args, " ")

		local peer_id = args[1]
		local peer_id, reason = peer_id, args[2] or "kicked"

		if Managers.state.network:is_valid_peer(peer_id) then
			Managers.admin:kick_player(peer_id, reason)

			return true, sprintf("Player with ID %s kicked", peer_id)
		else
			return false, sprintf("No player found with ID %s", peer_id)
		end
	end
end

function Commands:ban_player(args)
	if Managers.lobby.server then
		if not args then
			return false, "Missing arguments"
		end

		args = string.split(args, " ")

		local peer_id = args[1]
		local peer_id, reason = peer_id, args[2] or "banned"

		if Managers.state.network:is_valid_peer(peer_id) then
			Managers.admin:ban_player(peer_id, reason)

			return true, sprintf("Player with ID %s banned", peer_id)
		else
			return false, sprintf("No player found with ID %s", peer_id)
		end
	end
end

function Commands:temp_ban_player(args)
	if Managers.lobby.server then
		if not args then
			return false, "Missing arguments"
		end

		args = string.split(args, " ")

		local peer_id = args[1]
		local duration = tonumber(args[2])
		local peer_id, duration, reason = peer_id, duration, args[3] or "banned"

		if Managers.state.network:is_valid_peer(peer_id) and duration then
			duration = 3600 * duration

			Managers.admin:ban_player(peer_id, reason, duration)

			return true, sprintf("Player with ID %s banned for %d hours", peer_id, duration)
		else
			return false, sprintf("No player found with ID %s", peer_id)
		end
	end
end

function Commands:unban_player(id_or_name)
	local response = Managers.admin:unban_player(id_or_name)

	if response then
		return false, sprintf("No player found with name/ID %s", response)
	else
		return true, sprintf("Player with name/ID %s unbanned", id_or_name)
	end
end

function Commands:kill_player(peer_id)
	if Managers.lobby.server then
		if Managers.state.network:is_valid_peer(peer_id) then
			Managers.admin:kill_player(peer_id)

			return true, sprintf("Player with ID %s killed", peer_id)
		else
			return false, sprintf("No player found with ID %s", peer_id)
		end
	end
end

Commands.ban = Commands.ban_player
Commands.kick = Commands.kick_player
Commands.temp_ban = Commands.temp_ban_player
Commands.unban = Commands.unban_player

function Commands:set_friendly_fire(config)
	if Managers.lobby.server then
		local melee_value, melee_mirrored, ranged_value, ranged_mirrored = unpack_string(config)

		melee_value, melee_mirrored, ranged_value, ranged_mirrored = Managers.admin:set_friendly_fire(melee_value, melee_mirrored, ranged_value, ranged_mirrored)

		return true, sprintf("Friendly fire settings changed: Melee damage multiplier = %s Mirror melee damage = %s Range damage multiplier = %s Mirror range damage = %s", tostring(melee_value), tostring(melee_mirrored), tostring(ranged_value), tostring(ranged_mirrored))
	end
end

function Commands:vote_kick(peer_id, player)
	if Managers.lobby.server then
		return false, "Can't votekick on server, just kick."
	end

	local network_manager = Managers.state.network

	if Managers.state.network:is_valid_peer(peer_id) then
		network_manager:send_rpc_server("rpc_vote_kick", peer_id, player:player_id())
	else
		Managers.state.hud:output_console_text(sprintf(L("chat_cant_votekick_no_player"), peer_id), Vector3(163, 28, 166))

		return false, sprintf(L("chat_cant_votekick_no_player"), peer_id)
	end
end

function Commands:y(_, player)
	if Managers.lobby.server then
		return false, "Voting not allowed on server."
	end

	Managers.state.voting:client_vote("yes", player)
end

function Commands:n(_, player)
	if Managers.lobby.server then
		return false, "Voting not allowed on server."
	end

	Managers.state.voting:client_vote("no", player)
end

function Commands:reload_level()
	if Managers.lobby.server then
		Managers.state.event:trigger("reload_level")

		return true, "Reloading level"
	end
end

function Commands:change_level(map_pair)
	if Managers.lobby.server then
		local server_map_name, game_mode = unpack_string(map_pair or "")

		if not server_map_name then
			return false, "Map name missing. For example: /rcon <password> /change_level <level_name> tdm"
		end

		if not game_mode then
			return true, "Game mode missing. For example: /rcon <password> /change_level <level_name> tdm"
		end

		local level_key = server_map_name_to_level_key(server_map_name)

		if not level_key then
			return true, sprintf("Invalid map name: %s", server_map_name)
		end

		local settings = Managers.admin:map_rotation_settings(level_key, game_mode)

		if not settings then
			return true, sprintf("Map %q and game mode %q is not defined in map_rotations settings file. Run /list_levels to see which maps are available.", server_map_name, game_mode)
		end

		local level_name = L(LevelSettings[level_key].display_name)
		local message = "Changing level to " .. level_name .. "..."

		Managers.chat:send_chat_message(1, message, "rpc_admin_chat_message")
		Managers.state.event:trigger("change_level", level_key, settings)

		return true, "Changing level..."
	end
end

function Commands:dance(text, player)
	if player and not player.remote and Unit.alive(player.player_unit) and ScriptUnit.has_extension(player.player_unit, "locomotion_system") then
		local locomotion_ext = ScriptUnit.extension(player.player_unit, "locomotion_system")

		locomotion_ext:dance()

		return true
	end

	if Managers.lobby.server then
		return false, "Server doesn't want to dance."
	else
		return false
	end
end

function Commands:save_progress(flag)
	if Managers.lobby.server then
		local flag = to_boolean(flag)

		Managers.persistence:set_save_progress(flag)

		return true, sprintf("Save progression set to %s", tostring(flag))
	end
end

function Commands:move_player(peer_team_pair)
	if Managers.lobby.server then
		local peer_id, team_name = unpack_string(peer_team_pair or "")
		local player = Managers.state.network:player_from_peer_id(peer_id)

		if not peer_id then
			return true, "Player ID missing"
		end

		if not player then
			return true, sprintf("Invalid player ID %q. See list of available peers with /list_players", peer_id)
		end

		if not team_name then
			return true, "Team name is missing. Available teams are 'red' and 'white'"
		end

		team_name = team_name:lower()

		if team_name ~= "red" and team_name ~= "white" then
			return true, sprintf("Invalid team name %q. Available teams are 'red' and 'white'", team_name)
		end

		if team_name == player.team.name then
			return true, sprintf("Player %q (%s) is already member of team %q", player:name(), peer_id, team_name)
		end

		local message = sprintf("Moving player %q (%s) to team %q", player:name(), peer_id, team_name)

		Managers.chat:send_chat_message(1, message, "rpc_admin_chat_message")
		Managers.state.team:move_player_to_team_by_name(player, team_name)
		Managers.admin:kill_player(peer_id)

		return true, message
	end
end

function Commands:login(_, player)
	if Managers.lobby.server then
		local peer_id = player:network_id()
		local rcon_admin = Managers.admin:rcon_admin()
		local rcon_player = Managers.state.network:player_from_peer_id(rcon_admin)

		if not rcon_player then
			rcon_admin = nil

			Managers.admin:set_rcon_admin(nil)
		end

		if rcon_admin == peer_id then
			return true, "You are already logged in as RCON admin"
		elseif rcon_admin and rcon_admin ~= peer_id then
			return true, sprintf("Player with ID %s is currently logged in as RCON admin", rcon_admin)
		end

		Managers.admin:set_rcon_admin(peer_id)
		RPC.rpc_rcon_logged_in(peer_id, player:player_id())

		return true, "Successfully logged in as RCON admin"
	end
end

function Commands:logout(_, player)
	if Managers.lobby.server then
		local peer_id = player:network_id()
		local rcon_admin = Managers.admin:rcon_admin()

		if rcon_admin ~= peer_id then
			return true, "You are not logged in as RCON admin"
		end

		Managers.admin:set_rcon_admin(nil)
		RPC.rpc_rcon_logged_out(peer_id, player:player_id())

		return true, "Successfully logged out as RCON admin"
	end
end

function Commands:list_levels()
	if not Managers.lobby.server then
		local network_manager = Managers.state.network

		if network_manager:game() then
			network_manager:send_rpc_server("rpc_map_rotation")
		end

		return true
	end

	return false, "Don't run through /rcon interface"
end

Commands.list_maps = Commands.list_levels

function Commands:vote_map(map_pair, player)
	if Managers.lobby.server then
		return false, "Can't vote for maps on server."
	end

	if Managers.time:has_timer("loading") then
		Managers.state.hud:output_console_text(L("chat_cant_votemap_during_loading"), Vector3(163, 28, 166))

		return false, "Can't start a map-vote during loading."
	end

	local network_manager = Managers.state.network

	if network_manager:game() then
		network_manager:send_rpc_server("rpc_vote_map", player:player_id(), map_pair or "")
	end
end

Commands.vote_level = Commands.vote_map
Commands.v = Commands.vote_map
Commands.vote = Commands.vote_map
Commands.list_maps = Commands.list_levels
Commands.list = Commands.list_levels
Commands.maps = Commands.list_levels
Commands.l = Commands.list_levels
