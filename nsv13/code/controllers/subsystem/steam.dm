SUBSYSTEM_DEF(steam)
	name = "Steamworks"
	init_order = INIT_ORDER_DEFAULT
	priority = FIRE_PRIORITY_ATMOS_ADJACENCY
	wait = 0.5 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/cost_groups = 0
	var/cost_post_process = 0
	var/cost_rebuilds = 0
	var/cost_steam_machinery = 0
	var/cost_steamnets = 0

	var/list/networks = list()
	var/list/steamnets_needing_rebuilt = list()
	var/list/obj/machinery/steam_clock/steam/steam_machinery = list()
	var/list/obj/machinery/steam_clock/steam/steam_air_machinery = list()
	var/list/steam_init_dirs_cache = list()

	var/list/currentrun = list()
	var/currentpart = SSSTEAM_REBUILD_STEAMNETS

	var/map_loading = TRUE

/datum/controller/subsystem/steam/stat_entry(msg)
	msg += "C:{"
	msg += "SN:[round(cost_steamnets,1)]|"
	msg += "SM:[round(cost_steam_machinery,1)]"
	msg += "} "
	msg += "TC:{"
	msg += "EG:[round(cost_groups,1)]|"
	msg += "PO:[round(cost_post_process,1)]"
	msg += "}"
	msg += "PN:[networks.len]|"
	return ..()

/datum/controller/subsystem/steam/Initialize(start_timeofday)
	map_loading = FALSE
	setup_steam_machinery()
	setup_steamnets()
	return ..()

/datum/controller/subsystem/steam/fire(resumed = 0)
	var/timer = TICK_USAGE_REAL

	if(currentpart == SSSTEAM_REBUILD_STEAMNETS)
		timer = TICK_USAGE_REAL
		var/list/steamnet_rebuilds = steamnets_needing_rebuilt
		for(var/thing in steamnet_rebuilds)
			var/obj/machinery/steam_clock/steam/ST = thing
			if(!istype(ST))
				continue
			ST.build_network()
		cost_rebuilds = MC_AVERAGE(cost_rebuilds, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		steamnets_needing_rebuilt.Cut()
		if(state != SS_RUNNING)
			return
		resumed = FALSE
		currentpart = SSSTEAM_PIPENETS

	if(currentpart == SSSTEAM_PIPENETS || !resumed)
		timer = TICK_USAGE_REAL
		process_steamnets(resumed)
		cost_steamnets = MC_AVERAGE(cost_steamnets, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSSTEAM_STEAMMACHINERY
	if(currentpart == SSSTEAM_STEAMMACHINERY)
		timer = TICK_USAGE_REAL
		process_steam_machinery(resumed)
		cost_steam_machinery = MC_AVERAGE(cost_steam_machinery, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
		currentpart = SSSTEAM_STEAMMACHINERY_AIR
	if(currentpart == SSSTEAM_STEAMMACHINERY_AIR)
		timer = TICK_USAGE_REAL
		process_steam_air_machinery(resumed)
		cost_steam_machinery = MC_AVERAGE(cost_steam_machinery, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer))
		if(state != SS_RUNNING)
			return
		resumed = 0
	currentpart = SSSTEAM_REBUILD_STEAMNETS

/datum/controller/subsystem/steam/proc/process_steamnets(resumed = FALSE)
	if(!resumed)
		src.currentrun = networks.Copy()
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/datum/thing = currentrun[currentrun.len]
		currentrun.len--
		if(thing)
			thing.process()
		else
			networks.Remove(thing)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/steam/proc/add_to_rebuild_queue(steam_machine)
	if(istype(steam_machine, /obj/machinery/steam_clock/steam))
		steamnets_needing_rebuilt += steam_machine

/datum/controller/subsystem/steam/proc/process_steam_machinery(resumed = 0)
	if(!resumed)
		src.currentrun = steam_machinery.Copy()
		var/list/currentrun = src.currentrun
		while(currentrun.len)
			var/obj/machinery/M = currentrun[currentrun.len]
			currentrun.len--
			if(M == null)
				steam_machinery.Remove(M)
			if(!M || (M.process_steam() == PROCESS_KILL))
				steam_machinery.Remove(M)
			if(MC_TICK_CHECK)
				return

/datum/controller/subsystem/steam/proc/process_steam_air_machinery(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.currentrun = steam_air_machinery.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/obj/machinery/M = currentrun[currentrun.len]
		currentrun.len--
		if(!M || (M.process_steam(seconds) == PROCESS_KILL))
			steam_air_machinery.Remove(M)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/steam/proc/setup_steam_machinery()
	for(var/obj/machinery/steam_clock/steam/SM in steam_machinery + steam_air_machinery)
		SM.steaminit()
		CHECK_TICK

/datum/controller/subsystem/steam/proc/setup_steamnets()
	for(var/obj/machinery/steam_clock/steam/SM in steam_machinery + steam_air_machinery)
		SM.build_network()
		CHECK_TICK

/datum/controller/subsystem/steam/proc/get_init_dirs(type, dir)
	if(!steam_init_dirs_cache[type])
		steam_init_dirs_cache[type] = list()

	if(!steam_init_dirs_cache[type]["[dir]"])
		var/obj/machinery/steam_clock/steam/temp = new type(null, FALSE, dir)
		steam_init_dirs_cache[type]["[dir]"] = temp.GetInitDirections()
		qdel(temp)

	return steam_init_dirs_cache[type]["[dir]"]

#undef SSSTEAM_PIPENETS
#undef SSSTEAM_STEAMMACHINERY
#undef SSSTEAM_EXCITEDGROUPS
#undef SSSTEAM_HIGHPRESSURE
#undef SSSTEAM_HOTSPOTS
#undef SSSTEAM_TURF_CONDUCTION
#undef SSSTEAM_REBUILD_STEAMNETS
#undef SSSTEAM_EQUALIZE
#undef SSSTEAM_ACTIVETURFS
#undef SSSTEAM_TURF_POST_PROCESS
#undef SSSTEAM_FINALIZE_TURFS
#undef SSSTEAM_STEAMMACHINERY_AIR
