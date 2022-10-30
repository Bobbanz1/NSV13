/obj/item/robot_module
	var/icon/cyborg_icon_override
	var/model_select_alternate_icon
	var/list/model_features = list()

/obj/item/robot_module/standard
	name = "Standard"
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "robot"),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_standard", SKIN_ICON = CYBORG_ICON_STANDARD, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK)),
		"Protectron" = list(SKIN_ICON_STATE = "protectron_standard", SKIN_ICON = CYBORG_ICON_STANDARD),
	)

/obj/item/robot_module/medical
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "medical"),
		"Protectron" = list(SKIN_ICON = CYBORG_ICON_MED, SKIN_ICON_STATE = "protectron_medical"),
		"Zoomba" = list(SKIN_ICON = CYBORG_ICON_MED, SKIN_ICON_STATE = "zoomba_med", SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK), SKIN_HAT_OFFSET = -13),
	)
/obj/item/robot_module/engineering
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "engineer"),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_engi", SKIN_ICON = CYBORG_ICON_ENG, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK), SKIN_HAT_OFFSET = -13),
		"Default - Treads" = list(SKIN_ICON_STATE = "engi-tread", SKIN_LIGHT_KEY = "engineer", SKIN_ICON = CYBORG_ICON_ENG),
		"Can" = list(SKIN_ICON_STATE = "caneng", SKIN_ICON = CYBORG_ICON_ENG),
		"Loader" = list(SKIN_ICON_STATE = "loaderborg", SKIN_ICON = CYBORG_ICON_ENG, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK)),
	)

/obj/item/robot_module/peacekeeper
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "peace"),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_peace", SKIN_ICON = CYBORG_ICON_PEACEKEEPER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK), SKIN_HAT_OFFSET = -13),
		"Spider" = list(SKIN_ICON_STATE = "whitespider", SKIN_ICON = CYBORG_ICON_PEACEKEEPER),
	)

/obj/item/robot_module/janitor
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "janitor"),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_jani", SKIN_ICON = CYBORG_ICON_JANI, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK), SKIN_HAT_OFFSET = -13),
		"Can" = list(SKIN_ICON_STATE = "canjan", SKIN_ICON = CYBORG_ICON_JANI),
		"Protectron" = list(SKIN_ICON_STATE = "protectron_janitor", SKIN_ICON = CYBORG_ICON_JANI),
	)

/obj/item/robot_module/clown
	borg_skins = list(
		"Default" = list(SKIN_ICON_STATE = "clown"),
		"Clown Ross" = list(SKIN_ICON_STATE = "clownbot", SKIN_ICON = CYBORG_ICON_CLOWN),
	)

/obj/item/robot_module/butler
	special_light_key = null
	borg_skins = list(
		"Waitress" = list(SKIN_ICON_STATE = "service_f", SKIN_LIGHT_KEY = "service"),
		"Butler" = list(SKIN_ICON_STATE = "service_m", SKIN_LIGHT_KEY = "service"),
		"Bro" = list(SKIN_ICON_STATE = "brobot", SKIN_LIGHT_KEY = "service"),
		"Kent" = list(SKIN_ICON_STATE = "kent", SKIN_LIGHT_KEY = "medical"),
		"Tophat" = list(SKIN_ICON_STATE = "tophat"),
		"Handy" = list(SKIN_ICON_STATE = "handy-service", SKIN_ICON = CYBORG_ICON_SERVICE),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_green", SKIN_ICON = CYBORG_ICON_SERVICE, SKIN_FEATURES = list(model_features = R_TRAIT_UNIQUEWRECK)),
	)

/obj/item/robot_module/miner
	special_light_key = null
	borg_skins = list(
		"Lavaland Miner" = list(SKIN_ICON_STATE = "miner", SKIN_LIGHT_KEY = "miner"),
		"Asteroid Miner" = list(SKIN_ICON_STATE = "minerOLD", SKIN_LIGHT_KEY = "miner"),
		"Spider Miner" = list(SKIN_ICON_STATE = "spidermin", SKIN_LIGHT_KEY = "miner"),
		"Zoomba" = list(SKIN_ICON_STATE = "zoomba_miner", SKIN_ICON = CYBORG_ICON_MINING, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK)),
		"Can" = list(SKIN_ICON_STATE = "canmin", SKIN_ICON = CYBORG_ICON_MINING),
		"Drone" = list(SKIN_ICON_STATE = "miningdrone", SKIN_ICON = CYBORG_ICON_MINING),
	)
