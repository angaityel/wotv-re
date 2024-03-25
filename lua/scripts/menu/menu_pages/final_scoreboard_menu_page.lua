-- chunkname: @scripts/menu/menu_pages/final_scoreboard_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/texture_menu_container")
require("scripts/menu/menu_containers/rect_menu_container")
require("scripts/menu/menu_containers/text_box_menu_container")
require("scripts/menu/menu_containers/free_layout_menu_container")
require("scripts/menu/menu_pages/teams_menu_page")

FinalScoreboardMenuPage = class(FinalScoreboardMenuPage, TeamsMenuPage)

function FinalScoreboardMenuPage:init(config, item_groups, world)
	FinalScoreboardMenuPage.super.init(self, config, item_groups, world)
	Managers.state.event:register(self, "gm_event_end_conditions_met", "gm_event_end_conditions_met", "award_coins", "event_award_coins")

	self._containers = {
		coin_award = {
			container = FreeLayoutMenuContainer.create_from_config(item_groups.coin_award),
			visible_function = self._coin_award_visible,
			position_function = self._coin_award_position
		},
		center_items = {
			container = self._center_items_container,
			visible_function = self._center_items_visible,
			position_function = self._container_position
		},
		left_team_items = {
			container = self._left_team_items_container,
			visible_function = self._show,
			position_function = self._side_container_position
		},
		right_team_items = {
			container = self._right_team_items_container,
			self._right_team_items_container,
			visible_function = self._show,
			position_function = self._side_container_position
		}
	}
	self._timer = 0
	self._coin_award_data = nil
	self._pulsing_items = {}
end

function FinalScoreboardMenuPage:update(dt, t)
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local z = self.config.z
	local gui = self._gui

	if self:_coin_award_visible(t) then
		self:_update_coin_award_animation(dt, t)
		self:_update_pulsing_items(dt, t)
	end

	for container_name, container_data in pairs(self._containers) do
		if container_data.visible_function(self, t) then
			local container = container_data.container
			local container_layout_settings = layout_settings[container_name]

			container:update_size(dt, t, gui, container_layout_settings)

			local x, y = container_data.position_function(self, container_name, container, container_layout_settings, dt, t)

			container:update_position(dt, t, container_layout_settings, x, y, z + (container_layout_settings.z or 0))
			container:render(dt, t, gui, container_layout_settings)
		end
	end
end

local COIN_AWARD_START = 5
local FONT_PULSE_TIME = 0.5
local TEAM_ICON_INTERPOLATE_TIME = 2
local SCORE_UNHIDE_TIME = 2
local COIN_COUNTDOWN_START = 8
local COIN_COUNTDOWN_END = 12
local COIN_AWARD_POSITION_INTERPOLATE_DURATION = 0.5
local COIN_COUNTDOWN_MIN_COINS_PER_SECOND = 270 / (COIN_COUNTDOWN_END - COIN_COUNTDOWN_START)

function FinalScoreboardMenuPage:_coin_award_position(container_name, container, container_layout_settings, dt, t)
	local x, y = self:_container_position(container_name, container, container_layout_settings, dt, t)
	local time = t - (self._timer + COIN_AWARD_START)
	local width = container:width()

	x = math.lerp(x - width, x, math.smoothstep(time, 0, COIN_AWARD_POSITION_INTERPOLATE_DURATION))

	return x, y
end

function FinalScoreboardMenuPage:_side_container_position(container_name, container, container_layout_settings, dt, t)
	local x, y = self:_container_position(container_name, container, container_layout_settings, dt, t)
	local time = t - (self._timer + TEAM_ICON_INTERPOLATE_TIME)
	local width = container:width()
	local anim_layout_settings = container_layout_settings.anim_from
	local anim_x, anim_y = self:_container_position(container_name, container, anim_layout_settings, dt, t)
	local lerp_t = math[anim_layout_settings.interpolation](time, 0, anim_layout_settings.duration)

	x = math.lerp(anim_x, x, lerp_t)
	y = math.lerp(anim_y, y, lerp_t)

	return x, y
end

function FinalScoreboardMenuPage:_container_position(container_name, container, container_layout_settings, dt, t)
	local x, y = MenuHelper:container_position(container, container_layout_settings)

	return x, y
end

function FinalScoreboardMenuPage:_coin_award_visible(t)
	return self._coin_award_data and t > self._timer + COIN_AWARD_START
end

function FinalScoreboardMenuPage:_center_items_visible(t)
	return self._local_player.team and self._local_player.team.name ~= "unassigned" and t > self._timer + SCORE_UNHIDE_TIME
end

function FinalScoreboardMenuPage:_show(t)
	return self._local_player.team and self._local_player.team.name ~= "unassigned" and t > self._timer
end

function FinalScoreboardMenuPage:_show(t)
	return self._local_player.team and self._local_player.team.name ~= "unassigned" and t > self._timer
end

function FinalScoreboardMenuPage:render(dt, t)
	return
end

function FinalScoreboardMenuPage:_pulse_item(item, unpulsed_color, pulsed_color, duration, t)
	self._pulsing_items[item] = {
		unpulsed_color = unpulsed_color,
		pulsed_color = pulsed_color,
		duration = duration,
		start_time = t,
		color = table.clone(unpulsed_color)
	}
end

function FinalScoreboardMenuPage:_update_pulsing_items(dt, t)
	for item, data in pairs(self._pulsing_items) do
		local start_time = data.start_time
		local duration = data.duration

		if t > data.start_time + data.duration then
			self._pulsing_items[item] = nil
			item.config.color = nil
		else
			local linear_t = (t - start_time) / duration
			local lerp_t = math.sin(linear_t * math.pi)
			local current_color = data.color
			local unpulsed_color = data.unpulsed_color
			local pulsed_color = data.pulsed_color

			for i = 1, #current_color do
				current_color[i] = math.lerp(unpulsed_color[i], pulsed_color[i], lerp_t)
			end

			item.config.color = current_color
		end
	end
end

function FinalScoreboardMenuPage:_update_coin_award_animation(dt, t)
	local time = t - self._timer
	local total_coins_item = self:find_item_by_name("total_coins")
	local round_total_item = self:find_item_by_name("round_total")
	local data = self._coin_award_data
	local total_coins = data.total_coins
	local round_total = 0
	local timpani_world = World.timpani_world(self._world)
	local countdown_end = data.countdown_end
	local pulsed_color = data.pulsed_color
	local unpulsed_color = data.unpulsed_color
	local pulse_interval = 0.7

	for i, sum_item in ipairs(data.sum_items) do
		if time > COIN_AWARD_START + i * pulse_interval then
			if not sum_item.pulsed then
				sum_item.pulsed = true

				self:_pulse_item(sum_item.item, unpulsed_color, pulsed_color, FONT_PULSE_TIME, t)

				if sum_item.sound_event then
					TimpaniWorld.trigger_event(timpani_world, sum_item.sound_event)
				end

				TimpaniWorld.trigger_event(timpani_world, "menu_buy_money")
				self:_pulse_item(round_total_item, unpulsed_color, pulsed_color, FONT_PULSE_TIME, t)
			end

			round_total = sum_item.sum
		else
			break
		end
	end

	if countdown_end < time then
		total_coins = total_coins + round_total
		round_total = 0

		if data.counting_loop then
			TimpaniWorld.trigger_event(timpani_world, "Stop_end_screen_coin_pouch_loop")
			TimpaniWorld.trigger_event(timpani_world, "hud_tutorial_notification")

			self._coin_award_data.counting_loop = nil
		end

		round_total_item.config.color = nil
	elseif time > COIN_COUNTDOWN_START then
		local lerp_t = math.auto_lerp(COIN_COUNTDOWN_START, countdown_end, 0, 1, time)

		total_coins = math.lerp(total_coins, total_coins + round_total, lerp_t)
		round_total = math.lerp(round_total, 0, lerp_t)

		if not data.counting_loop then
			data.counting_loop = TimpaniWorld.trigger_event(timpani_world, "Play_end_screen_coin_pouch_loop")
		end

		round_total_item.config.color = data.pulsed_color
	end

	total_coins_item.config.text = string.format("%i", total_coins)
	round_total_item.config.text = string.format("%i", round_total)
end

function FinalScoreboardMenuPage:event_award_coins(total_coins, round_coins, short_term_goal_bonus, event_bonus, first_win_coins)
	local round_total = round_coins * short_term_goal_bonus * event_bonus
	local unpulsed_color = {
		255,
		100,
		100,
		100
	}
	local pulsed_color = {
		255,
		255,
		255,
		255
	}

	self._coin_award_data = {
		total_coins = total_coins,
		round_coins = round_coins,
		short_term_goal_bonus = short_term_goal_bonus,
		event_bonus = event_bonus,
		round_total = round_total,
		countdown_end = math.min(COIN_COUNTDOWN_END, COIN_COUNTDOWN_START + round_total / COIN_COUNTDOWN_MIN_COINS_PER_SECOND),
		unpulsed_color = unpulsed_color,
		pulsed_color = pulsed_color,
		sum_items = {}
	}

	local total_coins_item = self:find_item_by_name("total_coins")

	total_coins_item.config.text = string.format("%i", total_coins)

	local sum_items = self._coin_award_data.sum_items
	local round_coins_item = self:find_item_by_name("round_coins")

	round_coins_item.config.text = string.format("%i", round_coins)
	sum_items[#sum_items + 1] = {
		pulsed = false,
		item = round_coins_item,
		sum = round_coins
	}

	local short_term_goal_bonus_item = self:find_item_by_name("short_term_goal_bonus")

	short_term_goal_bonus_item.config.text = string.format("+%i", (short_term_goal_bonus - 1) * 100)

	if short_term_goal_bonus > 1 then
		sum_items[#sum_items + 1] = {
			sound_event = "hud_perc_ready",
			pulsed = false,
			item = short_term_goal_bonus_item,
			sum = round_coins * short_term_goal_bonus
		}
	end

	local event_bonus_item = self:find_item_by_name("event_bonus")

	if event_bonus > 1 then
		event_bonus_item.config.text = string.format("+%i", (event_bonus - 1) * 100)
		sum_items[#sum_items + 1] = {
			sound_event = "hud_perc_ready",
			pulsed = false,
			item = event_bonus_item,
			sum = round_coins * short_term_goal_bonus * event_bonus
		}
	else
		event_bonus_item.config.text = ""
		self:find_item_by_name("event_bonus_header").config.text = ""
		self:find_item_by_name("event_bonus_procent").config.text = ""
	end

	local first_win_coins_item = self:find_item_by_name("first_win_coins")

	first_win_coins_item.config.text = string.format("%i", first_win_coins)

	if first_win_coins > 0 then
		sum_items[#sum_items + 1] = {
			pulsed = false,
			item = first_win_coins_item,
			sum = round_coins * short_term_goal_bonus * event_bonus + first_win_coins
		}
	end

	local round_total_item = self:find_item_by_name("round_total")

	round_total_item.config.text = string.format("%i", 0)
end

function FinalScoreboardMenuPage:gm_event_end_conditions_met(winning_team_name, red_team_score, white_team_score, only_end_of_round)
	if not self._local_player.team or self._local_player.team.name == "unassigned" then
		return
	end

	self._timer = Managers.time:time("game")

	local player_team_name = self._local_player.team.name
	local player_team_side = self._local_player.team.side
	local own_team_result

	own_team_result = winning_team_name == "draw" and "draw" or winning_team_name == player_team_name and "won" or "lost"

	if only_end_of_round then
		own_team_result = own_team_result .. "_round"
		self._render_backgrounds = false
	else
		self._render_backgrounds = true
	end

	local text_color = player_team_name == "red" and HUDSettings.player_colors.red or HUDSettings.player_colors.white
	local battle_result_item = self:find_item_by_name("battle_result")

	battle_result_item.config.text = L("menu_battle_" .. own_team_result)
	battle_result_item.config.color = text_color

	local battle_details_item = self:find_item_by_name("battle_details")
	local level_settings = LevelHelper:current_level_settings()
	local level_name = L(level_settings.display_name)
	local game_mode_key = Managers.state.game_mode:game_mode_key()
	local battle_details = GameModeSettings[game_mode_key].battle_details[own_team_result]
	local battle_details_localized

	if only_end_of_round then
		local winscore = Managers.state.game_mode:win_score()

		battle_details_localized = string.gsub(L(battle_details), "&rounds;", tostring(winscore * 2 - 1))
	else
		battle_details_localized = string.gsub(L(battle_details), "&level_name;", level_name)
	end

	battle_details_item.config.visible = true
	battle_details_item.config.text = battle_details_localized
	battle_details_item.config.color = text_color

	local own_team_score_item = self:find_item_by_name("left_team_score")

	own_team_score_item.config.text = player_team_name == "red" and red_team_score or white_team_score

	local enemy_team_score_item = self:find_item_by_name("right_team_score")

	enemy_team_score_item.config.text = player_team_name == "red" and white_team_score or red_team_score

	local own_team_rose_item = self:find_item_by_name("left_team_rose")
	local layout_settings = MenuHelper:layout_settings(own_team_rose_item.config.layout_settings)

	own_team_rose_item.config.texture = player_team_name == "red" and layout_settings.texture_red or layout_settings.texture_white

	local enemy_team_rose_item = self:find_item_by_name("right_team_rose")
	local layout_settings = MenuHelper:layout_settings(enemy_team_rose_item.config.layout_settings)

	enemy_team_rose_item.config.texture = player_team_name == "red" and layout_settings.texture_white or layout_settings.texture_red

	local center_team_rose = self:find_item_by_name("center_team_rose")

	if only_end_of_round then
		own_team_rose_item.config.hide = true
		enemy_team_rose_item.config.hide = true

		local layout_settings = MenuHelper:layout_settings(center_team_rose.config.layout_settings)

		center_team_rose.config.texture = winning_team_name == "red" and layout_settings.texture_red or layout_settings.texture_white
	else
		own_team_rose_item.config.hide = false
		enemy_team_rose_item.config.hide = false
		center_team_rose.config.hide = true
	end

	local own_team_text_item = self:find_item_by_name("left_team_text")
	local layout_settings = MenuHelper:layout_settings(own_team_text_item.config.layout_settings)

	own_team_text_item.config.text = player_team_name == "red" and string.upper(L("lancaster")) or string.upper(L("york"))
	own_team_text_item.config.color = player_team_name == "red" and layout_settings.color_red or layout_settings.color_white

	local enemy_team_text_item = self:find_item_by_name("right_team_text")
	local layout_settings = MenuHelper:layout_settings(enemy_team_text_item.config.layout_settings)

	enemy_team_text_item.config.text = player_team_name == "red" and string.upper(L("york")) or string.upper(L("lancaster"))
	enemy_team_text_item.config.color = player_team_name == "red" and layout_settings.color_white or layout_settings.color_red
end

function FinalScoreboardMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "final_scoreboard",
		parent_page = parent_page,
		callback_object = callback_object,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		local_player = compiler_data.menu_data.local_player,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment()
	}

	return FinalScoreboardMenuPage:new(config, item_groups, compiler_data.world)
end
