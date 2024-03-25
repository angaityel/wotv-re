-- chunkname: @scripts/menu/menu_pages/perk_list_page.lua

require("scripts/settings/perk_settings")

PerkListPage = class(PerkListPage, MenuPage)

function PerkListPage:init(config, item_groups, world)
	PerkListPage.super.init(self, config, item_groups, world)

	self._mouse_pos = {
		0,
		0
	}
	self._container = TierGridMenuContainer.create_from_config(self._item_groups.perks)
end

function PerkListPage:set_position(x, y, z)
	self._x = x
	self._y = y
	self._z = z
end

function PerkListPage:set_data(page_data)
	self._page_data = page_data
	self.config.camera = page_data.camera
end

function PerkListPage:on_enter(on_cancel)
	PerkListPage.super.on_enter(self, on_cancel)
	self:_create_items()
end

function PerkListPage:on_exit(on_cancel)
	if on_cancel then
		self:_try_callback(self.config.callback_object, self.config.reset_callback)
	end
end

function PerkListPage:_create_items()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:remove_items("perks")

	for _, perk_name in ipairs(self._page_data.perks) do
		local perk = PerkUnlocks[perk_name]
		local config = {
			disabled_func = "cb_perk_disabled",
			remove_func = "cb_gear_hidden",
			name = perk.ui_header,
			text = perk.ui_header,
			layout_settings = self._page_data.layout_settings,
			on_select = self._page_data.on_select,
			on_select_args = {
				perk,
				self._page_data.perk_slot
			},
			remove_args = perk,
			sounds = self.config.sounds,
			item_padding = {
				layout_settings.perk.spacing_x or layout_settings.perk.spacing,
				layout_settings.perk.spacing_y or layout_settings.perk.spacing
			},
			disabled_args = {
				perk_name = perk_name
			},
			reset_callback = self.config.reset_callback,
			on_highlight = self._page_data.on_highlight,
			on_highlight_args = {
				perk
			},
			new_item = UnviewedUnlockedItems[perk.name],
			tier = perk.tier,
			index = perk.ui_sort_index
		}
		local item = GearItem.create_from_config({
			world = self._world
		}, config, self.config.callback_object)

		self:add_item(item, self.config.specified_item_group)
	end

	self._container:create_tiers(self._world, "ProfileEditorSettings.items.tier_item", PerkCategories)
	self._container.sort_items_by_tiers(self._items)
end

function PerkListPage:_update_input(input)
	PerkListPage.super._update_input(self, input)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._container:update_input(input, layout_settings.perk)

	if input:has("cursor") then
		self:_update_scroller(input:get("cursor"), input:get("release_left"), layout_settings.perk)
		self:_update_mouse_over(input:get("cursor"), input:get("select_left_click"), layout_settings.perk)
	end
end

function PerkListPage:_update_scroller(mouse_pos, release_left, layout_settings)
	if not self._scroll_mouse_pos or release_left then
		self._scroll_mouse_pos = nil

		return
	end

	local diff = mouse_pos[2] - self._scroll_mouse_pos

	self._container:update_scroller_position(-diff * 2)

	self._scroll_mouse_pos = mouse_pos[2]
end

function PerkListPage:_update_mouse_over(mouse_pos, left_click, layout_settings)
	self._mouse_pos = {
		mouse_pos[1],
		mouse_pos[2]
	}

	if not left_click then
		return
	end

	local x1 = self._container:x()
	local x2 = x1 + self._container:width()
	local y1 = self._container:y()
	local y2 = self._container:y() + self._container:height()

	if self._container:is_inside_scroller(mouse_pos, layout_settings) then
		self._scroll_mouse_pos = mouse_pos[2]
	elseif x1 > mouse_pos[1] or x2 < mouse_pos[1] or y1 > mouse_pos[2] or y2 < mouse_pos[2] then
		self:_cancel()
	end
end

function PerkListPage:_is_mouse_inside()
	local x1 = self._container:x()
	local x2 = x1 + self._container:width()
	local y1 = self._container:y()
	local y2 = self._container:y() + self._container:height()

	return x1 < self._mouse_pos[1] and x2 > self._mouse_pos[1] and y1 < self._mouse_pos[2] and y2 > self._mouse_pos[2]
end

function PerkListPage:_highlight_item(index, ignore_sound)
	if not Managers.input:pad_active(1) and not self:_is_mouse_inside() then
		PerkListPage.super._highlight_item(self, nil)

		return
	end

	PerkListPage.super._highlight_item(self, index, ignore_sound)
end

function PerkListPage:update(dt, t)
	PerkListPage.super.update(self, dt, t)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self._container:update_size(dt, t, self._gui, layout_settings.perk)

	local x, y = MenuHelper:container_position(self._container, layout_settings.perk)

	self._container:update_position(dt, t, layout_settings.perk, x + self._x, y + self._y, self._z)
	self._container:render(dt, t, self._gui, layout_settings.perk)
end

function PerkListPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "perk_list_page",
		name = page_config.name,
		parent_page = parent_page,
		items_callback = page_config.items_callback,
		items_callback_args = page_config.items_callback_args,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds or MenuSettings.sounds.default,
		render_parent_page = page_config.render_parent_page,
		specified_item_group = page_config.specified_item_group or "perks",
		item_layout_settings = page_config.item_layout_settings or "ProfileSettings.items.perk_item",
		reset_callback = page_config.reset_callback or "cb_reset_profile"
	}

	return PerkListPage:new(config, item_groups, compiler_data.world)
end
