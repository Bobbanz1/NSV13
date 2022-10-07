/obj/machinery/steam_clock/steam/machine/primary
	dir = SOUTH
	initialize_directions = SOUTH
	device_type = PRIMARY_MACHINE
	pipe_flags = PIPING_ONE_PER_TURF
	construction_type = /obj/item/brass_pipe/directional

/obj/machinery/steam_clock/steam/machine/primary/SetInitDirections()
	initialize_directions = dir

/obj/machinery/steam_clock/steam/machine/primary/on_construction()
	..()
	update_icon()

/obj/machinery/steam_clock/steam/machine/primary/hide(intact)
	update_icon()
	..(intact)
