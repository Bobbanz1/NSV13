/datum/steamline
	var/list/obj/machinery/steam_clock/steam/pipe/members
	var/update = TRUE

/datum/steamline/New()
	members = list()

/datum/steamline/Destroy()
	for(var/obj/machinery/steam_clock/steam/pipe/P in members)
		P.parent = null
	return ..()

/datum/steamline/proc/build_steamline(obj/machinery/steam_clock/steam/base)
	var/volume = 0
	if(istype(base, /obj/machinery/steam_clock/steam/pipe))
		var/obj/machinery/steam_clock/steam/pipe/E = base
		volume = E.volume
		members += E
	//else
	var/list/possible_expansions = list(base)
	while(possible_expansions.len > 0)
		for(var/obj/machinery/steam_clock/steam/borderline in possible_expansions)
			var/list/result = borderline.steamline_expansion(src)
			if(result.len > 0)
				for(var/obj/machinery/steam_clock/steam/P in result)
					if(istype(P, /obj/machinery/steam_clock/steam/pipe))
						var/obj/machinery/steam_clock/steam/pipe/item = P
						if(!members.Find(item))
							if(item.parent)
								var/static/steamnetwarnings = 10
								if(steamnetwarnings > 0)
									log_mapping("build_steamline(): [item.type] added to a steamnet while still having one. (pipes leading to the same spot stacking in one turf) Nearby: ([item.x], [item.y], [item.z]).")
									steamnetwarnings -= 1
									if(steamnetwarnings == 0)
										log_mapping("build_steamline(): further messages about steamnet will be suppressed")
							members += item
							possible_expansions += item

							volume += item.volume
							item.parent = src

			possible_expansions -= borderline


/datum/steamline/proc/addMember(obj/machinery/steam_clock/steam/A, obj/machinery/steam_clock/steam/N)
	if(istype(A, /obj/machinery/steam_clock/steam/pipe))
		var/obj/machinery/steam_clock/steam/pipe/P = A
		if(P.parent)
			merge(P.parent)
		P.parent = src
		var/list/adjacent = P.steamline_expansion()
		for(var/obj/machinery/steam_clock/steam/pipe/I in adjacent)
			if(I.parent == src)
				continue
			var/datum/steamline/E = I.parent
			merge(E)
		if(!members.Find(P))
			members += P

/datum/steamline/proc/merge(datum/pipeline/E)
	if(E == src)
		return
	members.Add(E.members)
	for(var/obj/machinery/steam_clock/steam/pipe/S in E.members)
		S.parent = src
	E.members.Cut()
	update = TRUE
	qdel(E)
