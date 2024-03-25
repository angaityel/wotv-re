-- chunkname: @scripts/menu/menu_definitions/splash_screen_definition.lua

require("scripts/menu/menu_definitions/main_menu_settings_1920")
require("scripts/menu/menu_definitions/main_menu_settings_1366")
require("scripts/menu/menu_definitions/main_menu_settings_low")

SplashScreenSettings = SplashScreenSettings or {}
SplashScreenSettings.items = SplashScreenSettings.items or {}
SplashScreenSettings.pages = SplashScreenSettings.pages or {}
SplashScreenSettings.music_events = {
	return_to_menu = {
		"Play_main_menu_ambience"
	}
}
SplashScreenSettings.items.loading_indicator = SplashScreenSettings.items.loading_indicator or {}
SplashScreenSettings.items.loading_indicator[1680] = SplashScreenSettings.items.loading_indicator[1680] or {}
SplashScreenSettings.items.loading_indicator[1680][1050] = SplashScreenSettings.items.loading_indicator[1680][1050] or table.clone(LoadingScreenMenuSettings.items.loading_indicator[1680][1050])
SplashScreenSettings.items.loading_indicator[1680][1050].screen_align_x = "left"
SplashScreenSettings.items.loading_indicator[1680][1050].screen_offset_x = 0.03
SplashScreenSettings.items.loading_indicator[1680][1050].pivot_align_x = "right"
SplashScreenSettings.items.fatshark_splash = SplashScreenSettings.items.fatshark_splash or {}
SplashScreenSettings.items.fatshark_splash[1680] = SplashScreenSettings.items.fatshark_splash[1680] or {}
SplashScreenSettings.items.fatshark_splash[1680][1050] = SplashScreenSettings.items.fatshark_splash[1680][1050] or {
	padding_top = 0,
	video_height = 720,
	padding_bottom = 0,
	padding_left = 0,
	fullscreen = true,
	padding_right = 0,
	video_width = 1280,
	video = MenuSettings.videos.fatshark_splash
}
SplashScreenSettings.items.paradox_splash = SplashScreenSettings.items.paradox_splash or {}
SplashScreenSettings.items.paradox_splash[1680] = SplashScreenSettings.items.paradox_splash[1680] or {}
SplashScreenSettings.items.paradox_splash[1680][1050] = SplashScreenSettings.items.paradox_splash[1680][1050] or {
	padding_top = 0,
	video_height = 720,
	padding_bottom = 0,
	padding_left = 0,
	fullscreen = true,
	padding_right = 0,
	video_width = 1280,
	video = MenuSettings.videos.paradox_splash
}
SplashScreenSettings.items.physx_splash = SplashScreenSettings.items.physx_splash or {}
SplashScreenSettings.items.physx_splash[1680] = SplashScreenSettings.items.physx_splash[1680] or {}
SplashScreenSettings.items.physx_splash[1680][1050] = SplashScreenSettings.items.physx_splash[1680][1050] or {
	padding_top = 0,
	video_height = 720,
	padding_bottom = 0,
	padding_left = 0,
	fullscreen = true,
	padding_right = 0,
	video_width = 1280,
	video = MenuSettings.videos.physx_splash
}
SplashScreenSettings.items.wotv_splash = SplashScreenSettings.items.wotv_splash or {}
SplashScreenSettings.items.wotv_splash[1680] = SplashScreenSettings.items.wotv_splash[1680] or {}
SplashScreenSettings.items.wotv_splash[1680][1050] = SplashScreenSettings.items.wotv_splash[1680][1050] or {
	padding_top = 0,
	video_height = 720,
	padding_bottom = 0,
	padding_left = 0,
	fullscreen = true,
	padding_right = 0,
	video_width = 1280,
	video = MenuSettings.videos.wotv_splash
}
SplashScreenSettings.items.bitsquid_splash = SplashScreenSettings.items.bitsquid_splash or {}
SplashScreenSettings.items.bitsquid_splash[1680] = SplashScreenSettings.items.bitsquid_splash[1680] or {}
SplashScreenSettings.items.bitsquid_splash[1680][1050] = SplashScreenSettings.items.bitsquid_splash[1680][1050] or {
	padding_left = 0,
	padding_top = 0,
	padding_right = 0,
	padding_bottom = 0
}
SplashScreenSettings.items.popup_button_small_text = SplashScreenSettings.items.popup_button_small_text or {}
SplashScreenSettings.items.popup_button_small_text[1680] = SplashScreenSettings.items.popup_button_small_text[1680] or {}
SplashScreenSettings.items.popup_button_small_text[1680][1050] = SplashScreenSettings.items.popup_button_small_text[1680][1050] or table.clone(MainMenuSettings.items.popup_button[1680][1050])
SplashScreenSettings.items.popup_button_small_text[1680][1050].font = MenuSettings.fonts.hell_shark_20
SplashScreenSettings.items.popup_button_small_text[1680][1050].font_size = 20
SplashScreenSettings.items.popup_button_small_text[1680][1050].text_offset_y = 24
SplashScreenSettings.items.popup_button_small_text[1680][1050].padding_left = 0
SplashScreenSettings.items.popup_button_small_text[1680][1050].padding_right = 0
SplashScreenSettings.items.expandable_popup_checkbox = SplashScreenSettings.items.expandable_popup_checkbox or {}
SplashScreenSettings.items.expandable_popup_checkbox[1680] = SplashScreenSettings.items.expandable_popup_checkbox[1680] or {}
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050] = SplashScreenSettings.items.expandable_popup_checkbox[1680][1050] or table.clone(ServerBrowserSettings.items.server_filter_checkbox[1680][1050])
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].texture_selected_offset_x = 5
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].texture_deselected_offset_x = 5
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].padding_top = 20
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].padding_bottom = 20
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].padding_left = 46
SplashScreenSettings.items.expandable_popup_checkbox[1680][1050].padding_right = 0
SplashScreenSettings.pages.splash_screen = SplashScreenSettings.pages.splash_screen or {}
SplashScreenSettings.pages.splash_screen[1680] = SplashScreenSettings.pages.splash_screen[1680] or {}
SplashScreenSettings.pages.splash_screen[1680][1050] = SplashScreenSettings.pages.splash_screen[1680][1050] or {
	do_not_render_buttons = true,
	item_list = {
		screen_align_y = "center",
		screen_offset_x = 0,
		pivot_offset_x = 0,
		screen_offset_y = 0,
		pivot_align_x = "center",
		pivot_align_y = "center",
		screen_align_x = "center",
		pivot_offset_y = 0
	}
}
SplashScreenSettings.pages.error_popup = SplashScreenSettings.pages.error_popup or {}
SplashScreenSettings.pages.error_popup[1680] = SplashScreenSettings.pages.error_popup[1680] or {}
SplashScreenSettings.pages.error_popup[1680][1050] = SplashScreenSettings.pages.error_popup[1680][1050] or table.clone(MainMenuSettings.pages.text_input_popup[1680][1050])
SplashScreenSettings.pages.error_popup[1680][1050].overlay_texture = nil
SplashScreenSettings.items.popup_button_small_text = SplashScreenSettings.items.popup_button_small_text or {}
SplashScreenSettings.items.popup_button_small_text[1366] = SplashScreenSettings.items.popup_button_small_text[1366] or {}
SplashScreenSettings.items.popup_button_small_text[1366][768] = SplashScreenSettings.items.popup_button_small_text[1366][768] or table.clone(MainMenuSettings.items.popup_button[1366][768])
SplashScreenSettings.items.popup_button_small_text[1366][768].font = MenuSettings.fonts.hell_shark_16
SplashScreenSettings.items.popup_button_small_text[1366][768].font_size = 16
SplashScreenSettings.items.popup_button_small_text[1366][768].text_offset_y = 18
SplashScreenSettings.items.popup_button_small_text[1366][768].padding_left = 0
SplashScreenSettings.items.popup_button_small_text[1366][768].padding_right = 0
SplashScreenSettings.items.expandable_popup_checkbox = SplashScreenSettings.items.expandable_popup_checkbox or {}
SplashScreenSettings.items.expandable_popup_checkbox[1366] = SplashScreenSettings.items.expandable_popup_checkbox[1366] or {}
SplashScreenSettings.items.expandable_popup_checkbox[1366][768] = SplashScreenSettings.items.expandable_popup_checkbox[1366][768] or table.clone(ServerBrowserSettings.items.server_filter_checkbox[1366][768])
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].texture_selected_offset_x = 4
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].texture_deselected_offset_x = 4
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].padding_top = 14
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].padding_bottom = 14
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].padding_left = 33
SplashScreenSettings.items.expandable_popup_checkbox[1366][768].padding_right = 0
SplashScreenSettings.pages.error_popup = SplashScreenSettings.pages.error_popup or {}
SplashScreenSettings.pages.error_popup[1366] = SplashScreenSettings.pages.error_popup[1366] or {}
SplashScreenSettings.pages.error_popup[1366][768] = SplashScreenSettings.pages.error_popup[1366][768] or table.clone(MainMenuSettings.pages.text_input_popup[1366][768])
SplashScreenSettings.pages.error_popup[1366][768].overlay_texture = nil
SplashScreenSettings.items.changelog_textbox = SplashScreenSettings.items.changelog_textbox or {}
SplashScreenSettings.items.changelog_textbox[1680] = SplashScreenSettings.items.changelog_textbox[1680] or {}
SplashScreenSettings.items.changelog_textbox[1680][1050] = SplashScreenSettings.items.changelog_textbox[1680][1050] or {
	max_height = 787,
	text_align = "left",
	render_from_top = true,
	padding_left = 18,
	font_size = 18,
	padding_top = 0,
	min_height = 284,
	padding_bottom = 0,
	line_height = 18,
	padding_right = 0,
	width = 500,
	can_scroll = true,
	font = MenuSettings.fonts.hell_shark_18,
	color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
SplashScreenSettings.items.changelog_textbox = SplashScreenSettings.items.changelog_textbox or {}
SplashScreenSettings.items.changelog_textbox[1366] = SplashScreenSettings.items.changelog_textbox[1366] or {}
SplashScreenSettings.items.changelog_textbox[1366][768] = SplashScreenSettings.items.changelog_textbox[1366][768] or {
	max_height = 576,
	text_align = "left",
	render_from_top = true,
	padding_left = 18,
	font_size = 16,
	padding_top = 0,
	min_height = 284,
	padding_bottom = 0,
	line_height = 16,
	padding_right = 0,
	width = 400,
	can_scroll = true,
	font = MenuSettings.fonts.hell_shark_16,
	color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
SplashScreenSettings.items.changelog_textbox = SplashScreenSettings.items.changelog_textbox or {}
SplashScreenSettings.items.changelog_textbox[1024] = SplashScreenSettings.items.changelog_textbox[1024] or {}
SplashScreenSettings.items.changelog_textbox[1024][768] = SplashScreenSettings.items.changelog_textbox[1024][768] or {
	max_height = 576,
	text_align = "left",
	render_from_top = true,
	padding_left = 18,
	font_size = 14,
	padding_top = 0,
	min_height = 284,
	padding_bottom = 0,
	line_height = 18,
	padding_right = 0,
	width = 400,
	can_scroll = true,
	font = MenuSettings.fonts.hell_shark_14,
	color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
SplashScreenSettings.items.changelog_textbox = SplashScreenSettings.items.changelog_textbox or {}
SplashScreenSettings.items.changelog_textbox[800] = SplashScreenSettings.items.changelog_textbox[800] or {}
SplashScreenSettings.items.changelog_textbox[800][600] = SplashScreenSettings.items.changelog_textbox[800][600] or {
	max_height = 480,
	text_align = "left",
	render_from_top = true,
	padding_left = 18,
	font_size = 12,
	padding_top = 0,
	min_height = 284,
	padding_bottom = 0,
	line_height = 10,
	padding_right = 0,
	width = 400,
	can_scroll = true,
	font = MenuSettings.fonts.hell_shark_12,
	color = {
		255,
		255,
		255,
		255
	},
	drop_shadow_color = {
		120,
		0,
		0,
		0
	},
	drop_shadow_offset = {
		2,
		-2
	}
}
SplashScreenSettings.items.scroll_bar = SplashScreenSettings.items.scroll_bar or {}
SplashScreenSettings.items.scroll_bar[1680] = SplashScreenSettings.items.scroll_bar[1680] or {}
SplashScreenSettings.items.scroll_bar[1680][1050] = SplashScreenSettings.items.scroll_bar[1680][768] or {
	scroll_bar_handle_width = 6,
	width = 16,
	scroll_bar_width = 2,
	scroll_bar_handle_color = {
		255,
		215,
		215,
		215
	},
	scroll_bar_color = {
		50,
		130,
		130,
		130
	},
	background_color = {
		220,
		20,
		20,
		20
	}
}
SplashScreenDefinition = {
	page = {
		type = "EmptyMenuPage",
		item_groups = {
			item_list = {
				{
					id = "disconnect_reason_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_error_popup_enter",
						on_item_selected = "cb_error_popup_item_selected",
						in_splash_screen = true,
						reverse_input_direction = true,
						layout_settings = SplashScreenSettings.pages.error_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "error_server_disconnect",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = MainMenuSettings.items.popup_header
								}
							},
							item_list = {
								{
									text = "menu_empty",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									layout_settings = MainMenuSettings.items.popup_textbox
								}
							},
							button_list = {
								{
									text = "menu_ok",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"continue"
									},
									layout_settings = MainMenuSettings.items.popup_button
								}
							}
						}
					}
				},
				{
					id = "error_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_error_popup_enter",
						on_item_selected = "cb_error_popup_item_selected",
						in_splash_screen = true,
						reverse_input_direction = true,
						layout_settings = SplashScreenSettings.pages.error_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "error_an_error_occured",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = MainMenuSettings.items.popup_header
								}
							},
							item_list = {
								{
									text = "menu_empty",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									layout_settings = MainMenuSettings.items.popup_textbox
								}
							},
							button_list = {
								{
									text = "error_continue_anyway",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"continue"
									},
									layout_settings = MainMenuSettings.items.popup_button
								},
								{
									text = "error_exit_game",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"quit_game"
									},
									layout_settings = MainMenuSettings.items.popup_button
								}
							}
						}
					}
				},
				{
					id = "nda_confirm_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_error_popup_enter",
						on_item_selected = "cb_error_popup_item_selected",
						in_splash_screen = true,
						reverse_input_direction = true,
						layout_settings = SplashScreenSettings.pages.error_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "nda_confirm_needed",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = MainMenuSettings.items.popup_header
								}
							},
							item_list = {
								{
									text = "menu_empty",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									layout_settings = MainMenuSettings.items.popup_textbox
								}
							},
							button_list = {
								{
									text = "i_agree",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"continue"
									},
									layout_settings = SplashScreenSettings.items.popup_button_small_text
								},
								{
									text = "error_exit_game",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"quit_game"
									},
									layout_settings = MainMenuSettings.items.popup_button
								}
							}
						}
					}
				},
				{
					id = "fatal_error_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_error_popup_enter",
						in_splash_screen = true,
						on_item_selected = "cb_error_popup_item_selected",
						layout_settings = SplashScreenSettings.pages.error_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "error_an_error_occured",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = MainMenuSettings.items.popup_header
								}
							},
							item_list = {
								{
									text = "menu_empty",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									layout_settings = MainMenuSettings.items.popup_textbox
								}
							},
							button_list = {
								{
									text = "error_exit_game",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"quit_game"
									},
									layout_settings = MainMenuSettings.items.popup_button
								}
							}
						}
					}
				},
				{
					id = "fatal_error_with_http_link_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_error_popup_enter",
						on_item_selected = "cb_error_popup_item_selected",
						in_splash_screen = true,
						reverse_input_direction = true,
						layout_settings = SplashScreenSettings.pages.error_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "error_an_error_occured",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = MainMenuSettings.items.popup_header
								}
							},
							item_list = {
								{
									text = "menu_empty",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									layout_settings = MainMenuSettings.items.popup_textbox
								}
							},
							button_list = {
								{
									on_select = "cb_open_url_in_browser",
									type = "TextureMenuItem",
									on_select_args = {
										"https://twitter.com/WotRSupport"
									},
									layout_settings = MainMenuSettings.items.popup_twitter_link
								},
								{
									text = "error_exit_game",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"quit_game"
									},
									layout_settings = MainMenuSettings.items.popup_button
								}
							}
						}
					}
				},
				{
					id = "changelog_popup",
					type = "EmptyMenuItem",
					page = {
						type = "ExpandablePopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_changelog_popup_enter",
						on_item_selected = "cb_changelog_popup_item_selected",
						in_splash_screen = true,
						reverse_input_direction = true,
						layout_settings = MainMenuSettings.pages.expandable_popup,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							scroll_bar = {
								{
									name = "scrolly",
									disabled_func = "cb_scroll_disabled",
									type = "ScrollBarMenuItem",
									on_resolution_change = "cb_scroll_disabled",
									on_select_down = "cb_scroll_select_down",
									callback_object = "page",
									layout_settings = SplashScreenSettings.items.scroll_bar
								}
							},
							item_list = {
								{
									text = "",
									name = "popup_header",
									disabled = true,
									type = "TextMenuItem",
									no_localization = true,
									layout_settings = MainMenuSettings.items.expandable_popup_header
								},
								{
									type = "EmptyMenuItem",
									layout_settings = MainMenuSettings.items.empty
								},
								{
									type = "EmptyMenuItem",
									layout_settings = MainMenuSettings.items.empty
								},
								{
									text = "",
									name = "popup_text",
									disabled = true,
									type = "TextBoxMenuItem",
									no_localization = true,
									can_scroll = true,
									layout_settings = SplashScreenSettings.items.changelog_textbox
								},
								{
									type = "EmptyMenuItem",
									layout_settings = MainMenuSettings.items.empty
								},
								{
									type = "EmptyMenuItem",
									layout_settings = MainMenuSettings.items.empty
								},
								{
									text = "dont_show_this_again",
									name = "omit_changelog_checkbox",
									type = "CheckboxMenuItem",
									layout_settings = SplashScreenSettings.items.expandable_popup_checkbox
								},
								{
									text = "close",
									callback_object = "page",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close"
									},
									layout_settings = MainMenuSettings.items.changelog_popup_button
								},
								{
									type = "EmptyMenuItem",
									layout_settings = MainMenuSettings.items.empty
								}
							}
						}
					}
				},
				{
					id = "pdx_os_login_popup",
					type = "EmptyMenuItem",
					page = {
						type = "PDXPopupMenuPage",
						z = 200,
						no_cancel_to_parent_page = true,
						on_enter_options = "cb_pdx_login_popup_enter",
						in_splash_screen = true,
						on_item_selected = "cb_pdx_login_popup_item_selected",
						layout_settings = "MainMenuSettings.pages.pdx_login",
						sounds = MenuSettings.sounds.default,
						item_groups = {
							header_list = {
								{
									text = "paradox_accounts_login",
									disabled = true,
									layout_settings = "MainMenuSettings.items.pdx_login_popup_header",
									type = "TextMenuItem"
								}
							},
							item_list = {
								{
									text = "menu_email",
									disabled = true,
									layout_settings = "MainMenuSettings.items.popup_text",
									type = "TextMenuItem"
								},
								{
									relative_height = 0.01,
									disabled = true,
									layout_settings = "MainMenuSettings.items.empty",
									type = "EmptyMenuItem"
								},
								{
									layout_settings = "MainMenuSettings.items.pdx_login_input",
									name = "popup_email",
									min_text_length = 1,
									type = "SelectableTextInputMenuItem",
									needs_highlight = true,
									max_text_length = 50
								},
								{
									relative_height = 0.01,
									disabled = true,
									layout_settings = "MainMenuSettings.items.empty",
									type = "EmptyMenuItem"
								},
								{
									text = "menu_password",
									disabled = true,
									layout_settings = "MainMenuSettings.items.popup_text",
									type = "TextMenuItem"
								},
								{
									relative_height = 0.01,
									disabled = true,
									layout_settings = "MainMenuSettings.items.empty",
									type = "EmptyMenuItem"
								},
								{
									layout_settings = "MainMenuSettings.items.pdx_login_input_password",
									name = "popup_password",
									min_text_length = 1,
									type = "SelectableTextInputMenuItem",
									needs_highlight = true,
									max_text_length = 50
								},
								{
									relative_height = 0.01,
									disabled = true,
									layout_settings = "MainMenuSettings.items.empty",
									type = "EmptyMenuItem"
								},
								{
									text = "",
									name = "error_message",
									disabled = true,
									type = "TextMenuItem",
									layout_settings = "MainMenuSettings.items.pdx_login_popup_error_text"
								}
							},
							button_list = {
								{
									callback_object = "page",
									name = "popup_login",
									disabled_func_args = "cb_pdx_account_login_button_disabled",
									type = "TextureButtonMenuItem",
									layout_settings = "MainMenuSettings.items.pdx_login_popup_button",
									on_select = "cb_item_selected",
									text = "menu_login",
									disabled_func = "cb_item_disabled",
									on_select_args = {
										"close",
										"login"
									}
								},
								{
									text = "menu_create",
									layout_settings = "MainMenuSettings.items.pdx_login_popup_button",
									type = "TextureButtonMenuItem",
									on_select = "cb_open_url_in_steam_overlay",
									on_select_args = {
										"https://accounts.paradoxplaza.com/new-user"
									}
								},
								{
									text = "error_exit_game",
									callback_object = "page",
									layout_settings = "MainMenuSettings.items.pdx_login_popup_button",
									type = "TextureButtonMenuItem",
									on_select = "cb_item_selected",
									on_select_args = {
										"close",
										"quit_game"
									}
								}
							}
						}
					}
				},
				{
					id = "splash_screen_start",
					type = "EmptyMenuItem",
					page = {
						z = 200,
						no_cancel_to_parent_page = true,
						type = "SplashScreenMenuPage",
						on_continue_input = "cb_goto_next_splash_screen",
						layout_settings = SplashScreenSettings.pages.splash_screen,
						sounds = MenuSettings.sounds.default,
						item_groups = {
							item_list = {
								{
									disabled = true,
									on_video_end = "cb_goto_next_splash_screen",
									type = "VideoMenuItem",
									layout_settings = SplashScreenSettings.items.paradox_splash,
									page = {
										z = 200,
										no_cancel_to_parent_page = true,
										type = "SplashScreenMenuPage",
										on_continue_input = "cb_goto_next_splash_screen",
										layout_settings = SplashScreenSettings.pages.splash_screen,
										sounds = MenuSettings.sounds.default,
										item_groups = {
											item_list = {
												{
													disabled = true,
													on_video_end = "cb_goto_next_splash_screen",
													type = "VideoMenuItem",
													layout_settings = SplashScreenSettings.items.fatshark_splash,
													page = {
														z = 200,
														no_cancel_to_parent_page = true,
														type = "SplashScreenMenuPage",
														on_continue_input = "cb_goto_next_splash_screen",
														layout_settings = SplashScreenSettings.pages.splash_screen,
														sounds = MenuSettings.sounds.default,
														item_groups = {
															item_list = {
																{
																	on_video_end = "cb_goto_next_splash_screen",
																	music_event = "Play_main_menu_ambience",
																	disabled = true,
																	type = "BitsquidSplashMenuItem",
																	layout_settings = SplashScreenSettings.items.bitsquid_splash,
																	page = {
																		z = 200,
																		no_cancel_to_parent_page = true,
																		type = "SplashScreenMenuPage",
																		layout_settings = SplashScreenSettings.pages.splash_screen,
																		sounds = MenuSettings.sounds.default,
																		item_groups = {
																			item_list = {
																				{
																					on_video_end = "cb_goto_main_menu",
																					disabled = true,
																					type = "VideoMenuItem",
																					layout_settings = SplashScreenSettings.items.wotv_splash
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
