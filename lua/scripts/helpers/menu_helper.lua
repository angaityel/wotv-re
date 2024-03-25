-- chunkname: @scripts/helpers/menu_helper.lua

require("scripts/helpers/ui_settings_cache")

local UISettingsCache = UISettingsCache
local UISettingsCache_cached_setting = UISettingsCache.cached_setting
local UISettingsCache_store_setting = UISettingsCache.store_setting

MenuHelper = MenuHelper or {}
MenuHelper.resolution_width = MenuHelper.resolution_width or 0
MenuHelper.resolution_height = MenuHelper.resolution_height or 0
MenuHelper.count_table = MenuHelper.count_table or 0
MenuHelper.count_string = MenuHelper.count_string or 0
MenuHelper.max_count_table = MenuHelper.max_count_table or 0
MenuHelper.max_count_string = MenuHelper.max_count_string or 0
MenuHelper.cache = MenuHelper.cache or UISettingsCache.new()

function MenuHelper:update_resolution()
	MenuHelper.resolution_width, MenuHelper.resolution_height = Gui.resolution()
end

function MenuHelper:resolution()
	return MenuHelper.resolution_width, MenuHelper.resolution_height
end

function MenuHelper:clear_cache()
	MenuHelper.cache = UISettingsCache.new()
end

function MenuHelper:reset_counters()
	MenuHelper.count_table = 0
	MenuHelper.count_string = 0
end

function MenuHelper:layout_settings(settings_table)
	if type(settings_table) == "string" then
		return MenuHelper:layout_settings_string(settings_table)
	end

	local res_width, res_height = MenuHelper:resolution()
	local helper_cache = MenuHelper.cache
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

function MenuHelper:layout_settings_string(settings_string)
	local res_width, res_height = MenuHelper:resolution()
	local helper_cache = MenuHelper.cache
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

function MenuHelper:create_lookup_table(t)
	local lookup_table = table.clone(t)

	for index, str in ipairs(t) do
		lookup_table[str] = index
	end

	return lookup_table
end

function MenuHelper:container_position(container, layout_settings)
	local res_width, res_height = MenuHelper:resolution()
	local screen_x, screen_y, pivot_x, pivot_y
	local pivot_offset_multiplier_x = 1
	local pivot_offset_multiplier_y = 1

	if layout_settings.res_relative_x then
		pivot_offset_multiplier_x = res_width / layout_settings.res_relative_x
	end

	if layout_settings.res_relative_y then
		pivot_offset_multiplier_y = res_height / layout_settings.res_relative_y
	end

	if layout_settings.screen_align_x == "left" then
		screen_x = 0
	elseif layout_settings.screen_align_x == "center" then
		screen_x = res_width / 2
	elseif layout_settings.screen_align_x == "right" then
		screen_x = res_width
	end

	if layout_settings.screen_align_y == "bottom" then
		screen_y = 0
	elseif layout_settings.screen_align_y == "center" then
		screen_y = res_height / 2
	elseif layout_settings.screen_align_y == "top" then
		screen_y = res_height
	end

	screen_x = screen_x + layout_settings.screen_offset_x * res_width
	screen_y = screen_y + layout_settings.screen_offset_y * res_height

	if layout_settings.pivot_align_x == "left" then
		pivot_x = 0
	elseif layout_settings.pivot_align_x == "center" then
		pivot_x = container and -container:width() / 2 or 0
	elseif layout_settings.pivot_align_x == "right" then
		pivot_x = container and -container:width() or 0
	end

	if layout_settings.pivot_align_y == "bottom" then
		pivot_y = 0
	elseif layout_settings.pivot_align_y == "center" then
		pivot_y = container and -container:height() / 2 or 0
	elseif layout_settings.pivot_align_y == "top" then
		pivot_y = container and -container:height() or 0
	end

	pivot_x = pivot_x + (type(layout_settings.pivot_offset_x) == "function" and layout_settings.pivot_offset_x(res_width, res_height) or layout_settings.pivot_offset_x * pivot_offset_multiplier_x)
	pivot_y = pivot_y + (type(layout_settings.pivot_offset_y) == "function" and layout_settings.pivot_offset_y(res_width, res_height) or layout_settings.pivot_offset_y * pivot_offset_multiplier_y)

	local x = screen_x + pivot_x
	local y = screen_y + pivot_y

	return x, y
end

function MenuHelper:page_position(layout_settings)
	local res_width, res_height = MenuHelper:resolution()
	local screen_x, screen_y, pivot_x, pivot_y

	if layout_settings.screen_align_x == "left" then
		screen_x = 0
	elseif layout_settings.screen_align_x == "center" then
		screen_x = res_width / 2
	elseif layout_settings.screen_align_x == "right" then
		screen_x = res_width
	end

	if layout_settings.screen_align_y == "bottom" then
		screen_y = 0
	elseif layout_settings.screen_align_y == "center" then
		screen_y = res_height / 2
	elseif layout_settings.screen_align_y == "top" then
		screen_y = res_height
	end

	screen_x = screen_x + layout_settings.screen_offset_x * res_width
	screen_y = screen_y + layout_settings.screen_offset_y * res_height

	local pivot_x = type(layout_settings.pivot_offset_x) == "function" and layout_settings.pivot_offset_x(res_width, res_height) or layout_settings.pivot_offset_x
	local pivot_y = type(layout_settings.pivot_offset_y) == "function" and layout_settings.pivot_offset_y(res_width, res_height) or layout_settings.pivot_offset_y
	local x = screen_x + pivot_x
	local y = screen_y + pivot_y

	return x, y
end

function MenuHelper.scale_to_fullscren(original_width, original_height, keep_aspect_ratio)
	local res_width, res_height = MenuHelper:resolution()
	local width, height

	if keep_aspect_ratio then
		width = res_width
		height = res_width * original_height / original_width
	else
		width = res_width
		height = res_height
	end

	return width, height
end

function MenuHelper:format_text(text, gui, font, font_size, max_width)
	return Gui.word_wrap(gui, text, font, font_size, max_width, " ", "-+&/*", "\n")
end

function MenuHelper:lines(str)
	local t = {}

	local function helper(line)
		table.insert(t, line)

		return ""
	end

	helper((str:gsub("(.-)\r?\n", helper)))

	return t
end

function MenuHelper:create_input_popup_page(world, parent_page, callback_object, on_enter_options, on_item_selected, cb_save_button_disabled, page_z, sounds, header_text, layout_settings_page, layout_settings_header, layout_settings_input, layout_settings_button, min_text_length, max_text_length, password)
	local compiler_data = {
		world = world
	}
	local page_config = {
		try_big_picture_input = true,
		on_enter_options = on_enter_options,
		on_item_selected = on_item_selected,
		z = page_z,
		layout_settings = layout_settings_page,
		sounds = sounds,
		big_picture_input_params = {
			bp_callback_object = "parent_page",
			bp_callback_name = "cb_set_profile_name",
			description = header_text,
			min_text_length = min_text_length,
			max_text_length = max_text_length,
			password = password
		}
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local header_config = {
		disabled = true,
		text = header_text,
		z = page_z + 1,
		layout_settings = layout_settings_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local input_config = {
		name = "text_input",
		z = page_z + 1,
		min_text_length = min_text_length,
		max_text_length = max_text_length,
		layout_settings = layout_settings_input,
		parent_page = page
	}
	local input_item = TextInputMenuItem.create_from_config({
		world = world
	}, input_config, page)

	page:add_item(input_item, "item_list")

	local cancel_btn_config = {
		text = "menu_cancel",
		on_select = "cb_item_selected",
		on_select_args = {
			"close"
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local cancel_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, cancel_btn_config, page)

	page:add_item(cancel_item, "button_list")

	local ok_btn_config = {
		text = "menu_ok",
		on_select = "cb_item_selected",
		disabled_func = cb_save_button_disabled and "cb_item_disabled",
		disabled_func_args = cb_save_button_disabled,
		on_select_args = {
			"close",
			"save"
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local ok_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, ok_btn_config, page)

	page:add_item(ok_item, "button_list")

	return page
end

function MenuHelper:create_confirmation_popup_page(world, parent_page, callback_object, on_enter_options, on_item_selected, page_z, sounds, header_text, message_text, layout_settings_page, layout_settings_header, layout_settings_message, layout_settings_button)
	local compiler_data = {
		world = world
	}
	local page_config = {
		on_enter_options = on_enter_options,
		on_item_selected = on_item_selected,
		z = page_z,
		layout_settings = layout_settings_page,
		sounds = sounds
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local header_config = {
		disabled = true,
		text = header_text,
		z = page_z + 1,
		layout_settings = layout_settings_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local message_config = {
		name = "text_message",
		disabled = true,
		text = message_text,
		z = page_z + 1,
		layout_settings = layout_settings_message,
		parent_page = page
	}
	local message_item = TextMenuItem.create_from_config({
		world = world
	}, message_config, page)

	page:add_item(message_item, "item_list")

	local cancel_btn_config = {
		text = "menu_cancel",
		on_select = "cb_item_selected",
		on_select_args = {
			"close"
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local cancel_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, cancel_btn_config, page)

	page:add_item(cancel_item, "button_list")

	local ok_btn_config = {
		text = "menu_ok",
		on_select = "cb_item_selected",
		on_select_args = {
			"close",
			"confirm"
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local ok_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, ok_btn_config, page)

	page:add_item(ok_item, "button_list")

	return page
end

function MenuHelper:cb_buy_entity_popup_selected(args)
	if args.action and args.action[1] == "purchase" then
		local market_items = Managers.persistence:market().items
		local market_item_name = args.action[2]
		local market_item = market_items[market_item_name]
		local popup_parent_page = args.action[3]
		local success_callback = args.action[4]

		Managers.persistence:purchase_item(market_item, callback(MenuHelper, "cb_purchase_complete"), success_callback)
	elseif args.action and args.action[1] == "wants_buy_gold" then
		local cb_wants_buy_gold = args.action[2]

		cb_wants_buy_gold(args.action[3], args.action[4])
	elseif args.action and args.action[1] == "reset_character" then
		args.action[2]()
	end
end

function MenuHelper:cb_purchase_complete(success)
	print("[MenuHelper:cb_purchase_complete] success:", success)

	if success then
		Managers.state.event:trigger("purchase_complete")

		local world = Application.main_world()
		local timpani_world = World.timpani_world(world)

		TimpaniWorld.trigger_event(timpani_world, MenuSettings.sounds.buy_item_success)
	end
end

function MenuHelper:create_purchase_market_item_popup_page(world, parent_page, market_item_type, market_item_name, message_args, page_z, sounds, reset_callback, success_callback)
	local layout_settings_page = MainMenuSettings.pages.text_input_popup
	local layout_settings_header = MainMenuSettings.items.popup_header
	local layout_settings_header_alert = MainMenuSettings.items.popup_header_alert
	local layout_settings_message = MainMenuSettings.items.popup_textbox
	local layout_settings_button = MainMenuSettings.items.popup_button
	local market_items = Managers.persistence:market().items
	local item = market_items[market_item_name]
	local header_text, message_text, insufficient_funds

	if not item then
		header_text = "menu_store_notice_confirmation_header"
		message_text = string.format("Item not found in backend!", message_args[1])

		Application.warning("Item not found in backend %q %q", market_item_type, market_item_name)
	else
		local prices = item.prices
		local price_table = prices[1]

		if not price_table then
			header_text = "menu_store_notice_confirmation_header"
			message_text = string.format("Item has no currency attached in backend!", message_args[2])

			Application.warning("Item does not have currency attached in backend %q %q", market_item_type, market_item_name)

			item = nil
		else
			local price = price_table.price
			local profile_data = Managers.persistence:profile_data()
			local profile_coins = profile_data.attributes.coins

			insufficient_funds = profile_coins < price

			if insufficient_funds then
				header_text = "menu_store_notice_insufficient_funds_header"
				message_text = string.format(L("menu_store_notice_insufficient_funds_message"), message_args[2], price, price - profile_coins)
			elseif market_item_type == "perk" then
				header_text = "menu_store_notice_confirmation_header"
				message_text = string.format(L("menu_store_notice_perk_confirmation"), message_args[2], price)
			elseif market_item_type == "gear_attachment" or market_item_type == "armour_attachment" or market_item_type == "helmet_attachment" then
				header_text = "menu_store_notice_confirmation_header"
				message_text = string.format(L("menu_store_notice_attachment_confirmation"), message_args[2], price)
			else
				header_text = "menu_store_notice_confirmation_header"
				message_text = string.format(L("menu_store_notice_item_confirmation"), message_args[2], price)
			end
		end
	end

	local compiler_data = {
		world = world
	}
	local page_config = {
		on_cancel_input = "cb_buy_entity_popup_selected",
		on_item_selected = "cb_buy_entity_popup_selected",
		z = page_z + 100,
		layout_settings = layout_settings_page,
		sounds = sounds,
		on_cancel_args = {
			action = {
				"reset_character",
				reset_callback and callback(parent_page, reset_callback)
			}
		}
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, MenuHelper)
	local header_config = {
		disabled = true,
		text = header_text,
		z = page_z + 1,
		layout_settings = insufficient_funds and layout_settings_header_alert or layout_settings_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local message_config = {
		disabled = true,
		no_localization = true,
		text = message_text,
		z = page_z + 1,
		layout_settings = layout_settings_message,
		parent_page = page
	}
	local message_item = TextBoxMenuItem.create_from_config({
		world = world
	}, message_config, page)

	page:add_item(message_item, "item_list")

	local cancel_btn_config = {
		text = "menu_cancel",
		on_select = "cb_item_selected",
		on_select_args = {
			"close",
			reset_callback and {
				"reset_character",
				callback(parent_page, reset_callback)
			} or nil
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local cancel_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, cancel_btn_config, page)

	page:add_item(cancel_item, "button_list")

	if not IS_DEMO and GameSettingsDevelopment.enable_micro_transactions and insufficient_funds and item then
		local btn_config = {
			text = "buy_gold_upper",
			on_select = "cb_item_selected",
			on_select_args = {
				"close",
				{
					"wants_buy_gold",
					callback(parent_page, "cb_wants_buy_gold"),
					reset_callback,
					success_callback
				}
			},
			z = page_z + 1,
			layout_settings = layout_settings_button,
			parent_page = page
		}
		local ok_item = TextureButtonMenuItem.create_from_config({
			world = world
		}, btn_config, page)

		page:add_item(ok_item, "button_list")
	end

	if not insufficient_funds and item then
		local ok_btn_config = {
			text = "menu_store_purchase",
			on_select = "cb_item_selected",
			on_select_args = {
				"close",
				{
					"purchase",
					market_item_name,
					[4] = success_callback
				}
			},
			z = page_z + 1,
			layout_settings = layout_settings_button,
			parent_page = page
		}
		local ok_item = TextureButtonMenuItem.create_from_config({
			world = world
		}, ok_btn_config, page)

		page:add_item(ok_item, "button_list")
	end

	return page
end

function MenuHelper:create_rank_not_met_popup_page(world, parent_page, entity_type, unlock_key, entity_ui_name, page_z, sounds, reset_callback)
	local layout_settings_page = MainMenuSettings.pages.message_popup
	local layout_settings_header = MainMenuSettings.items.popup_header
	local layout_settings_message = MainMenuSettings.items.popup_textbox
	local layout_settings_button = MainMenuSettings.items.popup_button
	local required_rank = ProfileHelper:required_entity_rank(entity_type, unlock_key)
	local missing_xp = ProfileHelper:xp_left_to_rank(required_rank)
	local message_text = string.format(L("menu_xplock_notice_message"), L(entity_ui_name), L(entity_ui_name), required_rank, missing_xp or "?")
	local compiler_data = {
		world = world
	}
	local page_config = {
		on_cancel_input = "cb_buy_entity_popup_selected",
		on_item_selected = "cb_buy_entity_popup_selected",
		z = page_z + 100,
		layout_settings = layout_settings_page,
		sounds = sounds,
		on_cancel_args = {
			action = {
				"reset_character",
				reset_callback and callback(parent_page, reset_callback)
			}
		}
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, MenuHelper)
	local header_config = {
		text = "menu_xplock_notice_header",
		disabled = true,
		z = page_z + 1,
		layout_settings = layout_settings_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local message_config = {
		disabled = true,
		no_localization = true,
		text = message_text,
		layout_settings = layout_settings_message,
		parent_page = page
	}
	local message_item = TextBoxMenuItem.create_from_config({
		world = world
	}, message_config, page)

	page:add_item(message_item, "item_list")

	local ok_btn_config = {
		text = "menu_ok",
		on_select = "cb_item_selected",
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page,
		on_select_args = {
			"close",
			reset_callback and {
				"reset_character",
				callback(parent_page, reset_callback)
			} or nil
		}
	}
	local ok_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, ok_btn_config, page)

	page:add_item(ok_item, "button_list")

	return page
end

function MenuHelper:create_locked_in_demo_popup_page(world, parent_page, page_z, sounds)
	return
end

function MenuHelper:create_filter_popup_page(world, parent_page, page_z, sounds)
	local layout_settings_page = MainMenuSettings.pages.filter_popup
	local compiler_data = {
		world = world
	}
	local page_config = {
		z = page_z + 100,
		layout_settings = layout_settings_page,
		sounds = sounds
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, parent_page)
	local header_config = {
		text = "menu_filter_settings",
		disabled = true,
		z = page_z + 1,
		layout_settings = MainMenuSettings.items.filter_popup_header,
		parent_page = parent_page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local compiler_data = {
		world = world
	}
	local game_mode_config = {
		on_enter_options = "cb_on_enter_options_local_filter_game_mode",
		on_option_changed = "cb_on_option_changed_local_filter_game_mode",
		layout_settings = ServerBrowserSettings.pages.popup_server_filter_ddl,
		sounds = MenuSettings.sounds.default,
		z = page_z + 150,
		callback_object = parent_page
	}
	local item_groups = {
		items = {}
	}
	local filter_game_mode_config = {
		on_enter_text = "cb_on_enter_text_local_filter_game_mode",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_ddl_closed_text,
		parent_page = parent_page,
		page = DropDownListMenuPage.create_from_config(compiler_data, game_mode_config, page, item_groups, parent_page)
	}
	local game_mode_page = DropDownListMenuItem.create_from_config({
		world = world
	}, filter_game_mode_config, parent_page)

	page:add_item(game_mode_page, "item_list")

	local compiler_data = {
		world = world
	}
	local level_config = {
		on_enter_options = "cb_on_enter_options_query_filter_level",
		on_option_changed = "cb_on_option_changed_query_filter_level_popup",
		layout_settings = ServerBrowserSettings.pages.popup_server_filter_ddl,
		sounds = MenuSettings.sounds.default,
		z = page_z + 150,
		callback_object = parent_page
	}
	local item_groups = {
		items = {}
	}
	local filter_level_config = {
		on_enter_text = "cb_on_enter_text_query_filter_level",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_ddl_closed_text,
		parent_page = parent_page,
		page = DropDownListMenuPage.create_from_config(compiler_data, level_config, page, item_groups, parent_page)
	}
	local filter_level_item = DropDownListMenuItem.create_from_config({
		world = world
	}, filter_level_config, parent_page)

	page:add_item(filter_level_item, "item_list")

	local filter_password_config = {
		text = "menu_password_protected",
		name = "local_filter_password",
		on_enter_select = "cb_on_enter_local_filter_password",
		on_select = "cb_on_select_local_filter_password_popup",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_checkbox,
		parent_page = parent_page
	}
	local filter_password = CheckboxMenuItem.create_from_config({
		world = world
	}, filter_password_config, parent_page)

	page:add_item(filter_password, "item_list")

	local filter_demo_config = {
		text = "menu_demo",
		name = "local_filter_demo",
		remove_func = "cb_demo_checkbox_remove",
		on_enter_select = "cb_on_enter_local_filter_demo",
		on_select = "cb_on_select_local_filter_demo_popup",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_checkbox,
		parent_page = parent_page
	}
	local filter_demo = CheckboxMenuItem.create_from_config({
		world = world
	}, filter_demo_config, parent_page)

	page:add_item(filter_demo, "item_list")

	local filter_only_available_config = {
		text = "menu_only_available",
		name = "local_filter_demo",
		on_enter_select = "cb_on_enter_local_filter_only_available",
		on_select = "cb_on_select_local_filter_only_available_popup",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_checkbox,
		parent_page = parent_page
	}
	local filter_only_available = CheckboxMenuItem.create_from_config({
		world = world
	}, filter_only_available_config, parent_page)

	page:add_item(filter_only_available, "item_list")

	local filter_not_full_config = {
		text = "menu_server_not_full",
		name = "query_filter_not_full",
		on_enter_select = "cb_on_enter_query_filter_not_full",
		on_select = "cb_on_select_query_filter_not_full_popup",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_checkbox,
		parent_page = parent_page
	}
	local filter_not_full = CheckboxMenuItem.create_from_config({
		world = world
	}, filter_not_full_config, parent_page)

	page:add_item(filter_not_full, "item_list")

	local filter_has_players_config = {
		text = "menu_server_has_players",
		name = "query_filter_has_players",
		on_enter_select = "cb_on_enter_query_filter_has_players",
		on_select = "cb_on_select_query_filter_has_players_popup",
		z = page_z + 1,
		layout_settings = ServerBrowserSettings.items.popup_filter_checkbox,
		parent_page = parent_page
	}
	local filter_has_players = CheckboxMenuItem.create_from_config({
		world = world
	}, filter_has_players_config, parent_page)

	page:add_item(filter_has_players, "item_list")

	return page
end

function MenuHelper:create_required_perk_popup_page(world, parent_page, ui_name, required_perk, page_z, sounds)
	local layout_settings_page = MainMenuSettings.pages.message_popup
	local layout_settings_header = MainMenuSettings.items.popup_header
	local layout_settings_message = MainMenuSettings.items.popup_textbox
	local layout_settings_button = MainMenuSettings.items.popup_button
	local required_perk_name = L(Perks[required_perk].ui_header)
	local message_text = string.format(L("menu_perk_needed_notice_message"), required_perk_name, ui_name)
	local compiler_data = {
		world = world
	}
	local page_config = {
		z = page_z + 100,
		layout_settings = layout_settings_page,
		sounds = sounds
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, MenuHelper)
	local header_config = {
		text = "menu_perk_needed_notice_header",
		disabled = true,
		z = page_z + 1,
		layout_settings = layout_settings_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local message_config = {
		disabled = true,
		no_localization = true,
		text = message_text,
		layout_settings = layout_settings_message,
		parent_page = page
	}
	local message_item = TextBoxMenuItem.create_from_config({
		world = world
	}, message_config, page)

	page:add_item(message_item, "item_list")

	local ok_btn_config = {
		text = "menu_ok",
		on_select = "cb_item_selected",
		on_select_args = {
			"close"
		},
		z = page_z + 1,
		layout_settings = layout_settings_button,
		parent_page = page
	}
	local ok_item = TextureButtonMenuItem.create_from_config({
		world = world
	}, ok_btn_config, page)

	page:add_item(ok_item, "button_list")

	return page
end

function MenuHelper:create_buy_gold_popup_page(world, parent_page, callback_object, on_enter_options, on_item_selected, page_z, sounds, reset_callback, success_callback)
	local page_config = {
		on_enter_options = on_enter_options,
		on_item_selected = on_item_selected,
		z = page_z,
		layout_settings = MainMenuSettings.pages.buy_gold_popup,
		sounds = sounds,
		on_cancel_input = reset_callback
	}
	local item_groups = {
		header_list = {},
		item_list = {},
		button_list = {}
	}
	local page = PopupMenuPage.create_from_config({
		world = world
	}, page_config, parent_page, item_groups, callback_object)
	local header_config = {
		text = "buy_gold",
		disabled = true,
		z = page_z + 1,
		layout_settings = MainMenuSettings.items.buy_coins_popup_header,
		parent_page = page
	}
	local header_item = TextMenuItem.create_from_config({
		world = world
	}, header_config, page)

	page:add_item(header_item, "header_list")

	local message_config = {
		text = "select_amount",
		name = "text_message",
		disabled = true,
		z = page_z + 1,
		layout_settings = MainMenuSettings.items.popup_text,
		parent_page = page
	}
	local message_item = TextMenuItem.create_from_config({
		world = world
	}, message_config, page)

	page:add_item(message_item, "item_list")

	local store = Managers.persistence:store()

	if store then
		local currency_code = "EUR"

		for i = 1, #store do
			local store_item = store[i]
			local id = store_item.id
			local description = store_item.descriptions.default
			local price = math.round(store_item.prices[currency_code] / 100, 2)
			local item_config = {
				no_localization = true,
				on_select = "cb_item_selected",
				on_select_args = {
					[2] = id
				},
				text = sprintf("%4.2f", price) .. " " .. currency_code,
				z = page_z + 1,
				layout_settings = table.clone(MainMenuSettings.items.coins_amount_button),
				parent_page = page
			}
			local layout_settings = item_config.layout_settings

			for _, rez in pairs(layout_settings) do
				for _, settings in pairs(rez) do
					settings.texture_middle = settings.texture_middle .. tostring(i)
					settings.texture_middle_highlighted = settings.texture_middle_highlighted .. tostring(i)
				end
			end

			local item = TextureButtonMenuItem.create_from_config({
				world = world
			}, item_config, page)

			page:add_item(item, "button_list")
		end
	end

	local cancel_btn_config = {
		on_select = "cb_item_selected",
		on_select_args = {
			"close",
			reset_callback and {
				"reset_character",
				callback(parent_page, reset_callback)
			} or nil
		},
		z = page_z + 1,
		layout_settings = MainMenuSettings.items.popup_close_texture,
		parent_page = page
	}
	local cancel_item = TextureMenuItem.create_from_config({
		world = world
	}, cancel_btn_config, page)

	page:add_item(cancel_item, "header_list")

	return page
end

function MenuHelper.outfit_menu_item_requirement_info(layout_settings, config)
	local texture, text, requirement_not_met

	if config.unavalible_reason == "required_perk" then
		texture = layout_settings.texture_unavalible_perk_required
		text = L(Perks[config.required_perk].ui_header)
		requirement_not_met = true
	elseif config.unavalible_reason == "rank_not_met" then
		texture = layout_settings.texture_unavalible_rank_not_met

		local required_rank = ProfileHelper:required_entity_rank(config.entity_type, config.unlock_key)

		text = required_rank
		requirement_not_met = true
	elseif config.unavalible_reason == "locked_in_demo" then
		texture = layout_settings.texture_unavalible_demo
		text = L("menu_demo_text")
		requirement_not_met = true
	elseif config.unavalible_reason == "not_owned" then
		texture = layout_settings.texture_unavalible_not_owned

		local market_items = Managers.persistence:market().items
		local item = market_items[config.market_item_name]

		if not item then
			text = string.format("Item not found in backend!", config.ui_name)

			Application.warning("Item not found in backend %q %q", config.entity_type, config.market_item_name)
		else
			local prices = item.prices
			local price_table = prices[1]

			if not price_table then
				text = string.format("Item has no currency attached in backend!", config.ui_name)

				Application.warning("Item does not have currency attached in backend %q %q", config.entity_type, config.market_item_name)
			else
				local price = price_table.price
				local profile_data = Managers.persistence:profile_data()
				local profile_coins = profile_data.attributes.coins

				text = price

				if profile_coins < price then
					requirement_not_met = true
				end
			end
		end
	end

	local text_color = requirement_not_met and layout_settings.requirement_not_met_color or layout_settings.color

	return texture, text, text_color
end

function MenuHelper:color(c)
	return Color(c[1], c[2], c[3], c[4])
end

function MenuHelper:localized_text(text)
	return L(text)
end

function MenuHelper.light_adaption_fix_shading_callback(world, shading_env)
	local reset = World.get_data(world, "luminance_reset")

	if reset then
		ShadingEnvironment.set_scalar(shading_env, "reset_luminance_adaption", 0)
	else
		ShadingEnvironment.set_scalar(shading_env, "reset_luminance_adaption", 1)
		World.set_data(world, "luminance_reset", true)
	end

	if Managers.state.camera then
		Managers.state.camera:shading_callback(world, shading_env)
	end
end

function MenuHelper.is_outside_screen(x, y, w, h, padding)
	local res_width, res_height = MenuHelper:resolution()

	if y + h + padding < 0 or res_height < y - padding or x + w + padding < 0 or res_width < x - padding then
		return true
	end
end

function MenuHelper.single_player_levels_sorted()
	local sorted_table = {}

	for level_key, config in pairs(LevelSettings) do
		if config.visible and config.single_player then
			sorted_table[#sorted_table + 1] = config
			sorted_table[#sorted_table].level_key = level_key
		end
	end

	table.sort(sorted_table, function(a, b)
		return a.sort_index < b.sort_index
	end)

	return sorted_table
end

function MenuHelper:render_border(gui, rect, thickness, color, layer, material)
	if material then
		Gui.bitmap(gui, material, Vector3(rect[1] - thickness, rect[2], layer or 1), Vector2(rect[3] + thickness * 2, -thickness), color)
		Gui.bitmap(gui, material, Vector3(rect[1], rect[2], layer or 1), Vector2(-thickness, rect[4]), color)
		Gui.bitmap(gui, material, Vector3(rect[1] + rect[3], rect[2], layer or 1), Vector2(thickness, rect[4]), color)
		Gui.bitmap(gui, material, Vector3(rect[1] - thickness, rect[2] + rect[4], layer or 1), Vector2(rect[3] + thickness * 2, thickness), color)
	else
		Gui.rect(gui, Vector3(rect[1] - thickness, rect[2], layer or 1), Vector2(rect[3] + thickness * 2, -thickness), color)
		Gui.rect(gui, Vector3(rect[1], rect[2], layer or 1), Vector2(-thickness, rect[4]), color)
		Gui.rect(gui, Vector3(rect[1] + rect[3], rect[2], layer or 1), Vector2(thickness, rect[4]), color)
		Gui.rect(gui, Vector3(rect[1] - thickness, rect[2] + rect[4], layer or 1), Vector2(rect[3] + thickness * 2, thickness), color)
	end
end

function MenuHelper:render_border_alternative(gui, pos, size, thickness, color, layer, material)
	if material then
		Gui.bitmap(gui, material, Vector3(pos[1] - thickness, pos[2], layer or 1), Vector2(size[1] + thickness * 2, -thickness), color)
		Gui.bitmap(gui, material, Vector3(pos[1], pos[2], layer or 1), Vector2(-thickness, size[2]), color)
		Gui.bitmap(gui, material, Vector3(pos[1] + size[1], pos[2], layer or 1), Vector2(thickness, size[2]), color)
		Gui.bitmap(gui, material, Vector3(pos[1] - thickness, pos[2] + size[2], layer or 1), Vector2(size[1] + thickness * 2, thickness), color)
	else
		Gui.rect(gui, Vector3(pos[1] - thickness, pos[2], layer or 1), Vector2(size[1] + thickness * 2, -thickness), color)
		Gui.rect(gui, Vector3(pos[1], pos[2], layer or 1), Vector2(-thickness, size[2]), color)
		Gui.rect(gui, Vector3(pos[1] + size[1], pos[2], layer or 1), Vector2(thickness, size[2]), color)
		Gui.rect(gui, Vector3(pos[1] - thickness, pos[2] + size[2], layer or 1), Vector2(size[1] + thickness * 2, thickness), color)
	end
end

function MenuHelper:render_wotv_menu_banner(dt, t, gui)
	local pos = Vector3(0, 0, -1)
	local w, h = MenuHelper:resolution()
	local scale_x = w / 1920
	local scale_y = h / 1080
	local material, uv00, uv11, size = HUDHelper.atlas_material("menu_assets", "bottom_banner_tile")
	local size = Vector2(size[1] * scale_x, size[2] * scale_y)

	while w > pos[1] do
		Gui.bitmap_uv(gui, material, uv00, uv11, pos, size)

		pos[1] = pos[1] + size[1]
	end
end

function MenuHelper:align_text(origin_x, origin_y, text_width, text_height, alignement_x, alignement_y)
	local x, y = origin_x, origin_y

	if alignement_x == "center" then
		x = origin_x - text_width / 2
	elseif alignement_x == "right" then
		x = origin_x - text_width
	elseif alignement_x == "left" then
		x = origin_x
	end

	if alignement_y == "center" then
		y = origin_y - text_height / 2
	elseif alignement_y == "top" then
		y = origin_y - text_height
	elseif alignement_y == "bottom" then
		y = origin_y
	end

	return x, y
end

function MenuHelper:debug_alignement_line(gui, position, alignement, color)
	local w, h = Application.resolution()
	local pos, size

	if alignement == "horizontal" then
		position.x = 0
		size = Vector2(w, 2)
	else
		position.y = 0
		size = Vector2(2, h)
	end

	position.z = 999

	Gui.rect(gui, position, size, color or Color(255, 255, 0, 255))
end

function MenuHelper:squad_menu_background(gui, position, size)
	Gui.rect(gui, position, size, Color(120, 0, 0, 0))
end

function MenuHelper:squad_menu_border(gui, position, size)
	MenuHelper:render_border(gui, {
		position.x,
		position.y,
		size.x,
		size.y
	}, 3, Color(180, 0, 0, 0), position.z)
end

function MenuHelper:point_within_rect(point_x, point_y, rect_x, rect_y, rect_width, rect_height)
	local x1 = rect_x
	local y1 = rect_y
	local x2 = x1 + rect_width
	local y2 = y1 + rect_height

	return x1 <= point_x and point_x <= x2 and y1 <= point_y and point_y <= y2
end

function MenuHelper:intersection_rect(one_x, one_y, one_width, one_height, two_x, two_y, two_width, two_height)
	local intersection = false
	local x, y, width, height
	local x_min = math.max(one_x, two_x)
	local x_max = math.min(one_x + one_width, two_x + two_width)

	if x_min < x_max then
		local y_min = math.max(one_y, two_y)
		local y_max = math.min(one_y + one_height, two_y + two_height)

		if y_min < y_max then
			intersection = true
			x = x_min
			y = y_min
			width = x_max - x_min
			height = y_max - y_min
		end
	end

	return intersection, x, y, width, height
end

function MenuHelper:render_texture_background_rect(dt, t, gui, layout_settings, available, highlighted, alpha, x, y, z, width, height)
	local texture = layout_settings.texture

	if texture then
		local color = self:_render_background_color_func(not available and layout_settings.disabled_rect_color or highlighted and not layout_settings.avoid_highlight and layout_settings.highlighted_rect_color or layout_settings.rect_color, alpha)
		local atlas = layout_settings.texture_atlas

		if atlas then
			local material = HUDHelper.atlas_material(atlas, texture, layout_settings.masked)

			ScriptGUI.bitmap_uv_tiled(gui, material, HUDHelper.atlas_texture_settings(atlas, texture), Vector3(x, y, z), Vector2(width, height), color)
		else
			local tile_x = math.ceil(width / layout_settings.texture_size[1])
			local tile_y = math.ceil(height / layout_settings.texture_size[2])

			for i = 1, tile_x do
				for j = 1, tile_y do
					local uv11 = Vector2(math.min((width - (i - 1) * layout_settings.texture_size[1]) / layout_settings.texture_size[1], 1), math.min((height - (j - 1) * layout_settings.texture_size[2]) / layout_settings.texture_size[2], 1))
					local pos = Vector3(x + (i - 1) * layout_settings.texture_size[1], y + (j - 1) * layout_settings.texture_size[2], z)
					local size = Vector2(layout_settings.texture_size[1] * uv11[1], layout_settings.texture_size[2] * uv11[2])

					Gui.bitmap_uv(gui, texture, Vector2(0, 0), uv11, pos, size, color)
				end
			end
		end
	else
		Gui.rect(gui, Vector3(x, y, z), Vector2(width, height), self:_render_background_color_func(not available and layout_settings.disabled_rect_color or highlighted and not layout_settings.avoid_highlight and layout_settings.highlighted_rect_color or layout_settings.rect_color, alpha))
	end

	if layout_settings.border_texture_atlas then
		self:_render_border_piece(gui, layout_settings, x, y + height, z, width, layout_settings.border_thickness, nil, true, alpha)
		self:_render_border_piece(gui, layout_settings, x + width, y, z, width, layout_settings.border_thickness, -180, false, alpha)
		self:_render_border_piece(gui, layout_settings, x, y, z, height, layout_settings.border_thickness, -90, true, alpha)
		self:_render_border_piece(gui, layout_settings, x + width, y + height, z, height, layout_settings.border_thickness, 90, false, alpha)
		self:_render_border_corners(gui, layout_settings, x, y, z + 1, width, height, alpha)
	else
		self:render_border(gui, {
			x,
			y,
			width,
			height
		}, layout_settings.border_thickness, self:_render_background_color_func(highlighted and available and layout_settings.highlighted_border_color or layout_settings.border_color, alpha))
	end
end

function MenuHelper:_render_border_piece(gui, layout_settings, x, y, z, width, height, rotate_angle, flip, alpha)
	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_material, layout_settings.masked)
	local uv_size = uv11 - uv00
	local size_diff = width / size[1]
	local curr_x = x
	local color = self:_render_background_color_func(layout_settings.border_color or {
		255,
		255,
		255,
		255
	}, alpha)

	repeat
		local new_uv11 = Vector2(uv11[1], uv11[2])

		new_uv11[1] = uv00[1] + math.min(size_diff, 1) * uv_size[1]

		local new_size = Vector2(size[1], size[2])

		new_size[1] = size[1] * math.min(size_diff, 1)

		if rotate_angle then
			local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(rotate_angle), Vector2(curr_x, y))

			if flip then
				Gui.bitmap_3d_uv(gui, material, uv00, new_uv11, rot, Vector3(curr_x + new_size[1], y, z), z, Vector2(-new_size[1], new_size[2]), color)
			else
				Gui.bitmap_3d_uv(gui, material, uv00, new_uv11, rot, Vector3(curr_x, y, z), z, new_size, color)
			end

			if flip then
				curr_x = curr_x + size[1]
			else
				curr_x = curr_x - size[1]
			end
		elseif flip then
			Gui.bitmap_uv(gui, material, uv00, new_uv11, Vector3(curr_x + new_size[1], y, z), Vector2(-new_size[1], new_size[2]), color)

			curr_x = curr_x + size[1]
		else
			Gui.bitmap_uv(gui, material, uv00, new_uv11, Vector3(curr_x, y, z), new_size, color)

			curr_x = curr_x - size[1]
		end

		size_diff = size_diff - 1
	until size_diff <= 0
end

function MenuHelper:_render_border_corners(gui, layout_settings, x, y, z, width, height, alpha)
	if not layout_settings.border_corner_material then
		return
	end

	local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_corner_material, layout_settings.masked)
	local offset = layout_settings.border_corner_offset or {
		0,
		0
	}
	local pos = Vector3(x + offset[1], y + height + offset[2], z - 1)
	local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)
	local color = self:_render_background_color_func(layout_settings.border_color or {
		255,
		255,
		255,
		255
	}, alpha)

	Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size, color)

	if layout_settings.border_corner_small_material then
		local material, uv00, uv11, size = HUDHelper.atlas_material(layout_settings.border_texture_atlas, layout_settings.border_corner_small_material, layout_settings.masked)
		local offset = layout_settings.border_corner_small_offset or {
			0,
			0
		}
		local pos = Vector3(x + offset[1], y + offset[2], 0)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(270), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size, color)

		local pos = Vector3(x + width - offset[2], y + offset[1], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(-180), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size, color)

		local pos = Vector3(x + width - offset[1], y + height - offset[2], z + 1)
		local rot = Rotation2D(Vector2(0, 0), math.degrees_to_radians(90), pos)

		Gui.bitmap_3d_uv(gui, material, uv00, uv11, rot, pos, z + 1, size, color)
	else
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x - size[1], y - layout_settings.border_thickness, 0), size, color)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + width - size[1], y - layout_settings.border_thickness, z - 1), size, color)
		Gui.bitmap_uv(gui, material, uv00, uv11, Vector3(x + width - size[1], y + height, z), size, color)
	end
end

function MenuHelper:_render_background_color_func(colour, alpha)
	return Color(colour[1] * alpha, colour[2], colour[3], colour[4])
end
