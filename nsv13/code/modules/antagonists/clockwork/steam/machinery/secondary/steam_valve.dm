/obj/machinery/steam_clock/steam/machine/secondary/valve
	icon_state = "map_steam_valve"

	name = "manual steam valve"
	desc = "A valve that allows for manual control of steam flow."

	can_unwrench = TRUE

	interaction_flags_machine = INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OPEN
	pipe_flags = PIPING_CARDINAL_AUTONORMALIZE

	var/valve_type = "m"

	pipe_state = "steam_valve"

	var/switching = FALSE

