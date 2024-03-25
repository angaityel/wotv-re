-- chunkname: @scripts/helpers/ui_settings_cache.lua

UISettingsCache = UISettingsCache or {}

function UISettingsCache.new()
	return {}
end

function UISettingsCache.cached_setting(cache, settings_table, resolution_width, resolution_height)
	local cached_lookup = cache[settings_table]

	if not cached_lookup then
		cache[settings_table] = {
			-1,
			-1
		}

		return nil
	end

	if cached_lookup[1] == resolution_width and cached_lookup[2] == resolution_height then
		return cached_lookup[3]
	end

	return nil
end

function UISettingsCache.store_setting(cache, settings_table, resolution_setting, resolution_width, resolution_height)
	local cached_lookup = cache[settings_table]

	cached_lookup[1] = resolution_width
	cached_lookup[2] = resolution_height
	cached_lookup[3] = resolution_setting
end
