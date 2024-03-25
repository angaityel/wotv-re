-- chunkname: @scripts/settings/inventory_slots.lua

InventorySlots = {
	primary = {
		wield_input = "wield_two_handed_weapon",
		wield_toggle = false
	},
	secondary = {
		wield_input = "wield_one_handed_weapon",
		wield_toggle = false
	},
	dagger = {
		wield_input = "wield_dagger",
		wield_toggle = false
	},
	shield = {
		wield_input = "wield_shield",
		wield_toggle = true
	}
}
InventorySlotPriority = {
	"primary",
	"secondary",
	"dagger"
}
