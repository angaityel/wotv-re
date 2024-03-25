﻿-- chunkname: @scripts/menu/menu_pages/outfit_editor/outfit_editor_armour_attachments_menu_page.lua

require("scripts/menu/menu_containers/item_list_menu_container")
require("scripts/menu/menu_containers/outfit_list_menu_container")
require("scripts/menu/menu_containers/profile_viewer_menu_container")
require("scripts/menu/menu_containers/text_menu_container")
require("scripts/menu/menu_pages/level_4_menu_page")
require("scripts/menu/menu_containers/outfit_info_menu_container")
require("scripts/menu/menu_items/texture_button_menu_item")

OutfitsEditorArmourAttachmentsMenuPage = class(OutfitsEditorArmourAttachmentsMenuPage, Level4MenuPage)

function OutfitsEditorArmourAttachmentsMenuPage:init(config, item_groups, world)
	OutfitsEditorArmourAttachmentsMenuPage.super.init(self, config, item_groups, world)

	self._armour_name = nil
	self._current_profile = nil
	self._child_page = nil
end

function OutfitsEditorArmourAttachmentsMenuPage:set_profile(player_profile)
	self._current_profile = player_profile
end

function OutfitsEditorArmourAttachmentsMenuPage:set_armour(armour_name, attachments_table)
	local attachment_config = table.remove(attachments_table, 1)

	if #attachments_table > 0 then
		self._child_page = self:_create_armour_attachment_page()

		self._child_page:set_profile(self._current_profile)
		self._child_page:set_armour(armour_name, attachments_table)
	end

	self._armour_name = armour_name

	self:_add_armour_attachment_items(armour_name, attachment_config)
	self:_set_camera(attachment_config)
end

function OutfitsEditorArmourAttachmentsMenuPage:_set_camera(attachment_config)
	if attachment_config.category == "patterns" then
		self.config.camera = "character_editor_armour_patterns"
	end
end

function OutfitsEditorArmourAttachmentsMenuPage:destroy()
	OutfitsEditorArmourAttachmentsMenuPage.super.destroy(self)

	if self._child_page then
		self._child_page:destroy()

		self._child_page = nil
	end
end

function OutfitsEditorArmourAttachmentsMenuPage:_create_armour_attachment_page()
	local compiler_data = {
		world = self._world
	}
	local page_config = {
		z = self.config.z + 50,
		layout_settings = MainMenuSettings.pages.level_4_armour_attachments,
		sounds = self.config.sounds
	}
	local item_groups = {
		item_list_header = {},
		item_list_scroll = {},
		item_list = {},
		back_list = {}
	}

	return OutfitsEditorArmourAttachmentsMenuPage.create_from_config(compiler_data, page_config, self, item_groups, self.config.callback_object)
end

function OutfitsEditorArmourAttachmentsMenuPage:_add_armour_attachment_items(armour_name, attachment_config)
	self:remove_items("item_list_header")
	self:remove_items("item_list")
	self:remove_items("back_list")
	self._item_list:set_top_visible_row(1)

	local layout_settings = MenuHelper:layout_settings(self.config.layout_settings)
	local header_item_config = {
		disabled = true,
		text = attachment_config.ui_header,
		z = self.config.z + 1,
		layout_settings = layout_settings.header_text,
		parent_page = self,
		sounds = self.config.sounds.items.text
	}
	local header_item = TextMenuItem.create_from_config({
		world = self._world
	}, header_item_config, self)

	self:add_item(header_item, "item_list_header")

	for i, attachment_item in ipairs(Armours[armour_name].attachment_definitions[attachment_config.category]) do
		local unlock_type = "armour_attachment"
		local unlock_key = armour_name .. "|" .. attachment_item.unlock_key
		local entity_type = "armour_attachment"
		local entity_name = armour_name .. "|" .. attachment_item.unlock_key
		local market_item_name = entity_type .. "|" .. entity_name
		local ui_name = L(attachment_item.ui_header)
		local market_message_args = {
			ui_name,
			L(Armours[armour_name].ui_header)
		}
		local available, unavalible_reason = ProfileHelper:is_entity_avalible(unlock_type, unlock_key, entity_type, entity_name, attachment_item.release_name, attachment_item.developer_item)

		if attachment_config.menu_page_type == "text" and (available or not OutfitHelper.gear_hidden(attachment_item)) then
			local item_config = {
				on_highlight = "cb_text_highlighted",
				on_select = "cb_text_selected",
				on_highlight_args = {
					attachment_config.category,
					i
				},
				on_select_args = {
					attachment_config.category,
					i
				},
				text = attachment_item.ui_header,
				tooltip_text = attachment_item.ui_description,
				tooltip_text_2 = attachment_item.ui_fluff_text,
				z = self.config.z + 1,
				layout_settings = layout_settings.text,
				parent_page = self,
				sounds = self.config.sounds.items.text,
				release_name = attachment_item.release_name,
				default_page = self._child_page,
				unlock_type = unlock_type,
				unlock_key = unlock_key,
				entity_type = entity_type,
				entity_name = entity_name,
				market_item_name = market_item_name,
				market_message_args = market_message_args,
				ui_name = ui_name
			}
			local item = OutfitTextMenuItem.create_from_config({
				world = self._world
			}, item_config, self)

			self:add_item(item, "item_list")
		end
	end

	local delimiter_item_config = {
		disabled = true,
		parent_page = self,
		layout_settings = layout_settings.delimiter_texture
	}
	local delimiter_item = TextureMenuItem.create_from_config({
		world = self._world
	}, delimiter_item_config, self)

	self:add_item(delimiter_item, "back_list")

	local back_item_config = {
		text = "main_menu_cancel",
		on_select = "cb_cancel",
		callback_object = "page",
		parent_page = self,
		layout_settings = layout_settings.text_back,
		sounds = self.config.sounds.items.text
	}
	local back_item = TextMenuItem.create_from_config({
		world = self._world
	}, back_item_config, self)

	self:add_item(back_item, "back_list")
end

function OutfitsEditorArmourAttachmentsMenuPage:cb_text_highlighted(category, attachment_index)
	Managers.state.event:trigger("event_outfit_editor_armour_attachments_selected", self._armour_name, category, attachment_index)
end

function OutfitsEditorArmourAttachmentsMenuPage:cb_text_selected(category, attachment_index)
	Managers.state.event:trigger("event_outfit_editor_armour_attachments_selected", self._armour_name, category, attachment_index)

	if not self._child_page then
		Managers.state.event:trigger("event_outfit_editor_save_profile")
		self:_try_callback(self.config.callback_object, "cb_cancel_to", "select_outfit_slot")
	end
end

function OutfitsEditorArmourAttachmentsMenuPage.create_from_config(compiler_data, page_config, parent_page, item_groups, callback_object)
	local config = {
		type = "outfit_editor",
		render_parent_page = true,
		parent_page = parent_page,
		callback_object = callback_object,
		z = page_config.z,
		layout_settings = page_config.layout_settings,
		sounds = page_config.sounds,
		environment = page_config.environment or parent_page and parent_page:environment(),
		camera = page_config.camera or parent_page and parent_page:camera()
	}

	return OutfitsEditorArmourAttachmentsMenuPage:new(config, item_groups, compiler_data.world)
end
