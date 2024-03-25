-- chunkname: @scripts/managers/hud/hud_ammo_counter/hud_ammo_counter.lua

require("scripts/managers/hud/shared_hud_elements/hud_container_element")
require("scripts/managers/hud/shared_hud_elements/hud_text_element")
require("scripts/managers/hud/shared_hud_elements/hud_texture_element")
require("scripts/managers/hud/hud_ammo_counter/hud_ammo_element")
require("scripts/managers/hud/shared_hud_elements/hud_collection_container_element")

HUDAmmoCounter = class(HUDAmmoCounter, HUDBase)

function HUDAmmoCounter:init(world, player)
	HUDAmmoCounter.super.init(self, world, player)

	self._world = world
	self._player = player
	self._gui = World.create_screen_gui(world, "material", "materials/hud/hud", "material", MenuSettings.font_group_materials.arial, "immediate")

	self:_setup_ammo_counter()

	self._weapons = {}

	local event_manager = Managers.state.event

	event_manager:register(self, "ammo_weapon_spawned", "event_ammo_weapon_spawned")
	event_manager:register(self, "ammo_weapon_despawned", "event_ammo_weapon_despawned")
end

function HUDAmmoCounter:_setup_ammo_counter()
	self._ammo_counter_container = HUDCollectionContainerElement.create_from_config({
		layout_settings = HUDSettings.ammo_counter.container
	})
end

function HUDAmmoCounter:event_ammo_weapon_spawned(player, user_unit, blackboard)
	if player == self._player then
		self._weapons[blackboard] = {
			user_unit = user_unit,
			elements = {}
		}

		for i = 1, blackboard.starting_ammo do
			self:_create_element(i, blackboard)
		end
	end
end

function HUDAmmoCounter:_remove_element(index, blackboard)
	local element = self._weapons[blackboard].elements[index]
	local element_index = self._ammo_counter_container:find_element(element)

	self._ammo_counter_container:remove_element(element_index)
end

function HUDAmmoCounter:_create_element(index, blackboard)
	local layout_settings = HUDSettings.ammo_counter.weapon
	local weapon_config = {
		z = 0,
		layout_settings = layout_settings,
		blackboard = {
			texture_atlas_settings = hud_assets[blackboard.texture],
			glow_texture_atlas_settings = hud_assets[blackboard.glow_texture]
		}
	}
	local element = HUDAmmoElement.create_from_config(weapon_config)

	self._ammo_counter_container:insert_element(element)

	self._weapons[blackboard].elements[index] = element
end

function HUDAmmoCounter:event_ammo_weapon_despawned(player, user_unit, blackboard)
	if player == self._player then
		local weapons = self._weapons[blackboard]

		for k, element in ipairs(weapons.elements) do
			local index = self._ammo_counter_container:find_element(element)

			if index then
				self._ammo_counter_container:remove_element(index)
			end
		end

		self._weapons[blackboard] = nil
	end
end

function HUDAmmoCounter:_update_weapons(dt, t)
	for blackboard, weapon in pairs(self._weapons) do
		local ammo = blackboard.ammo

		for i, element in ipairs(weapon.elements) do
			local element_index = self._ammo_counter_container:find_element(element)

			if i <= ammo and not element_index then
				self._ammo_counter_container:insert_element(element, 1)
				element:start_glow(t, 2, 0.1, 0.1)
			elseif ammo < i and element_index then
				self._ammo_counter_container:remove_element(element_index)
			end
		end
	end
end

function HUDAmmoCounter:post_update(dt, t)
	local layout_settings = HUDHelper:layout_settings(self._ammo_counter_container.config.layout_settings)
	local gui = self._gui

	self:_update_weapons(dt, t)
	self._ammo_counter_container:update_size(dt, t, gui, layout_settings)

	local x, y = HUDHelper:element_position(nil, self._ammo_counter_container, layout_settings)

	self._ammo_counter_container:update_position(dt, t, layout_settings, x, y, layout_settings.z)
	self._ammo_counter_container:render(dt, t, gui, layout_settings)
end

function HUDAmmoCounter:destroy()
	World.destroy_gui(self._world, self._gui)
end
