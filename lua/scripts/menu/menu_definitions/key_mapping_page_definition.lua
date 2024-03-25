-- chunkname: @scripts/menu/menu_definitions/key_mapping_page_definition.lua

require("scripts/menu/menu_definitions/key_mapping_page_settings_1920")
require("scripts/menu/menu_definitions/key_mapping_page_settings_1366")

local page_settings = KeyMappingPageDefinition.page_settings
local item_page_settings = KeyMappingPageDefinition.item_page_settings
local key_map_item_settings = KeyMappingPageDefinition.key_map_item_settings
local delimiter_item_settings = KeyMappingPageDefinition.delimiter_item_settings
local definition = definition or {
	layout_settings = "MainMenuSettings.items.key_centered_text",
	text = "menu_key_mapping",
	type = "HeaderItem",
	disabled = GameSettingsDevelopment.disable_key_mappings,
	page = {
		layout_settings = "KeyMappingPageDefinition.page_settings",
		name = "menu_key_mapping",
		show_revision = true,
		type = "KeyMappingsMenuPage",
		z = 150,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			item_list_header = {},
			header_items = {
				{
					text = "menu_key_mapping",
					disabled = true,
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_menu_header
				}
			},
			page_name = {
				{
					layout_settings = "MainMenuSettings.items.centered_text",
					disabled = true,
					on_enter_text = "cb_page_name",
					type = "HeaderItem",
					callback_object = "page"
				}
			},
			verification_items = {
				{
					remove_func = "cb_controller_enabled",
					disabled = true,
					type = "TextureMenuItem",
					layout_settings = delimiter_item_settings
				},
				{
					layout_settings = "MainMenuSettings.items.wotv_text_left_aligned",
					text = "main_menu_apply_settings",
					disabled_func = "cb_apply_changes_disabled",
					type = "HeaderItem",
					remove_func = "cb_controller_enabled",
					on_select = "cb_apply_key_mappings",
					callback_object = "page"
				},
				{
					layout_settings = "MainMenuSettings.items.wotv_text_left_aligned",
					text = "menu_reset",
					on_select = "cb_reset",
					type = "HeaderItem",
					remove_func = "cb_controller_enabled",
					callback_object = "page"
				},
				{
					layout_settings = "MainMenuSettings.items.wotv_text_left_aligned",
					text = "main_menu_cancel",
					on_select = "cb_cancel",
					type = "HeaderItem",
					remove_func = "cb_controller_enabled",
					callback_object = "page",
					sounds = MenuSettings.sounds.default.items.cancel
				}
			},
			item_list_scroll = {},
			item_list = {
				{
					text = "menu_key_move_forward",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"move_forward",
						"mount_cruise_control_gear_up"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_move_back",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"move_back",
						"mount_cruise_control_gear_down"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_move_left",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"move_left",
						"mount_move_left"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_move_right",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"move_right",
						"mount_move_right"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_jump",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"jump"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_crouch",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"crouch"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_melee_swing",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"left_hand_attack_held",
						"left_hand_attack_pressed",
						"melee_swing",
						"melee_pose_pushed",
						"melee_pose",
						"ranged_weapon_fire",
						"couch_lance",
						"falling_attack"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_special_attack",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"special_attack_primary",
						"special_attack_primary_held"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_special_attack_secondary",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"special_attack_secondary",
						"special_attack_secondary_held"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_throw_weapon",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"throw_weapon"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_dodge",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"dodge"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_travel_mode",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"travel_mode",
						"travel_mode_held"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_two_handed_weapon",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"wield_two_handed_weapon"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_one_handed_weapon",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"wield_one_handed_weapon"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_dagger",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"wield_dagger"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_shield",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"wield_shield"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_block",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"right_hand_attack_held",
						"right_hand_attack_pressed",
						"block",
						"raise_block",
						"lower_block",
						"ranged_weapon_aim",
						"ranged_weapon_aim_pressed"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_bandage",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"bandage",
						"bandage_start"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_interact",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"interact",
						"interacting"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_loot",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"loot",
						"looting"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_scoreboard",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"scoreboard"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_chat",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_chat_input_all"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_team_chat",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_chat_input_team"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_last_chat",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_chat_input"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_tag",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_tag"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_vote_yes",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"vote_yes"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_vote_no",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"vote_no"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_activate_perk_one",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_perk_1"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_activate_perk_two",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_perk_2"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_activate_perk_three",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_perk_3"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_activate_perk_four",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"activate_perk_4"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_taunt",
					layout_settings = "KeyMappingPageDefinition.key_map_item_settings",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_enabled",
					keys = {
						"taunt"
					},
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_jump",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"jump"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_crouch",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"crouch"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_melee_swing",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"right_hand_attack_held",
						"right_hand_attack_pressed",
						"melee_swing",
						"melee_pose",
						"ranged_weapon_fire",
						"couch_lance"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_one_handed_weapon",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"wield_one_handed_weapon"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_two_handed_weapon",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"wield_two_handed_weapon"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_dagger",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"wield_dagger"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_wield_shield",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"wield_shield"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_block",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"left_hand_attack_held",
						"left_hand_attack_pressed",
						"block",
						"raise_block",
						"lower_block",
						"ranged_weapon_aim",
						"ranged_weapon_aim_pressed"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_bandage",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"bandage",
						"bandage_start"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_interact",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"interact",
						"interacting"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_loot",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"loot",
						"looting"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_scoreboard",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"scoreboard"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_tag",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"activate_tag"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_vote_yes",
					prefix = "menu_key_shift_function",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"vote_yes"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_vote_no",
					prefix = "menu_key_shift_function",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"vote_no"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_zoom_in",
					prefix = "menu_key_shift_function",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"zoom_in"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_zoom_out",
					prefix = "menu_key_shift_function",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"zoom_out"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				},
				{
					text = "menu_key_chat",
					prefix = "menu_key_shift_function",
					type = "KeyMappingMenuItem",
					remove_func = "cb_controller_disabled",
					keys = {
						"activate_chat_input_all"
					},
					layout_settings = key_map_item_settings,
					page = {
						layout_settings = "KeyMappingPageDefinition.item_page_settings",
						z = 200,
						type = "KeyMappingPadMenuPage",
						render_parent_page = true,
						sounds = MenuSettings.sounds.default,
						item_groups = {}
					}
				}
			}
		}
	}
}

KeyMappingPageDefinition.main_menu_definition = definition
KeyMappingPageDefinition.ingame_menu_definition = table.clone(definition)
KeyMappingPageDefinition.ingame_menu_definition.page.layout_settings = "KeyMappingPageDefinition.page_settings_ingame"
