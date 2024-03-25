-- chunkname: @scripts/unit_extensions/weapons/weapon_bow_base.lua

require("scripts/unit_extensions/weapons/weapon_ranged_projectile_base")

WeaponBowBase = class(WeaponBowBase, WeaponRangedProjectileBase)

function WeaponBowBase:init(world, unit, user_unit, player, id, user_locomotion)
	WeaponBowBase.super.init(self, world, unit, user_unit, player, id, user_locomotion)

	self._fire_sound_event_full_charge = "release_bow_good"
	self._fire_sound_event = "release_bow"
	self._fail_fire_sound_event = "release_bow_bad"
	self._aim_anim_name = "bow_draw"
	self._unaim_anim_name = "bow_aim_cancel"
	self._wield_finished_anim_name = "bow_reload"
	self._fire_anim_name = "bow_release"
	self._weapon_category = "bow"
end

function WeaponBowBase:_play_fire_sound(charge_factor)
	local timpani_world = self._timpani_world
	local fire_sound_position = Unit.world_position(self._unit, 0)
	local fire_sound_event = charge_factor == 1 and self._fire_sound_event_full_charge or self._fire_sound_event
	local event_id = TimpaniWorld.trigger_event(timpani_world, fire_sound_event, fire_sound_position)

	TimpaniWorld.set_parameter(timpani_world, event_id, "shot", "shot_mono")

	local event_id = TimpaniWorld.trigger_event(timpani_world, "Stop_draw_bow", self._unit)
end

function WeaponBowBase:finish_reload(reload_successful, slot_name)
	self._loaded = true

	return WeaponBowBase.super.finish_reload(self, reload_successful)
end

function WeaponBowBase:aim()
	local event_id = TimpaniWorld.trigger_event(self._timpani_world, "draw_bow", self._unit)

	return WeaponBowBase.super.aim(self)
end

function WeaponBowBase:unaim()
	local event_id = TimpaniWorld.trigger_event(self._timpani_world, "Stop_draw_bow", self._unit)

	return WeaponBowBase.super.unaim(self)
end
