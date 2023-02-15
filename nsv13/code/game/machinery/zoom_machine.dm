/obj/machinery/relativity_breaker
	name = "Higgs Reduction Field Generator"
	desc = "A device that generates a field that reduces the mass of the vessel it's activated within."
	icon = 'icons/obj/machines/NavBeacon.dmi'
	icon_state = "beacon-inactive"
	use_power = NO_POWER_USE
	var/on = FALSE
	var/incremental_rate = 5000000	// amount of power to drain per tick
	var/power_drained = 0 		// has drained this much power
	var/max_power = 400000000		// maximum power that can be drained before exploding
	var/obj/structure/cable/C = null
	var/obj/structure/overmap/linked

/obj/machinery/relativity_breaker/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/relativity_breaker/LateInitialize()
	linked = get_overmap()
	return linked

/obj/machinery/relativity_breaker/proc/try_use_power()
	var/turf/T = get_turf(src)
	C = T.get_cable_node()
	if(C?.surplus() > power_input)
		C.powernet.load += power_input
		return TRUE
	return FALSE

/obj/machinery/relativity_breaker/process()
	if(on)
		if(power_input > 0 && try_use_power())
			radiation_pulse( src, radiationAmountOnProcess ) // Let's turn one form of energy into another form of energy. Using science!
		else
			on = FALSE
			update_visuals()

/obj/machinery/relativity_breaker/proc/update_visuals()
	if(panel_open)
		icon_state = "machine_maintenance"
	else if( on )
		icon_state = "machine_active"
	else
		icon_state = "machine_inactive"

/obj/machinery/relativity_breaker/examine(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	C = T.get_cable_node()
	if ( C?.surplus() > power_input )
		. += "<span class='notice'>Its LED display states: [display_power(power_input)]</span>"
	else
		. += "<span class='warning'>Its LED display flashes: [display_power(power_input)]</span>"

/obj/machinery/relativity_breaker/emag_act(mob/user)
	if ( !emagged )
		log_game("[key_name(user)] emagged [src].")
		// Emagging amplifies vibrations instead of reducing them!
		to_chat(user, "<span class='warning'>[src] inverts its manipulators, producing sparks!</span>")
		playsound(src.loc, "sparks", 50, 1)
		do_sparks(4, FALSE, src)
		emagged = TRUE
		recalculatePartEfficiency()

/obj/machinery/relativity_breaker/ui_data(mob/user)
	var/list/data = list()
	data["max_strength"] = (1 - EfficiencyToStrength(max_manipulator_rating)) * 100
	data["min_strength"] = (1 - EfficiencyToStrength(min_manipulator_rating)) * 100
	data["strength"] = (1 - EfficiencyToStrength(manipulator_setting)) * 100
	data["max_range"] = EfficiencyToRange(max_scanner_rating)
	data["min_range"] = EfficiencyToRange(min_scanner_rating)
	data["range"] = EfficiencyToRange(scanner_setting)
	data["power_usage"] = display_power(power_input)
	data["on"] = on
	return data


/obj/machinery/relativity_breaker/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(panel_open)
		return TRUE
	switch(action)
		if("strength")
			manipulator_setting = clamp(StrengthToEfficiency(1 - (params["value"] / 100)), min_manipulator_rating, max_manipulator_rating)
			RefreshParts()
			return TRUE
		if("range")
			scanner_setting = clamp(RangeToEfficiency(params["value"]), min_scanner_rating, max_scanner_rating)
			RefreshParts()
			return TRUE
		if("toggle_on")
			toggle_machine()
			return TRUE
	return FALSE

/obj/machinery/relativity_breaker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InertialDampener")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/computer/emergency_shuttle/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/relativity_breaker/proc/toggle_machine()
	var/turf/T = get_turf(src)
	C = T.get_cable_node()
	if ( on || C?.surplus() > power_input )
		on = !on
		update_visuals()

/obj/machinery/relativity_breaker/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE
	if( on )
		to_chat(user, "<span class='notice'>You must turn off [src] before opening the panel.</span>")
		return FALSE
	panel_open = !panel_open
	tool.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	update_visuals()
	return TRUE

/obj/machinery/relativity_breaker/crowbar_act(mob/user, obj/item/tool)
	default_deconstruction_crowbar(tool)
	return TRUE


// Techwebs

/datum/design/board/relativity_breaker
	name = "Machine Design (Relativity Field Generator Board)"
	desc = "The circuit board for an inertial dampener."
	id = "mass_breaker"
	build_path = /obj/item/circuitboard/machine/relativity_breaker
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/techweb_node/relativity_breaker
	id = "mass_breaker"
	display_name = "Relativity Breaker"
	description = "Researches the possibility of breaking all known laws against Speeding."
	prereq_ids = list("practical_bluespace","high_efficiency", "adv_power")
	design_ids = list("mass_breaker")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	export_price = 5000

