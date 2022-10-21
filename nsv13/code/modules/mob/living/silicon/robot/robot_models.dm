/obj/item/robot_module
	var/icon/cyborg_icon_override
	var/model_select_alternate_icon
	var/list/model_features = list()

/obj/item/robot_module/standard
	name = "Standard"

/obj/item/robot_module/medical
	name = "Medical"

/obj/item/robot_module/engineering
	name = "Engineering"

/obj/item/robot_module/peacekeeper
	name = "Peacekeeper"

/obj/item/robot_module/janitor
	name = "Janitor"

/obj/item/robot_module/clown
	name = "Clown"

/obj/item/robot_module/butler
	special_light_key = null
	borg_skins = list(
		"Waitress" = list(SKIN_ICON_STATE = "service_f", SKIN_LIGHT_KEY = "service"),
		"Butler" = list(SKIN_ICON_STATE = "service_m", SKIN_LIGHT_KEY = "service"),
		"Bro" = list(SKIN_ICON_STATE = "brobot", SKIN_LIGHT_KEY = "service"),
		"Kent" = list(SKIN_ICON_STATE = "kent", SKIN_LIGHT_KEY = "medical"),
		"Tophat" = list(SKIN_ICON_STATE = "tophat"),
		"Borgi" = list(SKIN_ICON_STATE = "borgi-serv", SKIN_ICON = CYBORG_ICON_SERVICE, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK)),
	)
/obj/item/robot_module/miner
	name = "Miner"
	borg_skins = list(
		"Lavaland Miner" = list(SKIN_ICON_STATE = "miner"),
		"Asteroid Miner" = list(SKIN_ICON_STATE = "minerOLD"),
		"Spider Miner" = list(SKIN_ICON_STATE = "spidermin"),
	)
