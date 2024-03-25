-- chunkname: @scripts/settings/camera_settings.lua

CameraSettings = CameraSettings or {}
PITCH_SPEED = 720
YAW_SPEED = 720
EnvironmentTweaks = EnvironmentTweaks or {}
EnvironmentTweaks.time_to_blend_env = 0.1
EnvironmentTweaks.time_to_default_env = 0.8
CameraTweaks = CameraTweaks or {}
CameraTweaks.zoom = {
	pad_scale = 0.1,
	scale = 0.1,
	interpolation_function = function(current, target, dt)
		return math.lerp(current, target, dt * 7)
	end
}
CameraSettings.player = {
	_node = {
		pitch_min = -71,
		name = "root_node",
		pitch_offset = 0,
		far_range = 1000,
		pitch_max = 65,
		class = "RootCamera",
		vertical_fov = 45,
		root_object_name = "camera_attach",
		pitch_speed = PITCH_SPEED,
		yaw_speed = YAW_SPEED,
		safe_position_offset = Vector3Box(0, 0, 1.55),
		tree_transitions = {
			horse = CameraTransitionTemplates.mounting,
			standard_bow_arrow = CameraTransitionTemplates.between_units_fast,
			player_dead = CameraTransitionTemplates.between_units_fast
		},
		node_transitions = {
			default = CameraTransitionTemplates.player_fast,
			dead = CameraTransitionTemplates.dead,
			knocked_down = CameraTransitionTemplates.dead,
			attacker_execution_camera = CameraTransitionTemplates.instant_cut,
			victim_execution_camera = CameraTransitionTemplates.instant_cut,
			travel_mode = CameraTransitionTemplates.to_travel_mode,
			blade_master = CameraTransitionTemplates.to_blade_master
		}
	},
	{
		_node = {
			animation_curve_parameter_name = "execution_attacker_anim_curves",
			name = "attacker_execution_camera_motion_builder",
			class = "ObjectLinkCamera",
			root_object_name = "execution_camera"
		},
		{
			_node = {
				name = "attacker_execution_camera",
				class = "RotationCamera",
				offset_pitch = -90,
				offset_yaw = -90,
				tree_transitions = {
					default = CameraTransitionTemplates.instant_cut
				},
				node_transitions = {
					default = CameraTransitionTemplates.instant_cut
				}
			}
		}
	},
	{
		_node = {
			animation_curve_parameter_name = "execution_victim_anim_curves",
			name = "victim_execution_camera_motion_builder",
			class = "ObjectLinkCamera",
			root_object_name = "execution_camera"
		},
		{
			_node = {
				name = "victim_execution_camera",
				class = "RotationCamera",
				offset_pitch = -90,
				offset_yaw = -90,
				tree_transitions = {
					default = CameraTransitionTemplates.instant_cut
				},
				node_transitions = {
					default = CameraTransitionTemplates.instant_cut
				}
			}
		}
	},
	{
		_node = {
			yaw = true,
			name = "yaw_aim",
			class = "AimCamera",
			pitch_offset = 14,
			pitch = false
		},
		{
			_node = {
				name = "up_translation",
				class = "TransformCamera",
				offset_position = {
					z = 0.25,
					x = 0,
					y = 0
				}
			},
			{
				_node = {
					pitch = true,
					name = "pitch_aim",
					class = "AimCamera",
					yaw = true
				},
				{
					_node = {
						name = "onground_no_scale",
						class = "TransformCamera",
						offset_position = {
							z = 0.18,
							x = 0,
							y = -2
						}
					},
					{
						_node = {
							name = "killer_cam",
							class = "TransformCamera",
							offset_position = {
								z = 0,
								x = 2,
								y = -5
							}
						}
					},
					{
						_node = {
							name = "travel_base",
							class = "TransformCamera",
							vertical_fov = 45,
							offset_position = {
								z = -0.3,
								x = 0,
								y = -0.1
							},
							node_transitions = {
								default = CameraTransitionTemplates.exit_travel_mode,
								dead = CameraTransitionTemplates.dead,
								attacker_execution_camera = CameraTransitionTemplates.instant_cut,
								victim_execution_camera = CameraTransitionTemplates.instant_cut,
								travel_mode_active = CameraTransitionTemplates.to_travel_mode_active,
								zoom_bow = CameraTransitionTemplates.player_fast,
								zoom_longbow = CameraTransitionTemplates.player_fast
							}
						},
						{
							_node = {
								class = "ScalableTransformCamera",
								name = "travel_mode",
								scale_variable = "zoom",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								scale_function = function(scale)
									return scale
								end
							}
						}
					},
					{
						_node = {
							name = "travel_active_base",
							class = "TransformCamera",
							vertical_fov = 65,
							offset_position = {
								z = -0.3,
								x = 0,
								y = -0.1
							},
							node_transitions = {
								default = CameraTransitionTemplates.exit_travel_mode,
								dead = CameraTransitionTemplates.dead,
								attacker_execution_camera = CameraTransitionTemplates.instant_cut,
								victim_execution_camera = CameraTransitionTemplates.instant_cut,
								travel_mode = CameraTransitionTemplates.to_travel_mode,
								zoom_bow = CameraTransitionTemplates.player_fast,
								zoom_longbow = CameraTransitionTemplates.player_fast
							}
						},
						{
							_node = {
								class = "ScalableTransformCamera",
								name = "travel_mode_active",
								scale_variable = "zoom",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								scale_function = function(scale)
									return scale
								end
							}
						}
					},
					{
						_node = {
							name = "blade_master_base",
							class = "TransformCamera",
							vertical_fov = 51,
							offset_position = {
								z = 0,
								x = 0,
								y = 0.2
							},
							node_transitions = {
								default = CameraTransitionTemplates.from_blade_master,
								dead = CameraTransitionTemplates.dead,
								attacker_execution_camera = CameraTransitionTemplates.instant_cut,
								victim_execution_camera = CameraTransitionTemplates.instant_cut,
								travel_mode = CameraTransitionTemplates.to_travel_mode
							}
						},
						{
							_node = {
								class = "ScalableTransformCamera",
								name = "blade_master",
								scale_variable = "zoom",
								offset_position = {
									z = 0,
									x = 0,
									y = -2
								},
								scale_function = function(scale)
									return scale
								end
							}
						}
					},
					{
						_node = {
							name = "onground",
							class = "ScalableTransformCamera",
							vertical_fov = 48,
							scale_variable = "zoom",
							offset_position = {
								z = 0,
								x = 0,
								y = -2
							},
							scale_function = function(scale)
								return scale
							end
						},
						{
							_node = {
								name = "dead",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "squad_spawn_camera",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = -5
								}
							}
						},
						{
							_node = {
								name = "climbing",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "planting_flag",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "reviving_teammate",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "bandaging_self",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "bandaging_teammate",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "stunned",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "swing_pose_blend",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "knocked_down",
								class = "TransformCamera",
								vertical_fov = 45,
								offset_position = {
									z = -1,
									x = 0.1,
									y = -0.5
								}
							}
						},
						{
							_node = {
								name = "crouch",
								class = "TransformCamera",
								vertical_fov = 45,
								offset_position = {
									z = -0.5,
									x = 0.1,
									y = 0.15
								}
							}
						},
						{
							_node = {
								name = "throwing_axe",
								class = "TransformCamera",
								pitch_offset = 0,
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								node_transitions = {
									default = CameraTransitionTemplates.unaim_throw,
									dead = CameraTransitionTemplates.dead,
									attacker_execution_camera = CameraTransitionTemplates.instant_cut,
									victim_execution_camera = CameraTransitionTemplates.instant_cut
								}
							}
						},
						{
							_node = {
								name = "throwing_dagger",
								class = "TransformCamera",
								pitch_offset = 0,
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								node_transitions = {
									default = CameraTransitionTemplates.unaim_throw,
									dead = CameraTransitionTemplates.dead,
									attacker_execution_camera = CameraTransitionTemplates.instant_cut,
									victim_execution_camera = CameraTransitionTemplates.instant_cut
								}
							}
						},
						{
							_node = {
								name = "throwing",
								class = "TransformCamera",
								pitch_offset = 0,
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								node_transitions = {
									default = CameraTransitionTemplates.unaim_throw,
									dead = CameraTransitionTemplates.dead,
									attacker_execution_camera = CameraTransitionTemplates.instant_cut,
									victim_execution_camera = CameraTransitionTemplates.instant_cut
								}
							}
						},
						{
							_node = {
								name = "throwing_javelin",
								class = "TransformCamera",
								pitch_offset = 0,
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								},
								node_transitions = {
									default = CameraTransitionTemplates.unaim_throw,
									dead = CameraTransitionTemplates.dead,
									attacker_execution_camera = CameraTransitionTemplates.instant_cut,
									victim_execution_camera = CameraTransitionTemplates.instant_cut
								}
							}
						},
						{
							_node = {
								name = "parry_pose_right",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "parry_pose_left",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "parry_pose_up",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "parry_pose_down",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						}
					}
				},
				{
					_node = {
						name = "jump_scale",
						class = "ScalableTransformCamera",
						vertical_fov = 48,
						scale_variable = "zoom",
						offset_position = {
							z = 0,
							x = 0,
							y = -3
						},
						scale_function = function(scale)
							return scale
						end
					},
					{
						_node = {
							name = "jump",
							class = "TransformCamera",
							offset_position = {
								z = -0.25,
								x = 0,
								y = -1.9
							}
						}
					},
					{
						_node = {
							name = "fall",
							class = "TransformCamera",
							offset_position = {
								z = 0.18,
								x = 0,
								y = -1.85
							}
						}
					},
					{
						_node = {
							name = "land_base",
							class = "TransformCamera",
							offset_position = {
								z = 0.1,
								x = 0,
								y = -1.9
							}
						},
						{
							_node = {
								name = "land_heavy",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "land_light",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "land_knocked_down",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						},
						{
							_node = {
								name = "land_dead",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							}
						}
					}
				},
				{
					_node = {
						name = "rush_base",
						class = "TransformCamera",
						vertical_fov = 55,
						offset_position = {
							z = 0.18,
							x = 0,
							y = -2
						}
					},
					{
						_node = {
							name = "rush",
							class = "ScalableTransformCamera",
							vertical_fov = 58,
							scale_variable = "zoom",
							offset_position = {
								z = 0,
								x = 0,
								y = -2
							},
							scale_function = function(scale)
								return scale
							end
						}
					}
				}
			}
		}
	},
	{
		_node = {
			pitch_min = -85,
			name = "zoom_pitch_aim",
			class = "AimCamera",
			pitch_max = 85,
			pitch_speed = PITCH_SPEED,
			yaw_speed = YAW_SPEED
		},
		{
			_node = {
				name = "zoom",
				class = "TransformCamera",
				vertical_fov = 45,
				offset_position = {
					z = 0.15,
					x = 0.28,
					y = -0.1
				}
			}
		},
		{
			_node = {
				name = "bow_hand",
				class = "ObjectLinkCamera",
				root_object_name = "crossbow_camera_align"
			},
			{
				_node = {
					dof_far_blur = 300,
					name = "zoom_bow_base",
					dof_near_focus = 0.4,
					dof_far_focus = 280,
					dof_amount = 0.5,
					class = "TransformCamera",
					vertical_fov = 45,
					dof_near_blur = 0.2,
					offset_position = {
						z = 0.01,
						x = -0.01,
						y = 0
					}
				},
				{
					_node = {
						name = "zoom_bow",
						class = "ScalableTransformCamera",
						vertical_fov = 5,
						scale_variable = "aim_zoom",
						offset_position = {
							z = 0,
							x = 0,
							y = 0
						},
						scale_function = function(scale)
							return 1 - scale
						end
					}
				}
			},
			{
				_node = {
					dof_far_blur = 300,
					name = "zoom_longbow_base",
					dof_near_focus = 0.4,
					dof_far_focus = 280,
					dof_amount = 0.5,
					class = "TransformCamera",
					vertical_fov = 30,
					dof_near_blur = 0.2,
					offset_position = {
						z = 0.01,
						x = -0.01,
						y = 0
					}
				},
				{
					_node = {
						name = "zoom_longbow",
						class = "ScalableTransformCamera",
						vertical_fov = 5,
						scale_variable = "aim_zoom",
						offset_position = {
							z = 0,
							x = 0,
							y = 0
						},
						scale_function = function(scale)
							return 1 - scale
						end
					}
				}
			}
		},
		{
			_node = {
				dof_near_focus = 0.4,
				name = "zoom_handgonne",
				class = "TransformCamera",
				vertical_fov = 45,
				dof_near_blur = 0,
				offset_position = {
					z = 0.15,
					x = 0.28,
					y = -0.51
				}
			}
		},
		{
			_node = {
				name = "crossbow_hand",
				class = "ObjectLinkCamera",
				root_object_name = "crossbow_camera_align"
			},
			{
				_node = {
					name = "zoom_crossbow_base",
					class = "TransformCamera",
					vertical_fov = 35,
					offset_position = {
						z = 0.03,
						x = 0,
						y = -0.3
					}
				},
				{
					_node = {
						name = "xoom_crossbow_scaled",
						class = "ScalableTransformCamera",
						vertical_fov = 5,
						scale_variable = "aim_zoom",
						offset_position = {
							z = 0,
							x = 0,
							y = 0
						},
						scale_function = function(scale)
							return 1 - scale
						end
					},
					{
						_node = {
							dof_near_focus = 0.5,
							name = "zoom_crossbow",
							class = "SwayCamera",
							dof_amount = 1,
							dof_near_blur = 0.1
						}
					}
				}
			}
		}
	}
}
CameraSettings.world = {
	_node = {
		pitch_min = -90,
		name = "default",
		far_range = 1000,
		pitch_max = -90,
		class = "RootCamera",
		yaw_speed = 0,
		vertical_fov = 45,
		pitch_speed = 0,
		tree_transitions = {},
		node_transitions = {}
	}
}
CameraSettings.main_menu = {
	_node = {
		far_range = 210,
		name = "default",
		pitch_min = 0,
		pitch_max = 0,
		class = "RootCamera",
		yaw_speed = 0,
		vertical_fov = 45,
		pitch_speed = 0,
		tree_transitions = {},
		node_transitions = {}
	},
	{
		_node = {
			class = "OffsetCamera",
			name = "sway"
		}
	}
}
CameraSettings.ingame_menu = {
	_node = {
		pitch_min = 0,
		name = "default",
		near_range = 1,
		far_range = 1000,
		pitch_max = 0,
		class = "RootCamera",
		yaw_speed = 0,
		vertical_fov = 45,
		pitch_speed = 0,
		tree_transitions = {},
		node_transitions = {}
	}
}
CameraSettings.player_dead = {
	_node = {
		pitch_min = -85,
		name = "root_node",
		pitch_offset = 0,
		pitch_max = 85,
		class = "RootCamera",
		vertical_fov = 45,
		root_object_name = "Hips",
		pitch_speed = PITCH_SPEED,
		yaw_speed = YAW_SPEED,
		safe_position_offset = Vector3Box(0, 0, 1.55),
		tree_transitions = {},
		node_transitions = {
			default = CameraTransitionTemplates.dead
		}
	},
	{
		_node = {
			yaw = true,
			name = "yaw_aim",
			class = "AimCamera",
			pitch_offset = 22.5,
			pitch = false
		},
		{
			_node = {
				name = "up_translation",
				class = "TransformCamera",
				offset_position = {
					z = 0.25,
					x = 0,
					y = 0
				}
			},
			{
				_node = {
					pitch = true,
					name = "pitch_aim",
					class = "AimCamera",
					yaw = true
				},
				{
					_node = {
						name = "onground_no_scale",
						class = "TransformCamera",
						offset_position = {
							z = 0.18,
							x = 0,
							y = -2
						}
					},
					{
						_node = {
							name = "onground",
							class = "ScalableTransformCamera",
							vertical_fov = 48,
							scale_variable = "zoom",
							offset_position = {
								z = 0,
								x = 0,
								y = -2
							},
							scale_function = function(scale)
								return scale
							end
						},
						{
							_node = {
								name = "knocked_down",
								class = "TransformCamera",
								offset_position = {
									z = 0,
									x = 0,
									y = 0
								}
							},
							{
								_node = {
									name = "default",
									class = "TransformCamera",
									offset_position = {
										z = 0,
										x = 0,
										y = 0
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
CameraSettings.standard_bow_arrow = {
	_node = {
		pitch_min = -90,
		name = "root_node",
		pitch_speed = 0,
		offset_pitch = -10,
		pitch_max = -90,
		class = "RootCamera",
		yaw_speed = 0,
		vertical_fov = 80,
		root_object_name = "rp_wpn_arrow_01",
		safe_position_offset = Vector3Box(0, 0, 1.55),
		tree_transitions = {},
		node_transitions = {}
	},
	{
		_node = {
			name = "default",
			class = "TransformCamera",
			offset_position = {
				z = 0.03,
				x = 0,
				y = -0.1
			}
		}
	}
}
CameraSettings.cutscene = {
	_node = {
		pitch_min = -90,
		name = "root_node",
		offset_pitch = -10,
		pitch_max = -90,
		class = "RootCamera",
		yaw_speed = 0,
		vertical_fov = 80,
		pitch_speed = 0,
		safe_position_offset = Vector3Box(0, 0, 1.55),
		tree_transitions = {},
		node_transitions = {}
	}
}
