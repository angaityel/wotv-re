-- chunkname: @scripts/menu/menu_pages/tier_list_page.lua

TierListPage = class(TierListPage, GearListPage)

function TierListPage:init(config, item_groups, world)
	TierListPage.super.init(self, config, item_groups, world)

	self._container = TierGridMenuContainer.create_from_config(self._item_groups[self.config.specified_item_group])
end

function TierListPage:_create_items()
	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)

	self:remove_items(self.config.specified_item_group)

	for _, gear in ipairs(self._item_data.gear) do
		local config = {
			remove_func = "cb_gear_hidden",
			name = gear.ui_header,
			text = gear.ui_header,
			layout_settings = self._item_data.layout_settings,
			on_select = self._item_data.on_select,
			on_select_args = {
				gear,
				self._item_data.weapon_slot
			},
			on_highlight = self._item_data.on_highlight,
			on_highlight_args = {
				gear,
				self._item_data.weapon_slot
			},
			sounds = self.config.sounds,
			item_padding = {
				layout_settings.gear.spacing_x or layout_settings.gear.spacing,
				layout_settings.gear.spacing_y or layout_settings.gear.spacing
			},
			reset_callback = self.config.reset_callback,
			tier = gear.tier,
			index = gear.index,
			on_highlight_new_item = self._item_data.on_highlight_new_item,
			on_highlight_new_item_args = {
				gear
			},
			new_item = UnviewedUnlockedItems[gear.name],
			remove_args = gear
		}
		local item = GearItem.create_from_config({
			world = self._world
		}, config, self.config.callback_object)

		self:add_item(item, self.config.specified_item_group)
	end

	self._container:create_tiers(self._world, "ProfileEditorSettings.items.tier_item", self.config.tier_names)
	self._container.sort_items_by_tiers(self._items)
end

function TierListPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "gear_list_page",
		name = page_config.name,
		parent_page = parent_page,
		items_callback = page_config.items_callback,
		items_callback_args = page_config.items_callback_args,
		callback_object = callback_object,
		environment = page_config.environment or parent_page and parent_page:environment(),
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds or MenuSettings.sounds.default,
		render_parent_page = page_config.render_parent_page,
		specified_item_group = page_config.specified_item_group or "gear",
		item_layout_settings = page_config.item_layout_settings or "ProfileEditorSettings.items.gear_item",
		reset_callback = page_config.reset_callback or "cb_reset_profile",
		tier_names = page_config.tier_names or {}
	}

	return TierListPage:new(config, item_groups, compiler_data.world)
end
