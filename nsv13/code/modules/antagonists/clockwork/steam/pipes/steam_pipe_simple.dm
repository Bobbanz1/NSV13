/obj/machinery/steam_clock/steam/pipe/simple
	icon = 'nsv13/icons/obj/clockwork/steam/pipes.dmi'
	icon_state = "steam_pipe"

	name = "steam pipe"
	desc = "A one meter section of brass steam pushing pipe."

	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	pipe_flags = PIPING_CARDINAL_AUTONORMALIZE

	device_type = BINARY

	//construction_type = /obj/item/pipe/binary/bendable
	//pipe_state = "simple"

/obj/machinery/steam_clock/steam/pipe/simple/SetInitDirections()
	if(dir in GLOB.diagonals)
		initialize_directions = dir
		return
	switch(dir)
		if(NORTH, SOUTH)
			initialize_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST

/obj/machinery/steam_clock/steam/pipe/simple/update_icon()
	icon_state = "steam_pipe"
	update_alpha()
