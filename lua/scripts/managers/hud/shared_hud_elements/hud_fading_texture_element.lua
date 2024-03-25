-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_fading_texture_element.lua

require("scripts/managers/hud/shared_hud_elements/hud_atlas_texture_element")

HUDFadingTextureElement = class(HUDFadingTextureElement, HUDAtlasTextureElement)

function HUDFadingTextureElement:init(config)
	HUDFadingTextureElement.super.init(self, config)

	self._fade_end_time = 0
end

function HUDFadingTextureElement:render(dt, t, gui, layout_settings)
	local alpha = 0
	local end_time = self._fade_end_time

	if t <= end_time then
		alpha = HUDHelper.alpha_animation(dt, t, layout_settings, end_time)
	end

	layout_settings.color[1] = alpha

	HUDFadingTextureElement.super.render(self, dt, t, gui, layout_settings)
end

function HUDFadingTextureElement:fade_animation()
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)
	local t = Managers.time:time("game")

	self._fade_end_time = t + layout_settings.alpha_animation.duration
end

function HUDFadingTextureElement.create_from_config(config)
	return HUDFadingTextureElement:new(config)
end
