/obj/machinery/steam_clock/steam
	icon = 'nsv13/icons/obj/clockwork/steam/pipes.dmi'
	icon_state = "steam_pipe"
	anchored = TRUE
	move_resist = INFINITY
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = AREA_USAGE_ENVIRON
	layer = GAS_PIPE_HIDDEN_LAYER
	resistance_flags = FIRE_PROOF
	max_integrity = 200
	obj_flags = CAN_BE_HIT | ON_BLUEPRINTS
	var/can_unwrench = 0
	var/initialize_directions = 0
	var/pipe_flags = NONE

	var/device_type = 0
	var/list/obj/machinery/steam_clock/steam/nodes

	var/on = FALSE
	var/interacts_with_steam = FALSE

/obj/machinery/steam_clock/steam/New(loc, process = TRUE, setdir)
	if(!isnull(setdir))
		setDir(setdir)
	if(pipe_flags & PIPING_CARDINAL_AUTONORMALIZE)
		normalize_cardinal_directions()
	nodes = new(device_type)
	..()
	if(process)
		if(interacts_with_steam)
			SSsteam.steam_air_machinery += src
		else
			SSsteam.steam_machinery += src
	SetInitDirections()

/obj/machinery/steam_clock/steam/Destroy()
	for(var/i in 1 to device_type)
		nullifyNode(i)

	SSsteam.steam_machinery -= src
	SSsteam.steam_air_machinery -= src
	SSsteam.steamnets_needing_rebuilt -= src

	dropContents()
	return ..()

/obj/machinery/steam_clock/steam/proc/destroy_network()
	return

/obj/machinery/steam_clock/steam/proc/build_network()
	return

/obj/machinery/steam_clock/steam/proc/nullifyNode(i)
	if(nodes[i])
		var/obj/machinery/steam_clock/steam/N = nodes[i]
		N.disconnect(src)
		nodes[i] = null

/obj/machinery/steam_clock/steam/proc/getNodeConnects()
	var/list/node_connects = list()
	node_connects.len = device_type

	for(var/i in 1 to device_type)
		for(var/D in GLOB.cardinals)
			if(D & GetInitDirections())
				if(D in node_connects)
					continue
				node_connects[i] = D
				break
	return node_connects

/obj/machinery/steam_clock/steam/proc/normalize_cardinal_directions()
	switch(dir)
		if(SOUTH)
			setDir(NORTH)
		if(WEST)
			setDir(EAST)

/obj/machinery/steam_clock/steam/proc/steaminit(list/node_connects)
	if(!node_connects) //for pipes where order of nodes doesn't matter
		node_connects = getNodeConnects()

	for(var/i in 1 to device_type)
		for(var/obj/machinery/steam_clock/steam/target in get_step(src, node_connects[i]))
			if(can_be_node(target, i))
				nodes[i] = target
				break
	update_icon()

/obj/machinery/steam_clock/steam/proc/can_be_node(obj/machinery/steam_clock/steam/target, iteration)
	return connection_check(target)

/obj/machinery/steam_clock/steam/proc/findConnecting(direction)
	for(var/obj/machinery/steam_clock/steam/target in get_step(src, direction))
		if(target.initialize_directions & get_dir(target,src))
			if(connection_check(target))
				return target

/obj/machinery/steam_clock/steam/proc/connection_check(obj/machinery/steam_clock/steam/target)
	if(isConnectable(target) && target.isConnectable(src) && (target.initialize_directions & get_dir(target, src)))
		return TRUE
	return FALSE

/obj/machinery/steam_clock/steam/proc/isConnectable(obj/machinery/steam_clock/steam/target)
	return TRUE

/obj/machinery/steam_clock/steam/proc/steamline_expansion()
	return nodes

/obj/machinery/steam_clock/steam/proc/SetInitDirections()
	return

/obj/machinery/steam_clock/steam/proc/GetInitDirections()
	return initialize_directions

/obj/machinery/steam_clock/steam/proc/returnPipenet()
	return

/obj/machinery/steam_clock/steam/proc/returnPipenetSteam()
	return

/obj/machinery/steam_clock/steam/proc/setPipenet()
	return

/obj/machinery/steam_clock/steam/proc/replacePipenet()
	return

/obj/machinery/steam_clock/steam/proc/disconnect(obj/machinery/steam_clock/steam/reference)
	if(istype(reference, /obj/machinery/steam_clock/steam/pipe))
		var/obj/machinery/steam_clock/steam/pipe/P = reference
		P.destroy_network()
	if(nodes.len >= nodes.Find(reference)) // for some reason things can still be acted on even though they've been deleted this is a really fucky way of detecting that
		nodes[nodes.Find(reference)] = null
		update_icon()

/obj/machinery/steam_clock/steam/proc/returnPipenets()
	return list()
