-- chunkname: @scripts/settings/hud_settings.lua

require("gui/textures/hud_atlas")
require("scripts/hud/hud_assets")
require("scripts/settings/level_settings")

SCALE_1366 = 0.7114583333333333
SCALE_BG_1024 = 1024 / hud_assets.hud_bottom_bg.size[1]
HUDSettings = HUDSettings or {}

local DEFAULT_DROP_SHADOW_COLOR = {
	120,
	0,
	0,
	0
}
local DEFAULT_DROP_SHADOW_OFFSET = {
	2,
	-2
}
local SMALL_DROP_SHADOW = {
	1,
	-1
}

HUDSettings.show_hud = true
HUDSettings.show_reticule = true
HUDSettings.show_combat_text = true
HUDSettings.show_xp_awards = true
HUDSettings.show_parry_helper = true
HUDSettings.show_pose_charge_helper = true
HUDSettings.show_announcements = true
HUDSettings.show_game_mode_status = false
HUDSettings.chat_output_vertical_align = "top"
HUDSettings.circle_section_size = 105
HUDSettings.marker_offset = 5
HUDSettings.crosshairs = {
	{
		texture = "crosshair_texture_1",
		string_id = "crosshair_1"
	},
	{
		texture = "crosshair_texture_2",
		string_id = "crosshair_2"
	},
	{
		texture = "crosshair_texture_3",
		string_id = "crosshair_3"
	},
	{
		texture = "crosshair_texture_4",
		string_id = "crosshair_4"
	},
	{
		texture = "crosshair_texture_5",
		string_id = "crosshair_5"
	}
}

if DLCSettings.brian_blessed() then
	HUDSettings.announcement_voice_over = "brian_blessed"
else
	HUDSettings.announcement_voice_over = "normal"
end

HUDSettings.side_select_sound_events = {
	white = "york_side_select",
	red = "lancaster_side_select"
}
HUDSettings.player_colors = HUDSettings.player_colors or {}
HUDSettings.player_colors.white = {
	255,
	199,
	50,
	39
}
HUDSettings.player_colors.red = {
	255,
	55,
	136,
	177
}
HUDSettings.player_colors.neutral_team = {
	255,
	255,
	255,
	255
}
HUDSettings.player_colors.team_member = {
	255,
	46,
	169,
	187
}
HUDSettings.player_colors.team_member_highlighted = {
	255,
	146,
	230,
	227
}
HUDSettings.player_colors.squad_member = {
	255,
	21,
	243,
	52
}
HUDSettings.player_colors.squad_member_highlighted = {
	255,
	171,
	243,
	152
}
HUDSettings.player_colors.enemy = {
	255,
	248,
	48,
	9
}
HUDSettings.player_colors.enemy_highlighted = {
	255,
	255,
	142,
	153
}
HUDSettings.player_colors.dead = {
	255,
	125,
	125,
	125
}
HUDSettings.player_colors.shadow = {
	255,
	0,
	0,
	0
}
HUDSettings.player_colors.squad_member_out_of_range = {
	255,
	86,
	108,
	86
}
HUDSettings.objective_icons = HUDSettings.objective_icons or {}
HUDSettings.objective_icons.team_icon = HUDSettings.objective_icons.team_icon or {}
HUDSettings.objective_icons.team_icon.red = hud_assets.objective_icon_center_viking
HUDSettings.objective_icons.team_icon.white = hud_assets.objective_icon_center_saxon
HUDSettings.objective_icons.team_icon.neutral = hud_assets.objective_icon_neutral
HUDSettings.outline_colors = {}
HUDSettings.outline_colors.enemy = {
	variable = "outline_color_red",
	outline_multiplier = 2,
	outline_multiplier_variable = "outline_multiplier_red",
	channel = {
		0,
		255,
		0,
		0
	},
	color = HUDSettings.player_colors.enemy
}
HUDSettings.outline_colors.squad_member = {
	variable = "outline_color_green",
	outline_multiplier = 2,
	outline_multiplier_variable = "outline_multiplier_green",
	channel = {
		0,
		0,
		255,
		0
	},
	color = {
		255,
		65,
		169,
		15
	}
}
HUDSettings.outline_colors.team_member = {
	variable = "outline_color_blue",
	outline_multiplier = 4,
	outline_multiplier_variable = "outline_multiplier_blue",
	channel = {
		0,
		0,
		0,
		255
	},
	color = {
		255,
		10,
		40,
		70
	}
}
HUDSettings.outline_colors.point_of_interest = {
	variable = "outline_color_alpha",
	outline_multiplier = 2,
	outline_multiplier_variable = "outline_multiplier_alpha",
	channel = {
		255,
		0,
		0,
		0
	},
	color = {
		255,
		255,
		236,
		139
	}
}
HUDSettings.outline_multiplier = 2
HUDSettings.chat_text_colors = HUDSettings.chat_text_colors or {
	all = {
		210,
		210,
		210
	},
	self_all = {
		245,
		245,
		245
	},
	team = {
		35,
		116,
		177
	},
	self_team = {
		45,
		126,
		187
	},
	developer_all = {
		255,
		163,
		71
	}
}
HUDSettings.player_icons = {
	tagged_enemy_hide_delay = 0,
	far_enemy_hide_delay = 0.25,
	far_enemy_show_delay_min = 0,
	team_member_hide_delay = 1,
	near_enemy_hide_delay = 0.75,
	default_far_enemy_max_distance = 75,
	squad_member_show_delay = 0,
	hide_fade_time = 0.3,
	team_member_max_distance = 150,
	squad_member_hide_delay = 1,
	near_enemy_max_distance = 10,
	team_member_show_delay = 0,
	far_enemy_show_delay_max = 1.5,
	near_enemy_show_delay = 0,
	tagged_enemy_show_delay = 0,
	squad_member_max_distance = math.huge,
	line_of_sight_nodes = {
		"Head"
	},
	health_bar = {
		y_offset = -8,
		size = {
			65,
			6
		},
		colors = {
			{
				above = 0.6666666666666666,
				value = HUDSettings.player_colors.squad_member
			},
			{
				above = 0.3333333333333333,
				value = {
					255,
					255,
					255,
					0
				}
			},
			less = HUDSettings.player_colors.enemy
		}
	}
}
HUDSettings.player_icons.level_far_enemy_max_distance = {}

for level_key, _ in pairs(LevelSettings) do
	HUDSettings.player_icons.level_far_enemy_max_distance[level_key] = HUDSettings.player_icons.default_far_enemy_max_distance
end

HUDSettings.attention_zone = HUDSettings.attention_zone or {}
HUDSettings.attention_zone.x_radius = 0.2
HUDSettings.attention_zone.y_radius = 0.5
HUDSettings.default_zone = HUDSettings.default_zone or {}
HUDSettings.default_zone.x_radius = 0.97
HUDSettings.default_zone.y_border_top = 50
HUDSettings.default_zone.y_border_bottom = 80
HUDSettings.fade_to_black = HUDSettings.fade_to_black or {
	layer = 101,
	color = {
		0,
		0,
		0,
		0
	}
}
HUDSettings.default_button_info = HUDSettings.default_button_info or {}
HUDSettings.default_button_info[1366] = HUDSettings.default_button_info[1366] or {}
HUDSettings.default_button_info[1366][768] = HUDSettings.default_button_info[1366][768] or {
	text_data = {
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		offset_x = 25 * SCALE_1366,
		offset_y = 100 * SCALE_1366,
		drop_shadow = SMALL_DROP_SHADOW
	},
	default_buttons = {
		{
			button_name = "b",
			text = "main_menu_cancel"
		}
	}
}
HUDSettings.default_button_info[1680] = HUDSettings.default_button_info[1680] or {}
HUDSettings.default_button_info[1680][1050] = HUDSettings.default_button_info[1680][1050] or {
	text_data = {
		font_size = 28,
		font = MenuSettings.fonts.hell_shark_28,
		offset_x = 25 * SCALE_1366,
		offset_y = 100 * SCALE_1366,
		drop_shadow = DEFAULT_DROP_SHADOW_OFFSET
	},
	default_buttons = {
		{
			button_name = "b",
			text = "main_menu_cancel"
		}
	}
}
HUDSettings.hit_marker = HUDSettings.hit_marker or {}
HUDSettings.hit_marker.container = HUDSettings.hit_marker.container or {}
HUDSettings.hit_marker.container[1680] = HUDSettings.hit_marker.container[1680] or {}
HUDSettings.hit_marker.container[1680][1050] = HUDSettings.hit_marker.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	height = 24,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 24,
	background_color = {
		0,
		0,
		0,
		0
	}
}
HUDSettings.hit_marker.marker = HUDSettings.hit_marker.marker or {}
HUDSettings.hit_marker.marker[1680] = HUDSettings.hit_marker.marker[1680] or {}
HUDSettings.hit_marker.marker[1680][1050] = HUDSettings.hit_marker.marker[1680][1050] or {}
HUDSettings.hit_marker.marker[1680][1050].screen_align_x = "center"
HUDSettings.hit_marker.marker[1680][1050].screen_align_y = "center"
HUDSettings.hit_marker.marker[1680][1050].screen_offset_x = 0
HUDSettings.hit_marker.marker[1680][1050].screen_offset_y = 0
HUDSettings.hit_marker.marker[1680][1050].pivot_align_x = "center"
HUDSettings.hit_marker.marker[1680][1050].pivot_align_y = "center"
HUDSettings.hit_marker.marker[1680][1050].pivot_offset_x = 0
HUDSettings.hit_marker.marker[1680][1050].pivot_offset_y = 0
HUDSettings.hit_marker.marker[1680][1050].texture_atlas = "hud_assets"
HUDSettings.hit_marker.marker[1680][1050].scale = 1
HUDSettings.hit_marker.marker[1680][1050].color = {
	255,
	255,
	255,
	255
}
HUDSettings.parry_helper = HUDSettings.parry_helper or {}
HUDSettings.parry_helper.container = HUDSettings.parry_helper.container or {}
HUDSettings.parry_helper.container[1680] = HUDSettings.parry_helper.container[1680] or {}
HUDSettings.parry_helper.container[1680][1050] = HUDSettings.parry_helper.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = 1,
	pivot_offset_y = 0,
	height = 500,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 500
}
HUDSettings.parry_helper.attack_direction = HUDSettings.parry_helper.attack_direction or {}
HUDSettings.parry_helper.attack_direction[1680] = HUDSettings.parry_helper.attack_direction[1680] or {}
HUDSettings.parry_helper.attack_direction[1680][1050] = HUDSettings.parry_helper.attack_direction[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_parry_helper_attack",
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_width = 348,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 144,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.death_text = HUDSettings.death_text or {}
HUDSettings.death_text[1680] = HUDSettings.death_text[1680] or {}
HUDSettings.death_text[1680][1050] = HUDSettings.death_text[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0.3,
	pivot_align_y = "top",
	font_size = 80,
	pivot_offset_y = 0,
	screen_align_x = "left",
	z = 20,
	pivot_offset_x = 0,
	screen_offset_y = -0.25,
	pivot_align_x = "center",
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.killer_name_text = HUDSettings.killer_name_text or table.clone(HUDSettings.death_text)
HUDSettings.killer_name_text[1680][1050].pivot_offset_y = -100 * SCALE_1366
HUDSettings.killer_name_text[1680][1050].font_size = 100
HUDSettings.killer_name_text[1680][1050].relative_max_width_limiter = 900
HUDSettings.death_text[1366] = HUDSettings.death_text[1366] or {}
HUDSettings.death_text[1366][768] = HUDSettings.death_text[1366][768] or table.clone(HUDSettings.death_text[1680][1050])
HUDSettings.death_text[1366][768].font_size = 65 * SCALE_1366
HUDSettings.killer_name_text[1366] = HUDSettings.killer_name_text[1366] or {}
HUDSettings.killer_name_text[1366][768] = HUDSettings.killer_name_text[1366][768] or table.clone(HUDSettings.killer_name_text[1680][1050])
HUDSettings.killer_name_text[1366][768].font_size = 85 * SCALE_1366
HUDSettings.buffs = HUDSettings.buffs or {}
HUDSettings.buffs.container = HUDSettings.buffs.container or {}
HUDSettings.buffs.container[1680] = HUDSettings.buffs.container[1680] or {}
HUDSettings.buffs.container[1680][1050] = HUDSettings.buffs.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	height = 60,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	width = 480
}
HUDSettings.buffs.last_stand_countdown = HUDSettings.buffs.last_stand_countdown or {}
HUDSettings.buffs.last_stand_countdown.container = HUDSettings.buffs.last_stand_countdown.container or {}
HUDSettings.buffs.last_stand_countdown.container[1680] = HUDSettings.buffs.last_stand_countdown.container[1680] or {}
HUDSettings.buffs.last_stand_countdown.container[1680][1050] = HUDSettings.buffs.last_stand_countdown.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = -0.25,
	pivot_align_x = "center"
}
HUDSettings.buffs.last_stand_countdown.last_stand_timer_text = HUDSettings.buffs.last_stand_countdown.last_stand_timer_text or {}
HUDSettings.buffs.last_stand_countdown.last_stand_timer_text[1680] = HUDSettings.buffs.last_stand_countdown.last_stand_timer_text[1680] or {}
HUDSettings.buffs.last_stand_countdown.last_stand_timer_text[1680][1050] = HUDSettings.buffs.last_stand_countdown.last_stand_timer_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 100,
	pivot_offset_y = -20,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text = HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text or {}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text[1680] = HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text[1680] or {}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text[1680][1050] = HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 36,
	pivot_offset_y = 30,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text = HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text or {}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text[1680] = HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text[1680] or {}
HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text[1680][1050] = HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 36,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.buffs.buff = HUDSettings.buffs.buff or {}
HUDSettings.buffs.buff.container = HUDSettings.buffs.buff.container or {}
HUDSettings.buffs.buff.container[1680] = HUDSettings.buffs.buff.container[1680] or {}
HUDSettings.buffs.buff.container[1680][1050] = HUDSettings.buffs.buff.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	height = 60,
	screen_align_x = "left",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 60
}
HUDSettings.buffs.buff.icon = HUDSettings.buffs.buff.icon or {}
HUDSettings.buffs.buff.icon[1680] = HUDSettings.buffs.buff.icon[1680] or {}
HUDSettings.buffs.buff.icon[1680][1050] = HUDSettings.buffs.buff.icon[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	texture_atlas = "hud_atlas",
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_width = 44,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 44,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.buffs.buff.level_circle = HUDSettings.buffs.buff.level_circle or {}
HUDSettings.buffs.buff.level_circle[1680] = HUDSettings.buffs.buff.level_circle[1680] or {}
HUDSettings.buffs.buff.level_circle[1680][1050] = HUDSettings.buffs.buff.level_circle[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0.25,
	texture_atlas = "hud_atlas",
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_width = 20,
	pivot_offset_x = 0,
	screen_offset_y = -0.25,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 20,
	texture_atlas_settings = HUDAtlas.buff_number_bg_small
}
HUDSettings.buffs.buff.level_text = HUDSettings.buffs.buff.level_text or {}
HUDSettings.buffs.buff.level_text[1680] = HUDSettings.buffs.buff.level_text[1680] or {}
HUDSettings.buffs.buff.level_text[1680][1050] = HUDSettings.buffs.buff.level_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0.24,
	pivot_align_y = "center",
	font_size = 15,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = -0.24,
	pivot_align_x = "center",
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.buffs.buff.timer_background = HUDSettings.buffs.buff.timer_background or {}
HUDSettings.buffs.buff.timer_background[1680] = HUDSettings.buffs.buff.timer_background[1680] or {}
HUDSettings.buffs.buff.timer_background[1680][1050] = HUDSettings.buffs.buff.timer_background[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	texture_atlas = "hud_atlas",
	pivot_align_y = "center",
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_width = 60,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 60,
	texture_atlas_settings = HUDAtlas.cooldowncircle_small
}
HUDSettings.buffs.buff.timer = HUDSettings.buffs.buff.timer or {}
HUDSettings.buffs.buff.timer[1680] = HUDSettings.buffs.buff.timer[1680] or {}
HUDSettings.buffs.buff.timer[1680][1050] = HUDSettings.buffs.buff.timer[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture_width = 60,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 60
}
HUDSettings.debuffs = HUDSettings.debuffs or {}
HUDSettings.debuffs.container = HUDSettings.debuffs.container or {}
HUDSettings.debuffs.container[1680] = HUDSettings.debuffs.container[1680] or {}
HUDSettings.debuffs.container[1680][1050] = HUDSettings.debuffs.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	height = 60,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	width = 480
}
HUDSettings.xp_and_coins = HUDSettings.xp_and_coins or {}
HUDSettings.xp_and_coins[1680] = HUDSettings.xp_and_coins[1680] or {}
HUDSettings.xp_and_coins[1680][1050] = HUDSettings.xp_and_coins[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0.1,
	pivot_align_y = "bottom",
	font_size = 32,
	pivot_offset_y = 0,
	text_spacing = 41,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = -0.2,
	pivot_align_x = "left",
	font = MenuSettings.fonts.hell_shark_32,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.xp_and_coins[1366] = HUDSettings.xp_and_coins[1366] or {}
HUDSettings.xp_and_coins[1366][768] = table.clone(HUDSettings.xp_and_coins[1680][1050])
HUDSettings.xp_and_coins[1366][768].font_size = HUDSettings.xp_and_coins[1366][768].font_size * SCALE_1366
HUDSettings.xp_and_coins[1366][768].text_spacing = HUDSettings.xp_and_coins[1366][768].text_spacing * SCALE_1366
HUDSettings.tagging = HUDSettings.tagging or {}
HUDSettings.tagging.container = HUDSettings.tagging.container or {}
HUDSettings.tagging.container[1680] = HUDSettings.tagging.container[1680] or {}
HUDSettings.tagging.container[1680][1050] = HUDSettings.tagging.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = -1,
	pivot_offset_y = 0,
	height = 32,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 32
}
HUDSettings.tagging.loading_circle = HUDSettings.tagging.loading_circle or {}
HUDSettings.tagging.loading_circle[1680] = HUDSettings.tagging.loading_circle[1680] or {}
HUDSettings.tagging.loading_circle[1680][1050] = HUDSettings.tagging.loading_circle[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_hit_marker",
	pivot_offset_y = 0,
	texture_width = 32,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 32
}
HUDSettings.combat_text = HUDSettings.combat_text or {}
HUDSettings.combat_text.container = HUDSettings.combat_text.container or {}
HUDSettings.combat_text.container[1680] = HUDSettings.combat_text.container[1680] or {}
HUDSettings.combat_text.container[1680][1050] = HUDSettings.combat_text.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 0,
	pivot_offset_y = 0,
	height = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 0
}
HUDSettings.combat_text.number = HUDSettings.combat_text.number or {}
HUDSettings.combat_text.number[1680] = HUDSettings.combat_text.number[1680] or {}
HUDSettings.combat_text.number[1680][1050] = HUDSettings.combat_text.number[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_align_y = "center",
	screen_align_x = "center",
	pivot_offset_y = 0
}
HUDSettings.player_status = HUDSettings.player_status or {}
HUDSettings.player_status.container = HUDSettings.player_status.container or {}
HUDSettings.player_status.container[1680] = HUDSettings.player_status.container[1680] or {}
HUDSettings.player_status.container[1680][1050] = HUDSettings.player_status.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = -1,
	pivot_offset_y = 0,
	height = 1,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 1
}
HUDSettings.player_status.power_bar = HUDSettings.player_status.power_bar or {}
HUDSettings.player_status.power_bar[1680] = {}
HUDSettings.player_status.power_bar[1680][1050] = HUDSettings.player_status.power_bar[1680][1050] or {
	screen_align_x = "center",
	atlas = "hud_assets",
	end_bar_texture = "powerframe_color",
	pivot_offset_y = 80,
	bar_height = 14,
	start_bar_texture = "powerframe_white",
	screen_offset_x = 0,
	start_value = 0.2,
	bar_texture_offset_x = 12,
	screen_align_y = "bottom",
	foreground_texture = "powerframe_fg",
	pivot_align_y = "center",
	glow_texture = "powerframe_glow",
	pivot_offset_x = -8,
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 217,
	background_texture = "powerframe_bg"
}
HUDSettings.player_status.power_bar_aiming = HUDSettings.player_status.power_bar_aiming or {}
HUDSettings.player_status.power_bar_aiming[1680] = HUDSettings.player_status.power_bar_aiming[1680] or {}
HUDSettings.player_status.power_bar_aiming[1680][1050] = {
	screen_align_x = "center",
	atlas = "hud_assets",
	end_bar_texture = "powerframe_color",
	pivot_offset_y = 0,
	bar_height = 14,
	start_bar_texture = "powerframe_white",
	screen_offset_x = 0,
	start_value = 0.2,
	bar_texture_offset_x = 12,
	screen_align_y = "bottom",
	foreground_texture = "powerframe_fg",
	pivot_align_y = "center",
	glow_texture = "powerframe_glow",
	pivot_offset_x = -8,
	screen_offset_y = 0.3,
	pivot_align_x = "center",
	bar_width = 217,
	background_texture = "powerframe_bg"
}
HUDSettings.player_status.health_bar = HUDSettings.player_status.health_bar or {}
HUDSettings.player_status.health_bar[1366] = HUDSettings.player_status.health_bar[1366] or {}
HUDSettings.player_status.health_bar[1366][768] = HUDSettings.player_status.health_bar[1366][768] or {
	texture_offset_y = 0,
	screen_offset_x = 0,
	combine_loss = true,
	bar_height = 14,
	pivot_align_y = "center",
	texture_glow_h = "life_lit_glow_horizontal",
	screen_align_y = "center",
	lose_lerp_speed = 0.2,
	lose_texture = "life_default_red",
	pivot_offset_y = 29,
	lose_texture_glow_h = "life_lit_glow_horizontal_red",
	grow_texture_glow_h = "life_lit_glow_horizontal",
	simple_grow_texture = "life_default_dark",
	show_pre_cut = false,
	darken_main_bar = false,
	lighten_main_bar = false,
	texture = "life_default",
	cut_edge_fadeout = true,
	grow_texture = "life_default",
	texture_offset_x = 10,
	lose_texture_glow_v = "life_lit_glow_vertical_red",
	screen_align_x = "center",
	grow_texture_glow_v = "life_lit_glow_vertical",
	pivot_offset_x = -9,
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 379,
	background_texture = "life_bg",
	text = {
		align = "center",
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		text_offset = {
			0,
			3
		},
		shadow_offset = {
			1,
			-2
		}
	}
}
HUDSettings.player_status.health_bar[1366][768].lose_texture_glow_h = "life_lit_glow_horizontal_red"
HUDSettings.player_status.health_bar[1366][768].texture_glow_h = "life_lit_glow_horizontal"
HUDSettings.player_status.health_bar[1366][768].grow_texture = "life_default_grow_outline"
HUDSettings.player_status.health_bar[1366][768].grow_texture_glow_v = "life_lit_glow_vertical"
HUDSettings.player_status.health_bar[1366][768].grow_texture_glow_h = "life_lit_glow_horizontal"
HUDSettings.player_status.health_bar[1366][768].combine_loss = true
HUDSettings.player_status.health_bar[1366][768].lose_texture_glow_v = "life_lit_glow_vertical_red"

local bg_texture = HUDSettings.player_status.health_bar[1366][768].background_texture

HUDSettings.player_status.health_bar = HUDSettings.player_status.health_bar or {}
HUDSettings.player_status.health_bar[1024] = {}
HUDSettings.player_status.health_bar[1024][768] = table.clone(HUDSettings.player_status.health_bar[1366][768])
HUDSettings.player_status.health_bar[1024][768].bar_width = HUDSettings.player_status.health_bar[1024][768].bar_width * SCALE_BG_1024 + SCALE_BG_1024 * 2
HUDSettings.player_status.health_bar[1024][768].bar_height = HUDSettings.player_status.health_bar[1024][768].bar_height * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].pivot_offset_x = HUDSettings.player_status.health_bar[1024][768].pivot_offset_x * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].pivot_offset_y = HUDSettings.player_status.health_bar[1024][768].pivot_offset_y * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].background_size = table.clone(hud_assets[bg_texture].size)
HUDSettings.player_status.health_bar[1024][768].background_size[1] = HUDSettings.player_status.health_bar[1024][768].background_size[1] * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].background_size[2] = HUDSettings.player_status.health_bar[1024][768].background_size[2] * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].texture_offset_x = HUDSettings.player_status.health_bar[1024][768].texture_offset_x * SCALE_BG_1024 - SCALE_BG_1024
HUDSettings.player_status.health_bar[1024][768].texture_offset_y = HUDSettings.player_status.health_bar[1024][768].texture_offset_y * SCALE_BG_1024 - SCALE_BG_1024
HUDSettings.player_status.stamina_bar = HUDSettings.player_status.stamina_bar or {}
HUDSettings.player_status.stamina_bar[1366] = HUDSettings.player_status.stamina_bar[1366] or {}
HUDSettings.player_status.stamina_bar[1366][768] = HUDSettings.player_status.stamina_bar[1366][768] or {
	texture_offset_y = 1,
	screen_offset_x = 0,
	combine_loss = true,
	bar_height = 14,
	pivot_align_y = "center",
	texture_glow_h = "stamina_lit_glow_horizontal",
	fail_duration = 0.5,
	lose_lerp_speed = 0.2,
	lose_texture = "stamina_dark_default",
	pivot_offset_y = 53,
	lose_texture_glow_h = "stamina_dark_lit_glow_horizontal",
	grow_texture_glow_h = "stamina_lit_glow_horizontal",
	continuous_growth = true,
	fail_texture = "stamina_lit_glow_vertical",
	screen_align_y = "center",
	texture = "stamina_default",
	grow_texture = "stamina_default",
	texture_offset_x = 10,
	lose_texture_glow_v = "stamina_dark_lit_glow_vertical",
	screen_align_x = "center",
	grow_texture_glow_v = "stamina_lit_glow_vertical",
	pivot_offset_x = -9,
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 379,
	background_texture = "stamina_bg",
	text = {
		align = "center",
		font_size = 16,
		font = MenuSettings.fonts.hell_shark_16,
		text_offset = {
			0,
			5
		},
		shadow_offset = SMALL_DROP_SHADOW
	}
}
HUDSettings.player_status.stamina_bar[1366][768].texture_glow_h = "stamina_lit_glow_horizontal"
HUDSettings.player_status.stamina_bar[1366][768].texture = "stamina_default"
HUDSettings.player_status.stamina_bar[1366][768].grow_texture = "stamina_lit"
HUDSettings.player_status.stamina_bar[1366][768].continuous_growth = true
HUDSettings.player_status.stamina_bar[1366][768].pulse = {
	pulse_function = function(t)
		local clamped_t = math.clamp(t, 0.1, 0.7)

		t = math.auto_lerp(0.1, 0.7, 0, 1, clamped_t)

		return math.sin(t * math.pi * 0.5)
	end,
	min_max_scale_function = function(t)
		return math.auto_lerp(0.2, 0.8, 0, 1, math.clamp(t, 0.2, 0.8))
	end,
	min = {
		color_multiplier_max = 1,
		frequency = 2,
		color_multiplier_min = 0.4
	},
	max = {
		color_multiplier_max = 1,
		frequency = 0.75,
		color_multiplier_min = 0.65
	}
}

local bg_texture = HUDSettings.player_status.stamina_bar[1366][768].background_texture

HUDSettings.player_status.stamina_bar = HUDSettings.player_status.stamina_bar or {}
HUDSettings.player_status.stamina_bar[1024] = {}
HUDSettings.player_status.stamina_bar[1024][768] = table.clone(HUDSettings.player_status.stamina_bar[1366][768])
HUDSettings.player_status.stamina_bar[1024][768].bar_width = HUDSettings.player_status.stamina_bar[1024][768].bar_width * SCALE_BG_1024 + SCALE_BG_1024 * 2
HUDSettings.player_status.stamina_bar[1024][768].bar_height = HUDSettings.player_status.stamina_bar[1024][768].bar_height * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.stamina_bar[1024][768].pivot_offset_x = HUDSettings.player_status.stamina_bar[1024][768].pivot_offset_x * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.stamina_bar[1024][768].pivot_offset_y = HUDSettings.player_status.stamina_bar[1024][768].pivot_offset_y * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.stamina_bar[1024][768].background_size = table.clone(hud_assets[bg_texture].size)
HUDSettings.player_status.stamina_bar[1024][768].background_size[1] = HUDSettings.player_status.stamina_bar[1024][768].background_size[1] * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.stamina_bar[1024][768].background_size[2] = HUDSettings.player_status.stamina_bar[1024][768].background_size[2] * SCALE_BG_1024 + SCALE_BG_1024
HUDSettings.player_status.stamina_bar[1024][768].texture_offset_x = HUDSettings.player_status.stamina_bar[1024][768].texture_offset_x * SCALE_BG_1024 - SCALE_BG_1024 * 1
HUDSettings.player_status.stamina_bar[1024][768].texture_offset_y = HUDSettings.player_status.stamina_bar[1024][768].texture_offset_y * SCALE_BG_1024 - SCALE_BG_1024 * 3
HUDSettings.player_status.exp_bar = HUDSettings.player_status.exp_bar or {}
HUDSettings.player_status.exp_bar[1366] = HUDSettings.player_status.exp_bar[1366] or {}
HUDSettings.player_status.exp_bar[1366][768] = HUDSettings.player_status.exp_bar[1366][768] or {
	pivot_offset_x = 0,
	screen_offset_x = 0,
	pivot_align_y = "center",
	bar_height = 4,
	screen_align_y = "center",
	lose_lerp_speed = 0.2,
	lose_texture = "exp_bar",
	lose_texture_glow_h = "exp_bar",
	continuous_growth = false,
	texture = "exp_bar",
	grow_texture = "exp_bar",
	pivot_offset_y = 10,
	grow_texture_glow_h = "exp_bar_lit_glow_horizontal",
	screen_align_x = "center",
	grow_texture_glow_v = "exp_bar_lit_glow_vertical",
	texture_glow_h = "exp_bar",
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 1080
}
HUDSettings.player_status.exp_bar = HUDSettings.player_status.exp_bar or {}
HUDSettings.player_status.exp_bar[1024] = {}
HUDSettings.player_status.exp_bar[1024][768] = table.clone(HUDSettings.player_status.exp_bar[1366][768])
HUDSettings.player_status.exp_bar[1024][768].bar_width = HUDSettings.player_status.exp_bar[1024][768].bar_width * SCALE_BG_1024
HUDSettings.player_status.exp_bar[1024][768].bar_height = HUDSettings.player_status.exp_bar[1024][768].bar_height * SCALE_BG_1024
HUDSettings.player_status.short_term_goal_bar = HUDSettings.player_status.short_term_goal_bar or {}
HUDSettings.player_status.short_term_goal_bar[1366] = HUDSettings.player_status.short_term_goal_bar[1366] or {}
HUDSettings.player_status.short_term_goal_bar[1366][768] = HUDSettings.player_status.short_term_goal_bar[1366][768] or {
	pivot_offset_x = 0,
	screen_offset_x = 0,
	pivot_align_y = "center",
	bar_height = 4,
	screen_align_y = "center",
	lose_lerp_speed = 0.2,
	lose_texture = "coin_bar",
	lose_texture_glow_h = "coin_bar",
	continuous_growth = false,
	texture = "coin_bar",
	grow_texture = "coin_bar",
	pivot_offset_y = 10,
	grow_texture_glow_h = "coin_bar_lit_glow_horizontal",
	screen_align_x = "center",
	grow_texture_glow_v = "coin_bar_lit_glow_vertical",
	texture_glow_h = "coin_bar",
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 1080
}
HUDSettings.player_status.short_term_goal_bar = HUDSettings.player_status.short_term_goal_bar or {}
HUDSettings.player_status.short_term_goal_bar[1024] = {}
HUDSettings.player_status.short_term_goal_bar[1024][768] = table.clone(HUDSettings.player_status.short_term_goal_bar[1366][768])
HUDSettings.player_status.short_term_goal_bar[1024][768].bar_width = HUDSettings.player_status.short_term_goal_bar[1024][768].bar_width * SCALE_BG_1024
HUDSettings.player_status.short_term_goal = HUDSettings.player_status.short_term_goal or {}
HUDSettings.player_status.short_term_goal.container = HUDSettings.player_status.short_term_goal.container or {}
HUDSettings.player_status.short_term_goal.container[1680] = HUDSettings.player_status.short_term_goal.container[1680] or {}
HUDSettings.player_status.short_term_goal.container[1680][1050] = HUDSettings.player_status.short_term_goal.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = -1,
	pivot_offset_y = 126,
	height = 32,
	screen_align_x = "center",
	pivot_offset_x = -1,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 150
}
HUDSettings.player_status.short_term_goal.timer = HUDSettings.player_status.short_term_goal.timer or {}
HUDSettings.player_status.short_term_goal.timer[1680] = HUDSettings.player_status.short_term_goal.timer[1680] or {}
HUDSettings.player_status.short_term_goal.timer[1680][1050] = HUDSettings.player_status.short_term_goal.timer[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 0,
	font_size = 16,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	alpha_animation = {
		fade_out = 0.9,
		duration = 8,
		fade_in = 0.1,
		fade_to = 255
	},
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.short_term_goal.bonus = HUDSettings.player_status.short_term_goal.bonus or {}
HUDSettings.player_status.short_term_goal.bonus[1680] = HUDSettings.player_status.short_term_goal.bonus[1680] or {}
HUDSettings.player_status.short_term_goal.bonus[1680][1050] = HUDSettings.player_status.short_term_goal.bonus[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	font_size = 16,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	alpha_animation = {
		fade_out = 0.9,
		duration = 8,
		fade_in = 0.1,
		fade_to = 255
	},
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.short_term_goal.background = HUDSettings.player_status.short_term_goal.background or {}
HUDSettings.player_status.short_term_goal.background[1680] = HUDSettings.player_status.short_term_goal.background[1680] or {}
HUDSettings.player_status.short_term_goal.background[1680][1050] = HUDSettings.player_status.short_term_goal.background[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = -46,
	atlas = "hud_assets",
	screen_align_x = "center",
	texture = "xpgoal_bg",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	alpha_animation = {
		fade_out = 0.9,
		duration = 8,
		fade_in = 0.1,
		fade_to = 255
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.rank_up_exp_bar = HUDSettings.player_status.rank_up_exp_bar or {}
HUDSettings.player_status.rank_up_exp_bar[1366] = HUDSettings.player_status.rank_up_exp_bar[1366] or {}
HUDSettings.player_status.rank_up_exp_bar[1366][768] = HUDSettings.player_status.rank_up_exp_bar[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 10,
	texture = "exp_bar_lit_glow_vertical",
	screen_align_x = "center",
	texture_width = 1080,
	pivot_offset_x = 1,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 4,
	alpha_animation = {
		fade_out = 0.6,
		duration = 1.5,
		fade_in = 0.3,
		fade_to = 255
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.rank_up_exp_bar = HUDSettings.player_status.rank_up_exp_bar or {}
HUDSettings.player_status.rank_up_exp_bar[1024] = {}
HUDSettings.player_status.rank_up_exp_bar[1024][768] = table.clone(HUDSettings.player_status.rank_up_exp_bar[1366][768])
HUDSettings.player_status.rank_up_exp_bar[1024][768].texture_width = HUDSettings.player_status.rank_up_exp_bar[1024][768].texture_width * SCALE_BG_1024
HUDSettings.player_status.rank_up_exp_bar[1024][768].texture_height = HUDSettings.player_status.rank_up_exp_bar[1024][768].texture_height * SCALE_BG_1024
HUDSettings.player_status.rank_up_upcoming_level = HUDSettings.player_status.rank_up_upcoming_level or {}
HUDSettings.player_status.rank_up_upcoming_level[1680] = HUDSettings.player_status.rank_up_upcoming_level[1680] or {}
HUDSettings.player_status.rank_up_upcoming_level[1680][1050] = HUDSettings.player_status.rank_up_upcoming_level[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	atlas = "hud_assets",
	pivot_offset_y = -2,
	texture = "level_upcoming_bg",
	screen_align_x = "center",
	pivot_offset_x = 585,
	screen_offset_y = 0,
	pivot_align_x = "center",
	alpha_animation = {
		fade_out = 0.6,
		duration = 1.5,
		fade_in = 0.3,
		fade_to = 255
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.background = HUDSettings.player_status.background or {}
HUDSettings.player_status.background[1366] = HUDSettings.player_status.background[1366] or {}
HUDSettings.player_status.background[1366][768] = HUDSettings.player_status.background[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	atlas = "hud_assets",
	pivot_offset_y = 0,
	texture = "hud_bottom_bg",
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center"
}
HUDSettings.player_status.background = HUDSettings.player_status.background or {}
HUDSettings.player_status.background[1024] = {}
HUDSettings.player_status.background[1024][768] = table.clone(HUDSettings.player_status.background[1366][768])
HUDSettings.player_status.background[1024][768].texture_width = 1024
HUDSettings.player_status.background[1024][768].texture_height = 80 * SCALE_BG_1024
HUDSettings.player_status.current_level = HUDSettings.player_status.current_level or {}
HUDSettings.player_status.current_level[1366] = {}
HUDSettings.player_status.current_level[1366][768] = HUDSettings.player_status.current_level[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = -2,
	text_offset_y = 23,
	screen_align_x = "center",
	atlas = "hud_assets",
	texture = "level_upcoming_bg",
	text_size = 30,
	pivot_offset_x = -590,
	screen_offset_y = 0,
	pivot_align_x = "center",
	text_offset_x = -586,
	text_font = MenuSettings.fonts.viking_numbers_30.font,
	text_font_material = MenuSettings.fonts.viking_numbers_30.material
}
HUDSettings.player_status.current_level = HUDSettings.player_status.current_level or {}
HUDSettings.player_status.current_level[1024] = {}
HUDSettings.player_status.current_level[1024][768] = table.clone(HUDSettings.player_status.current_level[1366][768])
HUDSettings.player_status.current_level[1024][768].pivot_offset_x = HUDSettings.player_status.current_level[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.current_level[1024][768].pivot_offset_y = HUDSettings.player_status.current_level[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.current_level[1024][768].text_offset_x = HUDSettings.player_status.current_level[1024][768].text_offset_x * SCALE_BG_1024
HUDSettings.player_status.current_level[1024][768].text_offset_y = HUDSettings.player_status.current_level[1024][768].text_offset_y * SCALE_BG_1024
HUDSettings.player_status.current_level[1024][768].text_size = HUDSettings.player_status.current_level[1024][768].text_size * SCALE_BG_1024
HUDSettings.player_status.current_level[1024][768].scale = SCALE_BG_1024
HUDSettings.player_status.upcoming_level = HUDSettings.player_status.upcoming_level or {}
HUDSettings.player_status.upcoming_level[1366] = {}
HUDSettings.player_status.upcoming_level[1366][768] = HUDSettings.player_status.upcoming_level[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = -2,
	text_offset_y = 23,
	screen_align_x = "center",
	atlas = "hud_assets",
	texture = "level_current_bg",
	text_size = 30,
	pivot_offset_x = 585,
	screen_offset_y = 0,
	pivot_align_x = "center",
	text_offset_x = 589,
	text_font = MenuSettings.fonts.viking_numbers_30.font,
	text_font_material = MenuSettings.fonts.viking_numbers_30.material
}
HUDSettings.player_status.upcoming_level = HUDSettings.player_status.upcoming_level or {}
HUDSettings.player_status.upcoming_level[1024] = {}
HUDSettings.player_status.upcoming_level[1024][768] = table.clone(HUDSettings.player_status.upcoming_level[1366][768])
HUDSettings.player_status.upcoming_level[1024][768].pivot_offset_x = HUDSettings.player_status.upcoming_level[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.upcoming_level[1024][768].pivot_offset_y = HUDSettings.player_status.upcoming_level[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.upcoming_level[1024][768].text_offset_x = HUDSettings.player_status.upcoming_level[1024][768].text_offset_x * SCALE_BG_1024
HUDSettings.player_status.upcoming_level[1024][768].text_offset_y = HUDSettings.player_status.upcoming_level[1024][768].text_offset_y * SCALE_BG_1024
HUDSettings.player_status.upcoming_level[1024][768].text_size = HUDSettings.player_status.upcoming_level[1024][768].text_size * SCALE_BG_1024
HUDSettings.player_status.upcoming_level[1024][768].scale = SCALE_BG_1024
HUDSettings.player_status.exp_divider = HUDSettings.player_status.exp_divider or {}
HUDSettings.player_status.exp_divider[1680] = HUDSettings.player_status.exp_divider[1680] or {}
HUDSettings.player_status.exp_divider[1680][1050] = HUDSettings.player_status.exp_divider[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	atlas = "hud_assets",
	texture = "exp_bar_divider",
	screen_align_x = "center",
	screen_offset_y = 0,
	pivot_align_x = "center",
	pivot_offset_x = -0,
	pivot_offset_y = -0
}
HUDSettings.player_status.exp_bar_end = HUDSettings.player_status.exp_bar_end or {}
HUDSettings.player_status.exp_bar_end[1680] = HUDSettings.player_status.exp_bar_end[1680] or {}
HUDSettings.player_status.exp_bar_end[1680][1050] = HUDSettings.player_status.exp_bar_end[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 11,
	texture = "xpgoal_marker",
	screen_align_x = "center",
	height = 14,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 14
}
HUDSettings.player_status.dirt_foreground = HUDSettings.player_status.dirt_foreground or {}
HUDSettings.player_status.dirt_foreground[1366] = HUDSettings.player_status.dirt_foreground[1366] or {}
HUDSettings.player_status.dirt_foreground[1366][768] = HUDSettings.player_status.dirt_foreground[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	atlas = "hud_assets",
	pivot_offset_y = 0,
	texture = "hud_bottom_fg",
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center"
}
HUDSettings.player_status.dirt_foreground = HUDSettings.player_status.dirt_foreground or {}
HUDSettings.player_status.dirt_foreground[1024] = {}
HUDSettings.player_status.dirt_foreground[1024][768] = table.clone(HUDSettings.player_status.dirt_foreground[1366][768])
HUDSettings.player_status.dirt_foreground[1024][768].texture_width = 1024
HUDSettings.player_status.dirt_foreground[1024][768].texture_height = 80 * SCALE_BG_1024
HUDSettings.player_status.perks = HUDSettings.player_status.perks or {}
HUDSettings.player_status.perks.container = HUDSettings.player_status.perks.container or {}
HUDSettings.player_status.perks.container[1680] = HUDSettings.player_status.perks.container[1680] or {}
HUDSettings.player_status.perks.container[1680][1050] = HUDSettings.player_status.perks.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = -2,
	pivot_offset_y = 0,
	height = 1,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 1
}
HUDSettings.player_status.perks.perk_icon = HUDSettings.player_status.perks.perk_icon or {}
HUDSettings.player_status.perks.perk_icon[1366] = HUDSettings.player_status.perks.perk_icon[1366] or {}
HUDSettings.player_status.perks.perk_icon[1366][768] = HUDSettings.player_status.perks.perk_icon[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 41,
	texture = "perk_icon_no_perk",
	screen_align_x = "center",
	perk_slot_x_difference = 45,
	offset_x = 177,
	pivot_offset_x = 177,
	screen_offset_y = 0,
	pivot_align_x = "center",
	fade_in_duration = 0.3,
	fade_out_duration = 0.9,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.perks.perk_icon = HUDSettings.player_status.perks.perk_icon or {}
HUDSettings.player_status.perks.perk_icon[1024] = {}
HUDSettings.player_status.perks.perk_icon[1024][768] = table.clone(HUDSettings.player_status.perks.perk_icon[1366][768])
HUDSettings.player_status.perks.perk_icon[1024][768].pivot_offset_x = HUDSettings.player_status.perks.perk_icon[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.perks.perk_icon[1024][768].pivot_offset_y = HUDSettings.player_status.perks.perk_icon[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.perks.perk_icon[1024][768].offset_x = HUDSettings.player_status.perks.perk_icon[1024][768].offset_x * SCALE_BG_1024
HUDSettings.player_status.perks.perk_icon[1024][768].perk_slot_x_difference = HUDSettings.player_status.perks.perk_icon[1024][768].perk_slot_x_difference * SCALE_BG_1024
HUDSettings.player_status.perks.perk_icon[1024][768].scale = SCALE_BG_1024
HUDSettings.player_status.perks.perk_key_binding = HUDSettings.player_status.perks.perk_key_binding or {}
HUDSettings.player_status.perks.perk_key_binding[1366] = HUDSettings.player_status.perks.perk_key_binding[1366] or {}
HUDSettings.player_status.perks.perk_key_binding[1366][768] = HUDSettings.player_status.perks.perk_key_binding[1366][768] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 11,
	pivot_offset_y = 20,
	screen_align_x = "center",
	perk_slot_x_difference = 45,
	text = "nil",
	pivot_offset_x = 179,
	screen_offset_y = 0,
	pivot_align_x = "center",
	offset_x = 179,
	font = MenuSettings.fonts.hell_shark_11,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.perks.perk_key_binding = HUDSettings.player_status.perks.perk_key_binding or {}
HUDSettings.player_status.perks.perk_key_binding[1024] = {}
HUDSettings.player_status.perks.perk_key_binding[1024][768] = table.clone(HUDSettings.player_status.perks.perk_key_binding[1366][768])
HUDSettings.player_status.perks.perk_key_binding[1024][768].offset_x = HUDSettings.player_status.perks.perk_key_binding[1366][768].offset_x * SCALE_BG_1024
HUDSettings.player_status.perks.perk_key_binding[1024][768].pivot_offset_y = HUDSettings.player_status.perks.perk_key_binding[1366][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.perks.perk_key_binding[1024][768].perk_slot_x_difference = HUDSettings.player_status.perks.perk_key_binding[1366][768].perk_slot_x_difference * SCALE_BG_1024
HUDSettings.player_status.squad_icons = HUDSettings.player_status.squad_icons or {}
HUDSettings.player_status.squad_icons.in_range_indicator = HUDSettings.player_status.squad_icons.in_range_indicator or {}
HUDSettings.player_status.squad_icons.in_range_indicator[1366] = {}
HUDSettings.player_status.squad_icons.in_range_indicator[1366][768] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 41,
	texture = "close_squadmember_icon",
	screen_align_x = "center",
	fade_in_duration = 0.6,
	fade_out_duration = 0.6,
	texture_lit = "close_squadmember_icon_lit",
	pivot_offset_x = -270,
	screen_offset_y = 0,
	pivot_align_x = "center",
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.squad_icons.in_range_indicator = HUDSettings.player_status.squad_icons.in_range_indicator or {}
HUDSettings.player_status.squad_icons.in_range_indicator[1024] = {}
HUDSettings.player_status.squad_icons.in_range_indicator[1024][768] = table.clone(HUDSettings.player_status.squad_icons.in_range_indicator[1366][768])
HUDSettings.player_status.squad_icons.in_range_indicator[1024][768].pivot_offset_x = HUDSettings.player_status.squad_icons.in_range_indicator[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.squad_icons.in_range_indicator[1024][768].pivot_offset_y = HUDSettings.player_status.squad_icons.in_range_indicator[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.squad_icons.in_range_indicator[1024][768].scale = SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_leader_indicator = HUDSettings.player_status.squad_icons.squad_leader_indicator or {}
HUDSettings.player_status.squad_icons.squad_leader_indicator[1366] = {}
HUDSettings.player_status.squad_icons.squad_leader_indicator[1366][768] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 41,
	texture = "squad_flag_icon",
	screen_align_x = "center",
	blank_icon_texture = "squad_flag_icon",
	squad_leader_icon_texture = "squad_flag_icon_lit",
	pivot_offset_x = -315,
	screen_offset_y = 0,
	pivot_align_x = "center",
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.squad_icons.squad_leader_indicator = HUDSettings.player_status.squad_icons.squad_leader_indicator or {}
HUDSettings.player_status.squad_icons.squad_leader_indicator[1024] = {}
HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768] = table.clone(HUDSettings.player_status.squad_icons.squad_leader_indicator[1366][768])
HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768].pivot_offset_x = HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768].pivot_offset_y = HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_leader_indicator[1024][768].scale = SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_flag_range_indicator = HUDSettings.player_status.squad_icons.squad_flag_range_indicator or {}
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1366] = {}
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1366][768] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	atlas = "hud_assets",
	pivot_offset_y = 41,
	texture = "perk_icon_no_perk",
	screen_align_x = "center",
	pivot_offset_x = -225,
	screen_offset_y = 0,
	pivot_align_x = "center",
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.player_status.squad_icons.squad_flag_range_indicator = HUDSettings.player_status.squad_icons.squad_flag_range_indicator or {}
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024] = {}
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768] = table.clone(HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1366][768])
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768].pivot_offset_x = HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768].pivot_offset_x * SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768].pivot_offset_y = HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768].pivot_offset_y * SCALE_BG_1024
HUDSettings.player_status.squad_icons.squad_flag_range_indicator[1024][768].scale = SCALE_BG_1024
HUDSettings.interaction = HUDSettings.interaction or {}
HUDSettings.interaction.container = HUDSettings.interaction.container or {}
HUDSettings.interaction.container[1680] = HUDSettings.interaction.container[1680] or {}
HUDSettings.interaction.container[1680][1050] = HUDSettings.interaction.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = 1,
	pivot_offset_y = 260,
	height = 40,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 400
}
HUDSettings.interaction.objective_bar = HUDSettings.interaction.objective_bar or {}
HUDSettings.interaction.objective_bar[1680] = HUDSettings.interaction.objective_bar[1680] or {}
HUDSettings.interaction.objective_bar[1680][1050] = HUDSettings.interaction.objective_bar[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	bar_height = 16,
	pivot_offset_y = 0,
	texture_inc_glow = "hud_interaction_bar_filling",
	screen_align_x = "center",
	texture_2 = "hud_interaction_bar_filling",
	texture = "hud_interaction_bar_filling",
	texture_offset_x = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 396,
	texture_offset_y = 1,
	background_texture = "hud_interaction_bar_background"
}
HUDSettings.interaction.interaction_bar = HUDSettings.interaction.interaction_bar or {}
HUDSettings.interaction.interaction_bar[1680] = HUDSettings.interaction.interaction_bar[1680] or {}
HUDSettings.interaction.interaction_bar[1680][1050] = HUDSettings.interaction.interaction_bar[1680][1050] or {
	screen_align_x = "center",
	atlas = "hud_assets",
	end_bar_texture = "bandage_bar_color",
	bar_height = 16,
	pivot_offset_y = -240,
	screen_offset_x = 0,
	start_value = 0,
	bar_texture_offset_x = 12,
	screen_align_y = "center",
	foreground_texture = "powerframe_fg",
	pivot_align_y = "center",
	glow_texture = "bandage_bar_glow",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	bar_width = 240,
	background_texture = "powerframe_bg"
}
HUDSettings.interaction.interaction_bar_text = HUDSettings.interaction.interaction_bar_text or {}
HUDSettings.interaction.interaction_bar_text[1680] = HUDSettings.interaction.interaction_bar_text[1680] or {}
HUDSettings.interaction.interaction_bar_text[1680][1050] = HUDSettings.interaction.interaction_bar_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 14,
	pivot_offset_y = -234,
	screen_align_x = "center",
	pulse_alpha_min = 20,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	pulse_alpha_max = 255,
	pulse_speed = 5,
	font = MenuSettings.fonts.hell_shark_14,
	text_color = {
		255,
		255,
		255,
		255
	},
	shadow_color = {
		100,
		100,
		100,
		100
	},
	shadow_offset = {
		0,
		0
	}
}
HUDSettings.ammo_counter = HUDSettings.ammo_counter or {}
HUDSettings.ammo_counter.container = HUDSettings.ammo_counter.container or {}
HUDSettings.ammo_counter.container[1680] = HUDSettings.ammo_counter.container[1680] or {}
HUDSettings.ammo_counter.container[1680][1050] = HUDSettings.ammo_counter.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	spacing = 20,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	z = 1,
	screen_align_x = "right",
	height = 60,
	alignment_x = "stacked",
	pivot_offset_x = -50,
	screen_offset_y = 0.2,
	pivot_align_x = "right",
	alignment_y = "bottom"
}
HUDSettings.ammo_counter.weapon = HUDSettings.ammo_counter.weapon or {}
HUDSettings.ammo_counter.weapon[1680] = HUDSettings.ammo_counter.weapon[1680] or {}
HUDSettings.ammo_counter.weapon[1680][1050] = HUDSettings.ammo_counter.weapon[1680][1050] or {
	texture_atlas = "hud_assets",
	scale = 1,
	texture_atlas_settings_func = function(bb)
		return bb.texture_atlas_settings
	end,
	glow_texture_atlas_settings_func = function(bb)
		return bb.glow_texture_atlas_settings
	end
}
HUDSettings.hit_indicator = HUDSettings.hit_indicator or {}
HUDSettings.hit_indicator[1680] = HUDSettings.hit_indicator[1680] or {}
HUDSettings.hit_indicator[1680][1050] = HUDSettings.hit_indicator[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hit_indicator",
	pivot_offset_y = 0,
	screen_align_x = "center",
	texture_width = 512,
	z = 1,
	pivot_offset_x = 0,
	screen_offset_y = -0.37037037037037035,
	pivot_align_x = "center",
	texture_height = 256,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.in_range_indicator = {}
HUDSettings.in_range_indicator[1680] = {}
HUDSettings.in_range_indicator[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = 1,
	pivot_offset_y = 0,
	height = 40,
	screen_align_x = "center",
	pivot_offset_x = -275,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 40,
	background_color = {
		0,
		0,
		0,
		0
	}
}
HUDSettings.squad_leader_indicator = {}
HUDSettings.squad_leader_indicator[1680] = {}
HUDSettings.squad_leader_indicator[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	z = 1,
	pivot_offset_y = 0,
	height = 40,
	screen_align_x = "center",
	pivot_offset_x = 235,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 40,
	background_color = {
		0,
		0,
		0,
		0
	}
}
HUDSettings.pose_charge = HUDSettings.pose_charge or {}
HUDSettings.pose_charge.container = HUDSettings.pose_charge.container or {}
HUDSettings.pose_charge.container[1680] = HUDSettings.pose_charge.container[1680] or {}
HUDSettings.pose_charge.container[1680][1050] = HUDSettings.pose_charge.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 1,
	pivot_offset_y = 0,
	height = 300,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 300,
	background_color = {
		0,
		0,
		0,
		0
	}
}
HUDSettings.pose_charge.marker = HUDSettings.pose_charge.marker or {}
HUDSettings.pose_charge.marker[1680] = HUDSettings.pose_charge.marker[1680] or {}
HUDSettings.pose_charge.marker[1680][1050] = HUDSettings.pose_charge.marker[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_pose_charge_marker",
	pivot_offset_y = 0,
	texture_width = 12,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 12,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.gradient_circle = HUDSettings.pose_charge.gradient_circle or {}
HUDSettings.pose_charge.gradient_circle[1680] = HUDSettings.pose_charge.gradient_circle[1680] or {}
HUDSettings.pose_charge.gradient_circle[1680][1050] = HUDSettings.pose_charge.gradient_circle[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_pose_charge_gradient_circle",
	pivot_offset_y = 0,
	texture_width = 300,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 300,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.circle_segment = HUDSettings.pose_charge.circle_segment or {}
HUDSettings.pose_charge.circle_segment[1680] = HUDSettings.pose_charge.circle_segment[1680] or {}
HUDSettings.pose_charge.circle_segment[1680][1050] = HUDSettings.pose_charge.circle_segment[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	offset_x = 0,
	pivot_offset_y = 0,
	texture = "hud_pose_charge_circle_segment",
	screen_align_x = "center",
	texture_width = 240,
	scale = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	offset_y = 0.35,
	texture_height = 128,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.attack_top = {}
HUDSettings.pose_charge.attack_top[1680] = {}
HUDSettings.pose_charge.attack_top[1680][1050] = {
	screen_align_y = "top",
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	offset_x = 5,
	pivot_offset_y = 0,
	pivot_align_y = "top",
	screen_align_x = "center",
	material = "attack_top",
	scale = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	offset_y = 400,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.attack_left = {}
HUDSettings.pose_charge.attack_left[1680] = {}
HUDSettings.pose_charge.attack_left[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	offset_x = -430,
	pivot_offset_y = 0,
	pivot_align_y = "bottom",
	screen_align_x = "left",
	material = "attack_side",
	flip_horizontal = true,
	scale = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	offset_y = 65,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.attack_right = {}
HUDSettings.pose_charge.attack_right[1680] = {}
HUDSettings.pose_charge.attack_right[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	offset_x = 430,
	pivot_offset_y = 0,
	pivot_align_y = "bottom",
	screen_align_x = "right",
	material = "attack_side",
	scale = 1,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	offset_y = 65,
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.parry_top = {}
HUDSettings.pose_charge.parry_top[1680] = {}
HUDSettings.pose_charge.parry_top[1680][1050] = {
	offset_y = 400,
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	screen_align_x = "center",
	pivot_offset_y = 0,
	offset_x = 0,
	pivot_align_y = "top",
	mask_offset_x = 505,
	scale = 1,
	screen_align_y = "top",
	z = 1,
	mask_offset_y = 187,
	material = "parry_top",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	mask_size = {
		20,
		50
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.parry_left = {}
HUDSettings.pose_charge.parry_left[1680] = {}
HUDSettings.pose_charge.parry_left[1680][1050] = {
	pivot_offset_x = 0,
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	screen_align_x = "left",
	offset_x = -420,
	pivot_align_y = "bottom",
	flip_horizontal = true,
	mask_offset_y = 415,
	scale = 1,
	screen_align_y = "bottom",
	z = 1,
	pivot_offset_y = 0,
	material = "parry_side",
	mask_offset_x = 70,
	screen_offset_y = 0,
	pivot_align_x = "left",
	offset_y = 0,
	mask_rot = 110,
	mask_size = {
		20,
		50
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.parry_right = {}
HUDSettings.pose_charge.parry_right[1680] = {}
HUDSettings.pose_charge.parry_right[1680][1050] = {
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	pivot_offset_y = 0,
	offset_x = 420,
	screen_align_x = "right",
	pivot_align_y = "bottom",
	mask_offset_x = 289,
	scale = 1,
	screen_align_y = "bottom",
	z = 1,
	mask_offset_y = 413,
	material = "parry_side",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "right",
	offset_y = 0,
	mask_rot = 68,
	mask_size = {
		20,
		50
	},
	color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.pose_charge.parry_top[1366] = {}
HUDSettings.pose_charge.parry_top[1366][768] = table.clone(HUDSettings.pose_charge.parry_top[1680][1050])
HUDSettings.pose_charge.parry_top[1366][768].scale = 0.7
HUDSettings.pose_charge.parry_top[1366][768].offset_y = 120
HUDSettings.pose_charge.parry_top[1366][768].mask_size = {
	10,
	25
}
HUDSettings.pose_charge.parry_top[1366][768].mask_offset_x = 356
HUDSettings.pose_charge.parry_top[1366][768].mask_offset_y = 141
HUDSettings.pose_charge.parry_top[1366][768].add_mask = false
HUDSettings.pose_charge.parry_right[1366] = {}
HUDSettings.pose_charge.parry_right[1366][768] = table.clone(HUDSettings.pose_charge.parry_right[1680][1050])
HUDSettings.pose_charge.parry_right[1366][768].scale = 0.7
HUDSettings.pose_charge.parry_right[1366][768].offset_x = 210
HUDSettings.pose_charge.parry_right[1366][768].mask_size = {
	15,
	30
}
HUDSettings.pose_charge.parry_right[1366][768].mask_offset_x = 204
HUDSettings.pose_charge.parry_right[1366][768].mask_offset_y = 293
HUDSettings.pose_charge.parry_right[1366][768].mask_rot = 70
HUDSettings.pose_charge.parry_right[1366][768].add_mask = false
HUDSettings.pose_charge.parry_left[1366] = {}
HUDSettings.pose_charge.parry_left[1366][768] = table.clone(HUDSettings.pose_charge.parry_left[1680][1050])
HUDSettings.pose_charge.parry_left[1366][768].scale = 0.7
HUDSettings.pose_charge.parry_left[1366][768].offset_x = -210
HUDSettings.pose_charge.parry_left[1366][768].mask_size = {
	15,
	30
}
HUDSettings.pose_charge.parry_left[1366][768].mask_offset_x = 45
HUDSettings.pose_charge.parry_left[1366][768].mask_offset_y = 295
HUDSettings.pose_charge.parry_left[1366][768].mask_rot = 110
HUDSettings.pose_charge.parry_left[1366][768].add_mask = false
HUDSettings.pose_charge.attack_top[1366] = {}
HUDSettings.pose_charge.attack_top[1366][768] = table.clone(HUDSettings.pose_charge.attack_top[1680][1050])
HUDSettings.pose_charge.attack_top[1366][768].scale = 0.7
HUDSettings.pose_charge.attack_top[1366][768].offset_x = 4
HUDSettings.pose_charge.attack_top[1366][768].offset_y = 120
HUDSettings.pose_charge.attack_right[1366] = {}
HUDSettings.pose_charge.attack_right[1366][768] = table.clone(HUDSettings.pose_charge.attack_right[1680][1050])
HUDSettings.pose_charge.attack_right[1366][768].scale = 0.7
HUDSettings.pose_charge.attack_right[1366][768].offset_x = 215
HUDSettings.pose_charge.attack_right[1366][768].offset_y = 45
HUDSettings.pose_charge.attack_left[1366] = {}
HUDSettings.pose_charge.attack_left[1366][768] = table.clone(HUDSettings.pose_charge.attack_left[1680][1050])
HUDSettings.pose_charge.attack_left[1366][768].scale = 0.7
HUDSettings.pose_charge.attack_left[1366][768].offset_x = -215
HUDSettings.pose_charge.attack_left[1366][768].offset_y = 45
HUDSettings.world_icons = HUDSettings.world_icons or {}

local function flash_function_smooth(t)
	local scaled_t = t / 0.8 % 1
	local alpha = math.smoothstep(math.clamp(math.abs(scaled_t - 0.5) * 2, 0, 1), 0, 1)

	return alpha
end

local function flash_function_smooth_slow(t)
	local scaled_t = t / 1.5 % 1
	local clipped_t = math.clamp(scaled_t * 1.2 - 0.1, 0, 1)
	local alpha = math.smoothstep(math.clamp(math.abs(clipped_t - 0.5) * 2, 0, 1), 0, 1) * 0.8

	return alpha
end

local function flash_function_intense(t)
	local scaled_t = t / 1 % 1
	local alpha = math.clamp(scaled_t * 3 - 1, 0, 1)^2

	return alpha
end

HUDSettings.world_icons.player = HUDSettings.world_icons.player or {}
HUDSettings.world_icons.player[1680] = HUDSettings.world_icons.player[1680] or {}
HUDSettings.world_icons.player[1680][1050] = HUDSettings.world_icons.player[1680][1050] or {}
HUDSettings.world_icons.player[1680][1050].attention_screen_zone = HUDSettings.world_icons.player[1680][1050].attention_screen_zone or {}
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.font_size = 26
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_scale = 1
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_atlas = "hud_assets"
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_last_stand = "perk_icon_furious_rage"
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_last_stand_glow = "perk_icon_furious_rage_lit"
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_last_stand_blend_function = flash_function_intense
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_enemy = hud_assets.finish
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_enemy_glow = hud_assets.finish_glow
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_enemy_blend_function = flash_function_smooth_slow
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down = hud_assets.revive
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_glow = hud_assets.revive_glow
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_blend_function = flash_function_smooth_slow
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_knocked_down_revive_request_blend_function = flash_function_smooth
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_dead = hud_assets.dead
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.texture_y_offset = 25
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.name_alpha_multiplier = 1
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.max_scale_distance = 0
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.min_scale = 0.15
HUDSettings.world_icons.player[1680][1050].attention_screen_zone.min_scale_distance = 50
HUDSettings.world_icons.player[1680][1050].default_screen_zone = HUDSettings.world_icons.player[1680][1050].default_screen_zone or {}
HUDSettings.world_icons.player[1680][1050].default_screen_zone.font_size = 26
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_scale = 1
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_atlas = "hud_assets"
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_knocked_down = hud_assets.revive
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_dead = hud_assets.dead
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_y_offset = 25
HUDSettings.world_icons.player[1680][1050].default_screen_zone.name_alpha_multiplier = 1
HUDSettings.world_icons.player[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.player[1680][1050].default_screen_zone.max_scale_distance = 0
HUDSettings.world_icons.player[1680][1050].default_screen_zone.min_scale = 0.15
HUDSettings.world_icons.player[1680][1050].default_screen_zone.min_scale_distance = 50
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_knocked_down_glow = hud_assets.revive_glow
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_knocked_down_revive_request_blend_function = flash_function_smooth
HUDSettings.world_icons.player[1680][1050].default_screen_zone.texture_knocked_down_blend_function = flash_function_smooth_slow
HUDSettings.world_icons.local_player = HUDSettings.world_icons.local_player or {}
HUDSettings.world_icons.local_player[1680] = HUDSettings.world_icons.local_player[1680] or {}
HUDSettings.world_icons.local_player[1680][1050] = HUDSettings.world_icons.local_player[1680][1050] or {}
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone = HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone or {}
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.font_size = 26
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_scale = 1
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_atlas = "hud_assets"
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_knocked_down = hud_assets.revive
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_dead = hud_assets.dead
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_y_offset = 25
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.name_alpha_multiplier = 0
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.max_scale_distance = 0
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.min_scale = 1
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.min_scale_distance = 100
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_knocked_down_glow = hud_assets.revive_glow
HUDSettings.world_icons.local_player[1680][1050].attention_screen_zone.texture_knocked_down_blend_function = flash_function_smooth_slow
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone = HUDSettings.world_icons.local_player[1680][1050].default_screen_zone or {}
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.font_size = 26
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_scale = 1
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_atlas = "hud_assets"
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_knocked_down = hud_assets.revive
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_dead = hud_assets.dead
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_y_offset = 25
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.name_alpha_multiplier = 0
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.max_scale_distance = 0
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.min_scale = 1
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.min_scale_distance = 50
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_knocked_down_glow = hud_assets.revive_glow
HUDSettings.world_icons.local_player[1680][1050].default_screen_zone.texture_knocked_down_blend_function = flash_function_smooth_slow
HUDSettings.world_icons.capture_flag = HUDSettings.world_icons.capture_flag or {}
HUDSettings.world_icons.capture_flag[1680] = HUDSettings.world_icons.capture_flag[1680] or {}
HUDSettings.world_icons.capture_flag[1680][1050] = HUDSettings.world_icons.capture_flag[1680][1050] or {
	attention_screen_zone = {
		min_scale_distance = 200,
		min_scale = 0.5,
		texture_atlas = "hud_atlas",
		max_scale_distance = 20,
		max_scale = 1,
		texture_func = function(blackboard, player)
			return HUDAtlas.hud_flag
		end
	},
	default_screen_zone = {
		min_scale_distance = 200,
		min_scale = 0.5,
		texture_atlas = "hud_atlas",
		max_scale_distance = 20,
		max_scale = 1,
		texture_func = function(blackboard, player)
			return HUDAtlas.hud_flag
		end
	},
	clamped_screen_zone = {
		texture = "mockup_hud_flag_icon",
		texture_atlas = "hud_atlas",
		scale = 1,
		texture_func = function(blackboard, player)
			return HUDAtlas.hud_flag
		end
	},
	spawn_map = {
		texture = "mockup_hud_flag_icon",
		texture_atlas = "hud_atlas",
		scale = 1,
		texture_func = function(blackboard, player)
			return HUDAtlas.hud_flag
		end
	}
}
HUDSettings.world_icons.grail_plant_point = HUDSettings.world_icons.grail_plant_point or {}
HUDSettings.world_icons.grail_plant_point[1680] = HUDSettings.world_icons.grail_plant_point[1680] or {}
HUDSettings.world_icons.grail_plant_point[1680][1050] = HUDSettings.world_icons.grail_plant_point[1680][1050] or {
	attention_screen_zone = {
		min_scale_distance = 200,
		min_scale = 0.5,
		texture_atlas = "hud_atlas",
		max_scale_distance = 20,
		max_scale = 1,
		texture_func = function(blackboard, player)
			local player_unit = player.player_unit
			local carried_flag = Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "locomotion_system").carried_flag

			return carried_flag and player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_plant_point or nil
		end
	},
	default_screen_zone = {
		min_scale_distance = 200,
		min_scale = 0.5,
		texture_atlas = "hud_atlas",
		max_scale_distance = 20,
		max_scale = 1,
		texture_func = function(blackboard, player)
			local player_unit = player.player_unit
			local carried_flag = Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "locomotion_system").carried_flag

			return carried_flag and player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_plant_point or nil
		end
	},
	clamped_screen_zone = {
		scale = 1,
		texture_atlas = "hud_atlas",
		texture_func = function(blackboard, player)
			local player_unit = player.player_unit
			local carried_flag = Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "locomotion_system").carried_flag

			return carried_flag and player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_plant_point or nil
		end
	},
	spawn_map = {
		scale = 1,
		texture_atlas = "hud_atlas",
		texture_func = function(blackboard, player)
			local player_unit = player.player_unit
			local carried_flag = Unit.alive(player_unit) and ScriptUnit.extension(player_unit, "locomotion_system").carried_flag

			return carried_flag and player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_plant_point or nil
		end
	}
}
HUDSettings.world_icons.objective_circle = HUDSettings.world_icons.objective_circle or {}
HUDSettings.world_icons.objective_circle[1680] = HUDSettings.world_icons.objective_circle[1680] or {}
HUDSettings.world_icons.objective_circle[1680][1050] = HUDSettings.world_icons.objective_circle[1680][1050] or {
	attention_screen_zone = {
		min_scale = 0.5,
		z = 0,
		texture_atlas = "hud_assets",
		show_progress = true,
		max_scale_distance = 20,
		min_scale_distance = 200,
		max_scale = 1,
		objective_text = {
			text_type = "string",
			font_size = 16,
			text_func = function(blackboard, player, unit, world)
				return player.team and blackboard.active_team_sides[player.team.side] and Unit.has_data(unit, "hud", "ui_name") and Unit.get_data(unit, "hud", "ui_name") .. "_floating", Color(200, 255, 255, 255)
			end,
			font = MenuSettings.fonts.player_name_font,
			drop_shadow = SMALL_DROP_SHADOW,
			drop_shadow_color = {
				200,
				0,
				0,
				0
			},
			text_offset = {
				z = 0,
				x = 0,
				y = 0
			}
		},
		texture_func = function(blackboard, player)
			return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_objective_circle or nil
		end
	},
	default_screen_zone = {
		min_scale_distance = 200,
		z = 0,
		texture_atlas = "hud_assets",
		show_progress = true,
		min_scale = 0.5,
		max_scale_distance = 20,
		max_scale = 1,
		texture_func = function(blackboard, player)
			return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_objective_circle or nil
		end
	},
	clamped_screen_zone = {
		texture_atlas = "hud_assets",
		z = 0,
		scale = 1,
		texture_func = function(blackboard, player)
			return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_objective_circle or nil
		end
	},
	spawn_map = {
		z = 0,
		texture_atlas = "hud_assets",
		scale = 1,
		show_progress = true,
		texture_func = function(blackboard, player)
			return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_objective_circle or nil
		end
	}
}
HUDSettings.world_icons.blank_icon = HUDSettings.world_icons.blank_icon or {}
HUDSettings.world_icons.blank_icon[1680] = HUDSettings.world_icons.blank_icon[1680] or {}
HUDSettings.world_icons.blank_icon[1680][1050] = HUDSettings.world_icons.blank_icon[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.blank_icon[1680][1050].attention_screen_zone.texture_func = function(blackboard, player)
	return HUDAtlas.hud_blank_icon
end
HUDSettings.world_icons.blank_icon[1680][1050].default_screen_zone.texture_func = function(blackboard, player)
	return HUDAtlas.hud_blank_icon
end
HUDSettings.world_icons.blank_icon[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return HUDAtlas.hud_blank_icon
end
HUDSettings.world_icons.blank_icon[1680][1050].spawn_map.texture_func = function(blackboard, player)
	return HUDAtlas.hud_blank_icon
end
HUDSettings.world_icons.interactable_destructable_gate = HUDSettings.world_icons.interactable_destructable_gate or {}
HUDSettings.world_icons.interactable_destructable_gate[1680] = HUDSettings.world_icons.interactable_destructable_gate[1680] or {}
HUDSettings.world_icons.interactable_destructable_gate[1680][1050] = HUDSettings.world_icons.interactable_destructable_gate[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance < 20 and distance > 10

	if show then
		local team_side = player.team.side

		if blackboard.active_team_sides[team_side] then
			return HUDAtlas.open_gate_icon
		elseif blackboard.active_team_sides_destructible[team_side] and blackboard.destructible_enabled then
			return HUDAtlas.break_gate_icon
		end
	end
end
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].attention_screen_zone.min_scale = 0.25
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].attention_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].default_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance < 20 and distance > 10

	if show then
		local team_side = player.team.side

		if blackboard.active_team_sides[team_side] then
			return HUDAtlas.open_gate_icon
		elseif blackboard.active_team_sides_destructible[team_side] and blackboard.destructible_enabled then
			return HUDAtlas.break_gate_icon
		end
	end
end
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].default_screen_zone.min_scale = 0.25
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].default_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return nil
end
HUDSettings.world_icons.interactable_destructable_gate[1680][1050].spawn_map.texture_func = function(blackboard, player)
	return
end
HUDSettings.world_icons.interactable_destructable_gate_2 = HUDSettings.world_icons.interactable_destructable_gate_2 or {}
HUDSettings.world_icons.interactable_destructable_gate_2[1680] = HUDSettings.world_icons.interactable_destructable_gate_2[1680] or {}
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050] = HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].default_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance > 20 and distance < 50

	if show then
		local team_side = player.team.side

		if blackboard.active_team_sides[team_side] then
			return HUDAtlas.hud_objective_diamond
		end
	else
		return nil
	end
end
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].default_screen_zone.max_scale = 0.5
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].default_screen_zone.min_scale = 0.5
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].default_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return
end
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].attention_screen_zone.max_scale = 0.5
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].attention_screen_zone.min_scale = 0.5
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].attention_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.interactable_destructable_gate_2[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance > 20 and distance < 50

	if show then
		local team_side = player.team.side

		if blackboard.active_team_sides[team_side] then
			return HUDAtlas.hud_objective_diamond
		end
	else
		return nil
	end
end
HUDSettings.world_icons.objective_cart = HUDSettings.world_icons.objective_cart or {}
HUDSettings.world_icons.objective_cart[1680] = HUDSettings.world_icons.objective_cart[1680] or {}
HUDSettings.world_icons.objective_cart[1680][1050] = HUDSettings.world_icons.objective_cart[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.objective_cart[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance > 10

	if show then
		return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.cart_icon or nil
	else
		return nil
	end
end
HUDSettings.world_icons.objective_cart[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.objective_cart[1680][1050].attention_screen_zone.min_scale = 1
HUDSettings.world_icons.objective_cart[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.objective_cart[1680][1050].attention_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.objective_cart[1680][1050].default_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local distance = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos)
	local show = distance > 10

	if show then
		return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.cart_icon or nil
	else
		return nil
	end
end
HUDSettings.world_icons.objective_cart[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.objective_cart[1680][1050].default_screen_zone.min_scale = 1
HUDSettings.world_icons.objective_cart[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.objective_cart[1680][1050].default_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.objective_cart[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.cart_icon or nil
end
HUDSettings.world_icons.objective_cart[1680][1050].clamped_screen_zone.scale = 1
HUDSettings.world_icons.objective_cart[1680][1050].spawn_map.texture_func = function(blackboard, player)
	return player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.cart_icon or nil
end
HUDSettings.world_icons.objective_cart[1680][1050].spawn_map.scale = 1
HUDSettings.world_icons.ladder_objective = HUDSettings.world_icons.ladder_objective or {}
HUDSettings.world_icons.ladder_objective[1680] = HUDSettings.world_icons.ladder_objective[1680] or {}
HUDSettings.world_icons.ladder_objective[1680][1050] = HUDSettings.world_icons.ladder_objective[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.ladder_objective[1680][1050].attention_screen_zone.texture_func = function()
	return HUDAtlas.ladder_objective
end
HUDSettings.world_icons.ladder_objective[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.ladder_objective[1680][1050].attention_screen_zone.min_scale = 0.25
HUDSettings.world_icons.ladder_objective[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.ladder_objective[1680][1050].attention_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.ladder_objective[1680][1050].avoid_menu_rendering = true
HUDSettings.world_icons.ladder_objective[1680][1050].default_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local show = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos) < 10

	if show then
		return HUDAtlas.ladder_objective
	else
		return nil
	end
end
HUDSettings.world_icons.ladder_objective[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.ladder_objective[1680][1050].default_screen_zone.min_scale = 0.25
HUDSettings.world_icons.ladder_objective[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.ladder_objective[1680][1050].default_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.ladder_objective[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return
end
HUDSettings.world_icons.ladder_objective[1680][1050].spawn_map.texture_func = function()
	return nil
end
HUDSettings.world_icons.ladder_objective[1680][1050].spawn_map.scale = 0.25
HUDSettings.world_icons.ladder_objective_2 = HUDSettings.world_icons.ladder_objective_2 or {}
HUDSettings.world_icons.ladder_objective_2[1680] = HUDSettings.world_icons.ladder_objective_2[1680] or {}
HUDSettings.world_icons.ladder_objective_2[1680][1050] = HUDSettings.world_icons.ladder_objective_2[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.ladder_objective_2[1680][1050].default_screen_zone.texture_func = function(blackboard, player, objective_unit, world)
	local camera_pos = Managers.state.camera:camera_position(player.viewport_name)
	local show = Vector3.length(Unit.world_position(objective_unit, 0) - camera_pos) < 10

	if show then
		return nil
	else
		return HUDAtlas.hud_objective_diamond
	end
end
HUDSettings.world_icons.ladder_objective_2[1680][1050].default_screen_zone.max_scale = 0.5
HUDSettings.world_icons.ladder_objective_2[1680][1050].default_screen_zone.min_scale = 0.5
HUDSettings.world_icons.ladder_objective_2[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.ladder_objective_2[1680][1050].default_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.ladder_objective_2[1680][1050].attention_screen_zone.max_scale = 0.5
HUDSettings.world_icons.ladder_objective_2[1680][1050].attention_screen_zone.min_scale = 0.5
HUDSettings.world_icons.ladder_objective_2[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.ladder_objective_2[1680][1050].attention_screen_zone.min_scale_distance = 20
HUDSettings.world_icons.ladder_objective_2[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player)
	return
end
HUDSettings.world_icons.objective_background = HUDSettings.world_icons.objective_background or {}
HUDSettings.world_icons.objective_background[1680] = HUDSettings.world_icons.objective_background[1680] or {}
HUDSettings.world_icons.objective_background[1680][1050] = HUDSettings.world_icons.objective_background[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.objective_background[1680][1050].attention_screen_zone.texture_func = function(blackboard, player)
	local owner_team_side = blackboard.owner_team_side

	return player.team and blackboard.active_team_sides[player.team.side] and (owner_team_side == "neutral" and hud_assets.objective_icon_colour_grey or player.team.side == owner_team_side and hud_assets.objective_icon_colour_blue or hud_assets.objective_icon_colour_red) or nil
end
HUDSettings.world_icons.objective_background[1680][1050].default_screen_zone.texture_func = HUDSettings.world_icons.objective_background[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_background[1680][1050].clamped_screen_zone.texture_func = HUDSettings.world_icons.objective_background[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_background[1680][1050].spawn_map.texture_func = HUDSettings.world_icons.objective_background[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_diamond = table.clone(HUDSettings.world_icons.objective_background)
HUDSettings.world_icons.objective_square = table.clone(HUDSettings.world_icons.objective_background)
HUDSettings.world_icons.objective_triangle = table.clone(HUDSettings.world_icons.objective_background)
HUDSettings.world_icons.objective_team_icon = HUDSettings.world_icons.objective_team_icon or {}
HUDSettings.world_icons.objective_team_icon[1680] = HUDSettings.world_icons.objective_team_icon[1680] or {}
HUDSettings.world_icons.objective_team_icon[1680][1050] = HUDSettings.world_icons.objective_team_icon[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.objective_text = nil
HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.texture_func = function(blackboard, player)
	local team_name = blackboard.owner_team_side == "neutral" and "neutral" or Managers.state.team:name(blackboard.owner_team_side)

	return player.team and blackboard.active_team_sides[player.team.side] and HUDSettings.objective_icons.team_icon[team_name] or nil
end
HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.z = 1
HUDSettings.world_icons.objective_team_icon[1680][1050].default_screen_zone.texture_func = HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_team_icon[1680][1050].default_screen_zone.z = 1
HUDSettings.world_icons.objective_team_icon[1680][1050].clamped_screen_zone.texture_func = HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_team_icon[1680][1050].clamped_screen_zone.z = 1
HUDSettings.world_icons.objective_team_icon[1680][1050].spawn_map.texture_func = HUDSettings.world_icons.objective_team_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_team_icon[1680][1050].spawn_map.z = 1
HUDSettings.world_icons.objective_a = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_b = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_c = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_d = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_e = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_f = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_g = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_h = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_x = table.clone(HUDSettings.world_icons.objective_team_icon)
HUDSettings.world_icons.objective_lock_icon = HUDSettings.world_icons.objective_lock_icon or {}
HUDSettings.world_icons.objective_lock_icon[1680] = HUDSettings.world_icons.objective_lock_icon[1680] or {}
HUDSettings.world_icons.objective_lock_icon[1680][1050] = HUDSettings.world_icons.objective_lock_icon[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.objective_text = {
	text_type = "number",
	font_size = 16,
	text_func = function(blackboard, player, unit, world)
		if player.team and blackboard.active_team_sides[player.team.side] and blackboard.locked then
			local t = blackboard.locked_end_time - Managers.time:time("round")

			if t > 0 then
				return t
			end
		end
	end,
	font = MenuSettings.fonts.viking_numbers_16,
	drop_shadow = SMALL_DROP_SHADOW,
	drop_shadow_color = {
		255,
		0,
		0,
		0
	},
	text_offset = {
		z = 0.9,
		x = 0,
		y = -38
	}
}
HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.texture_func = function(blackboard, player)
	return player.team and blackboard.active_team_sides[player.team.side] and blackboard.locked and hud_assets.objective_icon_locked or nil
end
HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.z = 2
HUDSettings.world_icons.objective_lock_icon[1680][1050].default_screen_zone.texture_func = HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_lock_icon[1680][1050].default_screen_zone.z = 2
HUDSettings.world_icons.objective_lock_icon[1680][1050].clamped_screen_zone.texture_func = HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_lock_icon[1680][1050].clamped_screen_zone.z = 2
HUDSettings.world_icons.objective_lock_icon[1680][1050].spawn_map.texture_func = HUDSettings.world_icons.objective_lock_icon[1680][1050].attention_screen_zone.texture_func
HUDSettings.world_icons.objective_lock_icon[1680][1050].spawn_map.z = 2
HUDSettings.world_icons.objective_tag = HUDSettings.world_icons.objective_tag or {}
HUDSettings.world_icons.objective_tag[1680] = HUDSettings.world_icons.objective_tag[1680] or {}
HUDSettings.world_icons.objective_tag[1680][1050] = HUDSettings.world_icons.objective_tag[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.objective_tag[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, unit, world)
	local squad = player.team and player.team.squads[player.squad_index]
	local texture, objective_system, tagged_unit
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if squad and game then
		local members = squad:members()

		for squad_player, _ in pairs(members) do
			if squad_player.is_corporal then
				local tagged_objective_unit_level_index = GameSession.game_object_field(game, squad_player.game_object_id, "tagged_objective_level_id")
				local level = LevelHelper:current_level(world)

				tagged_unit = Level.unit_by_index(level, tagged_objective_unit_level_index)
			end

			objective_system = tagged_unit and ScriptUnit.has_extension(tagged_unit, "objective_system") and ScriptUnit.extension(tagged_unit, "objective_system")
		end
	end

	local texture = objective_system and tagged_unit == unit and (player.team and objective_system:owned(player.team.side) and HUDAtlas.hud_buff_icon_armour_small or player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_buff_icon_damage_small) or nil

	return texture
end
HUDSettings.world_icons.objective_tag[1680][1050].default_screen_zone.texture_func = function(blackboard, player, unit, world)
	local squad = player.team and player.team.squads[player.squad_index]
	local texture, objective_system, tagged_unit
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if squad and game then
		local members = squad:members()

		for squad_player, _ in pairs(members) do
			if squad_player.is_corporal then
				local tagged_objective_unit_level_index = GameSession.game_object_field(game, squad_player.game_object_id, "tagged_objective_level_id")
				local level = LevelHelper:current_level(world)

				tagged_unit = Level.unit_by_index(level, tagged_objective_unit_level_index)
			end

			objective_system = tagged_unit and ScriptUnit.has_extension(tagged_unit, "objective_system") and ScriptUnit.extension(tagged_unit, "objective_system")
		end
	end

	local texture = objective_system and tagged_unit == unit and (player.team and objective_system:owned(player.team.side) and HUDAtlas.hud_buff_icon_armour_small or player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_buff_icon_damage_small) or nil

	return texture
end
HUDSettings.world_icons.objective_tag[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player, unit, world)
	local squad = player.team and player.team.squads[player.squad_index]
	local texture, objective_system, tagged_unit
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if squad and game then
		local members = squad:members()

		for squad_player, _ in pairs(members) do
			if squad_player.is_corporal then
				local tagged_objective_unit_level_index = GameSession.game_object_field(game, squad_player.game_object_id, "tagged_objective_level_id")
				local level = LevelHelper:current_level(world)

				tagged_unit = Level.unit_by_index(level, tagged_objective_unit_level_index)
			end

			objective_system = tagged_unit and ScriptUnit.has_extension(tagged_unit, "objective_system") and ScriptUnit.extension(tagged_unit, "objective_system")
		end
	end

	local texture = objective_system and tagged_unit == unit and (player.team and objective_system:owned(player.team.side) and HUDAtlas.hud_buff_icon_armour_small or player.team and blackboard.active_team_sides[player.team.side] and HUDAtlas.hud_buff_icon_damage_small) or nil

	return texture
end
HUDSettings.world_icons.player_tag = HUDSettings.world_icons.player_tag or {}
HUDSettings.world_icons.player_tag[1680] = HUDSettings.world_icons.player_tag[1680] or {}
HUDSettings.world_icons.player_tag[1680][1050] = HUDSettings.world_icons.player_tag[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.player_tag[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return nil
end
HUDSettings.world_icons.player_tag[1680][1050].attention_screen_zone.max_scale = 0.6
HUDSettings.world_icons.player_tag[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.player_tag[1680][1050].attention_screen_zone.min_scale = 0.2
HUDSettings.world_icons.player_tag[1680][1050].attention_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.player_tag[1680][1050].default_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return nil
end
HUDSettings.world_icons.player_tag[1680][1050].default_screen_zone.max_scale = 0.6
HUDSettings.world_icons.player_tag[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.player_tag[1680][1050].default_screen_zone.min_scale = 0.2
HUDSettings.world_icons.player_tag[1680][1050].default_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.player_tag[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return nil
end
HUDSettings.world_icons.player_tag[1680][1050].clamped_screen_zone.max_scale = 0.6
HUDSettings.world_icons.player_tag[1680][1050].clamped_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.player_tag[1680][1050].clamped_screen_zone.min_scale = 0.2
HUDSettings.world_icons.player_tag[1680][1050].clamped_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.help_request_tag = HUDSettings.world_icons.help_request_tag or {}
HUDSettings.world_icons.help_request_tag[1680] = HUDSettings.world_icons.help_request_tag[1680] or {}
HUDSettings.world_icons.help_request_tag[1680][1050] = HUDSettings.world_icons.help_request_tag[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.help_request_tag[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.hud_buff_icon_health_small
end
HUDSettings.world_icons.help_request_tag[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.help_request_tag[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.help_request_tag[1680][1050].attention_screen_zone.min_scale = 0.5
HUDSettings.world_icons.help_request_tag[1680][1050].attention_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.help_request_tag[1680][1050].default_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.hud_buff_icon_health_small
end
HUDSettings.world_icons.help_request_tag[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.help_request_tag[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.help_request_tag[1680][1050].default_screen_zone.min_scale = 0.5
HUDSettings.world_icons.help_request_tag[1680][1050].default_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.help_request_tag[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.hud_buff_icon_health_small
end
HUDSettings.world_icons.help_request_tag[1680][1050].clamped_screen_zone.max_scale = 1
HUDSettings.world_icons.help_request_tag[1680][1050].clamped_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.help_request_tag[1680][1050].clamped_screen_zone.min_scale = 0.5
HUDSettings.world_icons.help_request_tag[1680][1050].clamped_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.auto_aim = HUDSettings.world_icons.auto_aim or {}
HUDSettings.world_icons.auto_aim[1680] = HUDSettings.world_icons.auto_aim[1680] or {}
HUDSettings.world_icons.auto_aim[1680][1050] = HUDSettings.world_icons.auto_aim[1680][1050] or table.clone(HUDSettings.world_icons.objective_circle[1680][1050])
HUDSettings.world_icons.auto_aim[1680][1050].attention_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.perk_crosshair_easy_mode
end
HUDSettings.world_icons.auto_aim[1680][1050].attention_screen_zone.max_scale = 1
HUDSettings.world_icons.auto_aim[1680][1050].attention_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.auto_aim[1680][1050].attention_screen_zone.min_scale = 0.5
HUDSettings.world_icons.auto_aim[1680][1050].attention_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.auto_aim[1680][1050].default_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.perk_crosshair_easy_mode
end
HUDSettings.world_icons.auto_aim[1680][1050].default_screen_zone.max_scale = 1
HUDSettings.world_icons.auto_aim[1680][1050].default_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.auto_aim[1680][1050].default_screen_zone.min_scale = 0.5
HUDSettings.world_icons.auto_aim[1680][1050].default_screen_zone.min_scale_distance = 200
HUDSettings.world_icons.auto_aim[1680][1050].clamped_screen_zone.texture_func = function(blackboard, player, unit, world, player_unit)
	return HUDAtlas.perk_crosshair_easy_mode
end
HUDSettings.world_icons.auto_aim[1680][1050].clamped_screen_zone.max_scale = 1
HUDSettings.world_icons.auto_aim[1680][1050].clamped_screen_zone.max_scale_distance = 10
HUDSettings.world_icons.auto_aim[1680][1050].clamped_screen_zone.min_scale = 0.5
HUDSettings.world_icons.auto_aim[1680][1050].clamped_screen_zone.min_scale_distance = 200
HUDSettings.chat = HUDSettings.chat or {}
HUDSettings.chat.container = HUDSettings.chat.container or {}
HUDSettings.chat.container[1680] = HUDSettings.chat.container[1680] or {}
HUDSettings.chat.container[1680][1050] = HUDSettings.chat.container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	pivot_align_y = "bottom",
	screen_align_x = "left",
	pivot_offset_y = 0
}
HUDSettings.chat.input_text_loading = HUDSettings.chat.input_text_loading or {}
HUDSettings.chat.input_text_loading[1680] = HUDSettings.chat.input_text_loading[1680] or {}
HUDSettings.chat.input_text_loading[1680][1050] = HUDSettings.chat.input_text_loading[1680][1050] or {
	screen_offset_y = 0,
	height = 26,
	pivot_offset_y = 130,
	pivot_align_y = "bottom",
	text_offset_y = 8,
	screen_offset_x = 0,
	avoid_growth = true,
	marker_height = 18,
	marker_width = 2,
	border_size = 1,
	text_offset_x = 5,
	screen_align_y = "bottom",
	font_size = 16,
	screen_align_x = "left",
	pivot_offset_x = 26,
	pivot_align_x = "left",
	width = 378,
	font = MenuSettings.fonts.arial_16_masked,
	text_color = {
		255,
		255,
		255,
		255
	},
	background_color = {
		100,
		0,
		0,
		0
	},
	border_color = {
		150,
		0,
		0,
		0
	},
	marker_color = {
		255,
		255,
		255
	}
}
HUDSettings.chat.input_text = HUDSettings.chat.input_text or {}
HUDSettings.chat.input_text[1680] = HUDSettings.chat.input_text[1680] or {}
HUDSettings.chat.input_text[1680][1050] = HUDSettings.chat.input_text[1680][1050] or {
	screen_offset_y = 0,
	height = 26,
	pivot_offset_y = 0,
	pivot_align_y = "bottom",
	text_offset_y = 8,
	screen_offset_x = 0,
	avoid_growth = true,
	marker_height = 18,
	marker_width = 2,
	text_offset_x = 5,
	screen_align_y = "bottom",
	font_size = 16,
	screen_align_x = "left",
	pivot_offset_x = 0,
	pivot_align_x = "left",
	width = 390,
	font = MenuSettings.fonts.arial_16_masked,
	text_color = {
		255,
		255,
		255,
		255
	},
	background_color = {
		100,
		0,
		0,
		0
	},
	marker_color = {
		255,
		255,
		255
	}
}
HUDSettings.chat.new_output_window = {}
HUDSettings.chat.new_output_window[1680] = {}
HUDSettings.chat.new_output_window[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0.03,
	pivot_align_y = "bottom",
	pivot_offset_y = 130,
	screen_align_x = "left",
	z = 500,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	outer_window = {
		offset_x = 0,
		height = 295,
		offset_y = -10,
		z = 10,
		border_thickness = 1,
		width = 420,
		color = {
			128,
			0,
			0,
			0
		},
		border_color = {
			255,
			0,
			0,
			0
		}
	},
	inner_window = {
		offset_x = 0,
		height = 235,
		offset_y = 40,
		z = 100,
		border_thickness = 1,
		width = 400,
		color = {
			128,
			0,
			0,
			0
		},
		border_color = {
			255,
			0,
			0,
			0
		}
	},
	text_settings = {
		max_posts = 50,
		fade_time = 1,
		spacing = 18,
		life_time = 7,
		font_size = 20,
		scroll_speed = 800,
		offset_x = 5,
		z = 500,
		post_time = 10,
		text_scroll_time = 0.25,
		shadow_offset = 1,
		offset_y = 5,
		text_method = "top",
		font = MenuSettings.fonts.arial_20_masked,
		text_color = {
			255,
			196,
			196,
			196
		},
		shadow_color = {
			128,
			0,
			0,
			0
		}
	},
	text_scroller = {
		scroller_size = 40,
		z = 15,
		offset_y = 2,
		min_size = 30,
		offset_x = -3,
		border_thickness = 1,
		scroll_speed = 800,
		width = 10,
		color = {
			255,
			0,
			0,
			0
		},
		border_color = {
			255,
			192,
			192,
			192
		}
	}
}
HUDSettings.chat.new_output_window_loadingscreen = HUDSettings.chat.new_output_window_loadingscreen or {}
HUDSettings.chat.new_output_window_loadingscreen[1680] = HUDSettings.chat.new_output_window_loadingscreen[1680] or {}
HUDSettings.chat.new_output_window_loadingscreen[1680][1050] = table.clone(HUDSettings.chat.new_output_window[1680][1050])
HUDSettings.chat.new_output_window_loadingscreen[1680][1050].pivot_offset_x = 0
HUDSettings.chat.new_output_window_loadingscreen[1680][1050].pivot_offset_y = 43
HUDSettings.chat.new_output_window_loadingscreen = HUDSettings.chat.new_output_window_loadingscreen or {}
HUDSettings.chat.new_output_window_loadingscreen[1366] = HUDSettings.chat.new_output_window_loadingscreen[1366] or {}
HUDSettings.chat.new_output_window_loadingscreen[1366][768] = table.clone(HUDSettings.chat.new_output_window_loadingscreen[1680][1050])
HUDSettings.chat.new_output_window_loadingscreen[1366][768].screen_offset_x = 0.03
HUDSettings.chat.new_output_window_loadingscreen[1366][768].screen_offset_y = 0.072
HUDSettings.chat.new_output_window_loadingscreen[1366][768].pivot_offset_x = 0
HUDSettings.chat.new_output_window_loadingscreen[1366][768].pivot_offset_y = 0
HUDSettings.chat.new_output_window_loadingscreen[1366][768].outer_window.width = 420
HUDSettings.chat.new_output_window_loadingscreen[1366][768].outer_window.height = 240
HUDSettings.chat.new_output_window_loadingscreen[1366][768].inner_window.width = 400
HUDSettings.chat.new_output_window_loadingscreen[1366][768].inner_window.height = 180
HUDSettings.spawn = HUDSettings.spawn or {}
HUDSettings.spawn.select_spawn_point_text = HUDSettings.spawn.select_spawn_point_text or {}
HUDSettings.spawn.select_spawn_point_text[1680] = HUDSettings.spawn.select_spawn_point_text[1680] or {}
HUDSettings.spawn.select_spawn_point_text[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "top",
	font_size = 36,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0.25,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	},
	shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	shadow_offset = DEFAULT_DROP_SHADOW_OFFSET
}
HUDSettings.spawn.switch_spawn_point_text = HUDSettings.spawn.switch_spawn_point_text or {}
HUDSettings.spawn.switch_spawn_point_text[1680] = HUDSettings.spawn.switch_spawn_point_text[1680] or {}
HUDSettings.spawn.switch_spawn_point_text[1680][1050] = HUDSettings.spawn.select_spawn_point_text[1680][1050]
HUDSettings.spawn.ask_for_aid_text = HUDSettings.spawn.ask_for_aid_text or {}
HUDSettings.spawn.ask_for_aid_text[1680] = HUDSettings.spawn.ask_for_aid_text[1680] or {}
HUDSettings.spawn.ask_for_aid_text[1680][1050] = HUDSettings.spawn.ask_for_aid_text[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "top",
	font_size = 36,
	pivot_offset_y = -40,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0.25,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	},
	shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	shadow_offset = DEFAULT_DROP_SHADOW_OFFSET
}
HUDSettings.spawn.container = HUDSettings.spawn.container or {}
HUDSettings.spawn.container[1680] = HUDSettings.spawn.container[1680] or {}
HUDSettings.spawn.container[1680][1050] = HUDSettings.spawn.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	z = 10,
	pivot_offset_y = -90,
	height = 36,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 652
}
HUDSettings.spawn.container[1366] = HUDSettings.spawn.container[1366] or {}
HUDSettings.spawn.container[1366][768] = HUDSettings.spawn.container[1366][768] or table.clone(HUDSettings.spawn.container[1680][1050])
HUDSettings.spawn.container[1366][768].pivot_offset_y = -54
HUDSettings.spawn.container_domination = table.clone(HUDSettings.spawn.container)
HUDSettings.spawn.container_domination[1680][1050].pivot_offset_y = -57
HUDSettings.spawn.timer_text = HUDSettings.spawn.timer_text or {}
HUDSettings.spawn.timer_text[1680] = HUDSettings.spawn.timer_text[1680] or {}
HUDSettings.spawn.timer_text[1680][1050] = HUDSettings.spawn.timer_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 32,
	pivot_offset_y = 4,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_32,
	text_color = {
		255,
		255,
		255,
		255
	},
	shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	shadow_offset = DEFAULT_DROP_SHADOW_OFFSET
}
HUDSettings.spawn.timer_text[1366] = HUDSettings.spawn.timer_text[1366] or {}
HUDSettings.spawn.timer_text[1366][768] = HUDSettings.spawn.timer_text[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 22,
	pivot_offset_y = 4,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_22,
	text_color = {
		255,
		255,
		255,
		255
	},
	shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	shadow_offset = DEFAULT_DROP_SHADOW_OFFSET
}
HUDSettings.spawn.timer_texture = HUDSettings.spawn.timer_texture or {}
HUDSettings.spawn.timer_texture[1680] = HUDSettings.spawn.timer_texture[1680] or {}
HUDSettings.spawn.timer_texture[1680][1050] = HUDSettings.spawn.timer_texture[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_spawn_timer_background",
	pivot_offset_y = 0,
	texture_width = 652,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_height = 36
}
HUDSettings.spawn.timer_texture[1366] = HUDSettings.spawn.timer_texture[1366] or {}
HUDSettings.spawn.timer_texture[1366][768] = HUDSettings.spawn.timer_texture[1366][768] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	texture = "hud_spawn_timer_background",
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	scale = 1,
	texture_width = 652 * SCALE_1366,
	texture_height = 36 * SCALE_1366
}
HUDSettings.deserting = HUDSettings.deserting or {}
HUDSettings.deserting.container = HUDSettings.deserting.container or {}
HUDSettings.deserting.container[1680] = HUDSettings.deserting.container[1680] or {}
HUDSettings.deserting.container[1680][1050] = HUDSettings.deserting.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 100,
	pivot_offset_y = 0,
	height = 2000,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 2000,
	background_color = {
		100,
		210,
		0,
		0
	}
}
HUDSettings.deserting.text_line_1 = HUDSettings.deserting.text_line_1 or {}
HUDSettings.deserting.text_line_1[1680] = HUDSettings.deserting.text_line_1[1680] or {}
HUDSettings.deserting.text_line_1[1680][1050] = HUDSettings.deserting.text_line_1[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 60,
	pivot_offset_y = 100,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.deserting.text_line_2 = HUDSettings.deserting.text_line_2 or {}
HUDSettings.deserting.text_line_2[1680] = HUDSettings.deserting.text_line_2[1680] or {}
HUDSettings.deserting.text_line_2[1680][1050] = HUDSettings.deserting.text_line_2[1680][1050] or table.clone(HUDSettings.deserting.text_line_1[1680][1050])
HUDSettings.deserting.text_line_2[1680][1050].pivot_offset_y = -100
HUDSettings.deserting.timer = HUDSettings.deserting.timer or {}
HUDSettings.deserting.timer[1680] = HUDSettings.deserting.timer[1680] or {}
HUDSettings.deserting.timer[1680][1050] = HUDSettings.deserting.timer[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 60,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.game_mode_status = HUDSettings.game_mode_status or {}
HUDSettings.game_mode_status.container = HUDSettings.game_mode_status.container or {}
HUDSettings.game_mode_status.container[1680] = HUDSettings.game_mode_status.container[1680] or {}
HUDSettings.game_mode_status.container[1680][1050] = HUDSettings.game_mode_status.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	z = 1,
	pivot_offset_y = 0,
	height = 90,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 870
}
HUDSettings.game_mode_status.tdm_score_background = HUDSettings.game_mode_status.tdm_score_background or {}
HUDSettings.game_mode_status.tdm_score_background[1680] = HUDSettings.game_mode_status.tdm_score_background[1680] or {}
HUDSettings.game_mode_status.tdm_score_background[1680][1050] = HUDSettings.game_mode_status.tdm_score_background[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	pivot_align_y = "center",
	pivot_offset_y = 16,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	texture_atlas_settings = hud_assets.timer_bg
}
HUDSettings.game_mode_status.tdm_score_background_left = HUDSettings.game_mode_status.tdm_score_background_left or {}
HUDSettings.game_mode_status.tdm_score_background_left[1680] = HUDSettings.game_mode_status.tdm_score_background_left[1680] or {}
HUDSettings.game_mode_status.tdm_score_background_left[1680][1050] = table.clone(HUDSettings.game_mode_status.tdm_score_background[1680][1050])
HUDSettings.game_mode_status.tdm_score_background_left[1680][1050].pivot_offset_x = -50
HUDSettings.game_mode_status.tdm_score_background_left[1680][1050].color_func = function(layout_settings, config)
	local player_team_name = config.player.team.name
	local text_color = player_team_name and player_team_name == "red" and HUDSettings.player_colors.team_member or HUDSettings.player_colors.enemy_highlighted

	return Color(text_color[1], text_color[2], text_color[3], text_color[4])
end
HUDSettings.game_mode_status.tdm_score_background_right = HUDSettings.game_mode_status.tdm_score_background_right or {}
HUDSettings.game_mode_status.tdm_score_background_right[1680] = HUDSettings.game_mode_status.tdm_score_background_right[1680] or {}
HUDSettings.game_mode_status.tdm_score_background_right[1680][1050] = table.clone(HUDSettings.game_mode_status.tdm_score_background[1680][1050])
HUDSettings.game_mode_status.tdm_score_background_right[1680][1050].pivot_offset_x = 50
HUDSettings.game_mode_status.tdm_score_background_right[1680][1050].color_func = function(layout_settings, config)
	local player_team_name = config.player.team.name
	local text_color = player_team_name and player_team_name == "red" and HUDSettings.player_colors.enemy_highlighted or HUDSettings.player_colors.team_member

	return Color(text_color[1], text_color[2], text_color[3], text_color[4])
end
HUDSettings.game_mode_status.tdm_score_counter = HUDSettings.game_mode_status.tdm_score_counter or {}
HUDSettings.game_mode_status.tdm_score_counter[1680] = HUDSettings.game_mode_status.tdm_score_counter[1680] or {}
HUDSettings.game_mode_status.tdm_score_counter[1680][1050] = HUDSettings.game_mode_status.tdm_score_counter[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 16,
	pivot_offset_y = 16,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.game_mode_status.tdm_score_counter_left = HUDSettings.game_mode_status.tdm_score_counter_left or {}
HUDSettings.game_mode_status.tdm_score_counter_left[1680] = HUDSettings.game_mode_status.tdm_score_counter_left[1680] or {}
HUDSettings.game_mode_status.tdm_score_counter_left[1680][1050] = table.clone(HUDSettings.game_mode_status.tdm_score_counter[1680][1050])
HUDSettings.game_mode_status.tdm_score_counter_left[1680][1050].pivot_offset_x = -50
HUDSettings.game_mode_status.tdm_score_counter_left[1680][1050].font = MenuSettings.fonts.hell_shark_14
HUDSettings.game_mode_status.tdm_score_counter_left[1680][1050].font_size = 14
HUDSettings.game_mode_status.tdm_score_counter_right = HUDSettings.game_mode_status.tdm_score_counter_right or {}
HUDSettings.game_mode_status.tdm_score_counter_right[1680] = HUDSettings.game_mode_status.tdm_score_counter_right[1680] or {}
HUDSettings.game_mode_status.tdm_score_counter_right[1680][1050] = table.clone(HUDSettings.game_mode_status.tdm_score_counter[1680][1050])
HUDSettings.game_mode_status.tdm_score_counter_right[1680][1050].pivot_offset_x = 50
HUDSettings.game_mode_status.tdm_score_counter_right[1680][1050].font = MenuSettings.fonts.hell_shark_14
HUDSettings.game_mode_status.tdm_score_counter_right[1680][1050].font_size = 14
HUDSettings.game_mode_status.tdm_score_container = HUDSettings.game_mode_status.tdm_score_container or {}
HUDSettings.game_mode_status.tdm_score_container[1680] = HUDSettings.game_mode_status.tdm_score_container[1680] or {}
HUDSettings.game_mode_status.tdm_score_container[1680][1050] = HUDSettings.game_mode_status.tdm_score_container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	spacing = 48,
	z = 1,
	pivot_offset_y = 0,
	height = 44,
	screen_align_x = "center",
	pivot_align_y = "bottom",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 412
}
HUDSettings.game_mode_status.round_timer_background = HUDSettings.game_mode_status.round_timer_background or {}
HUDSettings.game_mode_status.round_timer_background[1680] = HUDSettings.game_mode_status.round_timer_background[1680] or {}
HUDSettings.game_mode_status.round_timer_background[1680][1050] = HUDSettings.game_mode_status.round_timer_background[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	texture_atlas = "hud_assets",
	pivot_align_y = "center",
	pivot_offset_y = 10,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	texture_atlas_settings = hud_assets.timer_bg
}
HUDSettings.game_mode_status.round_timer = HUDSettings.game_mode_status.round_timer or {}
HUDSettings.game_mode_status.round_timer[1680] = HUDSettings.game_mode_status.round_timer[1680] or {}
HUDSettings.game_mode_status.round_timer[1680][1050] = HUDSettings.game_mode_status.round_timer[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	font_size = 16,
	pivot_offset_y = 10,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		0
	}
}
HUDSettings.game_mode_status.objective_point_icon_container = HUDSettings.game_mode_status.objective_point_icon_container or {}
HUDSettings.game_mode_status.objective_point_icon_container[1680] = HUDSettings.game_mode_status.objective_point_icon_container[1680] or {}
HUDSettings.game_mode_status.objective_point_icon_container[1680][1050] = HUDSettings.game_mode_status.objective_point_icon_container[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	spacing = 48,
	z = 1,
	pivot_offset_y = 0,
	height = 44,
	screen_align_x = "center",
	pivot_align_y = "bottom",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 412
}
HUDSettings.game_mode_status.objective_point_icon = HUDSettings.game_mode_status.objective_point_icon or {}
HUDSettings.game_mode_status.objective_point_icon[1680] = HUDSettings.game_mode_status.objective_point_icon[1680] or {}
HUDSettings.game_mode_status.objective_point_icon[1680][1050] = HUDSettings.game_mode_status.objective_point_icon[1680][1050] or {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "bottom",
	pivot_offset_y = 0,
	glow_fade_out_duration = 0.2,
	screen_align_x = "left",
	fade_in_duration = 0.7,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	fade_out_duration = 0.7,
	glow_fade_in_duration = 0.2,
	atlas = "hud_assets",
	objective_text = {
		text_type = "number",
		font_size = 15,
		text_func = function(blackboard, player)
			if player.team and blackboard.active_team_sides[player.team.side] and blackboard.locked then
				local t = blackboard.locked_end_time - Managers.time:time("round")

				if t > 0 then
					return t
				end
			end
		end,
		font = MenuSettings.fonts.viking_numbers_16,
		drop_shadow = SMALL_DROP_SHADOW,
		drop_shadow_color = {
			200,
			0,
			0,
			0
		},
		text_offset = {
			z = 0.9,
			x = 22,
			y = 22
		}
	},
	texture_func = function(icon_colour, team_name, blackboard, player)
		icon_colour = icon_colour == "grey" and "objective_icon_colour_grey" or icon_colour == "blue" and "objective_icon_colour_blue" or "objective_icon_colour_red"
		team_name = blackboard and blackboard.active_team_sides[player.team.side] and blackboard.locked and "objective_icon_locked" or team_name == "neutral" and "objective_icon_center_neutral" or team_name == "swords" and "objective_icon_center_swords" or team_name == "red" and "objective_icon_center_viking" or "objective_icon_center_saxon"

		return icon_colour, team_name
	end,
	offset_x_func = function(element, layout_settings)
		return element.sign * (element.config.slot_number - 1) * element:width() + (element.sign < 0 and -element:width() or 0)
	end
}
HUDSettings.game_mode_status.progress_bar = {}
HUDSettings.game_mode_status.progress_bar[1680] = HUDSettings.game_mode_status.progress_bar[1680] or {}
HUDSettings.game_mode_status.progress_bar[1680][1050] = HUDSettings.game_mode_status.progress_bar[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = -8,
	atlas = "hud_assets",
	screen_align_x = "left",
	bar_height = 8,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "left",
	bar_width = 44,
	get_textures = function(progress_colour)
		progress_colour = progress_colour == "blue" and "objective_icon_bar_fg_blue" or "objective_icon_bar_fg_red"

		return "objective_icon_bar_bg", progress_colour
	end
}
HUDSettings.game_mode_status.round_timer_menu = HUDSettings.game_mode_status.round_timer_menu or {}
HUDSettings.game_mode_status.round_timer_menu[1680] = HUDSettings.game_mode_status.round_timer_menu[1680] or {}
HUDSettings.game_mode_status.round_timer_menu[1680][1050] = HUDSettings.game_mode_status.round_timer_menu[1680][1050] or table.clone(HUDSettings.game_mode_status.round_timer[1680][1050])
HUDSettings.combat_log = HUDSettings.combat_log or {}
HUDSettings.combat_log.container = HUDSettings.combat_log.container or {}
HUDSettings.combat_log.container[1680] = HUDSettings.combat_log.container[1680] or {}
HUDSettings.combat_log.container[1680][1050] = HUDSettings.combat_log.container[1680][1050] or {}
HUDSettings.combat_log.container[1680][1050].screen_align_x = "right"
HUDSettings.combat_log.container[1680][1050].screen_align_y = "top"
HUDSettings.combat_log.container[1680][1050].screen_offset_x = 0
HUDSettings.combat_log.container[1680][1050].screen_offset_y = 0
HUDSettings.combat_log.container[1680][1050].pivot_align_x = "right"
HUDSettings.combat_log.container[1680][1050].pivot_align_y = "top"
HUDSettings.combat_log.container[1680][1050].pivot_offset_x = 0
HUDSettings.combat_log.container[1680][1050].pivot_offset_y = -15
HUDSettings.combat_log.container[1680][1050].z = 1
HUDSettings.combat_log.container[1680][1050].width = 300
HUDSettings.combat_log.container[1680][1050].height = 210
HUDSettings.combat_log.log_entry = HUDSettings.combat_log.log_entry or {}
HUDSettings.combat_log.log_entry[1680] = HUDSettings.combat_log.log_entry[1680] or {}
HUDSettings.combat_log.log_entry[1680][1050] = HUDSettings.combat_log.log_entry[1680][1050] or {
	alpha_multiplier = 1,
	height = 20,
	texture_atlas = "hud_assets",
	font_size = 16,
	pivot_align_y = "top",
	screen_offset_x = 0,
	text_max_width = 105,
	padding = 30,
	screen_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "right",
	pivot_offset_x = -10,
	screen_offset_y = 0,
	pivot_align_x = "right",
	width = 275,
	font = MenuSettings.fonts.player_name_font,
	self_color = {
		255,
		255,
		255,
		255
	},
	texture_atlas_settings = hud_assets
}
HUDSettings.domination_minimap = HUDSettings.domination_minimap or {}
HUDSettings.domination_minimap.container = HUDSettings.domination_minimap.container or {}
HUDSettings.domination_minimap.container[1680] = HUDSettings.domination_minimap.container[1680] or {}
HUDSettings.domination_minimap.container[1680][1050] = HUDSettings.domination_minimap.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	height = 0,
	pivot_offset_y = -125,
	pivot_scale = 1.2,
	screen_align_x = "center",
	pivot_offset_x = -1,
	screen_offset_y = 0,
	pivot_align_x = "center",
	width = 0
}
HUDSettings.domination_minimap.objective_icon_neutral = HUDSettings.domination_minimap.objective_icon_neutral or {}
HUDSettings.domination_minimap.objective_icon_neutral[1680] = HUDSettings.domination_minimap.objective_icon_neutral[1680] or {}
HUDSettings.domination_minimap.objective_icon_neutral[1680][1050] = HUDSettings.domination_minimap.objective_icon_neutral[1680][1050] or {
	texture = "dom_minimap_capture_point_neutral",
	atlas = "hud_assets",
	texture_height = 20,
	texture_width = 20
}
HUDSettings.domination_minimap.objective_icon_friendly = HUDSettings.domination_minimap.objective_icon_friendly or {}
HUDSettings.domination_minimap.objective_icon_friendly[1680] = HUDSettings.domination_minimap.objective_icon_friendly[1680] or {}
HUDSettings.domination_minimap.objective_icon_friendly[1680][1050] = HUDSettings.domination_minimap.objective_icon_friendly[1680][1050] or {
	texture = "dom_minimap_capture_point_friendly",
	atlas = "hud_assets",
	texture_height = 20,
	texture_width = 20
}
HUDSettings.domination_minimap.objective_icon_enemy = HUDSettings.domination_minimap.objective_icon_enemy or {}
HUDSettings.domination_minimap.objective_icon_enemy[1680] = HUDSettings.domination_minimap.objective_icon_enemy[1680] or {}
HUDSettings.domination_minimap.objective_icon_enemy[1680][1050] = HUDSettings.domination_minimap.objective_icon_enemy[1680][1050] or {
	texture = "dom_minimap_capture_point_enemy",
	atlas = "hud_assets",
	texture_height = 20,
	texture_width = 20
}
HUDSettings.domination_minimap.objective_icon_contested = HUDSettings.domination_minimap.objective_icon_contested or {}
HUDSettings.domination_minimap.objective_icon_contested[1680] = HUDSettings.domination_minimap.objective_icon_contested[1680] or {}
HUDSettings.domination_minimap.objective_icon_contested[1680][1050] = HUDSettings.domination_minimap.objective_icon_contested[1680][1050] or {
	texture = "dom_minimap_capture_point_contested",
	atlas = "hud_assets",
	texture_height = 20,
	texture_width = 20
}
HUDSettings.domination_minimap.objective_icon_saxon = HUDSettings.domination_minimap.objective_icon_saxon or {}
HUDSettings.domination_minimap.objective_icon_saxon[1680] = HUDSettings.domination_minimap.objective_icon_saxon[1680] or {}
HUDSettings.domination_minimap.objective_icon_saxon[1680][1050] = HUDSettings.domination_minimap.objective_icon_saxon[1680][1050] or {
	texture = "dom_minimap_objective_icon_saxon",
	atlas = "hud_assets"
}
HUDSettings.domination_minimap.objective_icon_viking = HUDSettings.domination_minimap.objective_icon_viking or {}
HUDSettings.domination_minimap.objective_icon_viking[1680] = HUDSettings.domination_minimap.objective_icon_viking[1680] or {}
HUDSettings.domination_minimap.objective_icon_viking[1680][1050] = HUDSettings.domination_minimap.objective_icon_viking[1680][1050] or {
	texture = "dom_minimap_objective_icon_viking",
	atlas = "hud_assets"
}
HUDSettings.domination_minimap.spawn_point_icon_viking = HUDSettings.domination_minimap.spawn_point_icon_viking or {}
HUDSettings.domination_minimap.spawn_point_icon_viking[1680] = HUDSettings.domination_minimap.spawn_point_icon_viking[1680] or {}
HUDSettings.domination_minimap.spawn_point_icon_viking[1680][1050] = {
	texture = "dom_minimap_spawn_point_viking",
	atlas = "hud_assets",
	texture_width = 40,
	texture_height = 40,
	color = {
		125,
		255,
		255,
		255
	}
}
HUDSettings.domination_minimap.spawn_point_icon_saxon = HUDSettings.domination_minimap.spawn_point_icon_saxon or {}
HUDSettings.domination_minimap.spawn_point_icon_saxon[1680] = HUDSettings.domination_minimap.spawn_point_icon_saxon[1680] or {}
HUDSettings.domination_minimap.spawn_point_icon_saxon[1680][1050] = {
	texture = "dom_minimap_spawn_point_saxon",
	atlas = "hud_assets",
	texture_width = 40,
	texture_height = 40,
	color = {
		125,
		255,
		255,
		255
	}
}
HUDSettings.domination_minimap.player_icon_friendly = HUDSettings.domination_minimap.player_icon_friendly or {}
HUDSettings.domination_minimap.player_icon_friendly[1680] = HUDSettings.domination_minimap.player_icon_friendly[1680] or {}
HUDSettings.domination_minimap.player_icon_friendly[1680][1050] = HUDSettings.domination_minimap.player_icon_friendly[1680][1050] or {
	texture = "dom_minimap_player_friendly",
	atlas = "hud_assets",
	texture_height = 7,
	texture_width = 7
}
HUDSettings.domination_minimap.player_icon_squad = HUDSettings.domination_minimap.player_icon_squad or {}
HUDSettings.domination_minimap.player_icon_squad[1680] = HUDSettings.domination_minimap.player_icon_squad[1680] or {}
HUDSettings.domination_minimap.player_icon_squad[1680][1050] = HUDSettings.domination_minimap.player_icon_squad[1680][1050] or {
	texture = "dom_minimap_player_squad",
	atlas = "hud_assets",
	texture_height = 7,
	texture_width = 7
}
HUDSettings.domination_minimap.player_icon_player = HUDSettings.domination_minimap.player_icon_player or {}
HUDSettings.domination_minimap.player_icon_player[1680] = HUDSettings.domination_minimap.player_icon_player[1680] or {}
HUDSettings.domination_minimap.player_icon_player[1680][1050] = HUDSettings.domination_minimap.player_icon_player[1680][1050] or {
	texture = "dom_minimap_player_player",
	atlas = "hud_assets",
	texture_height = 12,
	texture_width = 12
}
HUDSettings.domination_minimap.score_bar_friendly = {}
HUDSettings.domination_minimap.score_bar_friendly[1680] = {}
HUDSettings.domination_minimap.score_bar_friendly[1680][1050] = {
	chunk_offset_y = 1,
	uv_progress_scale = true,
	lose_texture_glow_v = "stamina_dark_lit_glow_vertical",
	texture = "dom_bar_desaturated",
	texture_offset_x = 12,
	screen_offset_x = 0,
	pivot_align_y = "top",
	bar_width_override = 216,
	start_value = 0,
	texture_offset_y = 0.5,
	continuous_growth = true,
	screen_align_y = "top",
	pivot_offset_y = -42,
	grow_texture_glow_h = "stamina_lit_glow_horizontal",
	screen_align_x = "center",
	grow_texture_glow_v = "stamina_lit_glow_vertical",
	pivot_offset_x = -67,
	bar_height = 10,
	bar_height_override = 24,
	background_texture = "powerframe_bg",
	atlas = "hud_assets",
	combine_loss = true,
	lose_lerp_speed = 0.2,
	lose_texture = "stamina_dark_default",
	lose_texture_glow_h = "stamina_dark_lit_glow_horizontal",
	bar_texture_offset_x = 12,
	pixel_offset_y = 1,
	grow_texture = "stamina_default",
	chunk_height_override = 25,
	texture_glow_h = "stamina_lit_glow_horizontal",
	screen_offset_y = 0,
	pivot_align_x = "right",
	bar_width = 240,
	pixel_chunk_height_override = 24
}
HUDSettings.domination_minimap.score_bar_enemy = HUDSettings.domination_minimap.score_bar_enemy or {}
HUDSettings.domination_minimap.score_bar_enemy[1680] = HUDSettings.domination_minimap.score_bar_enemy[1680] or {}
HUDSettings.domination_minimap.score_bar_enemy[1680][1050] = HUDSettings.domination_minimap.score_bar_enemy[1680][1050] or table.clone(HUDSettings.domination_minimap.score_bar_friendly[1680][1050])
HUDSettings.domination_minimap.score_bar_enemy[1680][1050].pivot_offset_x = 67
HUDSettings.domination_minimap.score_bar_enemy[1680][1050].pivot_align_x = "left"
HUDSettings.domination_minimap.score_bar_enemy[1680][1050].texture = "dom_bar_desaturated_02"
HUDSettings.domination_minimap.score_ticker_bg_friendly = HUDSettings.domination_minimap.score_ticker_bg_friendly or {}
HUDSettings.domination_minimap.score_ticker_bg_friendly[1680] = HUDSettings.domination_minimap.score_ticker_bg_friendly[1680] or {}
HUDSettings.domination_minimap.score_ticker_bg_friendly[1680][1050] = HUDSettings.domination_minimap.score_ticker_bg_friendly[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	atlas = "hud_assets",
	pivot_offset_y = -26,
	texture = "timer_bg",
	screen_align_x = "center",
	pivot_offset_x = -30,
	screen_offset_y = 0,
	pivot_align_x = "right"
}
HUDSettings.domination_minimap.score_ticker_bg_enemy = HUDSettings.domination_minimap.score_ticker_bg_enemy or {}
HUDSettings.domination_minimap.score_ticker_bg_enemy[1680] = HUDSettings.domination_minimap.score_ticker_bg_enemy[1680] or {}
HUDSettings.domination_minimap.score_ticker_bg_enemy[1680][1050] = table.clone(HUDSettings.domination_minimap.score_ticker_bg_friendly[1680][1050])
HUDSettings.domination_minimap.score_ticker_bg_enemy[1680][1050].pivot_align_x = "left"
HUDSettings.domination_minimap.score_ticker_bg_enemy[1680][1050].pivot_offset_x = 30
HUDSettings.domination_minimap.score_ticker_friendly = HUDSettings.domination_minimap.score_ticker_friendly or {}
HUDSettings.domination_minimap.score_ticker_friendly[1680] = HUDSettings.domination_minimap.score_ticker_friendly[1680] or {}
HUDSettings.domination_minimap.score_ticker_friendly[1680][1050] = HUDSettings.domination_minimap.score_ticker_friendly[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	font_size = 16,
	pivot_offset_y = -32,
	screen_align_x = "center",
	pivot_offset_x = -44,
	screen_offset_y = 0,
	pivot_align_x = "right",
	font = MenuSettings.fonts.hell_shark_16,
	text_color = {
		255,
		255,
		255,
		255
	}
}
HUDSettings.domination_minimap.score_ticker_enemy = HUDSettings.domination_minimap.score_ticker_enemy or {}
HUDSettings.domination_minimap.score_ticker_enemy[1680] = HUDSettings.domination_minimap.score_ticker_enemy[1680] or {}
HUDSettings.domination_minimap.score_ticker_enemy[1680][1050] = HUDSettings.domination_minimap.score_ticker_enemy[1680][1050] or table.clone(HUDSettings.domination_minimap.score_ticker_friendly[1680][1050])
HUDSettings.domination_minimap.score_ticker_enemy[1680][1050].pivot_align_x = "left"
HUDSettings.domination_minimap.score_ticker_enemy[1680][1050].pivot_offset_x = 44
HUDSettings.domination_minimap.owned_objectives_indicator_left = HUDSettings.domination_minimap.owned_objectives_indicator_left or {}
HUDSettings.domination_minimap.owned_objectives_indicator_left[1680] = HUDSettings.domination_minimap.owned_objectives_indicator_left[1680] or {}
HUDSettings.domination_minimap.owned_objectives_indicator_left[1680][1050] = {
	screen_align_y = "top",
	screen_offset_x = 0,
	spacing = 0,
	pivot_align_y = "top",
	pivot_offset_y = -10,
	height = 60,
	screen_align_x = "center",
	alignment_x = "stacked_right",
	pivot_offset_x = -35,
	screen_offset_y = 0,
	pivot_align_x = "right",
	width = 0,
	alignment_y = "bottom"
}
HUDSettings.domination_minimap.owned_objectives_indicator_middle = HUDSettings.domination_minimap.owned_objectives_indicator_middle or {}
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680] = HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680] or {}
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680][1050] = table.clone(HUDSettings.domination_minimap.owned_objectives_indicator_left[1680][1050])
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680][1050].pivot_offset_x = 0
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680][1050].alignment_x = "center"
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680][1050].pivot_align_x = "center"
HUDSettings.domination_minimap.owned_objectives_indicator_middle[1680][1050].pivot_offset_x = 0
HUDSettings.domination_minimap.owned_objectives_indicator_right = HUDSettings.domination_minimap.owned_objectives_indicator_right or {}
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680] = HUDSettings.domination_minimap.owned_objectives_indicator_right[1680] or {}
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680][1050] = table.clone(HUDSettings.domination_minimap.owned_objectives_indicator_left[1680][1050])
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680][1050].pivot_offset_x = 62
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680][1050].alignment_x = "stacked"
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680][1050].pivot_align_x = "left"
HUDSettings.domination_minimap.owned_objectives_indicator_right[1680][1050].pivot_offset_x = 35
HUDSettings.domination_minimap.owned_objective_friendly = HUDSettings.domination_minimap.owned_objective_friendly or {}
HUDSettings.domination_minimap.owned_objective_friendly[1680] = HUDSettings.domination_minimap.owned_objective_friendly[1680] or {}
HUDSettings.domination_minimap.owned_objective_friendly[1680][1050] = HUDSettings.domination_minimap.owned_objective_friendly[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	texture_width = 20,
	pivot_offset_y = 0,
	atlas = "hud_assets",
	screen_align_x = "center",
	texture = "dom_minimap_capture_point_friendly",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	texture_height = 20
}
HUDSettings.domination_minimap.owned_objective_enemy = HUDSettings.domination_minimap.owned_objective_enemy or {}
HUDSettings.domination_minimap.owned_objective_enemy[1680] = HUDSettings.domination_minimap.owned_objective_enemy[1680] or {}
HUDSettings.domination_minimap.owned_objective_enemy[1680][1050] = HUDSettings.domination_minimap.owned_objective_enemy[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	texture_width = 20,
	pivot_offset_y = 0,
	atlas = "hud_assets",
	screen_align_x = "center",
	texture = "dom_minimap_capture_point_enemy",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	texture_height = 20
}
HUDSettings.domination_minimap.bg = HUDSettings.domination_minimap.bg or {}
HUDSettings.domination_minimap.bg[1680] = HUDSettings.domination_minimap.bg[1680] or {}
HUDSettings.domination_minimap.bg[1680][1050] = HUDSettings.domination_minimap.bg[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = -75,
	atlas = "hud_assets",
	screen_align_x = "center",
	texture = "dom_minimap_bg_02",
	texture_width = 220,
	pivot_offset_x = -5,
	screen_offset_y = 0,
	pivot_align_x = "center",
	texture_height = 105,
	color = {
		75,
		255,
		255,
		255
	}
}
HUDSettings.domination_minimap.domination_text_lower = HUDSettings.domination_minimap.domination_text_lower or {}
HUDSettings.domination_minimap.domination_text_lower[1680] = HUDSettings.domination_minimap.domination_text_lower[1680] or {}
HUDSettings.domination_minimap.domination_text_lower[1680][1050] = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	font_size = 24,
	pivot_offset_y = -210,
	text_align = "center",
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_32,
	animations = {}
}
HUDSettings.domination_minimap.domination_text_upper = HUDSettings.domination_minimap.domination_text_upper or {}
HUDSettings.domination_minimap.domination_text_upper[1680] = HUDSettings.domination_minimap.domination_text_upper[1680] or {}
HUDSettings.domination_minimap.domination_text_upper[1680][1050] = {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	font_size = 24,
	pivot_offset_y = -62,
	text_align = "center",
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_32,
	animations = {}
}
HUDSettings.domination_minimap.domination_text_upper[1680][1050].pivot_offset_y = -68
HUDSettings.announcements = HUDSettings.announcements or {}
HUDSettings.announcements.container = HUDSettings.announcements.container or {}
HUDSettings.announcements.container[1680] = HUDSettings.announcements.container[1680] or {}
HUDSettings.announcements.container[1680][1050] = HUDSettings.announcements.container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	z = 20,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = -0.2,
	pivot_align_x = "center"
}
HUDSettings.announcements.objective = HUDSettings.announcements.objective or {}
HUDSettings.announcements.objective[1680] = HUDSettings.announcements.objective[1680] or {}
HUDSettings.announcements.objective[1680][1050] = HUDSettings.announcements.objective[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	text_align = "center",
	screen_align_x = "center",
	font_size = 80,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 5,
	queue_delay = 5,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.1
			local t2 = 0.9

			if t < t1 then
				return math.lerp(0, 1, t * 10)
			elseif t < t2 then
				return 1
			else
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			end
		end
	}
}
HUDSettings.announcements.team_help_request = HUDSettings.announcements.team_help_request or {}
HUDSettings.announcements.team_help_request[1680] = HUDSettings.announcements.team_help_request[1680] or {}
HUDSettings.announcements.team_help_request[1680][1050] = {
	screen_align_y = "bottom",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 150,
	text_align = "center",
	screen_align_x = "center",
	font_size = 40,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0.25,
	pivot_align_x = "center",
	anim_length = 5,
	queue_delay = 5,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = HUDSettings.player_colors.team_member,
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.1
			local t2 = 0.9

			if t < t1 then
				return math.lerp(0, 1, t * 10)
			elseif t < t2 then
				return 1
			else
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			end
		end
	}
}
HUDSettings.announcements.squad_help_request = table.clone(HUDSettings.announcements.team_help_request)
HUDSettings.announcements.squad_help_request[1680][1050].text_color = HUDSettings.player_colors.squad_member
HUDSettings.announcements.duel_challenge = table.clone(HUDSettings.announcements.team_help_request)
HUDSettings.announcements.duel_challenge[1680][1050].text_color = HUDSettings.player_colors.enemy
HUDSettings.announcements.defender_event = HUDSettings.announcements.defender_event or {}
HUDSettings.announcements.defender_event[1680] = HUDSettings.announcements.defender_event[1680] or {}
HUDSettings.announcements.defender_event[1680][1050] = HUDSettings.announcements.defender_event[1680][1050] or {
	screen_offset_x = 0,
	pivot_offset_y = 0,
	pivot_align_y = "top",
	screen_align_x = "center",
	screen_align_y = "top",
	line_height = 70,
	anim_length = 5,
	queue_delay = 5,
	font_size = 36,
	text_align = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0.1,
	pivot_align_x = "center",
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	},
	drop_shadow = SMALL_DROP_SHADOW,
	drop_shadow_color = {
		128,
		0,
		0,
		0
	},
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.1
			local t2 = 0.9
			local alpha_multiplier = 0

			if t < t1 then
				alpha_multiplier = math.lerp(0, 1, t / t1)
			else
				alpha_multiplier = t < t2 and 1 or math.lerp(1, 0, (t - t2) / (1 - t2))
			end

			local pulses = 8

			return math.lerp(0, 1, 0.75 + math.sin(t * pulses * 4) * 0.25) * alpha_multiplier
		end,
		offset_y = function(t)
			return 0
		end,
		font_size_multiplier = function(t)
			local pulses = 8

			return math.lerp(0, 1, 0.95 + math.sin(t * pulses * 4) * 0.05)
		end
	}
}
HUDSettings.announcements.time_extended = HUDSettings.announcements.time_extended or {}
HUDSettings.announcements.time_extended[1680] = HUDSettings.announcements.time_extended[1680] or {}
HUDSettings.announcements.time_extended[1680][1050] = HUDSettings.announcements.time_extended[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	text_align = "center",
	screen_align_x = "center",
	font_size = 40,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = -0.45,
	pivot_align_x = "center",
	anim_length = 5,
	queue_delay = 5,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.1
			local t2 = 0.9

			if t < t1 then
				return math.lerp(0, 1, t * 10)
			elseif t < t2 then
				return 1
			else
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			end
		end,
		offset_y = function(t)
			local t2 = 0.9

			if t < t2 then
				return 0
			else
				return math.lerp(0, -100, (t - t2) * (1 / (1 - t2)))
			end
		end,
		font_size_multiplier = function(t)
			local t2 = 0.9

			if t < t2 then
				return 1
			else
				return math.lerp(1, 0.3, (t - t2) * (1 / (1 - t2)))
			end
		end
	}
}
HUDSettings.announcements.round_timer = HUDSettings.announcements.round_timer or {}
HUDSettings.announcements.round_timer[1680] = HUDSettings.announcements.round_timer[1680] or {}
HUDSettings.announcements.round_timer[1680][1050] = HUDSettings.announcements.round_timer[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	text_align = "center",
	screen_align_x = "center",
	font_size = 80,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 1,
	queue_delay = 1,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		alpha_multiplier = function(t)
			return math.lerp(1, 0, t)
		end
	}
}
HUDSettings.announcements.deserter_timer = HUDSettings.announcements.deserter_timer or {}
HUDSettings.announcements.deserter_timer[1680] = HUDSettings.announcements.deserter_timer[1680] or {}
HUDSettings.announcements.deserter_timer[1680][1050] = HUDSettings.announcements.deserter_timer[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	text_align = "center",
	screen_align_x = "center",
	font_size = 80,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 1,
	queue_delay = 5,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {}
}
HUDSettings.announcements.winning_losing = HUDSettings.announcements.winning_losing or {}
HUDSettings.announcements.winning_losing[1680] = HUDSettings.announcements.winning_losing[1680] or {}
HUDSettings.announcements.winning_losing[1680][1050] = HUDSettings.announcements.winning_losing[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	text_align = "center",
	screen_align_x = "center",
	font_size = 80,
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 3,
	queue_delay = 3,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.8

			if t < t1 then
				return 1
			else
				return math.lerp(1, 0, (t - t1) * (1 / (1 - t1)))
			end
		end
	}
}
HUDSettings.announcements.achievement = HUDSettings.announcements.achievement or {}
HUDSettings.announcements.achievement[1680] = HUDSettings.announcements.achievement[1680] or {}
HUDSettings.announcements.achievement[1680][1050] = HUDSettings.announcements.achievement[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	font_size = 80,
	screen_align_x = "center",
	line_height = 70,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 2,
	queue_delay = 2,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		alpha_multiplier = function(t)
			local t1 = 0.9

			if t < t1 then
				return 1
			else
				return math.lerp(1, 0, (t - t1) * (1 / (1 - t1)))
			end
		end
	}
}
HUDSettings.announcements.game_description_container = HUDSettings.announcements.game_description_container or {}
HUDSettings.announcements.game_description_container[1680] = HUDSettings.announcements.game_description_container[1680] or {}
HUDSettings.announcements.game_description_container[1680][1050] = HUDSettings.announcements.game_description_container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "center",
	anim_length = 5,
	queue_delay = 5,
	pivot_offset_x = 0,
	screen_offset_y = 0.05,
	pivot_align_x = "center",
	animations = {},
	particle_effects = {
		{
			stop_time = 0.99,
			effect = "fx/hud_gamemode_smoke",
			position_y = 0.53,
			position_x = -0.35,
			position_z = 1,
			start_time = 0.8
		}
	}
}
HUDSettings.announcements.game_description_container[1366] = {}
HUDSettings.announcements.game_description_container[1366][768] = table.clone(HUDSettings.announcements.game_description_container[1680][1050])
HUDSettings.announcements.game_description_container[1366][768].screen_offset_y = 0.06
HUDSettings.announcements.game_description_container[1366][768].particle_effects = {
	{
		stop_time = 0.99,
		effect = "fx/hud_gamemode_smoke",
		position_y = 0.55,
		position_x = -0.35,
		position_z = 1,
		start_time = 0.8
	}
}
HUDSettings.announcements.game_description_header_text = HUDSettings.announcements.game_description_header_text or {}
HUDSettings.announcements.game_description_header_text[1680] = HUDSettings.announcements.game_description_header_text[1680] or {}
HUDSettings.announcements.game_description_header_text[1680][1050] = HUDSettings.announcements.game_description_header_text[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	font_size = 50,
	screen_align_x = "center",
	z = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 5,
	font = MenuSettings.fonts.hell_shark_36,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		font_size_multiplier = function(t)
			local t1 = 0.02
			local t2 = 0.04

			if t < t1 then
				local v = t * (1 / t1)

				return math.lerp(3, 0.98, 1 - (1 - v) * (1 - v))
			elseif t < t2 then
				local v = (t - t1) * (1 / (t2 - t1))

				return math.lerp(0.98, 1, v)
			else
				return 1
			end
		end,
		alpha_multiplier = function(t)
			local t1 = 0.04
			local t2 = 0.95

			if t < t1 then
				return math.lerp(0, 1, t * (1 / t1))
			elseif t2 < t then
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			else
				return 1
			end
		end
	}
}
HUDSettings.announcements.game_description_header_text[1366] = {}
HUDSettings.announcements.game_description_header_text[1366][768] = table.clone(HUDSettings.announcements.game_description_header_text[1680][1050])
HUDSettings.announcements.game_description_header_text[1366][768].font_size = 50 * SCALE_1366
HUDSettings.announcements.game_description_sub_text = HUDSettings.announcements.game_description_sub_text or {}
HUDSettings.announcements.game_description_sub_text[1680] = HUDSettings.announcements.game_description_sub_text[1680] or {}
HUDSettings.announcements.game_description_sub_text[1680][1050] = HUDSettings.announcements.game_description_sub_text[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = -50,
	font_size = 24,
	screen_align_x = "center",
	z = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center",
	anim_length = 5,
	font = MenuSettings.fonts.hell_shark_24,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		font_size_multiplier = function(t)
			local t1 = 0.02
			local t2 = 0.04

			if t < t1 then
				local v = t * (1 / t1)

				return math.lerp(3, 0.98, 1 - (1 - v) * (1 - v))
			elseif t < t2 then
				local v = (t - t1) * (1 / (t2 - t1))

				return math.lerp(0.98, 1, v)
			else
				return 1
			end
		end,
		alpha_multiplier = function(t)
			local t1 = 0.04
			local t2 = 0.95

			if t < t1 then
				return math.lerp(0, 1, t * (1 / t1))
			elseif t2 < t then
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			else
				return 1
			end
		end
	}
}
HUDSettings.announcements.game_description_sub_text[1366] = {}
HUDSettings.announcements.game_description_sub_text[1366][768] = table.clone(HUDSettings.announcements.game_description_sub_text[1680][1050])
HUDSettings.announcements.game_description_sub_text[1366][768].font_size = 24 * SCALE_1366
HUDSettings.announcements.game_description_sub_text[1366][768].font = MenuSettings.fonts.hell_shark_18
HUDSettings.announcements.game_description_sub_text[1366][768].pivot_offset_y = -50 * SCALE_1366
HUDSettings.announcements.rank_up_container = HUDSettings.announcements.rank_up_container or {}
HUDSettings.announcements.rank_up_container[1680] = HUDSettings.announcements.rank_up_container[1680] or {}
HUDSettings.announcements.rank_up_container[1680][1050] = HUDSettings.announcements.rank_up_container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "center",
	anim_length = 4,
	queue_delay = 4,
	pivot_offset_x = 0,
	screen_offset_y = 0.05,
	pivot_align_x = "center",
	animations = {},
	particle_effects = {
		{
			stop_time = 0.99,
			effect = "fx/hud_levelup",
			position_y = 0.54,
			position_x = 0,
			position_z = 1,
			start_time = 0.05
		}
	}
}
HUDSettings.announcements.rank_up_container[1366] = {}
HUDSettings.announcements.rank_up_container[1366][768] = table.clone(HUDSettings.announcements.rank_up_container[1680][1050])
HUDSettings.announcements.rank_up_container[1366][768].screen_offset_y = 0.06
HUDSettings.announcements.rank_up_container[1366][768].particle_effects = {}
HUDSettings.announcements.rank_up_text = HUDSettings.announcements.rank_up_text or {}
HUDSettings.announcements.rank_up_text[1680] = HUDSettings.announcements.rank_up_text[1680] or {}
HUDSettings.announcements.rank_up_text[1680][1050] = HUDSettings.announcements.rank_up_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	font_size = 62,
	screen_align_x = "center",
	z = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.42,
	pivot_align_x = "center",
	anim_length = 4,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		font_size_multiplier = function(t)
			local t1 = 0.02
			local t2 = 0.04

			if t < t1 then
				local v = t * (1 / t1)

				return math.lerp(3, 0.98, 1 - (1 - v) * (1 - v))
			elseif t < t2 then
				local v = (t - t1) * (1 / (t2 - t1))

				return math.lerp(0.98, 1, v)
			else
				return 1
			end
		end,
		alpha_multiplier = function(t)
			local t1 = 0.04
			local t2 = 0.95

			if t < t1 then
				return math.lerp(0, 1, t * (1 / t1))
			elseif t2 < t then
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			else
				return 1
			end
		end
	}
}
HUDSettings.announcements.rank_up_text[1366] = {}
HUDSettings.announcements.rank_up_text[1366][768] = table.clone(HUDSettings.announcements.rank_up_text[1680][1050])
HUDSettings.announcements.rank_up_text[1366][768].font_size = 51
HUDSettings.announcements.rank_up_header_text = HUDSettings.announcements.rank_up_header_text or table.clone(HUDSettings.announcements.rank_up_text)
HUDSettings.announcements.rank_up_header_text[1680][1050].pivot_offset_y = 50
HUDSettings.announcements.rank_up_header_text[1680][1050].font = MenuSettings.fonts.hell_shark_28
HUDSettings.announcements.rank_up_header_text[1680][1050].font_size = 28
HUDSettings.announcements.rank_up_header_text[1366][768].pivot_offset_y = 50 * SCALE_1366
HUDSettings.announcements.rank_up_header_text[1366][768].font = MenuSettings.fonts.hell_shark_22
HUDSettings.announcements.rank_up_header_text[1366][768].font_size = 22
HUDSettings.announcements.rank_up_footer_text = HUDSettings.announcements.rank_up_footer_text or table.clone(HUDSettings.announcements.rank_up_text)
HUDSettings.announcements.rank_up_footer_text[1680][1050].pivot_offset_y = -50
HUDSettings.announcements.rank_up_footer_text[1680][1050].font = MenuSettings.fonts.hell_shark_28
HUDSettings.announcements.rank_up_footer_text[1680][1050].font_size = 28
HUDSettings.announcements.rank_up_footer_text[1366][768].pivot_offset_y = -50 * SCALE_1366
HUDSettings.announcements.rank_up_footer_text[1366][768].font = MenuSettings.fonts.hell_shark_22
HUDSettings.announcements.rank_up_footer_text[1366][768].font_size = 22
HUDSettings.announcements.short_term_goal_achieved_container = HUDSettings.announcements.short_term_goal_achieved_container or {}
HUDSettings.announcements.short_term_goal_achieved_container[1680] = HUDSettings.announcements.short_term_goal_achieved_container[1680] or {}
HUDSettings.announcements.short_term_goal_achieved_container[1680][1050] = HUDSettings.announcements.short_term_goal_achieved_container[1680][1050] or {
	screen_align_y = "top",
	screen_offset_x = 0,
	pivot_align_y = "top",
	pivot_offset_y = 0,
	screen_align_x = "center",
	anim_length = 4,
	queue_delay = 4,
	pivot_offset_x = 0,
	screen_offset_y = 0.05,
	pivot_align_x = "center",
	animations = {},
	particle_effects = {}
}
HUDSettings.announcements.short_term_goal_achieved_container[1366] = {}
HUDSettings.announcements.short_term_goal_achieved_container[1366][768] = table.clone(HUDSettings.announcements.short_term_goal_achieved_container[1680][1050])
HUDSettings.announcements.short_term_goal_achieved_container[1366][768].screen_offset_y = 0.06
HUDSettings.announcements.short_term_goal_achieved_container[1366][768].particle_effects = {}
HUDSettings.announcements.short_term_goal_achieved_text = HUDSettings.announcements.short_term_goal_achieved_text or {}
HUDSettings.announcements.short_term_goal_achieved_text[1680] = HUDSettings.announcements.short_term_goal_achieved_text[1680] or {}
HUDSettings.announcements.short_term_goal_achieved_text[1680][1050] = HUDSettings.announcements.short_term_goal_achieved_text[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	pivot_offset_y = 0,
	font_size = 62,
	screen_align_x = "center",
	z = 0,
	pivot_offset_x = 0,
	screen_offset_y = 0.42,
	pivot_align_x = "center",
	anim_length = 4,
	font = MenuSettings.fonts.font_gradient_100,
	text_color = {
		255,
		255,
		255,
		255
	},
	animations = {
		font_size_multiplier = function(t)
			local t1 = 0.02
			local t2 = 0.04

			if t < t1 then
				local v = t * (1 / t1)

				return math.lerp(3, 0.98, 1 - (1 - v) * (1 - v))
			elseif t < t2 then
				local v = (t - t1) * (1 / (t2 - t1))

				return math.lerp(0.98, 1, v)
			else
				return 1
			end
		end,
		alpha_multiplier = function(t)
			local t1 = 0.04
			local t2 = 0.95

			if t < t1 then
				return math.lerp(0, 1, t * (1 / t1))
			elseif t2 < t then
				return math.lerp(1, 0, (t - t2) * (1 / (1 - t2)))
			else
				return 1
			end
		end
	}
}
HUDSettings.announcements.short_term_goal_achieved_text[1366] = {}
HUDSettings.announcements.short_term_goal_achieved_text[1366][768] = table.clone(HUDSettings.announcements.short_term_goal_achieved_text[1680][1050])
HUDSettings.announcements.short_term_goal_achieved_text[1366][768].font_size = 51
HUDSettings.announcements.short_term_goal_achieved_footer_text = HUDSettings.announcements.short_term_goal_achieved_footer_text or table.clone(HUDSettings.announcements.short_term_goal_achieved_text)
HUDSettings.announcements.short_term_goal_achieved_footer_text[1680][1050].pivot_offset_y = -50
HUDSettings.announcements.short_term_goal_achieved_footer_text[1680][1050].font = MenuSettings.fonts.hell_shark_28
HUDSettings.announcements.short_term_goal_achieved_footer_text[1680][1050].font_size = 28
HUDSettings.announcements.short_term_goal_achieved_footer_text[1366][768].pivot_offset_y = -50 * SCALE_1366
HUDSettings.announcements.short_term_goal_achieved_footer_text[1366][768].font = MenuSettings.fonts.hell_shark_22
HUDSettings.announcements.short_term_goal_achieved_footer_text[1366][768].font_size = 22
HUDSettings.sp_tutorial = HUDSettings.sp_tutorial or {}
HUDSettings.sp_tutorial.container = HUDSettings.sp_tutorial.container or {}
HUDSettings.sp_tutorial.container[1680] = HUDSettings.sp_tutorial.container[1680] or {}
HUDSettings.sp_tutorial.container[1680][1050] = HUDSettings.sp_tutorial.container[1680][1050] or {
	screen_align_y = "center",
	screen_offset_x = 0,
	pivot_align_y = "center",
	z = 30,
	pivot_offset_y = 0,
	screen_align_x = "center",
	pivot_offset_x = 0,
	screen_offset_y = 0,
	pivot_align_x = "center"
}
HUDSettings.sp_tutorial.tutorial_text = HUDSettings.sp_tutorial.tutorial_text or {}
HUDSettings.sp_tutorial.tutorial_text[1680] = HUDSettings.sp_tutorial.tutorial_text[1680] or {}
HUDSettings.sp_tutorial.tutorial_text[1680][1050] = HUDSettings.sp_tutorial.tutorial_text[1680][1050] or {
	header_padding_left = 16,
	screen_offset_x = 0.1,
	text_padding_left = 16,
	text_width = 420,
	text_padding_top = 56,
	line_height = 24,
	pivot_align_y = "top",
	header_texture_offset_y = -12,
	header_font_size = 26,
	bottom_line_texture_atlas = "hud_atlas",
	header_texture_atlas = "hud_atlas",
	screen_align_y = "center",
	gradient_texture_atlas = "hud_atlas",
	pivot_offset_y = 0,
	text_padding_bottom = 20,
	screen_align_x = "center",
	pivot_offset_x = 0,
	header_texture_height = 40,
	top_line_texture_atlas = "hud_atlas",
	font_size = 22,
	header_padding_bottom = 16,
	screen_offset_y = -0.1,
	pivot_align_x = "left",
	header_font = MenuSettings.fonts.hell_shark_26,
	header_color = {
		255,
		255,
		255,
		255
	},
	header_shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	header_shadow_offset = DEFAULT_DROP_SHADOW_OFFSET,
	font = MenuSettings.fonts.hell_shark_22,
	text_color = {
		255,
		255,
		255,
		255
	},
	text_shadow_color = DEFAULT_DROP_SHADOW_COLOR,
	text_shadow_offset = DEFAULT_DROP_SHADOW_OFFSET,
	header_texture_atlas_settings = HUDAtlas.tutorial_bgr_gradient,
	header_texture_color = {
		255,
		255,
		255,
		255
	},
	gradient_texture_atlas_settings = HUDAtlas.tutorial_bgr_gradient,
	gradient_texture_color = {
		200,
		255,
		255,
		255
	},
	top_line_texture_atlas_settings = HUDAtlas.tutorial_top_line,
	bottom_line_texture_atlas_settings = HUDAtlas.tutorial_bottom_line
}
HUDSettings.parry_helper.scan_radius = 5
HUDSettings.parry_helper.activation_angle = 90
HUDSettings.parry_helper.inner_activation_angle = 180
HUDSettings.parry_helper.inner_activation_radius = 1
HUDSettings.parry_helper.count_not_attacking_enemies = false
HUDSettings.parry_helper.only_show_if_can_parry = true
HUDSettings.parry_helper.alpha_multipliers = {
	1,
	0.45,
	0.1
}
HUDSettings.hud_in_range_indicator = {}
HUDSettings.hud_in_range_indicator.fade_time = 0.25
