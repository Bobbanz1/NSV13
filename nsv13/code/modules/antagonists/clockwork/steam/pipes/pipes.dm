/obj/machinery/steam_clock/steam/pipe
	var/volume = 0

	level = 1

	use_power = NO_POWER_USE
	can_unwrench = 1
	var/datum/steamline/parent = null

/obj/machinery/steam_clock/steam/pipe/New()
	volume = 35 * device_type
	..()

/obj/machinery/steam_clock/steam/pipe/destroy_network()
	QDEL_NULL(parent)

/obj/machinery/steam_clock/steam/pipe/build_network()
	if(QDELETED(parent))
		parent = new
		parent.build_steamline(src)

/obj/machinery/steam_clock/steam/pipe/hide(i)
	if(level == 1 && isturf(loc))
		invisibility = i ? INVISIBILITY_MAXIMUM : 0
	update_icon()

/obj/machinery/steam_clock/steam/pipe/returnPipenet()
//	if(parent)
//		return parent.air

/obj/machinery/steam_clock/steam/pipe/setPipenet(datum/steamline/P)
	parent = P

/obj/machinery/steam_clock/steam/pipe/update_icon()
	. = ..()
	update_alpha()

/obj/machinery/steam_clock/steam/pipe/proc/update_alpha()
	alpha = invisibility ? 64 : 255

/obj/machinery/steam_clock/steam/pipe/proc/update_node_icon()
	for(var/i in 1 to device_type)
		if(nodes[i])
			var/obj/machinery/steam_clock/steam/N = nodes[i]
			N.update_icon()

/obj/machinery/steam_clock/steam/pipe/returnPipenets()
	. = list(parent)
