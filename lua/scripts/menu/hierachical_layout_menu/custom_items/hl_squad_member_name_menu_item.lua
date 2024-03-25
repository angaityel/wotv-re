-- chunkname: @scripts/menu/hierachical_layout_menu/custom_items/hl_squad_member_name_menu_item.lua

HLSquadMemberNameMenuItem = class(HLSquadMemberNameMenuItem, HLTextMenuItem)

function HLSquadMemberNameMenuItem:init(world, config)
	HLSquadMemberNameMenuItem.super.init(self, world, config)
end

function HLSquadMemberNameMenuItem:_text()
	return self.config.player:name()
end

function HLSquadMemberNameMenuItem:player()
	return self.config.player
end

function HLSquadMemberNameMenuItem.create_from_config(world, config, callback_object)
	config.callback_object = callback_object

	return HLSquadMemberNameMenuItem:new(world, config)
end
