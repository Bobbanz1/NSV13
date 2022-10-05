/obj/machinery/steam_clock/steam/machine
	var/showpipe = FALSE

	var/list/datum/steamline/parents
	var/list/datum/gas_mixture/steams

/obj/machinery/steam_clock/steam/machine/New()
	parents = new(device_type)
	steams = new(device_type)

	..()

	for(var/i in 1 to device_type)
		var/datum/gas_mixture/A = new(200)
		steams[i] = A

/obj/machinery/steam_clock/steam/machine/proc/update_icon_nopipes()
	return

/obj/machinery/steam_clock/steam/machine/update_icon()
	update_icon_nopipes()

	underlays.Cut()

	var/turf/T = loc
	if(level == 2 || (istype(T) && !T.intact))
		showpipe = TRUE
		plane = GAME_PLANE
	else
		showpipe = FALSE
		plane = FLOOR_PLANE

	if(!showpipe)
		return

	var/connected = 0

	for(var/i in 1 to device_type)
		if(nodes[i])
			var/obj/machinery/steam_clock/steam/node = nodes[i]
			var/image/img = get_pipe_underlay("pipe_intact", get_dir(src, node))
			underlays += img
			connected |= img.dir

	for(var/direction in GLOB.cardinals)
		if((initialize_directions & direction) && !(connected & direction))
			underlays += get_pipe_underlay("pipe_exposed", direction)

/obj/machinery/steam_clock/steam/machine/proc/get_pipe_underlay(state, dir)
	. = getpipeimage('nsv13/icons/obj/clockwork/steam/pipes.dmi', state, dir)

/obj/machinery/steam_clock/steam/machine/nullifyNode(i)
	if(parents[i])
		nullifyPipenet(parents[i])
	if(steams[i])
		QDEL_NULL(steams[i])
	..()

/obj/machinery/steam_clock/steam/machine/on_construction()
	..()
	update_parents()

/obj/machinery/steam_clock/steam/machine/build_network()
	for(var/i in 1 to device_type)
		if(QDELETED(parents[i]))
			parents[i] = new /datum/steamline()
			var/datum/steamline/P = parents[i]
			P.build_steamline(src)

/obj/machinery/steam_clock/steam/machine/proc/nullifyPipenet(datum/steamline/reference)
	if(!reference)
		CRASH("nullifyPipenet(null) called by [type] on [COORD(src)]")
	var/i = parents.Find(reference)
	reference.other_steams -= steams[i]
	reference.other_steammch -= src
	if(!(reference.other_steammch.len || reference.members.len || QDESTROYING(reference)))
		qdel(reference)
	parents[i] = null

/obj/machinery/steam_clock/steam/machine/returnPipenetSteam(datum/steamline/reference)
	for(var/i in 1 to device_type)
		if(parents[i] == reference)
			if(.)
				if(!islist(.))
					. = list(.)
				. += steams[i]
			else
				. = steams[i]

/obj/machinery/steam_clock/steam/machine/steamline_expansion(datum/steamline/reference)
	if(reference)
		return list(nodes[parents.Find(reference)])
	return ..()

/obj/machinery/steam_clock/steam/machine/setPipenet(datum/steamline/reference, obj/machinery/steam_clock/steam/S)
	parents[nodes.Find(S)] = reference

/obj/machinery/steam_clock/steam/machine/returnPipenet(obj/machinery/steam_clock/steam/S = nodes[1])
	return parents[nodes.Find(S)]

/obj/machinery/steam_clock/steam/machine/replacePipenet(datum/steamline/Old, datum/steamline/New)
	parents[parents.Find(Old)] = New


/obj/machinery/steam_clock/steam/machine/proc/update_parents()
	for(var/i in 1 to device_type)
		var/datum/steamline/parent = parents[i]
		if(!parent)
			SSsteam.add_to_rebuild_queue(src)
			continue
		parent.update = PIPENET_UPDATE_STATUS_RECONCILE_NEEDED

/obj/machinery/steam_clock/steam/machine/returnPipenets()
	. = list()
	for(var/i in 1 to device_type)
		. += returnPipenet(nodes[i])

/obj/machinery/steam_clock/steam/machine/ui_status(mob/user)
	if(allowed(user))
		return ..()
	to_chat(user, "<span class='danger'>Access denied.</span>")
	return UI_CLOSE
