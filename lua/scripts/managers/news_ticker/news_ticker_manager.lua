-- chunkname: @scripts/managers/news_ticker/news_ticker_manager.lua

require("scripts/managers/news_ticker/news_ticker_token")
require("scripts/menu/menu_containers/news_ticker_menu_container")

NewsTickerManager = class(NewsTickerManager)

function NewsTickerManager:init(layout_settings)
	if not rawget(_G, "UrlLoader") then
		return
	end

	self._loader = UrlLoader()
	self._url = "https://services.paradoxplaza.com/head/feeds/wotv-news-ticker/content"
	self._layout_settings = layout_settings
	self._news_ticker_container = NewsTickerMenuContainer:new()
	self._enabled = false
	self._gui = nil
end

function NewsTickerManager:load(callback)
	if not rawget(_G, "UrlLoader") then
		return
	end

	local job = UrlLoader.load_text(self._loader, self._url)
	local token = NewsTickerToken:new(self._loader, job)

	Managers.token:register_token(token, callback)
end

function NewsTickerManager:enable(world)
	self._enabled = true
	self._gui = World.create_screen_gui(world, "material", "materials/menu/loading_atlas", "material", "materials/menu/splash_screen", "material", "materials/fonts/hell_shark_font", "material", "materials/hud/buttons", "immediate")

	if not rawget(_G, "UrlLoader") then
		return
	end

	self._news_ticker_container:load(self._gui)
end

function NewsTickerManager:disable(world)
	local gui = self._gui

	World.destroy_gui(world, gui)

	self._enabled = false
	self._gui = nil
	self._current_world = nil
end

function NewsTickerManager:enabled()
	return self._enabled
end

function NewsTickerManager:update(dt)
	if not rawget(_G, "UrlLoader") then
		return
	end

	UrlLoader.update(self._loader)

	if not self._enabled then
		return
	end

	local t = Managers.time:time("game")
	local layout_settings = MenuHelper:layout_settings(self._layout_settings)

	self._news_ticker_container:update_size(dt, t, self._gui, layout_settings)

	local x, y = MenuHelper:container_position(self._news_ticker_container, layout_settings)

	self._news_ticker_container:update_position(dt, t, layout_settings, x, y, 950)
	self._news_ticker_container:render(dt, t, self._gui, layout_settings)
end

function NewsTickerManager:destroy()
	if not rawget(_G, "UrlLoader") then
		return
	end

	UrlLoader.destroy(self._loader)
end
