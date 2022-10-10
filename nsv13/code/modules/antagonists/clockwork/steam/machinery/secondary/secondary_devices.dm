/obj/machinery/steam_clock/steam/machine/secondary
	icon = 'nsv13/icons/obj/clockwork/steam/machines/secondary/secondary_devices.dmi'
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	use_power = IDLE_POWER_USE
	device_type = SECONDARY_MACHINE
	layer = GAS_PUMP_LAYER

/obj/machinery/steam_clock/steam/machine/secondary/SetInitDirections()
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = NORTH|SOUTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST

/obj/machinery/steam_clock/steam/machine/secondary/hide(intact)
	update_icon()
	..(intact)

/obj/machinery/steam_clock/steam/machine/secondary/getNodeConnects()
	return list(turn(dir, 180), dir)
