-- chunkname: @scripts/menu/menu_containers/tip_of_the_day_menu_container.lua

require("scripts/menu/menu_containers/menu_container")
require("scripts/settings/tip_of_the_day")

TipOfTheDayMenuContainer = class(TipOfTheDayMenuContainer, MenuContainer)

function TipOfTheDayMenuContainer:init(world)
	TipOfTheDayMenuContainer.super.init(self)

	self._tip_text = TextBoxMenuContainer.create_from_config()
	self._tip_header = string.upper(L("tip_of_the_day"))
	self._world = world
end

function TipOfTheDayMenuContainer:load_tip(tip_name, level_name, layout_settings, gui)
	local tip_settings = TipOfTheDay[tip_name]
	local level_settings = LevelSettings[level_name]
	local text = tip_settings.text

	if tip_settings.text_pad360 and Managers.input:pad_active(1) then
		text = tip_settings.text_pad360
	end

	self._tip_text:set_text(L(text), layout_settings.tip_text, gui)

	local tip_video = tip_settings[layout_settings.tip_graphics.video_key] or level_settings.loading_screen_preview[layout_settings.tip_graphics.video_key]

	if tip_video then
		self._tip_video_gui = World.create_screen_gui(self._world, "material", tip_video.material, "immediate")
		self._tip_video_player = World.create_video_player(self._world, tip_video.ivf, layout_settings.loop)
		self._tip_video = tip_video
	else
		self._tip_texture = tip_settings[layout_settings.tip_graphics.texture_key] or level_settings.loading_screen_preview[layout_settings.tip_graphics.texture_key]
	end
end

function TipOfTheDayMenuContainer:update_size(dt, t, gui, layout_settings)
	self._tip_text:update_size(dt, t, gui, layout_settings.tip_text)

	self._width = self._tip_text:width()
	self._height = self._tip_text:height()
end

function TipOfTheDayMenuContainer:update_position(dt, t, layout_settings, x, y, z)
	local text_x = x + layout_settings.tip_text.offset_x
	local text_y = y + layout_settings.tip_text.offset_y

	self._tip_text:update_position(dt, t, layout_settings.tip_text, text_x, text_y, z + 2)

	self._x = x
	self._y = y
	self._z = z
end

function TipOfTheDayMenuContainer:render(dt, t, gui, layout_settings)
	self._tip_text:render(dt, t, gui, layout_settings.tip_text)

	self._tip_header = string.upper(L("tip_of_the_day"))

	local layout_settings = MenuHelper:layout_settings(LoadingScreenMenuSettings.items.loading_screen_header_center_aligned)
	local c = layout_settings.color_disabled
	local color = Color(c[1], c[2], c[3], c[4])
	local min, max = Gui.text_extents(gui, self._tip_header, layout_settings.font.font, layout_settings.font_size)
	local extents = {
		max[1] - min[1],
		max[3] - min[3]
	}
	local x = self._tip_text._x
	local y = self._tip_text._y
	local z = self._tip_text._z
	local pos = Vector3(math.floor(x + self._width * 0.5 - extents[1] * 0.5), math.floor(y + self._height + layout_settings.padding_bottom), z)

	ScriptGUI.text(gui, self._tip_header, layout_settings.font.font, layout_settings.font_size, layout_settings.font.material, pos, color)

	if layout_settings.background_stripe then
		local c = layout_settings.background_stripe_color
		local color = Color(c[1], c[2], c[3], c[4])

		Gui.rect(gui, pos + Vector3(0, extents[2] * 0.35 - layout_settings.background_stripe_size * 0.5 * extents[2], -2), Vector2(extents[1], layout_settings.background_stripe_size * extents[2]), color)
	end
end

function TipOfTheDayMenuContainer:destroy()
	TipOfTheDayMenuContainer.super.destroy(self)

	if self._tip_video_gui then
		World.destroy_gui(self._world, self._tip_video_gui)

		self._tip_video_gui = nil
	end

	if self._tip_video_player then
		World.destroy_video_player(self._world, self._tip_video_player)

		self._tip_video_player = nil
	end
end

function TipOfTheDayMenuContainer.create_from_config(world)
	return TipOfTheDayMenuContainer:new(world)
end
