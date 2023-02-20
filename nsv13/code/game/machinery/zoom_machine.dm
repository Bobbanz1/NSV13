/obj/machinery/relativity_breaker
	name = "Higgs Reduction Field Generator"
	desc = "A device that generates a field that reduces the mass of the vessel it's activated within."
	icon = 'icons/obj/machines/NavBeacon.dmi'
	icon_state = "beacon-inactive"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 50
	active_power_usage = 0
	var/on = FALSE
	var/power_allocation = 0 //how much power we are pumping into the system
	var/incremental_rate = 0 // amount of power to drain per tick 5 MW
	var/power_drained = 0 // has drained this much power
	var/max_power_allocation = 5 // total maximum power allocation we can devour without CE authorization
	var/overclock_max_power_allocation = 400 MW // 400 MW is the grand maximum this thing can draw
	var/intended_mass = MASS_MEDIUM_LARGE // What ship mass this version is meant for
	var/obj/structure/cable/C = null
	var/obj/structure/overmap/OM
	var/obj/structure/cable/attached // the attached cable
	var/save_forward
	var/save_backward
	var/save_side
	var/save_max_angular

/obj/machinery/relativity_breaker/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/relativity_breaker/LateInitialize()
	. = ..()
	OM = get_overmap()
	if(OM)
		save_forward = OM.forward_maxthrust
		save_backward = OM.backward_maxthrust
		save_side = OM.side_maxthrust
		save_max_angular = OM.max_angular_acceleration

/obj/machinery/relativity_breaker/process()
	if(OM)
		handle_power_allocation()

		if(!try_use_power(power_allocation))
			on = FALSE
			update_visuals()
			return FALSE

		if(is_operational)
			handle_mass_reduction()
			update_visuals()
			return TRUE

/obj/machinery/relativity_breaker/proc/try_use_power(amount)
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(attached?.surplus() > amount)
		attached.powernet.load += amount
		return TRUE
	return FALSE

/obj/machinery/relativity_breaker/proc/handle_power_allocation()
	active_power_usage = power_allocation

/obj/machinery/relativity_breaker/proc/handle_mass_reduction()
	if(OM?.mass == intended_mass)
		return

/obj/machinery/relativity_breaker/proc/update_visuals()
	if(panel_open)
		icon_state = "machine_maintenance"
	else if( on )
		icon_state = "beacon-active"
	else
		icon_state = "machine_inactive"

/obj/machinery/relativity_breaker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InertialDampener")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/relativity_breaker/ui_act(action, params)
	if(..())
		return
	var/adjust = text2num(params["adjust"])
	if(action == "power_allocation")
		if(adjust && isnum(adjust))
			power_allocation = adjust
			if(power_allocation > max_power_allocation)
				power_allocation = max_power_allocation
				return
			if(power_allocation < 0)
				power_allocation = 0
				return
	switch(action)
		if("toggle_machine")
			toggle_machine()
			return TRUE
	return FALSE

/obj/machinery/relativity_breaker/ui_data(mob/user)
	var/list/data = list()
	data["power_allocation"] = power_allocation
	data["max_power_allocation"] = max_power_allocation
	data["on"] = on

	data["available_power"] = 0
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(attached)
		if(attached.powernet)
			data["available_power"] = attached.surplus()

	return data

/obj/machinery/relativity_breaker/proc/toggle_machine()
	var/turf/T = get_turf(src)
	C = T.get_cable_node()
	if(on || C?.surplus() > power_allocation)
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


/* Techwebs

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

*/
