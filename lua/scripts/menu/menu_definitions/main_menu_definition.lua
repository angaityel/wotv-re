-- chunkname: @scripts/menu/menu_definitions/main_menu_definition.lua

require("scripts/settings/menu_settings")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1920")
require("scripts/menu/menu_definitions/loading_screen_menu_settings_1366")
require("scripts/settings/coat_of_arms")
require("gui/textures/loading_atlas")
require("scripts/menu/menu_definitions/server_browser_page_definition")
require("scripts/menu/menu_definitions/server_browser_page_settings_1920")
require("scripts/menu/menu_definitions/server_browser_page_settings_1366")
require("scripts/menu/menu_definitions/key_mapping_page_definition")
require("scripts/menu/menu_definitions/credits_page_definition")
require("scripts/menu/menu_definitions/credits_page_settings_1920")
require("scripts/menu/menu_definitions/credits_page_settings_1366")

HOST_ITEM = {
	text = "main_menu_host",
	type = "HeaderItem",
	remove_func = "cb_has_debug_host_lobby",
	layout_settings = MainMenuSettings.items.centered_text,
	page = {
		z = 100,
		type = "StandardMenuPage",
		layout_settings = MainMenuSettings.pages.lobby,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			item_list = {
				{
					disabled = true,
					id = "lobby_host",
					type = "LobbyHostMenuItem",
					layout_settings = MainMenuSettings.items.lobby_host
				}
			}
		}
	}
}
JOIN_ITEM = {
	text = "main_menu_join",
	type = "HeaderItem",
	remove_func = "cb_has_debug_join_lobby",
	layout_settings = MainMenuSettings.items.centered_text,
	page = {
		z = 100,
		type = "StandardMenuPage",
		layout_settings = MainMenuSettings.pages.join_lobby,
		sounds = MenuSettings.sounds.default,
		item_groups = {
			item_list = {
				{
					disabled = true,
					id = "lobby_join",
					type = "LobbyJoinMenuItem",
					layout_settings = MainMenuSettings.items.lobby_join
				}
			}
		}
	}
}
HOW_TO_PLAY_PAGE = {
	z = 50,
	environment = "blurred",
	on_enter_page = "cb_set_banner_material_variation",
	type = "WotvMenuPage",
	name = "menu_settings",
	show_revision = false,
	on_enter_page_args = {
		"units/menu/menu_banner_2"
	},
	layout_settings = MainMenuSettings.pages.how_to_play_page,
	sounds = MenuSettings.sounds.default,
	item_groups = {
		item_list = {
			{
				disabled = true,
				type = "TextureMenuItem",
				layout_settings = MainMenuSettings.items.how_to_play
			}
		},
		page_name = {
			{
				text = "main_menu_cancel",
				name = "cancel",
				on_select = "cb_cancel",
				type = "HeaderItem",
				callback_object = "page",
				layout_settings = ProfileEditorSettings.items.prev_link,
				sounds = MenuSettings.sounds.default.items.cancel
			}
		},
		links = {
			{
				text = "main_menu_next",
				name = "next",
				type = "HeaderItem",
				id = "end_of_tutorial",
				layout_settings = ProfileEditorSettings.items.next_link,
				sounds = MenuSettings.sounds.default.items.cancel,
				page = {
					z = 50,
					environment = "blurred",
					on_enter_page = "cb_set_banner_material_variation",
					type = "WotvMenuPage",
					name = "menu_how_to_play_page2",
					show_revision = false,
					on_enter_page_args = {
						"units/menu/menu_banner_2"
					},
					layout_settings = MainMenuSettings.pages.how_to_play_end_of_tutorial_page,
					sounds = MenuSettings.sounds.default,
					item_groups = {
						item_list = {
							{
								disabled = true,
								type = "TextureMenuItem",
								layout_settings = MainMenuSettings.items.how_to_play_end_of_tutorial
							}
						},
						page_name = {
							{
								text = "main_menu_previous",
								name = "previous",
								on_select = "cb_cancel",
								type = "HeaderItem",
								callback_object = "page",
								layout_settings = ProfileEditorSettings.items.prev_link,
								sounds = MenuSettings.sounds.default.items.cancel
							}
						},
						links = {
							{
								text = "main_menu_main",
								name = "goto_title_screen",
								on_select = "cb_goto_root",
								type = "HeaderItem",
								callback_object = "page",
								layout_settings = ProfileEditorSettings.items.next_link,
								sounds = MenuSettings.sounds.default.items.cancel
							}
						}
					}
				}
			}
		}
	}
}
MainMenuDefinition = {
	page = {
		name = "main_menu_main",
		on_enter_page = "cb_set_banner_material_variation",
		type = "WotvMenuPage",
		update_condition = "cb_camera_positioned",
		environment = "default",
		z = 1,
		camera = "title_screen",
		layout_settings = "MainMenuSettings.pages.wotv_page",
		on_enter_page_args = {
			"units/menu/menu_banner_2"
		},
		sounds = MenuSettings.sounds.default,
		item_groups = {
			item_list = {
				{
					text = "main_menu_play_online",
					disabled_func = "cb_steam_server_browser_disabled",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_text,
					page = ServerBrowserPage
				},
				{
					text = "menu_how_to_play",
					type = "HeaderItem",
					id = "how_to_play",
					layout_settings = MainMenuSettings.items.centered_text,
					page = HOW_TO_PLAY_PAGE
				},
				HOST_ITEM,
				JOIN_ITEM,
				{
					text = "main_menu_tutorial",
					disabled_func = "cb_disable_single_player",
					demo_icon = true,
					type = "HeaderItem",
					id = "single_player_level_select",
					layout_settings = "MainMenuSettings.items.centered_text",
					on_select = "cb_start_tutorial"
				},
				{
					callback_object = "MainMenuCallbacks",
					text = "main_menu_edit_profiles",
					type = "NewUnlockHeaderItem",
					on_enter_required_rank = "cb_loudout_required_rank",
					layout_settings = "MainMenuSettings.items.centered_new_unlock_text",
					on_enter_unviewed_item = "cb_has_unviewed_unlocks",
					sounds = MenuSettings.sounds.default.items.profile_editor,
					disabled = GameSettingsDevelopment.disable_character_profiles_editor,
					page = {
						layout_settings = "ProfileEditorSettings.pages.profile_editor_selection",
						environment = "profile_editor",
						type = "ProfileEditorSelectionPage",
						camera = "character_editor",
						sounds = MenuSettings.sounds.profile_editor,
						item_groups = {
							menu_items = {},
							header_items = {
								{
									text = "main_profile_selection",
									name = "profile_name",
									disabled = true,
									type = "HeaderItem",
									text_func = "cb_profile_name",
									no_localization = true,
									layout_settings = "ProfileEditorSettings.items.team_colored_header",
									callback_object = "page"
								}
							},
							coat_of_arms_link = {
								{
									name = "coat_of_arms_link",
									on_highlight = "cb_coat_of_arms_highlighted",
									type = "NewUnlockTextMenuItem",
									text = "menu_coat_of_arms",
									callback_object = "page",
									layout_settings = "ProfileEditorSettings.items.coat_of_arms_header_item",
									on_enter_unviewed_item = "cb_has_unviewed_coat_of_arms",
									sounds = MenuSettings.sounds.default.items.profile_editor,
									page = {
										layout_settings = "ProfileEditorSettings.pages.wotv_coat_of_arms",
										environment = "coat_of_arms",
										type = "CoatOfArmsWotvMenuPage",
										camera = "coat_of_arms",
										sounds = MenuSettings.sounds.default,
										item_groups = {
											header_items = {
												{
													text = "menu_coat_of_arms",
													disabled = true,
													layout_settings = "ProfileEditorSettings.items.coat_of_arms_header",
													type = "HeaderItem",
													callback_object = "page"
												}
											},
											page_name = {
												{
													text = "menu_coat_of_arms",
													name = "name",
													disabled = true,
													type = "HeaderItem",
													layout_settings = ProfileEditorSettings.items.name
												}
											},
											prev_link = {
												{
													text = "main_menu_cancel",
													name = "cancel",
													on_select = "cb_cancel",
													type = "HeaderItem",
													callback_object = "page",
													layout_settings = ProfileEditorSettings.items.prev_link,
													sounds = MenuSettings.sounds.default.items.cancel
												}
											},
											team_switch = {
												{
													name = "team_switch",
													callback_object = "page",
													type = "SwitchMenuItem",
													on_select = "cb_change_team",
													layout_settings = ProfileEditorSettings.items.team_switch
												}
											}
										}
									}
								}
							},
							team_switch = {
								{
									name = "team_switch",
									callback_object = "page",
									type = "SwitchMenuItem",
									on_select = "cb_change_team",
									layout_settings = ProfileEditorSettings.items.team_switch
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
									text = "main_menu_cancel",
									name = "cancel",
									on_select = "cb_cancel",
									type = "HeaderItem",
									remove_func = "cb_controller_enabled",
									callback_object = "page",
									layout_settings = ProfileEditorSettings.items.prev_link,
									sounds = MenuSettings.sounds.default.items.cancel
								}
							}
						}
					}
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
						show_revision = true,
						on_enter_page_args = {
							"units/menu/menu_banner_2"
						},
						layout_settings = MainMenuSettings.pages.wotv_page,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									text = "menu_audio_settings",
									type = "HeaderItem",
									layout_settings = MainMenuSettings.items.centered_text,
									page = {
										z = 100,
										on_enter_page = "cb_set_banner_material_variation",
										type = "WotvMenuPage",
										name = "menu_audio_settings",
										show_revision = true,
										header_text = "menu_audio_settings",
										on_enter_page_args = {
											"units/menu/menu_banner_no_logo_2"
										},
										layout_settings = MainMenuSettings.pages.wotv_audio_sub_level,
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
										show_revision = true,
										on_enter_page_args = {
											"units/menu/menu_banner_no_logo_2"
										},
										layout_settings = MainMenuSettings.pages.wotv_video_settings,
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
														layout_settings = "MainMenuSettings.pages.ddl_center_aligned",
														show_revision = true,
														on_option_changed = "cb_resolution_option_changed",
														sounds = MenuSettings.sounds.default,
														item_groups = {
															scroll_bar = {
																{
																	layout_settings = "MainMenuSettings.items.wotv_drop_down_list_scroll_bar",
																	disabled_func = "cb_scroll_bar_disabled",
																	type = "ScrollBarMenuItem",
																	on_select_down = "cb_scroll_bar_select_down",
																	callback_object = "page"
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
										show_revision = true,
										on_enter_page_args = {
											"units/menu/menu_banner_no_logo_2"
										},
										layout_settings = MainMenuSettings.pages.wotv_gameplay_sub_level,
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
													on_init_options = "cb_mouse_sensitivity_options",
													text = "menu_mouse_sensitivity",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_mouse_sensitivity_option_changed",
													layout_settings = MainMenuSettings.items.centered_slider
												},
												{
													on_init_options = "cb_aim_multiplier_options",
													text = "menu_mouse_sensitivity_first_person",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_aim_multiplier_option_changed",
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
													on_init_options = "cb_keyboard_parry_options",
													text = "menu_keyboard_parry",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_keyboard_parry_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_keyboard_pose_options",
													text = "menu_keyboard_pose",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_keyboard_pose_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_invert_pose_control_x_options",
													text = "menu_invert_swing_control_x",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_invert_pose_control_x_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_invert_pose_control_y_options",
													text = "menu_invert_swing_control_y",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_invert_pose_control_y_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_invert_parry_control_x_options",
													text = "menu_invert_parry_control_x",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_invert_parry_control_x_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_invert_parry_control_y_options",
													text = "menu_invert_parry_control_y",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_invert_parry_control_y_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_double_tap_dodge_options",
													text = "menu_double_tap_dodge",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_double_tap_dodge_changed",
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
												KeyMappingPageDefinition.main_menu_definition,
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
										show_revision = true,
										on_enter_page_args = {
											"units/menu/menu_banner_no_logo_2"
										},
										layout_settings = MainMenuSettings.pages.wotv_gameplay_sub_level,
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
													on_init_options = "cb_show_reticule_options",
													text = "menu_show_reticule",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_reticule_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum
												},
												{
													on_init_options = "cb_show_reticule_color_a_options",
													text = "menu_reticule_a",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_show_reticule_color_a_option_changed",
													layout_settings = MainMenuSettings.items.centered_slider
												},
												{
													on_init_options = "cb_show_reticule_color_r_options",
													text = "menu_reticule_r",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_show_reticule_color_r_option_changed",
													layout_settings = MainMenuSettings.items.centered_slider
												},
												{
													on_init_options = "cb_show_reticule_color_g_options",
													text = "menu_reticule_g",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_show_reticule_color_g_option_changed",
													layout_settings = MainMenuSettings.items.centered_slider
												},
												{
													on_init_options = "cb_show_reticule_color_b_options",
													text = "menu_reticule_b",
													type = "EnumSliderMenuItem",
													on_option_changed = "cb_show_reticule_color_b_option_changed",
													layout_settings = MainMenuSettings.items.centered_slider
												},
												{
													disabled = true,
													type = "TextureMenuItem",
													layout_settings = MainMenuSettings.items.delimiter_texture
												},
												{
													on_init_options = "cb_show_hud_options",
													text = "menu_show_hud",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_hud_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_show_combat_text_options",
													text = "menu_show_combat_text",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_combat_text_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_show_xp_awards",
													text = "menu_show_xp_awards",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_xp_awards_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_show_parry_helper",
													text = "menu_show_parry_helper",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_parry_helper_option_changed",
													layout_settings = MainMenuSettings.items.centered_enum_checkbox
												},
												{
													on_init_options = "cb_show_pose_charge_helper",
													text = "menu_show_pose_charge_helper",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_pose_charge_helper_option_changed",
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
													on_init_options = "cb_show_announcements",
													text = "menu_show_announcements",
													type = "NewEnumMenuItem",
													on_option_changed = "cb_show_announcements_option_changed",
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
							},
							page_name = {
								{
									layout_settings = "MainMenuSettings.items.centered_text",
									disabled = true,
									on_enter_text = "cb_page_name",
									type = "HeaderItem",
									disable_sounds = true,
									callback_object = "page"
								}
							}
						}
					}
				},
				CreditsPageDefinition,
				{
					disabled = true,
					type = "TextureMenuItem",
					layout_settings = MainMenuSettings.items.delimiter_texture
				},
				{
					text = "main_menu_exit_game",
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.exit_header_text,
					page = {
						layout_settings = "MainMenuSettings.pages.wotv_sub_level",
						z = 50,
						environment = "blurred",
						type = "WotvMenuPage",
						name = "main_menu_exit_game",
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									text = "main_menu_confirm_exit_game",
									disabled = true,
									type = "HeaderItem",
									layout_settings = MainMenuSettings.items.centered_menu_header
								},
								{
									text = "main_menu_yes",
									on_select = "cb_exit_game",
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
									text = GameSettingsDevelopment.fix_version,
									type = "HeaderItem",
									callback_object = "page"
								}
							}
						}
					}
				},
				{
					disabled = true,
					text = GameSettingsDevelopment.fix_version,
					type = "HeaderItem",
					layout_settings = MainMenuSettings.items.centered_text,
				},
				{
					layout_settings = "MainMenuSettings.items.discord",
					name = "discord",
					type = "TextureLinkButtonMenuItem",
					remove_func = "cb_controller_enabled",
					on_select = "cb_open_link",
					on_select_args = {
						GameSettingsDevelopment.discord_url
					}
				},
				{
					layout_settings = "MainMenuSettings.items.steam_chat",
					name = "steam_chat",
					type = "TextureLinkButtonMenuItem",
					remove_func = "cb_controller_enabled",
					on_select = "cb_open_link",
					on_select_args = {
						GameSettingsDevelopment.steam_chat_url
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
}

function name_items(table)
	for key, item in pairs(table) do
		if item[1366] and item[1366][768] then
			item[1366][768].layout_name = key
		end

		if item[1680] and item[1680][1050] then
			item[1680][1050].layout_name = key
		end
	end
end

name_items(MainMenuSettings.items)
name_items(MainMenuSettings.pages)
