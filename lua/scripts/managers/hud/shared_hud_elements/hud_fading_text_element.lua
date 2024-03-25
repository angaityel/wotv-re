-- chunkname: @scripts/managers/hud/shared_hud_elements/hud_fading_text_element.lua

require("scripts/managers/hud/shared_hud_elements/hud_text_element")

HUDFadingTextElement = class(HUDFadingTextElement, HUDTextElement)

function HUDFadingTextElement:init(config)
	HUDFadingTextElement.super.init(self, config)

	self._fade_end_time = 0
end

function HUDFadingTextElement:render(dt, t, gui, layout_settings)
	local alpha = 0
	local end_time = self._fade_end_time

	if t <= end_time then
		alpha = HUDHelper.alpha_animation(dt, t, layout_settings, end_time)
	end

	layout_settings.text_color[1] = alpha

	HUDFadingTextElement.super.render(self, dt, t, gui, layout_settings)
end

function HUDFadingTextElement:fade_animation()
	local layout_settings = HUDHelper:layout_settings(self.config.layout_settings)
	local t = Managers.time:time("game")

	self._fade_end_time = t + layout_settings.alpha_animation.duration
end

function HUDFadingTextElement.create_from_config(config)
	return HUDFadingTextElement:new(config)
end
