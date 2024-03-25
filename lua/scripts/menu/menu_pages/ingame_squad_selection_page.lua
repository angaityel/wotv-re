-- chunkname: @scripts/menu/menu_pages/ingame_squad_selection_page.lua

require("scripts/menu/menu_containers/simple_grid_menu_container")
require("scripts/menu/menu_containers/squad_menu_container")

IngameSquadSelectionPage = class(IngameSquadSelectionPage, MenuPage)

function IngameSquadSelectionPage:init(config, item_groups, world)
	IngameSquadSelectionPage.super.init(self, config, item_groups, world)

	self._world = world
	self._local_player = config.local_player
	self.hide_banner = config.hide_banner
	self._squads = SimpleGridMenuContainer.create_from_config(self._item_groups.menu_items)
	self._containers = {}

	Managers.state.event:register(self, "player_joined_squad", "event_rebuild_squad_selection_page")
	Managers.state.event:register(self, "player_left_squad", "event_rebuild_squad_selection_page")
end

function IngameSquadSelectionPage:update(dt, t, render_from_child_page)
	IngameSquadSelectionPage.super.update(self, dt, t, render_from_child_page)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:_update_size(dt, t, self._gui, layout_settings)
	self:_update_position(dt, t, layout_settings)
	self:_render(dt, t, self._gui, layout_settings)
	self._squads:update_size(dt, t, self._gui, layout_settings.menu_items)
end

function IngameSquadSelectionPage:_update_input(input)
	IngameSquadSelectionPage.super._update_input(self, input)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._squads:update_input(input, layout_settings.menu_items)

	local mouse_pos = input:get("cursor")

	self:_update_scroller(mouse_pos, input:get("release_left"), layout_settings.menu_items)
	self:_update_mouse_over(mouse_pos, input:get("select_left_click"), layout_settings.menu_items)
end

function IngameSquadSelectionPage:_update_scroller(mouse_pos, release_left, layout_settings)
	if not mouse_pos or not self._scroll_mouse_pos or release_left then
		self._scroll_mouse_pos = nil

		return
	end

	local diff = mouse_pos[2] - self._scroll_mouse_pos

	self._squads:update_scroller_position(-diff * 2)

	self._scroll_mouse_pos = mouse_pos[2]
end

function IngameSquadSelectionPage:_update_mouse_over(mouse_pos, left_click, layout_settings)
	if not mouse_pos or not left_click then
		return
	end

	local x1 = self._squads:x()
	local x2 = x1 + self._squads:current_width()
	local y1 = self._squads:y() - self._squads:current_height()
	local y2 = self._squads:y()

	if self._squads:is_inside_scroller(mouse_pos, layout_settings) then
		self._scroll_mouse_pos = mouse_pos[2]
	end
end

function IngameSquadSelectionPage:_update_size(dt, t, gui, layout_settings)
	self._squads:update_size(dt, t, gui, layout_settings.menu_items)

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:update_size(dt, t, gui, item_layout_settings)
			end
		end
	end
end

function IngameSquadSelectionPage:_update_position(dt, t, layout_settings)
	local x, y, z = MenuHelper:container_position(self._squads, layout_settings.menu_items)

	self._squads:update_position(dt, t, layout_settings.menu_items, x, y, z or self.config.z or 0)

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			local x, y, z = MenuHelper:container_position(nil, layout_settings[item_group])

			z = z or self.config.z or 0

			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:update_position(dt, t, item_layout_settings, x, y, item_layout_settings.z or z)

				y = y - item:height() - (item_layout_settings.spacing or 0)
			end
		end
	end
end

function IngameSquadSelectionPage:_render(dt, t, gui, layout_settings)
	MenuHelper:render_wotv_menu_banner(dt, t, gui)
	self._squads:render(dt, t, gui, layout_settings.menu_items)

	for item_group, items in pairs(self._item_groups) do
		if not layout_settings[item_group].using_container then
			for _, item in ipairs(items) do
				local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

				item:render(dt, t, self._gui, item_layout_settings)
			end
		end
	end
end

function IngameSquadSelectionPage:on_enter(on_cancel)
	IngameSquadSelectionPage.super.on_enter(self, on_cancel)

	if on_cancel then
		return
	end

	self:_build_page()
end

function IngameSquadSelectionPage:_build_page()
	self:remove_items("menu_items")

	local local_player = self._local_player
	local squads = local_player.team.squads
	local config = {
		no_localization = false,
		name = "lone_wolves",
		text = "scoreboard_no_squad",
		on_select = "cb_squad_selected",
		layout_settings = "SquadMenuSettings.items.squad_menu_squad_header_text",
		parent_page = self.config.parent_page,
		disabled = not self._local_player.squad_index,
		on_select_args = {
			0
		},
		sounds = self.config.sounds
	}
	local item = TextMenuItem.create_from_config({
		world = self._world
	}, config, self)

	self:add_item(item, "menu_items")

	local lone_wolf_count = 0

	for _, player in pairs(Managers.player:players()) do
		if not player.squad_index then
			lone_wolf_count = lone_wolf_count + 1
		end
	end

	local members_config = {
		name = "members_lone_wolves",
		disabled = true,
		layout_settings = "SquadMenuSettings.items.squad_menu_squad_members_text",
		no_localization = true,
		text = lone_wolf_count,
		z = self.config.z or 1,
		parent_page = self.config.parent_page
	}

	item = TextMenuItem.create_from_config({
		world = self._world
	}, members_config, self)

	self:add_item(item, "menu_items")

	local squad_members_count_ordered = {}
	local ordered_squads = {}

	for id, squad in ipairs(squads) do
		local squads_added_count = #squad_members_count_ordered
		local squad_member_count = squad:num_members()
		local inserted = false

		for i = 1, squads_added_count do
			if squad_member_count >= squad_members_count_ordered[i] then
				table.insert(squad_members_count_ordered, i, squad_member_count)
				table.insert(ordered_squads, i, id)

				inserted = true

				break
			end
		end

		if not inserted then
			local next_id = squads_added_count + 1

			squad_members_count_ordered[next_id] = squad_member_count
			ordered_squads[next_id] = id
		end
	end

	for _, id in ipairs(ordered_squads) do
		local squad = local_player.team:squad(id)
		local config = {
			no_localization = false,
			on_select = "cb_squad_selected",
			layout_settings = "SquadMenuSettings.items.squad_menu_squad_header_text",
			disabled_func = "cb_squad_disabled",
			name = "squad_" .. id,
			parent_page = self.config.parent_page,
			text = squad:name(),
			disabled_func_args = {
				id
			},
			on_select_args = {
				id
			},
			sounds = self.config.sounds
		}
		local item = TextMenuItem.create_from_config({
			world = self._world
		}, config, self)

		self:add_item(item, "menu_items")

		local members_config = {
			disabled = true,
			layout_settings = "SquadMenuSettings.items.squad_menu_squad_members_text",
			no_localization = true,
			name = "members_" .. id,
			text = squad:num_members(),
			z = self.config.z or 1,
			parent_page = self.config.parent_page
		}

		item = TextMenuItem.create_from_config({
			world = self._world
		}, members_config, self)

		self:add_item(item, "menu_items")
	end
end

function IngameSquadSelectionPage:on_exit(on_cancel)
	for _, item_group in pairs(self._item_groups) do
		for _, item in pairs(item_group) do
			if item.on_deselect then
				item:on_deselect()
			end
		end
	end
end

function IngameSquadSelectionPage:event_rebuild_squad_selection_page(player)
	if self._local_player.team then
		self:_build_page()

		if self._local_player == player then
			self.config.callback_object:cb_return_to_battle()
		end
	end
end

function IngameSquadSelectionPage:cb_squad_disabled(params)
	if not self._local_player.team then
		return true
	end

	local squad = self._local_player.team.squads[params[1]]

	return not squad:can_join(self._local_player)
end

function IngameSquadSelectionPage:cb_squad_selected(squad_id)
	local local_player = self._local_player

	if squad_id == 0 then
		local squad_index = local_player.squad_index

		if squad_index then
			local_player.team.squads[squad_index]:request_to_leave(local_player)
		end
	else
		local_player.team.squads[squad_id]:request_to_join(local_player)
	end
end

function IngameSquadSelectionPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "ingame_squad_selection",
		parent_page = parent_page,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		camera = page_config.camera or parent_page and parent_page:camera(),
		local_player = compiler_data.menu_data.local_player,
		hide_banner = page_config.hide_banner,
		disable_preview = page_config.disable_preview,
		no_cancel_to_parent_page = page_config.no_cancel_to_parent_page
	}

	return IngameSquadSelectionPage:new(config, item_groups, compiler_data.world)
end
