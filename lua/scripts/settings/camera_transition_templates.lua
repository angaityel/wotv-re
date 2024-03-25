-- chunkname: @scripts/settings/camera_transition_templates.lua

require("scripts/settings/player_movement_settings")

CameraTransitionTemplates = CameraTransitionTemplates or {}

local DURATION = 0.3

CameraTransitionTemplates.instant_cut = {}
CameraTransitionTemplates.unaim_throw = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION * 2,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 2 * 0.8
	},
	vertical_fov = {
		class = "CameraTransitionFOVLinear",
		duration = DURATION * 2 * 0.8
	},
	pitch_offset = {
		parameter = "pitch_offset",
		class = "CameraTransitionGeneric",
		duration = DURATION * 2 * 0.8,
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	}
}
CameraTransitionTemplates.player_fast = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION,
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.8
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.2,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	},
	pitch_offset = {
		parameter = "pitch_offset",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.8,
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	}
}
CameraTransitionTemplates.from_blade_master = table.clone(CameraTransitionTemplates.player_fast)
CameraTransitionTemplates.from_blade_master.vertical_fov.duration = 1.25
CameraTransitionTemplates.from_blade_master.position.duration = 1.25

function CameraTransitionTemplates.from_blade_master.position.transition_func(t)
	return math.smoothstep(t, 0, 1)
end

CameraTransitionTemplates.to_blade_master = table.clone(CameraTransitionTemplates.player_fast)
CameraTransitionTemplates.to_blade_master.vertical_fov.duration = 0.5
CameraTransitionTemplates.to_blade_master.position.duration = 0.5

function CameraTransitionTemplates.to_blade_master.position.transition_func(t)
	return math.smoothstep(t, 0, 1)
end

local TRAVEL_MODE_DELAY = PlayerUnitMovementSettings.travel_mode.camera_speed_up_delay

CameraTransitionTemplates.to_travel_mode = CameraTransitionTemplates.to_travel_mode or {}
CameraTransitionTemplates.to_travel_mode.position = {
	class = "CameraTransitionPositionLinear",
	duration = TRAVEL_MODE_DELAY,
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.to_travel_mode.rotation = {
	class = "CameraTransitionRotationLerp",
	duration = TRAVEL_MODE_DELAY
}
CameraTransitionTemplates.to_travel_mode.vertical_fov = {
	parameter = "vertical_fov",
	class = "CameraTransitionGeneric",
	duration = TRAVEL_MODE_DELAY,
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.to_travel_mode.pitch_offset = {
	parameter = "pitch_offset",
	class = "CameraTransitionGeneric",
	duration = TRAVEL_MODE_DELAY,
	transition_func = function(t)
		return math.sin(0.5 * t * math.pi)
	end
}
CameraTransitionTemplates.exit_travel_mode = CameraTransitionTemplates.exit_travel_mode or {}
CameraTransitionTemplates.exit_travel_mode.position = {
	duration = 1,
	class = "CameraTransitionPositionLinear",
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.exit_travel_mode.rotation = {
	class = "CameraTransitionRotationLerp",
	duration = 1
}
CameraTransitionTemplates.exit_travel_mode.vertical_fov = {
	parameter = "vertical_fov",
	duration = 1,
	class = "CameraTransitionGeneric",
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.exit_travel_mode.pitch_offset = {
	parameter = "pitch_offset",
	duration = 1,
	class = "CameraTransitionGeneric",
	transition_func = function(t)
		return math.sin(0.5 * t * math.pi)
	end
}
CameraTransitionTemplates.to_travel_mode_active = CameraTransitionTemplates.to_travel_mode_active or {}
CameraTransitionTemplates.to_travel_mode_active.position = {
	duration = 1.5,
	class = "CameraTransitionPositionLinear",
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.to_travel_mode_active.rotation = {
	class = "CameraTransitionRotationLerp",
	duration = 1.5
}
CameraTransitionTemplates.to_travel_mode_active.vertical_fov = {
	parameter = "vertical_fov",
	duration = 1.5,
	class = "CameraTransitionGeneric",
	transition_func = function(t)
		return math.smoothstep(t, 0, 1)
	end
}
CameraTransitionTemplates.to_travel_mode_active.pitch_offset = {
	parameter = "pitch_offset",
	duration = 1.5,
	class = "CameraTransitionGeneric",
	transition_func = function(t)
		return math.sin(0.5 * t * math.pi)
	end
}
CameraTransitionTemplates.dead = {
	position = {
		duration = 1,
		class = "CameraTransitionPositionLinear",
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = 0.8
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.8,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.swing_blend_to_swing = {
	pitch_speed = {
		parameter = "pitch_speed",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	yaw_speed = {
		parameter = "yaw_speed",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.8,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.swing_blend_to_other = {
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION,
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	rotation = {
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.8
	},
	pitch_speed = {
		parameter = "pitch_speed",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	yaw_speed = {
		parameter = "yaw_speed",
		duration = 0.3,
		class = "CameraTransitionGeneric",
		transition_func = function(t)
			return math.sin(0.5 * t * math.pi)
		end
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.8,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.between_units_fast = {
	inherit_aim_rotation = true,
	position = {
		freeze_start_node = true,
		class = "CameraTransitionPositionLinear",
		duration = DURATION
	},
	rotation = {
		freeze_start_node = true,
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.8
	}
}
CameraTransitionTemplates.mounting = {
	inherit_aim_rotation = true,
	position = {
		class = "CameraTransitionPositionLinear",
		duration = DURATION
	},
	rotation = {
		freeze_start_node = true,
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.8
	},
	vertical_fov = {
		parameter = "vertical_fov",
		class = "CameraTransitionGeneric",
		duration = DURATION * 0.8,
		transition_func = function(t)
			return math.smoothstep(t, 0, 1)
		end
	}
}
CameraTransitionTemplates.between_units_fast = {
	inherit_aim_rotation = true,
	position = {
		freeze_start_node = true,
		class = "CameraTransitionPositionLinear",
		duration = DURATION
	},
	rotation = {
		freeze_start_node = true,
		class = "CameraTransitionRotationLerp",
		duration = DURATION * 0.8
	}
}
