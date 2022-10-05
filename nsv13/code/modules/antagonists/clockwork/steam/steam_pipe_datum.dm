/datum/steamline
	var/datum/gas_mixture/steam
	var/list/datum/gas_mixture/other_steams

	var/list/obj/machinery/steam_clock/steam/pipe/members
	var/list/obj/machinery/steam_clock/steam/machine/other_steammch

	var/update = TRUE

/datum/steamline/New()
	other_steams = list()
	members = list()
	other_steammch = list()
	SSsteam.networks += src

/datum/steamline/Destroy()
	SSsteam.networks -= src
	if(steam && steam.return_volume())
		temporarily_store_steam()
	for(var/obj/machinery/steam_clock/steam/pipe/P in members)
		P.parent = null
	for(var/obj/machinery/steam_clock/steam/machine/M in other_steammch)
		M.nullifyPipenet(src)
	return ..()

/datum/steamline/process()
	if(update)
		update = FALSE
		reconcile_steam()
	update = steam.react(src)

/datum/steamline/proc/build_steamline(obj/machinery/steam_clock/steam/base)
	var/volume = 0
	if(istype(base, /obj/machinery/steam_clock/steam/pipe))
		var/obj/machinery/steam_clock/steam/pipe/E = base
		volume = E.volume
		members += E
		if(E.steam_temporary)
			steam = E.steam_temporary
			E.steam_temporary = null
	else
		addMachineryMember(base)
	if(!steam)
		steam = new
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

							if(item.steam_temporary)
								steam.merge(item.steam_temporary)
								item.steam_temporary = null
					else
						P.setPipenet(src, borderline)
						addMachineryMember(P)

			possible_expansions -= borderline

	steam.set_volume(volume)

/datum/steamline/proc/addMachineryMember(obj/machinery/steam_clock/steam/machine/M)
	other_steammch |= M
	var/datum/gas_mixture/G = M.returnPipenetSteam(src)
	if(!G)
		stack_trace("addMachineryMember: Null gasmix added to steamline datum from [M] which is of type [M.type]. Nearby: ([M.x], [M.y], [M.z])")
	other_steams |= G

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
			steam.set_volume(steam.return_volume() + P.volume)
	else
		A.setPipenet(src, N)
		addMachineryMember(A)

/datum/steamline/proc/merge(datum/steamline/E)
	if(E == src)
		return
	steam.set_volume(steam.return_volume() + E.steam.return_volume())
	members.Add(E.members)
	for(var/obj/machinery/steam_clock/steam/pipe/S in E.members)
		S.parent = src
	steam.merge(E.steam)
	for(var/obj/machinery/steam_clock/steam/machine/M in E.other_steammch)
		M.replacePipenet(E, src)
	other_steammch.Add(E.other_steammch)
	other_steams.Add(E.other_steams)
	E.members.Cut()
	E.other_steammch.Cut()
	update = TRUE
	qdel(E)

/obj/machinery/steam_clock/steam/proc/addMember(obj/machinery/steam_clock/steam/A)
	return

/obj/machinery/steam_clock/steam/pipe/addMember(obj/machinery/steam_clock/steam/A)
	parent.addMember(A, src)

/obj/machinery/steam_clock/steam/machine/addMember(obj/machinery/steam_clock/steam/S)
	var/datum/steamline/L = returnPipenet(S)
	if(!L)
		CRASH("null.addMember() called by [type] on [COORD(src)]")
	L.addMember(S, src)

/datum/steamline/proc/temporarily_store_steam()
	for(var/obj/machinery/steam_clock/steam/pipe/member in members)
		member.steam_temporary = new
		member.steam_temporary.set_volume(member.volume)
		member.steam_temporary.copy_from(steam)

		member.steam_temporary.multiply(member.volume/steam.return_volume())

		member.steam_temporary.set_temperature(steam.return_temperature())

/datum/steamline/proc/return_steam()
	. = other_steams + steam

/datum/steamline/proc/empty()
	for(var/datum/gas_mixture/GM in get_all_connected_steam())
		GM.clear()

/datum/steamline/proc/get_all_connected_steam()
	var/list/datum/gas_mixture/GL = list()
	var/list/datum/steamline/SL = list()
	SL += src

	for(var/i = 1; i <= SL.len; i++)
		var/datum/steamline/S = SL[i]
		if(!S)
			continue
		GL += S.return_steam()

	return GL

/datum/steamline/proc/reconcile_steam()
	var/list/datum/gas_mixture/GL = get_all_connected_steam()
	equalize_all_gases_in_list(GL)
