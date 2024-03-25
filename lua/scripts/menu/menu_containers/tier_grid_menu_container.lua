-- chunkname: @scripts/menu/menu_containers/tier_grid_menu_container.lua

TierGridMenuContainer = class(TierGridMenuContainer, SimpleGridMenuContainer)

function TierGridMenuContainer:init(items)
	TierGridMenuContainer.super.init(self, items)
end

function TierGridMenuContainer:create_tiers(world, layout_settings, tier_names)
	tier_names = tier_names or {}

	local tiers = {}

	for _, item in ipairs(self._items) do
		local tier = item.config.tier

		if not table.contains(tiers, tier) then
			tiers[#tiers + 1] = tier
		end
	end

	table.sort(tiers)

	self._tier_items = {}

	for key, tier in ipairs(tiers) do
		local config = {
			disabled = true,
			no_localization = true,
			name = "tier_" .. key,
			text = tier_names[tier] and L(tier_names[tier]) or L("tier_" .. tier),
			layout_settings = layout_settings
		}
		local item = HeaderItem.create_from_config({
			world
		}, config)

		self._tier_items[key] = item
	end

	self.sort_items_by_tiers(self._items)

	self._tiers = {}

	for key, tier in ipairs(tiers) do
		self._tiers[key] = {}

		for _, item in ipairs(self._items) do
			if item.config.tier == tier then
				self._tiers[key][#self._tiers[key] + 1] = item
			end
		end
	end
end

function TierGridMenuContainer.sort_items_by_tiers(items)
	local function sort(a, b)
		if a.config.tier < b.config.tier then
			return true
		elseif a.config.tier > b.config.tier then
			return false
		else
			return a.config.index < b.config.index
		end
	end

	table.sort(items, sort)
end

function TierGridMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	self._x = x + (layout_settings.offset_x or 0)
	self._y = y + (layout_settings.offset_y or 0)
	self._z = z + (layout_settings.z or 0)

	local num_columns = layout_settings.num_columns or 1
	local current_pos = {
		self._x,
		self._y + self._height
	}
	local current_tier = 0
	local tier_items_index = 0
	local idx = 1
	local row_switch = true
	local min_x = math.huge

	for _, item in ipairs(self._items) do
		if not item:removed() then
			if current_tier < item.config.tier then
				current_tier = item.config.tier
				tier_items_index = tier_items_index + 1

				local tier_item = self._tier_items[tier_items_index]
				local tier_item_layout_settings = MenuHelper:layout_settings(tier_item.config.layout_settings)

				current_pos[1] = self._x + self._width * 0.5

				if not row_switch then
					current_pos[2] = current_pos[2] + item:height() * -1
				end

				local tier_item_y = current_pos[2] + tier_item:height() * -1 + self._current_scroll_offset

				tier_item:update_position(dt, t, tier_item_layout_settings, current_pos[1], tier_item_y, self._z)

				current_pos[1] = self._x
				current_pos[2] = current_pos[2] + tier_item:height() * -1
				idx = 1
			end

			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)
			local item_y = current_pos[2] + item:height() * -1 + self._current_scroll_offset

			item:update_position(dt, t, item_layout_settings, current_pos[1], item_y, self._z)

			local curr_column = (idx - 1) % num_columns + 1
			local new_column = idx % num_columns + 1

			if new_column <= curr_column then
				current_pos[1] = self._x
			else
				current_pos[1] = current_pos[1] + item:width()
			end

			local curr_row = math.floor((idx - 1) / num_columns) + 1
			local new_row = math.floor(idx / num_columns) + 1

			row_switch = false

			if curr_row < new_row then
				row_switch = true
				current_pos[2] = current_pos[2] + item:height() * -1
			end

			idx = idx + 1
			min_x = min_x > item:x() and item:x() or min_x
		end
	end

	self._min_x = min_x
end

function TierGridMenuContainer:_render_items(dt, t, gui, layout_settings, render_from_child_page)
	TierGridMenuContainer.super._render_items(self, dt, t, gui, layout_settings, render_from_child_page)

	for _, item in ipairs(self._tier_items) do
		if not item:removed() then
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			if self:_item_inside(gui, item) then
				item:render(dt, t, gui, item_layout_settings, render_from_child_page)
			end
		end
	end
end

function TierGridMenuContainer:_num_rows(layout_settings)
	local num_columns = layout_settings.num_columns
	local num_rows = 0

	for tier, _ in ipairs(self._tier_items) do
		local num_items = #self._tiers[tier]

		num_rows = num_rows + math.ceil(num_items / num_columns)
	end

	return num_rows
end

function TierGridMenuContainer:_calculate_size(dt, t, gui, layout_settings)
	local width, height = 0, 0
	local total_item_height = 0
	local num_columns = layout_settings.num_columns
	local max_width = 0
	local num_rows = 0
	local num_tiers = #self._tier_items
	local current_tier = 0

	for tier, tier_item in ipairs(self._tier_items) do
		local tier_item_layout_settings = MenuHelper:layout_settings(tier_item.config.layout_settings)

		tier_item:update_size(dt, t, gui, tier_item_layout_settings)

		local idx = 1
		local tier_width = 0
		local tier_height = tier_item:height()

		for _, item in ipairs(self._tiers[tier]) do
			local item_layout_settings = MenuHelper:layout_settings(item.config.layout_settings)

			item:update_size(dt, t, gui, item_layout_settings)

			if not item:removed() then
				if idx <= num_columns then
					width = width + item:width()
				else
					width = width > 0 and width or item:width()
					tier_width = tier_width < width and width or tier_width
					width = 0
				end

				if (idx - 1) % num_columns == 0 then
					tier_height = tier_height + item:height()
					num_rows = num_rows + 1

					if not layout_settings.max_shown_items or num_rows <= self._calculated_max_shown_items then
						height = height + item:height()
					end
				end

				idx = idx + 1
			end
		end

		tier_width = tier_width < width and width or tier_width
		width = 0

		if max_width < tier_width then
			max_width = tier_width
		end

		total_item_height = total_item_height + tier_height
	end

	self._width = max_width
	self._height = height

	if layout_settings.max_shown_items then
		self._max_item_height = height
		self._total_item_height = total_item_height
	end

	if not layout_settings.max_shown_items or num_rows <= self._calculated_max_shown_items then
		self._height = total_item_height
	end

	self._current_width = self._width
	self._current_height = self._height
end

function TierGridMenuContainer.create_from_config(items)
	return TierGridMenuContainer:new(items)
end
