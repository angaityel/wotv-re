﻿-- chunkname: @scripts/managers/changelog/changelog_manager_offline.lua

ChangelogManagerOffline = class(ChangelogManagerOffline)

function ChangelogManagerOffline:init()
	return
end

function ChangelogManagerOffline:get_changelog(callback)
	callback("Missing UrlLoader")
end

function ChangelogManagerOffline:update()
	return
end
