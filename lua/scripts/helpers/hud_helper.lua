-- chunkname: @scripts/helpers/hud_helper.lua

require("scripts/helpers/ui_settings_cache")

local UISettingsCache = UISettingsCache
local UISettingsCache_cached_setting = UISettingsCache.cached_setting
local UISettingsCache_store_setting = UISettingsCache.store_setting

HUDHelper = HUDHelper or {}
HUDHelper.STANDARD_ASPECT_RATIO = 1.7777777777777777
HUDHelper.resolution_width = HUDHelper.resolution_width or 0
HUDHelper.resolution_height = HUDHelper.resolution_height or 0
HUDHelper.count_table = HUDHelper.count_table or 0
HUDHelper.count_string = HUDHelper.count_string or 0
HUDHelper.max_count_table = HUDHelper.max_count_table or 0
HUDHelper.max_count_string = HUDHelper.max_count_string or 0
HUDHelper.cache = HUDHelper.cache or UISettingsCache.new()

function HUDHelper:clear_cache()
	HUDHelper.cache = UISettingsCache.new()
end

function HUDHelper:update_resolution()
	HUDHelper.resolution_width, HUDHelper.resolution_height = Gui.resolution()
end

function HUDHelper:resolution()
	return HUDHelper.resolution_width, HUDHelper.resolution_height
end

function HUDHelper:reset_counters()
	HUDHelper.count_table = 0
	HUDHelper.count_string = 0
end

function HUDHelper:layout_settings(settings_table)
	if type(settings_table) == "string" then
		return HUDHelper:layout_settings_string(settings_table)
	end

	local res_width, res_height = HUDHelper:resolution()
	local helper_cache = HUDHelper.cache
	local cached_lookup = UISettingsCache_cached_setting(helper_cache, settings_table, res_width, res_height)

	if cached_lookup then
		return cached_lookup
	end

	local selected_width = 0
	local selected_height = 0
	local lowest_available_width = math.huge
	local lowest_available_height = math.huge

	for width, setting in pairs(settings_table) do
		if width <= res_width and selected_width < width then
			selected_width = width
		end

		if width < lowest_available_width then
			lowest_available_width = width
		end
	end

	if selected_width == 0 then
		selected_width = lowest_available_width
	end

	for height, setting in pairs(settings_table[selected_width]) do
		if height <= res_height and selected_height < height then
			selected_height = height
		end

		if height < lowest_available_height then
			lowest_available_height = height
		end
	end

	if selected_height == 0 then
		selected_height = lowest_available_height
	end

	local selected_setting = settings_table[selected_width][selected_height]

	UISettingsCache_store_setting(helper_cache, settings_table, selected_setting, res_width, res_height)

	return selected_setting
end

function HUDHelper:layout_settings_string(settings_string)
	local res_width, res_height = HUDHelper:resolution()
	local helper_cache = HUDHelper.cache
	local cached_lookup = UISettingsCache_cached_setting(helper_cache, settings_string, res_width, res_height)

	if cached_lookup then
		return cached_lookup
	end

	local settings = string.split(settings_string, ".")
	local settings_table = rawget(_G, settings[1])

	for i = 2, #settings do
		settings_table = settings_table[settings[i]]
	end

	local selected_width = 0
	local selected_height = 0
	local lowest_available_width = math.huge
	local lowest_available_height = math.huge

	for width, setting in pairs(settings_table) do
		if width <= res_width and selected_width < width then
			selected_width = width
		end

		if width < lowest_available_width then
			lowest_available_width = width
		end
	end

	if selected_width == 0 then
		selected_width = lowest_available_width
	end

	for height, setting in pairs(settings_table[selected_width]) do
		if height <= res_height and selected_height < height then
			selected_height = height
		end

		if height < lowest_available_height then
			lowest_available_height = height
		end
	end

	if selected_height == 0 then
		selected_height = lowest_available_height
	end

	local selected_setting = settings_table[selected_width][selected_height]

	UISettingsCache_store_setting(helper_cache, settings_string, selected_setting, res_width, res_height)

	return selected_setting
end

function HUDHelper:element_position(parent_element, element, layout_settings)
	local parent_width, parent_height

	if parent_element then
		parent_width = parent_element:width()
		parent_height = parent_element:height()
	else
		parent_width, parent_height = HUDHelper:resolution()
	end

	local screen_x, screen_y, pivot_x, pivot_y

	if layout_settings.screen_align_x == "left" then
		screen_x = 0
	elseif layout_settings.screen_align_x == "center" then
		screen_x = parent_width * 0.5
	elseif layout_settings.screen_align_x == "right" then
		screen_x = parent_width
	end

	if layout_settings.screen_align_y == "bottom" then
		screen_y = 0
	elseif layout_settings.screen_align_y == "center" then
		screen_y = parent_height * 0.5
	elseif layout_settings.screen_align_y == "top" then
		screen_y = parent_height
	end

	screen_x = screen_x + layout_settings.screen_offset_x * parent_width
	screen_y = screen_y + layout_settings.screen_offset_y * parent_height

	if layout_settings.pivot_align_x == "left" then
		pivot_x = 0
	elseif layout_settings.pivot_align_x == "center" then
		pivot_x = -element:width() * 0.5
	elseif layout_settings.pivot_align_x == "right" then
		pivot_x = -element:width()
	end

	if layout_settings.pivot_align_y == "bottom" then
		pivot_y = 0
	elseif layout_settings.pivot_align_y == "center" then
		pivot_y = -element:height() * 0.5
	elseif layout_settings.pivot_align_y == "top" then
		pivot_y = -element:height()
	end

	local pivot_scale_x = layout_settings.pivot_scale or element.config and element.config.blackboard and element.config.blackboard.scale or 1
	local pivot_scale_y = layout_settings.pivot_scale or element.config and element.config.blackboard and element.config.blackboard.scale or 1

	pivot_x = pivot_x + layout_settings.pivot_offset_x * pivot_scale_x
	pivot_y = pivot_y + layout_settings.pivot_offset_y * pivot_scale_y

	local x = screen_x + pivot_x
	local y = screen_y + pivot_y

	return x, y
end

function HUDHelper:floating_icon_size(screen_z, texture_width, texture_height, min_scale, max_scale, min_scale_distance, max_scale_distance)
	local k = (max_scale - min_scale) / (max_scale_distance - min_scale_distance)
	local scale = k * (screen_z - max_scale_distance) + max_scale

	scale = math.clamp(scale, min_scale, max_scale)

	local width = texture_width * scale
	local height = texture_height * scale

	return width, height
end

function HUDHelper:floating_text_icon_size(screen_z, font_size, min_scale, max_scale, min_scale_distance, max_scale_distance)
	local k = (max_scale - min_scale) / (max_scale_distance - min_scale_distance)
	local scale = k * (screen_z - max_scale_distance) + max_scale

	scale = math.clamp(scale, min_scale, max_scale)

	local scaled_font_size = font_size * scale

	return scaled_font_size
end

function HUDHelper:clamped_icon_position(x, y, z)
	local res_width, res_height = HUDHelper:resolution()
	local left_margin = res_height * self.STANDARD_ASPECT_RATIO * (1 - HUDSettings.default_zone.x_radius)
	local right_margin = res_width - left_margin
	local y_top = res_height - HUDSettings.default_zone.y_border_top
	local y_bot = HUDSettings.default_zone.y_border_bottom

	if z < 0 and x > 0 then
		x = left_margin
	elseif z < 0 and x < 0 then
		x = right_margin
	elseif x < left_margin then
		x = left_margin
	elseif right_margin < x then
		x = right_margin
	end

	if y < y_bot then
		y = y_bot
	elseif y_top < y then
		y = y_top
	end

	return x, y
end

function HUDHelper:inside_attention_screen_zone(x, y, z)
	if z > 0 then
		local res_width, res_height = HUDHelper:resolution()
		local width = res_height * self.STANDARD_ASPECT_RATIO
		local height = res_height

		x = x * (width / res_width)

		local center_x = width / 2
		local center_y = height / 2
		local radius_ratio = HUDSettings.attention_zone.y_radius / HUDSettings.attention_zone.x_radius
		local scaled_x = (x - center_x) / center_x * radius_ratio
		local scaled_y = (y - center_y) / center_y
		local distance = Vector3.length(Vector3(scaled_x, scaled_y, 0))

		return distance < HUDSettings.attention_zone.y_radius
	end
end

function HUDHelper:inside_default_screen_zone(x, y, z)
	if z > 0 then
		local res_width, res_height = HUDHelper:resolution()
		local margin_x = res_height * self.STANDARD_ASPECT_RATIO * (1 - HUDSettings.default_zone.x_radius)
		local y_top = res_height - HUDSettings.default_zone.y_border_top
		local y_bot = HUDSettings.default_zone.y_border_bottom

		if margin_x < x and x < res_width - margin_x and y_bot < y and y < y_top then
			return true
		end
	end
end

function HUDHelper:inside_screen(x, y, z)
	if z > 0 then
		local res_width, res_height = HUDHelper:resolution()

		if x > 0 and x < res_width and y > 0 and y < res_height then
			return true
		end
	end
end

function HUDHelper:crop_text(gui, base_text, font, font_size, max_width, crop_suffix)
	local suffix = ""
	local text = base_text
	local index = string.len(text)

	while index > 0 do
		local min, max = Gui.text_extents(gui, text, font, font_size)
		local text_width = max[1] - min[1]
		local suffix_min, suffix_max = Gui.text_extents(gui, suffix, font, font_size)
		local suffix_width = suffix_max[1] - suffix_min[1]

		if max_width >= text_width + suffix_width then
			return text .. suffix
		end

		local char_begin, char_end = Utf8.location(text, index)

		index = char_begin - 1
		text = string.sub(text, 1, index)
		suffix = crop_suffix or ""
	end

	return ""
end

function HUDHelper:truncate_text(text, max_length, trunkate_suffix, replace_all_with_suffix)
	local length = string.len(text)
	local index = 1
	local num_chars = 0
	local _

	while index <= length do
		_, index = Utf8.location(text, index)
		num_chars = num_chars + 1

		if num_chars == max_length then
			break
		end
	end

	local new_text = string.sub(text, 1, index - 1)

	if index - 1 ~= length and trunkate_suffix then
		if replace_all_with_suffix then
			new_text = trunkate_suffix
		else
			new_text = new_text .. trunkate_suffix
		end
	end

	return new_text
end

function HUDHelper:player_color(local_player, other_player, highlighted)
	local color_table

	if local_player.team.name == "unassigned" then
		return HUDSettings.player_colors[other_player.team.name]
	end

	if local_player.team and local_player.team == other_player.team then
		local same_squad = local_player.squad_index and local_player.squad_index == other_player.squad_index

		if same_squad and highlighted then
			color_table = HUDSettings.player_colors.squad_member_highlighted
		elseif same_squad then
			color_table = HUDSettings.player_colors.squad_member
		elseif highlighted then
			color_table = HUDSettings.player_colors.team_member_highlighted
		else
			color_table = HUDSettings.player_colors.team_member
		end
	elseif highlighted then
		color_table = HUDSettings.player_colors.enemy_highlighted
	else
		color_table = HUDSettings.player_colors.enemy
	end

	return color_table
end

function HUDHelper:render_version_info(gui)
	local res_width, res_height = HUDHelper:resolution()
	local text_size = 18
	local build = script_data.build_identifier or "???"
	local revision = script_data.settings.content_revision or "???"
	local text = "Content revision: " .. revision .. " Build version: " .. build

	if rawget(_G, "Steam") then
		local appid = Steam.app_id()

		text = text .. " Appid: " .. appid
	end

	local min, max = Gui.text_extents(gui, text, MenuSettings.fonts.menu_font.font, text_size)
	local width = max[1] - min[1]
	local height = max[3] - min[3]
	local x = res_width - width - 8
	local y = height

	Gui.text(gui, text, MenuSettings.fonts.menu_font.font, text_size, MenuSettings.fonts.menu_font.material, Vector3(x, y, 102), Color(255, 255, 255, 255))
	Gui.text(gui, text, MenuSettings.fonts.menu_font.font, text_size, MenuSettings.fonts.menu_font.material, Vector3(x + 2, y - 2, 101), Color(255, 0, 0, 0))
end

function HUDHelper:render_fps(gui, dt)
	local fps

	fps = dt < 1e-07 and 0 or 1 / dt

	local text = string.format("%i FPS", fps)
	local color

	if fps < 30 then
		color = Color(255, 255, 80, 80)
	else
		color = Color(255, 255, 255, 255)
	end

	local res_width, res_height = HUDHelper:resolution()
	local text_size = 24
	local min, max = Gui.text_extents(gui, text, MenuSettings.fonts.menu_font.font, text_size)
	local width = max[1] - min[1]
	local height = max[3] - min[3]
	local x = res_width - width - 8
	local y = height + 16

	Gui.text(gui, text, MenuSettings.fonts.menu_font.font, text_size, MenuSettings.fonts.menu_font.material, Vector3(x, y, 102), color)
	Gui.text(gui, text, MenuSettings.fonts.menu_font.font, text_size, MenuSettings.fonts.menu_font.material, Vector3(x + 2, y - 2, 101), Color(255, 0, 0, 0))
end

function HUDHelper.floating_hud_icon_color(player, settings, blackboard, dt, t)
	local alpha_mul = 1

	if blackboard and blackboard.owner_team_side and player.team and blackboard.being_captured then
		alpha_mul = math.abs(t % 1 - 0.5) * 2
	end

	return Color(alpha_mul * 255, 255, 255, 255)
end

function HUDHelper.atlas_material(atlas_name, material_name, masked, default_material_name)
	local material_table = HUDHelper.atlas_texture_settings(atlas_name, material_name, default_material_name)
	local material = masked and atlas_name .. "_masked" or atlas_name
	local uv00 = Vector2(material_table.uv00[1], material_table.uv00[2])
	local uv11 = Vector2(material_table.uv11[1], material_table.uv11[2])
	local size = Vector2(material_table.size[1], material_table.size[2])

	return material, uv00, uv11, size
end

function HUDHelper.atlas_size(atlas_name, material_name, masked, default_material_name)
	local material_table = HUDHelper.atlas_texture_settings(atlas_name, material_name, default_material_name)
	local size = Vector2(material_table.size[1], material_table.size[2])

	return size
end

function HUDHelper.atlas_texture_settings(atlas_name, material_name, default_material_name)
	local real_atlas = rawget(_G, atlas_name)

	fassert(real_atlas, "[HUDHelper.atlas_texture_settings] There is no such atlas(%q)", tostring(atlas_name))

	local material_table = real_atlas[material_name] or real_atlas[default_material_name]

	fassert(material_table, "[HUDHelper.atlas_material] There is no material name (%q) in atlas (%q)", tostring(material_name), tostring(atlas_name))

	return material_table
end

function HUDHelper.atlas_bitmap(gui, atlas_name, asset_name, pos, size, color)
	local material_table = HUDHelper.atlas_texture_settings(atlas_name, asset_name)

	size = size or material_table.size and Vector2(material_table.size[1], material_table.size[2])

	local uv00 = material_table.uv00
	local uv11 = material_table.uv11

	Gui.bitmap_uv(gui, atlas_name, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), pos, size, color)
end

function HUDHelper.atlas_bitmap_3d(gui, atlas_name, asset_name, pos, size, color, rotation)
	local material_table = HUDHelper.atlas_texture_settings(atlas_name, asset_name)

	size = size or material_table.size and Vector2(material_table.size[1], material_table.size[2])

	local uv00 = material_table.uv00
	local uv11 = material_table.uv11
	local rot = Rotation2D(Vector2(0, 0), rotation, Vector2(pos[1] + size[1] / 2, pos[2] + size[2] / 2))

	Gui.bitmap_3d_uv(gui, atlas_name, Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), rot, pos, pos.z, size, color)
end

function HUDHelper.get_360_button_bitmap(button_name, masked)
	local button = button_name

	if not button or not X360Buttons[button] then
		button = "default"
	end

	local uv00 = X360Buttons[button].uv00
	local uv11 = X360Buttons[button].uv11
	local size = X360Buttons[button].size

	return masked and "x360_buttons_masked" or "x360_buttons", Vector2(uv00[1], uv00[2]), Vector2(uv11[1], uv11[2]), Vector2(size[1], size[2])
end

function HUDHelper.text_align(gui, text, font, text_size)
	local text_extent_min, text_extent_max = Gui.text_extents(gui, text, font, text_size)
	local text_width = text_extent_max[1] - text_extent_min[1]
	local text_height = text_extent_max[3] - text_extent_min[3]
	local text_offset = Vector3(-text_width / 2, -text_height / 2, 0)

	return text_offset, text_width, text_height
end

function HUDHelper.alpha_animation(dt, t, layout_settings, end_time)
	local alpha = 0
	local alpha_anim_settings = layout_settings.alpha_animation
	local fade_to = alpha_anim_settings.fade_to
	local fade_in = alpha_anim_settings.fade_in
	local fade_out = alpha_anim_settings.fade_out
	local duration = alpha_anim_settings.duration
	local start_time = end_time - duration
	local fade_in_duration = fade_in * duration
	local fade_out_duration = (1 - fade_out) * duration
	local fade_in_end = start_time + fade_in_duration
	local fade_out_start = start_time + duration - fade_out_duration

	if t <= fade_in_end then
		alpha = fade_to * (1 - (fade_in_end - t) / fade_in_duration)
	elseif fade_out_start < t then
		alpha = fade_to * (1 - (t - fade_out_start) / fade_out_duration)
	else
		alpha = fade_to
	end

	return alpha
end

function HUDHelper.rank_up_level_reached_text(player, world, params)
	local profile_data = Managers.persistence:profile_data()
	local xp = profile_data.attributes.experience
	local round_xp = Managers.state.stats_collection:get(player:network_id(), "experience_round")
	local text = string.format(L("rank_up_level_reached_text"), xp_to_rank(xp + round_xp))

	return text
end

function HUDHelper.rank_up_unlock_text(player, world, params)
	local profile_data = Managers.persistence:profile_data()
	local xp = profile_data.attributes.experience
	local round_xp = Managers.state.stats_collection:get(player:network_id(), "experience_round")
	local rank = RANKS[xp_to_rank(xp + round_xp)]
	local unlocks_text = rank.ingame_unlocks_text and L(rank.ingame_unlocks_text) or ""

	return unlocks_text
end

function HUDHelper.short_term_goal_achieved(player, world, params)
	local goal = params.param1
	local goal_settings = ShortTermGoals[goal]

	return string.format(L("short_term_goal_achieved"), goal_settings.name)
end

function HUDHelper.coin_bonus_gained(player, world, params)
	local goal = params.param1
	local goal_settings = ShortTermGoals[goal]

	return string.format(L("coin_bonus_gained"), goal_settings.bonus)
end
