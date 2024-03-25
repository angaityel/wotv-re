-- chunkname: @scripts/menu/menu_definitions/ingame_menu_definition.lua

require("scripts/menu/menu_definitions/key_mapping_page_definition")
require("scripts/menu/menu_definitions/squad_menu_settings_1920")
require("scripts/menu/menu_definitions/squad_menu_settings_1366")
require("scripts/menu/menu_definitions/final_scoreboard_menu_settings_1920")
require("scripts/menu/menu_definitions/final_scoreboard_menu_settings_1366")
require("scripts/menu/menu_definitions/ingame_menu_settings_1920")
require("scripts/menu/menu_definitions/ingame_menu_settings_1366")

IngameMenuSettings = IngameMenuSettings or {}
IngameMenuSettings.items = IngameMenuSettings.items or {}
IngameMenuSettings.pages = IngameMenuSettings.pages or {}
SquadContainerTemplate = {
	name = "squad_container_template",
	type = "HLMenuGridContainer",
	layout_settings = SquadMenuSettings.squad_container,
	components = {
		{
			name = "squad_header_container",
			type = "HLMenuContainer",
			layout_settings = SquadMenuSettings.squad_header_container,
			components = {
				{
					name = "squad_header_background",
					type = "HLAtlasTextureMenuItem",
					color_func = "cb_squad_header_background_colour",
					callback_object = "page",
					layout_settings = SquadMenuSettings.squad_header_background
				},
				{
					name = "squad_header_information_container",
					type = "HLMenuGridContainer",
					layout_settings = SquadMenuSettings.squad_header_information_container,
					components = {
						{
							name = "squad_header_text",
							type = "HLTextMenuItem",
							text_func = "cb_squad_header_text",
							color_func = "cb_squad_header_text_colour",
							callback_object = "page",
							layout_settings = SquadMenuSettings.squad_header_text
						},
						{
							name = "squad_header_lock_icon",
							callback_object = "page",
							type = "HLAtlasTextureMenuItem",
							highlightable_func = "cb_can_highlight_lock",
							on_select = "cb_lock_selected",
							texture_func = "cb_lock_texture",
							layout_settings = SquadMenuSettings.squad_header_lock_icon,
							sounds = MenuSettings.sounds.default.items.text
						},
						{
							name = "squad_header_animal_container",
							type = "HLMenuContainer",
							layout_settings = SquadMenuSettings.squad_header_animal_container,
							components = {
								{
									name = "squad_header_animal_background",
									type = "HLAtlasTextureMenuItem",
									color_func = "cb_squad_animal_background_colour",
									callback_object = "page",
									layout_settings = SquadMenuSettings.squad_header_animal_background
								},
								{
									on_select = "cb_animal_selected",
									name = "squad_header_animal_icon",
									callback_object = "page",
									texture_func = "cb_squad_animal_texture",
									type = "HLAtlasTextureMenuItem",
									highlightable_func = "cb_can_highlight_animal",
									color_func = "cb_squad_animal_colour",
									layout_settings = SquadMenuSettings.squad_header_animal_icon,
									sounds = MenuSettings.sounds.default.items.text
								}
							}
						}
					}
				}
			}
		},
		{
			name = "join_squad_container",
			type = "HLMenuContainer",
			layout_settings = SquadMenuSettings.join_squad_container,
			background_func = MenuHelper.squad_menu_background,
			components = {
				{
					name = "join_squad_text",
					callback_object = "page",
					type = "HLTextMenuItem",
					highlightable_func = "cb_can_highlight_join_squad",
					on_select = "cb_join_squad_selected",
					text_func = "cb_join_squad_text",
					layout_settings = SquadMenuSettings.join_squad_text,
					sounds = MenuSettings.sounds.default.items.text
				},
				{
					name = "join_squad_button_prompt",
					type = "HLAtlasTextureMenuItem",
					color_func = "cb_join_squad_button_color",
					callback_object = "page",
					layout_settings = SquadMenuSettings.join_squad_button_prompt
				}
			}
		},
		{
			name = "squad_members_container",
			type = "HLMenuListContainer",
			layout_settings = SquadMenuSettings.squad_members_container,
			components = {}
		}
	}
}
SquadMenuPageDefinition = {
	hierachical_layout_menu = true,
	name = "menu_select_squad",
	type = "HLSquadSelectionMenuPage",
	hide_banner = true,
	sounds = MenuSettings.sounds.default,
	components = {
		{
			name = "background_container",
			type = "HLMenuGridContainer",
			layout_settings = SquadMenuSettings.background_container,
			background_func = MenuHelper.squad_menu_background,
			border_func = MenuHelper.squad_menu_border,
			components = {
				{
					name = "squad_grid_container",
					type = "HLMenuGridContainer",
					layout_settings = SquadMenuSettings.squad_grid_container,
					components = {
						{
							namespace = "squad_1",
							name = "squad_container_1",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_2",
							name = "squad_container_2",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_3",
							name = "squad_container_3",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_4",
							name = "squad_container_4",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_5",
							name = "squad_container_5",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_6",
							name = "squad_container_6",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_7",
							name = "squad_container_7",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						},
						{
							namespace = "squad_8",
							name = "squad_container_8",
							type = SquadContainerTemplate.type,
							layout_settings = SquadContainerTemplate.layout_settings,
							background_func = MenuHelper.squad_menu_background,
							border_func = MenuHelper.squad_menu_border,
							components = SquadContainerTemplate.components
						}
					}
				},
				{
					name = "squadless_container",
					type = "HLMenuGridContainer",
					layout_settings = SquadMenuSettings.squadless_container,
					background_func = MenuHelper.squad_menu_background,
					border_func = MenuHelper.squad_menu_border,
					components = {
						{
							name = "squadless_header_container",
							type = "HLMenuContainer",
							layout_settings = SquadMenuSettings.squadless_header_container,
							components = {
								{
									name = "squadless_header_background",
									type = "HLAtlasTextureMenuItem",
									layout_settings = SquadMenuSettings.squadless_header_background
								},
								{
									name = "squadless_header_text",
									type = "HLTextMenuItem",
									layout_settings = SquadMenuSettings.squadless_header_text
								}
							}
						},
						{
							name = "join_squadless_container",
							type = "HLMenuContainer",
							layout_settings = SquadMenuSettings.join_squadless_container,
							background_func = MenuHelper.squad_menu_background,
							components = {
								{
									name = "join_squadless_text",
									callback_object = "page",
									type = "HLTextMenuItem",
									highlightable_func = "cb_can_highlight_join_squadless",
									on_select = "cb_join_squadless_selected",
									layout_settings = SquadMenuSettings.join_squadless_text,
									sounds = MenuSettings.sounds.default.items.text
								}
							}
						},
						{
							name = "squadless_scroll_container",
							type = "HLMenuScrollContainer",
							layout_settings = SquadMenuSettings.squadless_scroll_container,
							scroll_bar_border_func = MenuHelper.squad_menu_border,
							components = {
								{
									name = "squadless_members_container",
									type = "HLMenuListContainer",
									layout_settings = SquadMenuSettings.squadless_members_container,
									components = {}
								}
							}
						}
					}
				}
			}
		},
		{
			name = "select_team_text",
			callback_object = "page",
			type = "HLTextMenuItem",
			highlightable_func = "cb_return_true",
			on_select = "cb_select_team_pressed",
			layout_settings = SquadMenuSettings.select_team_text,
			sounds = MenuSettings.sounds.default.items.header_item
		},
		{
			name = "page_name_text",
			type = "HLTextMenuItem",
			layout_settings = SquadMenuSettings.page_name_text
		},
		{
			name = "select_profile_text",
			callback_object = "page",
			type = "HLTextMenuItem",
			highlightable_func = "cb_return_true",
			on_select = "cb_select_profile_pressed",
			layout_settings = SquadMenuSettings.select_profile_text,
			sounds = MenuSettings.sounds.default.items.header_item
		}
	}
}
IngameMenuSettingsItems = {
	{
		text = "menu_audio_settings",
		type = "HeaderItem",
		layout_settings = MainMenuSettings.items.centered_text,
		page = {
			z = 100,
			on_enter_page = "cb_set_banner_material_variation",
			type = "WotvMenuPage",
			name = "menu_audio_settings",
			layout_settings = "IngameMenuSettings.pages.wotv_audio_sub_level",
			show_revision = true,
			header_text = "menu_audio_settings",
			on_enter_page_args = {
				"units/menu/menu_banner_no_logo"
			},
			sounds = MenuSettings.sounds.default,
			item_groups = {
				item_list = {
					{
						text = "menu_audio_settings",
						disabled = true,
						type = "HeaderItem",
						layout_settings = MainMenuSettings.items.centered_menu_header
					},
					{
						on_init_options = "cb_master_volumes",
						text = "menu_master_volume",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_master_volume_changed",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						on_init_options = "cb_music_volumes",
						text = "menu_music_volume",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_music_volume_changed",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						on_init_options = "cb_sfx_volumes",
						text = "menu_sfx_volume",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_sfx_volume_changed",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						on_init_options = "cb_voice_over_volumes",
						text = "menu_voice_over_volume",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_voice_over_volume_changed",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "main_menu_cancel",
						on_select = "cb_cancel",
						type = "HeaderItem",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_text,
						sounds = MenuSettings.sounds.default.items.cancel
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
				}
			}
		}
	},
	{
		text = "menu_video_settings",
		type = "HeaderItem",
		layout_settings = MainMenuSettings.items.centered_text,
		page = {
			z = 100,
			on_enter_page = "cb_set_banner_material_variation",
			type = "VideoSettingsMenuPage",
			name = "menu_video_settings",
			layout_settings = "IngameMenuSettings.pages.wotv_video_settings",
			show_revision = true,
			on_enter_page_args = {
				"units/menu/menu_banner_no_logo"
			},
			sounds = MenuSettings.sounds.default,
			item_groups = {
				item_list = {
					{
						text = "menu_video_settings",
						disabled = true,
						type = "HeaderItem",
						layout_settings = MainMenuSettings.items.centered_menu_header
					},
					{
						name = "screen_resolution",
						on_enter_text = "cb_resolution_drop_down_list_text",
						type = "DropDownListMenuItem",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.ddl_closed_text_center_aligned,
						page = {
							callback_object = "parent_page",
							z = 150,
							type = "DropDownListMenuPage",
							on_enter_options = "cb_resolution_options",
							show_revision = true,
							on_option_changed = "cb_resolution_option_changed",
							layout_settings = MainMenuSettings.pages.ddl_center_aligned,
							sounds = MenuSettings.sounds.default,
							item_groups = {
								scroll_bar = {
									{
										disabled_func = "cb_scroll_bar_disabled",
										type = "ScrollBarMenuItem",
										on_select_down = "cb_scroll_bar_select_down",
										callback_object = "page",
										layout_settings = MainMenuSettings.items.wotv_drop_down_list_scroll_bar
									}
								}
							}
						}
					},
					{
						text = "menu_gamma",
						on_enter_options = "cb_gamma_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_gamma_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_fullscreen",
						on_enter_options = "cb_fullscreen_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_fullscreen_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_fullscreen_output",
						on_enter_options = "cb_fullscreen_output_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_fullscreen_output_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_vertical_sync",
						on_enter_options = "cb_vertical_sync_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_vertical_sync_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_max_fps",
						on_enter_options = "cb_max_fps_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_max_fps_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_max_stacking_frames",
						on_enter_options = "cb_max_stacking_frames_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_max_stacking_frames_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						name = "graphics_quality",
						text = "menu_graphics_quality",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_graphics_quality_option_changed",
						on_enter_options = "cb_graphics_quality_options",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "menu_shadow_quality",
						on_enter_options = "cb_shadow_quality_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_shadow_quality_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_texture_quality_characters",
						on_enter_options = "cb_texture_quality_characters_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_texture_quality_characters_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_texture_quality_environment",
						on_enter_options = "cb_texture_quality_environment_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_texture_quality_environment_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_texture_quality_coat_of_arms",
						on_enter_options = "cb_texture_quality_coat_of_arms_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_texture_quality_coat_of_arms_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_anti_aliasing",
						on_enter_options = "cb_anti_aliasing_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_anti_aliasing_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_lod",
						on_enter_options = "cb_lod_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_lod_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_landscape_decoration",
						on_enter_options = "cb_landscape_decoration_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_landscape_decoration_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_scatter",
						on_enter_options = "cb_scatter_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_scatter_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_particles_quality",
						on_enter_options = "cb_particles_quality_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_particles_quality_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_light_casts_shadows",
						on_enter_options = "cb_light_casts_shadows_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_light_casts_shadows_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_ssao",
						on_enter_options = "cb_ssao_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_ssao_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_apex_cloth",
						on_enter_options = "cb_apex_cloth_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_apex_cloth_option_changed",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "menu_apply_settings",
						disabled_func = "cb_apply_changes_disabled",
						type = "HeaderItem",
						on_select = "cb_apply_changes",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_text
					},
					{
						text = "main_menu_cancel",
						on_select = "cb_cancel",
						type = "HeaderItem",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_text,
						sounds = MenuSettings.sounds.default.items.cancel
					},
					{
						name = "unapplied_changes_popup",
						type = "EmptyMenuItem",
						layout_settings = MainMenuSettings.items.empty,
						page = {
							z = 200,
							callback_object = "parent_page",
							type = "PopupMenuPage",
							on_item_selected = "cb_unapplied_changes_popup_item_selected",
							layout_settings = MainMenuSettings.pages.text_input_popup,
							sounds = MenuSettings.sounds.default,
							item_groups = {
								header_list = {
									{
										text = "menu_empty",
										disabled = true,
										type = "TextMenuItem",
										layout_settings = MainMenuSettings.items.popup_header
									}
								},
								item_list = {
									{
										text = "unapplied_video_changes",
										disabled = true,
										type = "TextBoxMenuItem",
										layout_settings = MainMenuSettings.items.popup_textbox
									}
								},
								button_list = {
									{
										text = "apply",
										callback_object = "page",
										type = "TextureButtonMenuItem",
										on_select = "cb_item_selected",
										on_select_args = {
											"close",
											"apply_changes"
										},
										layout_settings = MainMenuSettings.items.popup_button
									},
									{
										text = "discard",
										callback_object = "page",
										type = "TextureButtonMenuItem",
										on_select = "cb_item_selected",
										on_select_args = {
											"close",
											"discard_changes"
										},
										layout_settings = MainMenuSettings.items.popup_button
									}
								}
							}
						}
					},
					{
						name = "keep_changes_popup",
						type = "EmptyMenuItem",
						layout_settings = MainMenuSettings.items.empty,
						page = {
							z = 200,
							no_cancel_to_parent_page = true,
							type = "PopupMenuPage",
							callback_object = "parent_page",
							on_item_selected = "cb_keep_changes_popup_item_selected",
							layout_settings = MainMenuSettings.pages.text_input_popup,
							sounds = MenuSettings.sounds.default,
							item_groups = {
								header_list = {
									{
										text = "menu_empty",
										disabled = true,
										type = "TextMenuItem",
										layout_settings = MainMenuSettings.items.popup_header
									}
								},
								item_list = {
									{
										text = "keep_video_changes",
										disabled = true,
										type = "TextBoxMenuItem",
										layout_settings = MainMenuSettings.items.popup_textbox
									}
								},
								button_list = {
									{
										text = "keep",
										callback_object = "page",
										type = "TextureButtonMenuItem",
										on_select = "cb_item_selected",
										on_select_args = {
											"close",
											"keep_changes"
										},
										layout_settings = MainMenuSettings.items.popup_button
									},
									{
										on_countdown_done = "cb_item_selected",
										on_select = "cb_item_selected",
										type = "TextureButtonCountdownMenuItem",
										callback_object = "page",
										text = "revert",
										countdown_time = 10,
										on_countdown_done_args = {
											"close",
											"revert_changes"
										},
										on_select_args = {
											"close",
											"revert_changes"
										},
										layout_settings = MainMenuSettings.items.popup_button
									}
								}
							}
						}
					},
					{
						name = "changes_need_restart_popup",
						type = "EmptyMenuItem",
						layout_settings = MainMenuSettings.items.empty,
						page = {
							z = 200,
							no_cancel_to_parent_page = true,
							type = "PopupMenuPage",
							callback_object = "parent_page",
							on_item_selected = "cb_restart_popup_item_selected",
							layout_settings = MainMenuSettings.pages.text_input_popup,
							sounds = MenuSettings.sounds.none,
							item_groups = {
								header_list = {
									{
										text = "menu_empty",
										disabled = true,
										type = "TextMenuItem",
										layout_settings = MainMenuSettings.items.popup_header
									}
								},
								item_list = {
									{
										text = "changes_need_restart_main_menu",
										disabled = true,
										type = "TextBoxMenuItem",
										layout_settings = MainMenuSettings.items.popup_textbox
									}
								},
								button_list = {
									{
										text = "restart",
										callback_object = "page",
										type = "TextureButtonMenuItem",
										on_select = "cb_item_selected",
										on_select_args = {
											"close",
											"restart"
										},
										layout_settings = MainMenuSettings.items.popup_button
									},
									{
										text = "ignore",
										callback_object = "page",
										type = "TextureButtonMenuItem",
										on_select = "cb_item_selected",
										on_select_args = {
											"close"
										},
										layout_settings = MainMenuSettings.items.popup_button
									}
								}
							}
						}
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
				}
			}
		}
	},
	{
		text = "menu_control_settings",
		type = "HeaderItem",
		layout_settings = MainMenuSettings.items.centered_text,
		page = {
			z = 100,
			on_enter_page = "cb_set_banner_material_variation",
			type = "WotvMenuPage",
			name = "menu_control_settings",
			layout_settings = "IngameMenuSettings.pages.wotv_gameplay_sub_level",
			show_revision = true,
			on_enter_page_args = {
				"units/menu/menu_banner_no_logo"
			},
			sounds = MenuSettings.sounds.default,
			item_groups = {
				item_list = {
					{
						text = "menu_control_settings",
						disabled = true,
						type = "HeaderItem",
						layout_settings = MainMenuSettings.items.centered_menu_header
					},
					{
						text = "menu_mouse_sensitivity",
						on_init_options = "cb_mouse_sensitivity_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_mouse_sensitivity_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_mouse_sensitivity_first_person",
						on_init_options = "cb_aim_multiplier_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_aim_multiplier_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_look_invert",
						on_init_options = "cb_look_invert_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_look_invert_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_keyboard_parry",
						on_init_options = "cb_keyboard_parry_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_keyboard_parry_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_keyboard_pose",
						on_init_options = "cb_keyboard_pose_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_keyboard_pose_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_invert_swing_control_x",
						on_init_options = "cb_invert_pose_control_x_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_invert_pose_control_x_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_invert_swing_control_y",
						on_init_options = "cb_invert_pose_control_y_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_invert_pose_control_y_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_invert_parry_control_x",
						on_init_options = "cb_invert_parry_control_x_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_invert_parry_control_x_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_invert_parry_control_y",
						on_init_options = "cb_invert_parry_control_y_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_invert_parry_control_y_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_double_tap_dodge",
						on_init_options = "cb_double_tap_dodge_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_double_tap_dodge_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_travel_mode_input_mode",
						on_init_options = "cb_travel_mode_input_mode_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_travel_mode_input_mode_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					KeyMappingPageDefinition.ingame_menu_definition,
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "main_menu_cancel",
						on_select = "cb_cancel",
						type = "HeaderItem",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_text,
						sounds = MenuSettings.sounds.default.items.cancel
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
				}
			}
		}
	},
	{
		text = "menu_gameplay_settings",
		type = "HeaderItem",
		layout_settings = MainMenuSettings.items.centered_text,
		page = {
			z = 100,
			on_enter_page = "cb_set_banner_material_variation",
			type = "WotvMenuPage",
			name = "menu_gameplay_settings",
			layout_settings = "IngameMenuSettings.pages.wotv_gameplay_sub_level",
			show_revision = true,
			on_enter_page_args = {
				"units/menu/menu_banner_no_logo"
			},
			sounds = MenuSettings.sounds.default,
			item_groups = {
				item_list = {
					{
						text = "menu_gameplay_settings",
						disabled = true,
						layout_settings = "MainMenuSettings.items.centered_menu_header",
						type = "HeaderItem"
					},
					{
						text = "menu_show_reticule",
						on_init_options = "cb_show_reticule_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_reticule_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						text = "menu_reticule_a",
						on_init_options = "cb_show_reticule_color_a_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_show_reticule_color_a_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_reticule_r",
						on_init_options = "cb_show_reticule_color_r_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_show_reticule_color_r_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_reticule_g",
						on_init_options = "cb_show_reticule_color_g_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_show_reticule_color_g_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						text = "menu_reticule_b",
						on_init_options = "cb_show_reticule_color_b_options",
						type = "EnumSliderMenuItem",
						on_option_changed = "cb_show_reticule_color_b_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_slider
					},
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "menu_show_hud",
						on_init_options = "cb_show_hud_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_hud_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_combat_text",
						on_init_options = "cb_show_combat_text_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_combat_text_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_xp_awards",
						on_init_options = "cb_show_xp_awards",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_xp_awards_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_parry_helper",
						on_init_options = "cb_show_parry_helper",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_parry_helper_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_pose_charge_helper",
						on_init_options = "cb_show_pose_charge_helper",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_pose_charge_helper_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_attack_indicators_with_shield",
						on_init_options = "cb_show_attack_indicators_with_shield_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_attack_indicators_with_shield_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_announcements",
						on_init_options = "cb_show_announcements",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_announcements_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_team_outlines",
						on_init_options = "cb_show_team_outlines_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_team_outlines_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_squad_outlines",
						on_init_options = "cb_show_squad_outlines_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_squad_outlines_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_show_tagged_outlines",
						on_init_options = "cb_show_tagged_outlines_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_show_tagged_outlines_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_hide_blood",
						on_init_options = "cb_hide_blood_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_hide_blood_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_squadless_scoreboard",
						on_init_options = "cb_squadless_scoreboard_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_squadless_scoreboard_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_autojoin_squad",
						on_init_options = "cb_autojoin_squad_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_autojoin_squad_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_battle_chatter_hardcore",
						on_init_options = "cb_battle_chatter_hardcore_mode_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_battle_chatter_hardcore_mode_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_immediate_hit_effects",
						on_init_options = "cb_immediate_hit_effects_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_immediate_hit_effects_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum_checkbox
					},
					{
						text = "menu_incoming_chat_sound",
						on_init_options = "cb_incoming_chat_sound_options",
						type = "NewEnumMenuItem",
						on_option_changed = "cb_incoming_chat_sound_option_changed",
						callback_object = "MainMenuCallbacks",
						layout_settings = MainMenuSettings.items.centered_enum
					},
					{
						disabled = true,
						type = "TextureMenuItem",
						layout_settings = MainMenuSettings.items.delimiter_texture
					},
					{
						text = "main_menu_cancel",
						on_select = "cb_cancel",
						type = "HeaderItem",
						callback_object = "page",
						layout_settings = MainMenuSettings.items.centered_text,
						sounds = MenuSettings.sounds.default.items.cancel
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
				}
			}
		}
	},
	{
		disabled = true,
		type = "TextureMenuItem",
		layout_settings = MainMenuSettings.items.delimiter_texture
	},
	{
		text = "main_menu_cancel",
		on_select = "cb_cancel",
		type = "HeaderItem",
		callback_object = "page",
		layout_settings = MainMenuSettings.items.centered_text,
		sounds = MenuSettings.sounds.default.items.cancel
	}
}
LeaveBattlePopupPage = {
	z = 200,
	type = "PopupMenuPage",
	on_item_selected = "cb_leave_game_popup_item_selected",
	layout_settings = MainMenuSettings.pages.text_input_popup,
	sounds = MenuSettings.sounds.default,
	item_groups = {
		header_list = {
			{
				text = "menu_empty",
				disabled = true,
				type = "TextMenuItem",
				layout_settings = MainMenuSettings.items.popup_header
			}
		},
		item_list = {
			{
				text = "menu_popup_confirm_leave_battle",
				disabled = true,
				type = "TextMenuItem",
				layout_settings = MainMenuSettings.items.popup_text
			}
		},
		button_list = {
			{
				text = "menu_yes",
				callback_object = "page",
				type = "TextureButtonMenuItem",
				on_select = "cb_item_selected",
				on_select_args = {
					"close",
					"leave_game"
				},
				layout_settings = MainMenuSettings.items.popup_button
			},
			{
				text = "menu_no",
				callback_object = "page",
				type = "TextureButtonMenuItem",
				on_select = "cb_item_selected",
				on_select_args = {
					"close",
					"cancel"
				},
				layout_settings = MainMenuSettings.items.popup_button
			}
		}
	}
}
LeaveBattlePopupPageNoBanner = {
	z = 200,
	type = "PopupMenuPage",
	hide_banner = true,
	on_item_selected = "cb_leave_game_popup_item_selected",
	layout_settings = MainMenuSettings.pages.text_input_popup,
	sounds = MenuSettings.sounds.default,
	item_groups = {
		header_list = {
			{
				text = "menu_empty",
				disabled = true,
				type = "TextMenuItem",
				layout_settings = MainMenuSettings.items.popup_header
			}
		},
		item_list = {
			{
				text = "menu_popup_confirm_leave_battle",
				disabled = true,
				type = "TextMenuItem",
				layout_settings = MainMenuSettings.items.popup_text
			}
		},
		button_list = {
			{
				text = "menu_yes",
				callback_object = "page",
				type = "TextureButtonMenuItem",
				on_select = "cb_item_selected",
				on_select_args = {
					"close",
					"leave_game"
				},
				layout_settings = MainMenuSettings.items.popup_button
			},
			{
				text = "menu_no",
				callback_object = "page",
				type = "TextureButtonMenuItem",
				on_select = "cb_item_selected",
				on_select_args = {
					"close",
					"cancel"
				},
				layout_settings = MainMenuSettings.items.popup_button
			}
		}
	}
}
IngameMenuDefinition = {
	page = {
		name = "ingame_menu_main",
		on_enter_page = "cb_set_banner_material_variation",
		type = "WotvMenuPage",
		z = 1,
		layout_settings = "IngameMenuSettings.pages.wotv_page",
		id = "root",
		on_enter_page_args = {
			"units/menu/menu_banner"
		},
		sounds = MenuSettings.sounds.default,
		item_groups = {
			item_list = {
				{
					text = "menu_how_to_play",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.large_centered_text,
					page = HOW_TO_PLAY_PAGE
				},
				{
					disabled = true,
					type = "TextureMenuItem",
					layout_settings = MainMenuSettings.items.delimiter_texture
				},
				{
					id = "select_team",
					type = "EmptyMenuItem",
					layout_settings = MainMenuSettings.items.empty,
					page = {
						no_cancel_to_parent_page = false,
						z = 50,
						do_not_select_first_index = true,
						type = "TeamSelectionMenuPage",
						on_enter_page = "cb_set_banner_material_variation",
						name = "menu_choose_your_king",
						layout_settings = "SquadMenuSettings.pages.select_team",
						on_enter_highlight_item = "cb_team_selection_highlight_item",
						on_enter_page_args = {
							"units/menu/menu_banner_no_logo"
						},
						sounds = MenuSettings.sounds.default,
						item_groups = {
							center_items = {
								{
									text = "menu_choose_your_king",
									disabled = true,
									type = "HeaderItem",
									layout_settings = SquadMenuSettings.items.choose_side
								}
							},
							auto_join_items = {
								{
									callback_object = "page",
									disabled_func = "cb_auto_join_team_disabled",
									type = "TextureMenuItem",
									on_select = "cb_auto_join_team",
									layout_settings = SquadMenuSettings.items.auto_join
								},
								{
									text = "menu_auto_join",
									disabled = true,
									type = "HeaderItem",
									layout_settings = SquadMenuSettings.items.centered_text
								}
							},
							left_team_items = {
								{
									on_lowlight = "cb_hide_red_team",
									name = "red_team_rose",
									on_highlight = "cb_show_red_team",
									type = "TextureMenuItem",
									on_select = "cb_join_team_selected",
									callback_object = "page",
									disabled_func_args = "red",
									disabled_func = "cb_join_team_selection_disabled",
									on_select_args = {
										"red"
									},
									layout_settings = SquadMenuSettings.items.wotv_viking_team
								},
								{
									text = "lancaster_upper",
									name = "red_team_text",
									disabled = true,
									type = "TextMenuItem",
									callback_object = "page",
									layout_settings = SquadMenuSettings.items.red_team_text
								},
								{
									text = "",
									name = "red_num_members",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = SquadMenuSettings.items.red_team_num_players
								}
							},
							right_team_items = {
								{
									on_lowlight = "cb_hide_white_team",
									name = "white_team_rose",
									on_highlight = "cb_show_white_team",
									type = "TextureMenuItem",
									on_select = "cb_join_team_selected",
									callback_object = "page",
									disabled_func_args = "white",
									disabled_func = "cb_join_team_selection_disabled",
									on_select_args = {
										"white"
									},
									layout_settings = SquadMenuSettings.items.wotv_saxon_team
								},
								{
									text = "york_upper",
									name = "white_team_text",
									disabled = true,
									type = "TextMenuItem",
									callback_object = "page",
									layout_settings = SquadMenuSettings.items.white_team_text
								},
								{
									text = "",
									name = "white_num_members",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = SquadMenuSettings.items.white_team_num_players
								}
							},
							page_links = {
								{
									text = "menu_observer_team",
									name = "observer_team_button",
									disabled_func = "cb_auto_join_team_disabled",
									type = "TextureButtonMenuItem",
									on_select = "cb_observer_team_selected",
									callback_object = "page",
									layout_settings = LoadingScreenMenuSettings.items.next_button
								}
							},
							back_list = {
								{
									text = "menu_ingame_leave_battle_lower",
									type = "TextureButtonMenuItem",
									layout_settings = LoadingScreenMenuSettings.items.previous_button,
									page = LeaveBattlePopupPage
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
							red_players = {},
							white_players = {}
						}
					}
				},
				{
					id = "select_squad",
					type = "EmptyMenuItem",
					layout_settings = MainMenuSettings.items.empty,
					page = SquadMenuPageDefinition
				},
				{
					id = "select_profile",
					type = "EmptyMenuItem",
					layout_settings = MainMenuSettings.items.empty,
					page = {
						environment = "profile_editor",
						no_cancel_to_parent_page = true,
						type = "IngameProfileEditorSelectionPage",
						camera = "character_editor",
						layout_settings = "ProfileEditorSettings.pages.ingame_profile_editor_selection",
						enable_chat = true,
						hide_banner = true,
						sounds = MenuSettings.sounds.profile_editor,
						item_groups = {
							menu_items = {},
							header_items = {
								{
									text = "main_profile_selection",
									disabled = true,
									type = "HeaderItem",
									text_func = "cb_profile_name",
									no_localization = true,
									callback_object = "page",
									layout_settings = ProfileEditorSettings.items.team_colored_header
								}
							},
							page_name = {
								{
									text = "menu_profile_selection",
									name = "name",
									disabled = true,
									type = "HeaderItem",
									layout_settings = ProfileEditorSettings.items.name
								}
							},
							prev_link = {
								{
									text = "menu_select_squad",
									name = "select_squad",
									layout_settings = "ProfileEditorSettings.items.prev_link",
									type = "HeaderItem",
									on_select = "cb_goto",
									on_select_args = {
										"select_squad"
									}
								}
							},
							back_list = {
								{
									text = "menu_spawn",
									name = "spawn",
									on_select = "cb_spawn",
									type = "HeaderItem",
									layout_settings = "ProfileEditorSettings.items.next_link",
									callback_object = "page"
								}
							}
						}
					}
				},
				{
					text = "menu_switch_character_lower",
					remove_func = "cb_should_remove_select_profile_ingame",
					type = "HeaderItem",
					id = "select_profile_ingame",
					layout_settings = MainMenuSettings.items.centered_text,
					page = {
						environment = "profile_editor",
						type = "IngameProfileEditorSelectionPage",
						camera = "character_editor",
						layout_settings = "ProfileEditorSettings.pages.ingame_profile_editor_selection",
						disable_preview = true,
						enable_chat = true,
						hide_banner = true,
						sounds = MenuSettings.sounds.profile_editor,
						item_groups = {
							menu_items = {},
							header_items = {
								{
									text = "main_profile_selection",
									disabled = true,
									type = "HeaderItem",
									text_func = "cb_profile_name",
									no_localization = true,
									callback_object = "page",
									layout_settings = ProfileEditorSettings.items.team_colored_header
								}
							},
							page_name = {
								{
									text = "menu_profile_selection",
									name = "name",
									disabled = true,
									type = "HeaderItem",
									layout_settings = ProfileEditorSettings.items.name
								}
							},
							prev_link = {
								{
									text = "menu_select_team",
									name = "select_team",
									layout_settings = "ProfileEditorSettings.items.prev_link",
									type = "HeaderItem",
									on_select = "cb_goto",
									on_select_args = {
										"select_team"
									}
								}
							},
							back_list = {
								{
									text = "menu_spawn",
									name = "spawn",
									on_select = "cb_spawn",
									type = "HeaderItem",
									layout_settings = "ProfileEditorSettings.items.next_link",
									callback_object = "page"
								}
							}
						}
					}
				},
				{
					text = "menu_select_team",
					visible_func = "cb_return_to_team_selection_visible",
					remove_func = "cb_in_tutorial",
					type = "HeaderItem",
					id = "select_team_ingame",
					on_select = "cb_return_to_team_selection",
					layout_settings = MainMenuSettings.items.centered_text
				},
				{
					text = "menu_select_squad",
					id = "select_squad_ingame",
					disabled_func = "cb_join_squad_disabled",
					type = "HeaderItem",
					remove_func = "cb_in_tutorial",
					on_select = "cb_return_to_squad_selection",
					layout_settings = MainMenuSettings.items.centered_text
				},
				{
					text = "menu_settings",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_text,
					page = {
						z = 50,
						environment = "blurred",
						on_enter_page = "cb_set_banner_material_variation",
						type = "WotvMenuPage",
						name = "menu_settings",
						layout_settings = "IngameMenuSettings.pages.wotv_page",
						show_revision = true,
						on_enter_page_args = {
							"units/menu/menu_banner"
						},
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = IngameMenuSettingsItems,
							page_name = {
								{
									layout_settings = "MainMenuSettings.items.centered_text",
									disabled = true,
									on_enter_text = "cb_page_name",
									type = "HeaderItem",
									callback_object = "page"
								}
							}
						}
					}
				},
				{
					text = "menu_ingame_leave_battle",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_text,
					page = {
						layout_settings = "IngameMenuSettings.pages.wotv_sub_level",
						z = 50,
						environment = "blurred",
						type = "WotvMenuPage",
						name = "menu_ingame_leave_battle",
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									text = "menu_confirm_leave_battle",
									disabled = true,
									type = "HeaderItem",
									layout_settings = MainMenuSettings.items.centered_menu_header
								},
								{
									text = "main_menu_yes",
									on_select = "cb_leave_game",
									type = "HeaderItem",
									layout_settings = MainMenuSettings.items.centered_text
								},
								{
									text = "main_menu_no",
									on_select = "cb_return_to_main",
									type = "HeaderItem",
									callback_object = "page",
									layout_settings = MainMenuSettings.items.centered_text
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
							}
						}
					}
				},
				{
					disabled = true,
					type = "TextureMenuItem",
					layout_settings = MainMenuSettings.items.delimiter_texture
				},
				{
					text = "menu_ingame_return_to_battle",
					on_select = "cb_return_to_battle",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_text
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
			}
		}
	}
}
