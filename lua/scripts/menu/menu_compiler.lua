-- chunkname: @scripts/menu/menu_compiler.lua

require("scripts/menu/menu_pages/menu_page")
require("scripts/menu/menu_pages/category_list_page")
require("scripts/menu/menu_pages/profile_editor_selection_page")
require("scripts/menu/menu_pages/ingame_profile_editor_selection_page")
require("scripts/menu/menu_pages/ingame_squad_selection_page")
require("scripts/menu/menu_pages/gear_list_page")
require("scripts/menu/menu_pages/perk_list_page")
require("scripts/menu/menu_pages/archetype_list_page")
require("scripts/menu/menu_pages/standard_menu_page")
require("scripts/menu/menu_pages/level_1_menu_page")
require("scripts/menu/menu_pages/level_2_menu_page")
require("scripts/menu/menu_pages/level_3_menu_page")
require("scripts/menu/menu_pages/wotv_sub_menu_page")
require("scripts/menu/menu_pages/wotv_menu_page")
require("scripts/menu/menu_pages/video_settings_menu_page")
require("scripts/menu/menu_pages/drop_down_list_menu_page")
require("scripts/menu/menu_pages/outfit_drop_down_list_menu_page")
require("scripts/menu/menu_pages/loading_screen_menu_page")
require("scripts/menu/menu_pages/key_mappings_menu_page")
require("scripts/menu/menu_pages/key_mapping_menu_page")
require("scripts/menu/menu_pages/key_mapping_pad_menu_page")
require("scripts/menu/menu_pages/coat_of_arms_wotv_menu_page")
require("scripts/menu/menu_pages/teams_menu_page")
require("scripts/menu/menu_pages/final_scoreboard_menu_page")
require("scripts/menu/menu_pages/profile_viewer_menu_page")
require("scripts/menu/menu_pages/empty_menu_page")
require("scripts/menu/menu_pages/profile_editor_main_page")
require("scripts/menu/menu_pages/popup_menu_page")
require("scripts/menu/menu_pages/pdx_os_popup_menu_page")
require("scripts/menu/menu_pages/demo_popup_menu_page")
require("scripts/menu/menu_pages/team_selection_menu_page")
require("scripts/menu/menu_pages/server_browser_menu_page")
require("scripts/menu/menu_pages/battle_report_base_menu_page")
require("scripts/menu/menu_pages/battle_report_scoreboard_menu_page")
require("scripts/menu/menu_pages/ingame_scoreboard_menu_page")
require("scripts/menu/menu_pages/battle_report_summary_menu_page")
require("scripts/menu/menu_pages/battle_report_awards_menu_page")
require("scripts/menu/menu_pages/splash_screen_menu_page")
require("scripts/menu/menu_pages/credits_menu_page")
require("scripts/menu/menu_pages/expandable_popup_menu_page")
require("scripts/menu/menu_pages/tier_list_page")
require("scripts/menu/menu_containers/stat_grid_menu_container")
require("scripts/menu/menu_containers/simple_grid_menu_container")
require("scripts/menu/menu_containers/profile_editor_rect_menu_container")
require("scripts/menu/menu_containers/tier_grid_menu_container")
require("scripts/menu/menu_items/menu_item")
require("scripts/menu/menu_items/experience_menu_item")
require("scripts/menu/menu_items/switch_menu_item")
require("scripts/menu/menu_items/category_item")
require("scripts/menu/menu_items/gear_item")
require("scripts/menu/menu_items/header_item")
require("scripts/menu/menu_items/team_scoreboard_menu_item")
require("scripts/menu/menu_items/squad_score_menu_item")
require("scripts/menu/menu_items/player_scoreboard_menu_item")
require("scripts/menu/menu_items/text_menu_item")
require("scripts/menu/menu_items/scoreboard_header_menu_item")
require("scripts/menu/menu_items/division_text_menu_item")
require("scripts/menu/menu_items/checkbox_menu_item")
require("scripts/menu/menu_items/texture_menu_item")
require("scripts/menu/menu_items/enum_menu_item")
require("scripts/menu/menu_items/new_enum_menu_item")
require("scripts/menu/menu_items/enum_slider_menu_item")
require("scripts/menu/menu_items/lobby_host_menu_item")
require("scripts/menu/menu_items/lobby_join_menu_item")
require("scripts/menu/menu_items/drop_down_list_menu_item")
require("scripts/menu/menu_items/button_menu_item")
require("scripts/menu/menu_items/squad_text_menu_item")
require("scripts/menu/menu_items/key_mapping_menu_item")
require("scripts/menu/menu_items/coat_of_arms_menu_item")
require("scripts/menu/menu_items/coat_of_arms_color_picker_menu_item")
require("scripts/menu/menu_items/texture_button_menu_item")
require("scripts/menu/menu_items/texture_link_button_menu_item")
require("scripts/menu/menu_items/texture_button_countdown_menu_item")
require("scripts/menu/menu_items/empty_menu_item")
require("scripts/menu/menu_items/progress_bar_menu_item")
require("scripts/menu/menu_items/text_input_menu_item")
require("scripts/menu/menu_items/selectable_text_input_menu_item")
require("scripts/menu/menu_items/text_box_menu_item")
require("scripts/menu/menu_items/server_menu_item")
require("scripts/menu/menu_items/column_header_text_menu_item")
require("scripts/menu/menu_items/column_header_texture_menu_item")
require("scripts/menu/menu_items/player_info_menu_item")
require("scripts/menu/menu_items/scroll_bar_menu_item")
require("scripts/menu/menu_items/tab_menu_item")
require("scripts/menu/menu_items/loading_texture_menu_item")
require("scripts/menu/menu_items/animated_texture_menu_item")
require("scripts/menu/menu_items/battle_report_scoreboard_menu_item")
require("scripts/menu/menu_items/battle_report_summary_menu_item")
require("scripts/menu/menu_items/battle_report_summary_total_menu_item")
require("scripts/menu/menu_items/battle_report_summary_award_menu_item")
require("scripts/menu/menu_items/video_menu_item")
require("scripts/menu/menu_items/bitsquid_splash_menu_item")
require("scripts/menu/menu_items/url_texture_menu_item")
require("scripts/menu/menu_items/arrow_menu_item")
require("scripts/menu/menu_items/new_unlock_header_item")
require("scripts/menu/menu_items/new_unlock_text_menu_item")
require("scripts/menu/hierachical_layout_menu/hl_menu_component")
require("scripts/menu/hierachical_layout_menu/base_containers/hl_menu_container")
require("scripts/menu/hierachical_layout_menu/base_containers/hl_menu_grid_container")
require("scripts/menu/hierachical_layout_menu/base_containers/hl_menu_scroll_container")
require("scripts/menu/hierachical_layout_menu/base_items/hl_menu_item")
require("scripts/menu/hierachical_layout_menu/base_items/hl_atlas_texture_menu_item")
require("scripts/menu/hierachical_layout_menu/base_items/hl_text_menu_item")
require("scripts/menu/hierachical_layout_menu/base_pages/hl_menu_page")
require("scripts/menu/hierachical_layout_menu/custom_pages/hl_squad_selection_menu_page")
require("scripts/menu/hierachical_layout_menu/custom_items/hl_squad_member_name_menu_item")
require("scripts/menu/hierachical_layout_menu/base_containers/hl_menu_list_container")

MenuCompiler = class(MenuCompiler)

function MenuCompiler:init(data)
	self._data = data
end

function MenuCompiler:compile(menu_def)
	local shortcut_table = {}

	return self:_compile_page(table.clone(menu_def.page), nil, shortcut_table), shortcut_table
end

function MenuCompiler:_compile_page(page_config, parent_page, shortcut_table, ...)
	local page
	local item_groups = {}

	for group_name, _ in pairs(page_config.item_groups) do
		item_groups[group_name] = {}
	end

	local callback_object = self._data.callback_object

	if page_config.callback_object == "parent_page" then
		callback_object = parent_page
	end

	local page_class = rawget(_G, page_config.type)

	page = page_class.create_from_config(self._data, page_config, parent_page, item_groups, callback_object)

	local key = 1

	for group_name, items in pairs(page_config.item_groups) do
		for _, item_config in ipairs(items) do
			local item

			if ... then
				item = self:_compile_item(item_config, page, shortcut_table, ..., key)
			else
				item = self:_compile_item(item_config, page, shortcut_table, key)
			end

			page:add_item(item, group_name)

			if item_config.id then
				fassert(not shortcut_table[item_config.id], "[MenuLogic] Id already assigned %s", item_config.id)

				local shortcut = {
					...
				}

				shortcut[#shortcut + 1] = key
				shortcut_table[item_config.id] = shortcut
			end

			key = key + 1
		end
	end

	return page
end

function MenuCompiler:_compile_page_new(page_config, parent_page, shortcut_table, ...)
	local callback_object = self._data.callback_object

	if page_config.callback_object == "parent_page" then
		callback_object = parent_page
	end

	local key = 1
	local page_class = rawget(_G, page_config.type)
	local page = page_class.create_from_config(self._data, page_config, parent_page, callback_object)

	for _, component_config in ipairs(page_config.components) do
		local namespace_shortcut_table = {}
		local component

		if ... then
			component = self:_compile_component(component_config, page, namespace_shortcut_table, shortcut_table, ..., key)
		else
			component = self:_compile_component(component_config, page, namespace_shortcut_table, shortcut_table, key)
		end

		page:add_component(component)

		if component_config.id then
			fassert(not shortcut_table[component_config.id], "[MenuLogic] Id already assigned %s", component_config.id)

			local shortcut = {
				...
			}

			shortcut[#shortcut + 1] = key
			shortcut_table[component_config.id] = shortcut
		end

		key = key + 1
	end

	return page
end

function MenuCompiler:_compile_item(item_config, parent_page, shortcut_table, ...)
	fassert(item_config.type, "Item type not declared")

	if item_config.page then
		item_config.page = item_config.page.hierachical_layout_menu and self:_compile_page_new(item_config.page, parent_page, shortcut_table, ...) or self:_compile_page(item_config.page, parent_page, shortcut_table, ...)
	end

	item_config.parent_page = parent_page

	local callback_object = self._data.callback_object

	if item_config.callback_object == "page" then
		callback_object = parent_page
	elseif item_config.callback_object ~= nil then
		callback_object = rawget(_G, item_config.callback_object)
	end

	local item_class = rawget(_G, item_config.type)
	local item = item_class.create_from_config(self._data, item_config, callback_object)

	return item
end

function MenuCompiler:_compile_component(component_config, parent_page, namespace_shortcut_table, shortcut_table, ...)
	fassert(component_config.type, "Item type not declared")

	local component_config = table.clone(component_config)

	component_config.parent_page = parent_page

	local callback_object = self._data.callback_object
	local component_callback_object = component_config.callback_object

	if component_callback_object == "page" then
		callback_object = parent_page
	elseif component_callback_object ~= nil then
		callback_object = rawget(_G, component_callback_object)
	end

	local namespace_path = table.clone(namespace_shortcut_table)
	local namespace_path_parent = table.clone(namespace_shortcut_table)
	local namespace = component_config.namespace

	if namespace then
		namespace_path[#namespace_path + 1] = namespace
	end

	local components = {}

	if component_config.components then
		for _, component_definition in ipairs(component_config.components) do
			if component_definition.page then
				components[#components + 1] = component_config.page.hierachical_layout_menu and self:_compile_page_new(component_config.page, parent_page, shortcut_table, ...) or self:_compile_page(component_config.page, parent_page, shortcut_table, ...)
			else
				components[#components + 1] = self:_compile_component(component_definition, parent_page, namespace_path)
			end
		end

		component_config.components = nil
	end

	component_config.namespace_path = table.clone(namespace_path_parent)

	local component_class = rawget(_G, component_config.type)
	local component = component_class.create_from_config(self._data.world, component_config, callback_object)

	for _, child_component in ipairs(components) do
		fassert(component.add_component, "Trying to add a component to a menu item instead of a container")
		component:add_component(child_component)
	end

	return component
end
