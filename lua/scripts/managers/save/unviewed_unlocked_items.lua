-- chunkname: @scripts/managers/save/unviewed_unlocked_items.lua

UnviewedUnlockedItems = UnviewedUnlockedItems or {}
UnviewedUnlockedItemsHelper = {}

function UnviewedUnlockedItemsHelper:fill_unviewed_table(rank, save_data)
	table.clear(UnviewedUnlockedItems)

	for i = 0, rank do
		local unlocks = RANKS[i].unlocks

		for _, unlock in ipairs(unlocks) do
			UnviewedUnlockedItems[unlock.name] = unlock
		end
	end

	local viewed_unlocked_items = save_data.viewed_unlocked_items or {}

	for _, item_name in ipairs(viewed_unlocked_items) do
		UnviewedUnlockedItems[item_name] = nil
	end
end

function UnviewedUnlockedItemsHelper:rank_up(rank)
	local new_unlocks = RANKS[rank].unlocks

	for _, unlock in ipairs(new_unlocks) do
		UnviewedUnlockedItems[unlock.name] = unlock
	end
end

local function save_viewed_items(save_data)
	Managers.save:auto_save(SaveFileName, save_data)
end

function UnviewedUnlockedItemsHelper:view_item(item_name, save_data, ignore_save)
	if not UnviewedUnlockedItems[item_name] then
		return
	end

	UnviewedUnlockedItems[item_name] = nil

	local viewed_unlocked_items = save_data.viewed_unlocked_items or {}
	local already_viewed = false
	local num_saved_items = #viewed_unlocked_items

	for i = 1, num_saved_items do
		local saved_item_name = viewed_unlocked_items[i]

		if saved_item_name == item_name then
			already_viewed = true

			break
		end
	end

	if not already_viewed then
		viewed_unlocked_items[#viewed_unlocked_items + 1] = item_name
		save_data.viewed_unlocked_items = viewed_unlocked_items

		if not ignore_save then
			save_viewed_items(save_data)
		end
	end
end

function UnviewedUnlockedItemsHelper:view_all_items_in_category(category, save_data)
	local had_unviewed_item = false

	for name, item in pairs(UnviewedUnlockedItems) do
		if category == item.category then
			had_unviewed_item = true

			UnviewedUnlockedItemsHelper:view_item(name, save_data, true)
		end
	end

	if had_unviewed_item then
		save_viewed_items(save_data)
	end
end

function UnviewedUnlockedItemsHelper:has_unviewed_item_in_category(category)
	for name, item in pairs(UnviewedUnlockedItems) do
		if category == item.category then
			return true
		end
	end

	return false
end

function UnviewedUnlockedItemsHelper:has_unviewed_items()
	local i = 0

	for _, _ in pairs(UnviewedUnlockedItems) do
		i = i + 1
	end

	return i > 0
end

local function print_unviewed_item(item)
	local item_string = item.name

	print(item_string)
end

function UnviewedUnlockedItemsHelper:print_unviewed_items_from_category(category)
	printf("<---%s--->", category)

	for name, item in pairs(UnviewedUnlockedItems) do
		if category == item.category then
			print_unviewed_item(item)
		end
	end

	printf("</--%s--/>", category)
end

function UnviewedUnlockedItemsHelper:can_access_item(item)
	local profile_data = Managers.persistence:profile_data() or {
		entities = {},
		attributes = {
			rank = 0
		}
	}

	return ProfileHelper:entity_rank_met(item.entity_type, item.name, profile_data) and ProfileHelper:entity_owned(item.entity_type, item.name, profile_data)
end
