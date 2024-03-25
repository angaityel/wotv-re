-- chunkname: @scripts/managers/hud/hud_player_effects/hud_debuffs.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/hud_player_effects/hud_player_effect_icon")
require("scripts/managers/hud/hud_player_effects/hud_player_effect_container_element")
require("scripts/managers/hud/hud_player_effects/hud_player_effect_timer_background")
require("scripts/managers/hud/hud_player_effects/hud_player_effect_timer")
require("scripts/managers/hud/hud_player_effects/hud_player_effect_wounded_timer_text")
require("scripts/managers/hud/shared_hud_elements/hud_text_buff_element")

HUDDebuffs = class(HUDDebuffs, HUDBase)

function HUDDebuffs:init(world, player)
	HUDDebuffs.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "material", MenuSettings.font_group_materials.wotr_hud_text, "material", MenuSettings.font_group_materials.font_gradient_100, "material", "materials/fonts/hell_shark_font", "immediate")

	self:_setup_debuff()

	self._active = false

	Managers.state.event:register(self, "debuffs_activated", "event_hud_debuffs_activated", "debuffs_deactivated", "event_hud_debuffs_deactivated")
end

function HUDDebuffs:_setup_debuff()
	self._debuffs_container = HUDPlayerEffectContainerElement.create_from_config({
		layout_settings = HUDSettings.debuffs.container
	})

	for debuff_name, _ in pairs(Debuffs) do
		local debuff_container = HUDContainerElement.create_from_config({
			layout_settings = HUDSettings.buffs.buff.container
		})
		local debuff_icon_config = {
			z = 10,
			layout_settings = table.clone(HUDSettings.buffs.buff.icon)
		}

		debuff_container:add_element(debuff_name .. "_icon", HUDPlayerEffectIcon.create_from_config(debuff_icon_config))

		local timer_bg_circle_config = {
			z = 5,
			layout_settings = table.clone(HUDSettings.buffs.buff.timer_background)
		}

		debuff_container:add_element(debuff_name .. "_timer_background", HUDPlayerEffectTimerBackground.create_from_config(timer_bg_circle_config))

		local timer_circle_config = {
			z = 7,
			layout_settings = table.clone(HUDSettings.buffs.buff.timer)
		}

		debuff_container:add_element(debuff_name .. "_timer", HUDPlayerEffectTimer.create_from_config(timer_circle_config))

		local debuff_level_circle_config = {
			z = 20,
			layout_settings = table.clone(HUDSettings.buffs.buff.level_circle)
		}

		debuff_container:add_element(debuff_name .. "_level_circle", HUDPlayerEffectInformationIcon.create_from_config(debuff_level_circle_config))

		local debuff_level_text_config = {
			text = "",
			z = 30,
			layout_settings = table.clone(HUDSettings.buffs.buff.level_text)
		}

		debuff_container:add_element(debuff_name .. "_level_text", HUDPlayerEffectInformationText.create_from_config(debuff_level_text_config))
		self._debuffs_container:add_element(debuff_name, debuff_container)
	end

	local countdown_text = {
		text = "",
		z = 30,
		layout_settings = table.clone(HUDSettings.buffs.last_stand_countdown.last_stand_timer_text)
	}
	local bandage_text1 = {
		text = "",
		z = 30,
		layout_settings = table.clone(HUDSettings.buffs.last_stand_countdown.last_stand_bandage1_text)
	}
	local bandage_text2 = {
		text = "",
		z = 30,
		layout_settings = table.clone(HUDSettings.buffs.last_stand_countdown.last_stand_bandage2_text)
	}
	local last_stand_container = HUDContainerElement.create_from_config({
		layout_settings = HUDSettings.buffs.last_stand_countdown.container
	})

	last_stand_container:add_element("countdown_text", HUDPlayerEffectWoundedTimerText.create_from_config(countdown_text))
	last_stand_container:add_element("bandage_text1", HUDTextElement.create_from_config(bandage_text1))
	last_stand_container:add_element("bandage_text2", HUDTextBuffElement.create_from_config(bandage_text2))

	self._last_stand_container = last_stand_container
end

function HUDDebuffs:event_hud_debuffs_activated(player, blackboard)
	if player == self._player then
		self._active = true
		self._blackboard = blackboard

		local debuffs_container = self._debuffs_container
		local debuff_containers = debuffs_container:elements()

		debuffs_container.config.is_buff_container = false

		for debuff_name, debuff_container in pairs(debuff_containers) do
			debuff_container.config.blackboard = blackboard
			debuff_container.config.effect_type = debuff_name

			local elements = debuff_container:elements()

			for id, element in pairs(elements) do
				element.config.blackboard = blackboard
				element.config.name = id
				element.config.effect_type = debuff_name
			end
		end

		local elements = self._last_stand_container:elements()

		for id, element in pairs(elements) do
			element.config.blackboard = blackboard
			element.config.name = id
			element.config.effect_type = "last_stand"
		end
	end
end

function HUDDebuffs:event_hud_debuffs_deactivated(player)
	if player == self._player then
		self._active = false
	end
end

function HUDDebuffs:post_update(dt, t)
	local layout_settings = HUDHelper:layout_settings(self._debuffs_container.config.layout_settings)
	local gui = self._gui

	if self._active then
		self._debuffs_container:update_size(dt, t, gui, layout_settings)

		local x, y = HUDHelper:element_position(nil, self._debuffs_container, layout_settings)

		self._debuffs_container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
		self._debuffs_container:render(dt, t, gui, layout_settings)

		local last_stand_container = self._last_stand_container
		local last_stand_layout_settings = HUDHelper:layout_settings(last_stand_container.config.layout_settings)

		last_stand_container:update_size(dt, t, gui, last_stand_layout_settings)

		local x, y = HUDHelper:element_position(nil, last_stand_container, last_stand_layout_settings)

		if self._blackboard.last_stand.level > 0 then
			last_stand_container:elements().bandage_text1.config.text = L("you_will_bleed_out_in")
			last_stand_container:elements().bandage_text2.config.text = "perk_ui_last_stand_tip"
		else
			last_stand_container:elements().bandage_text1.config.text = ""
			last_stand_container:elements().bandage_text2.config.text = ""
		end

		last_stand_container:update_position(dt, t, last_stand_layout_settings, x, y, last_stand_layout_settings.z)
		last_stand_container:render(dt, t, gui, last_stand_layout_settings)
	end
end

function HUDDebuffs:destroy()
	World.destroy_gui(self._world, self._gui)
end
