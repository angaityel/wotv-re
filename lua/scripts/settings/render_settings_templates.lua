﻿-- chunkname: @scripts/settings/render_settings_templates.lua

GraphicsQuality = {
	very_low = {
		user_settings = {
			graphics_quality = "very_low",
			texture_quality_characters = "low",
			shadow_quality = "off",
			texture_quality_environment = "low",
			apex_cloth = "off",
			texture_quality_coat_of_arms = "low",
			light_casts_shadows = false,
			particles_quality = "low"
		},
		render_settings = {
			ssao_enabled = false,
			csm_enabled = false,
			lighting = false,
			lod_scatter_density = 0,
			lod_decoration_density = 0.1,
			fxaa_enabled = false,
			lod_object_multiplier = 0.6,
			shadow_map_size = {
				2,
				2
			}
		}
	},
	low = {
		user_settings = {
			graphics_quality = "low",
			texture_quality_characters = "low",
			shadow_quality = "low",
			texture_quality_environment = "low",
			apex_cloth = "off",
			texture_quality_coat_of_arms = "low",
			light_casts_shadows = false,
			particles_quality = "low"
		},
		render_settings = {
			ssao_enabled = false,
			csm_enabled = true,
			lighting = true,
			lod_scatter_density = 0,
			lod_decoration_density = 0.1,
			fxaa_enabled = false,
			lod_object_multiplier = 0.6,
			shadow_map_size = {
				512,
				512
			}
		}
	},
	medium = {
		user_settings = {
			graphics_quality = "medium",
			texture_quality_characters = "medium",
			shadow_quality = "medium",
			texture_quality_environment = "medium",
			apex_cloth = "off",
			texture_quality_coat_of_arms = "medium",
			light_casts_shadows = false,
			particles_quality = "medium"
		},
		render_settings = {
			ssao_enabled = true,
			csm_enabled = true,
			lighting = true,
			lod_scatter_density = 0.5,
			lod_decoration_density = 0.5,
			fxaa_enabled = false,
			lod_object_multiplier = 0.8,
			shadow_map_size = {
				1024,
				1024
			}
		}
	},
	high = {
		user_settings = {
			graphics_quality = "high",
			texture_quality_characters = "high",
			shadow_quality = "high",
			texture_quality_environment = "high",
			apex_cloth = "off",
			texture_quality_coat_of_arms = "high",
			light_casts_shadows = false,
			particles_quality = "high"
		},
		render_settings = {
			ssao_enabled = true,
			csm_enabled = true,
			lighting = true,
			lod_scatter_density = 1,
			lod_decoration_density = 1,
			fxaa_enabled = true,
			lod_object_multiplier = 1,
			shadow_map_size = {
				2048,
				2048
			}
		}
	},
	extreme = {
		user_settings = {
			graphics_quality = "high",
			texture_quality_characters = "extreme",
			shadow_quality = "high",
			texture_quality_environment = "extreme",
			apex_cloth = "medium",
			texture_quality_coat_of_arms = "high",
			light_casts_shadows = true,
			particles_quality = "high"
		},
		render_settings = {
			ssao_enabled = true,
			csm_enabled = true,
			lighting = true,
			lod_scatter_density = 1,
			lod_decoration_density = 1,
			fxaa_enabled = true,
			lod_object_multiplier = 1,
			shadow_map_size = {
				2048,
				2048
			}
		}
	},
	custom = {
		user_settings = {},
		render_settings = {}
	},
	shadows = {
		off = {
			2,
			2
		},
		low = {
			512,
			512
		},
		medium = {
			1024,
			1024
		},
		high = {
			2048,
			2048
		},
		extreme = {
			4096,
			4096
		}
	}
}
ApexClothQuality = {
	off = {
		disable_apex_cloth = true
	},
	low = {
		disable_apex_cloth = false,
		apex_lod_resource_budget = 0.5
	},
	medium = {
		disable_apex_cloth = false,
		apex_lod_resource_budget = 1.5
	},
	high = {
		disable_apex_cloth = false,
		apex_lod_resource_budget = 3
	},
	extreme = {
		disable_apex_cloth = false,
		apex_lod_resource_budget = 5
	}
}
ParticlesQuality = {
	low = {
		particles_receive_shadows = false,
		particles_cast_shadows = false,
		particles_local_lighting = false,
		particles_tessellation = false
	},
	medium = {
		particles_receive_shadows = true,
		particles_cast_shadows = false,
		particles_local_lighting = true,
		particles_tessellation = false
	},
	high = {
		particles_receive_shadows = true,
		particles_cast_shadows = true,
		particles_local_lighting = true,
		particles_tessellation = true
	}
}
TextureQuality = {
	default = "high",
	characters = {
		low = {
			{
				mip_level = 3,
				texture_setting = "texture_categories/character_df"
			},
			{
				mip_level = 3,
				texture_setting = "texture_categories/character_gsm"
			},
			{
				mip_level = 3,
				texture_setting = "texture_categories/character_nm"
			},
			{
				mip_level = 3,
				texture_setting = "texture_categories/weapon_df"
			},
			{
				mip_level = 3,
				texture_setting = "texture_categories/weapon_gsm"
			},
			{
				mip_level = 3,
				texture_setting = "texture_categories/weapon_nm"
			}
		},
		medium = {
			{
				mip_level = 2,
				texture_setting = "texture_categories/character_df"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/character_gsm"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/character_nm"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/weapon_df"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/weapon_gsm"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/weapon_nm"
			}
		},
		high = {
			{
				mip_level = 1,
				texture_setting = "texture_categories/character_df"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/character_gsm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/character_nm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/weapon_df"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/weapon_gsm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/weapon_nm"
			}
		},
		extreme = {
			{
				mip_level = 0,
				texture_setting = "texture_categories/character_df"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/character_gsm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/character_nm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/weapon_df"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/weapon_gsm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/weapon_nm"
			}
		}
	},
	environment = {
		low = {
			{
				mip_level = 2,
				texture_setting = "texture_categories/environment_df"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_dfa"
			},
			{
				mip_level = 2,
				texture_setting = "texture_categories/environment_gsm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_nm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/fx"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/gui"
			}
		},
		medium = {
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_df"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_dfa"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_gsm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_nm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/fx"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/gui"
			}
		},
		high = {
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_df"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_dfa"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_gsm"
			},
			{
				mip_level = 1,
				texture_setting = "texture_categories/environment_nm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/fx"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/gui"
			}
		},
		extreme = {
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_df"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_dfa"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_gsm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/environment_nm"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/fx"
			},
			{
				mip_level = 0,
				texture_setting = "texture_categories/gui"
			}
		}
	},
	coat_of_arms = {
		low = {
			{
				mip_level = 2,
				texture_setting = "texture_categories/coat_of_arms"
			}
		},
		medium = {
			{
				mip_level = 1,
				texture_setting = "texture_categories/coat_of_arms"
			}
		},
		high = {
			{
				mip_level = 0,
				texture_setting = "texture_categories/coat_of_arms"
			}
		}
	}
}
