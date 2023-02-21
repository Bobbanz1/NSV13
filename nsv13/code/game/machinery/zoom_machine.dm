/**
 * Linear Scaling function
 *
 * Params:
 *
 * * B: Base value
 * * P: Inputted Power value
 * * I: Incremental Power Threshold Value
 * * S: Factor Scale Value
 */
#define LINEAR_SCALE(B, P, I, S) (B + (P / I) * S)

/obj/machinery/relativity_modifier
	name = "Higgs Reduction Field Generator"
	desc = "A device that generates a field that reduces the mass of the vessel it's activated within."
	icon = 'icons/obj/machines/NavBeacon.dmi'
	icon_state = "beacon-inactive"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 50
	active_power_usage = 0
	req_one_access = list(ACCESS_CE, ACCESS_CAPTAIN)
	var/on = FALSE
	var/override_safeties = FALSE // Whether or not we are overriding the power draw limit

	var/obj/structure/overmap/OM
	var/intended_mass = MASS_MEDIUM_LARGE // What ship mass this version is meant for
	var/save_forward // The original maximum forward thrust of the ship
	var/save_backward // The original maximum backward thrust of the ship
	var/save_side // The original maximum side thrust of the ship
	var/save_max_angular // The original maximum angular acceleration of the ship

	var/obj/structure/cable/attached // The attached cable
	var/incremental_value = 0.05 // Value we use to increment the speed/manueverability of the ship
	var/incremental_power_threshold = 5 MW // Power threshold we use to increment the speed/manueverability of the ship
	var/power_allocation = 0 // How much power we are pumping into the system
	var/max_power_allocation = 5 MW // Total maximum power allocation we can devour without CE authorization
	var/max_possible_allocation = 400 MW // 400 MW is the complete maximum this thing can draw if you override the safeties
	var/thrust_normality = 5 MW // How much power we need to reach the normal maneuverability of the ship

/obj/machinery/relativity_modifier/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/relativity_modifier/LateInitialize()
	. = ..()
	OM = get_overmap()
	addtimer(CALLBACK(src, .proc/collect_ship_stats), 30 SECONDS)

/obj/machinery/relativity_modifier/process()
	if(on && OM)
		handle_power_allocation()

		if(!try_use_power(power_allocation))
			on = FALSE
			handle_mass_reduction(power_allocation)
			update_visuals()
			return FALSE

		if(is_operational)
			handle_mass_reduction(power_allocation)
			update_visuals()
			return TRUE

/**
 * Collects the overmap vessel's original movement variables
 * before we start messing with them
 */
/obj/machinery/relativity_modifier/proc/collect_ship_stats()
	if(OM)
		save_forward = OM.forward_maxthrust
		save_backward = OM.backward_maxthrust
		save_side = OM.side_maxthrust
		save_max_angular = OM.max_angular_acceleration

/obj/machinery/relativity_modifier/proc/try_use_power(amount)
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(attached?.surplus() > amount)
		attached.powernet.load += amount
		return TRUE
	return FALSE

/obj/machinery/relativity_modifier/proc/handle_power_allocation()
	active_power_usage = power_allocation
	return

/obj/machinery/relativity_modifier/proc/handle_mass_reduction(var/allocated)
	if(on)
		if(OM?.mass == intended_mass)
			switch(allocated)
				if(0)
					OM.forward_maxthrust = 0
					OM.backward_maxthrust = 0
					OM.side_maxthrust = 0
					OM.max_angular_acceleration = 0

				if(1 to (thrust_normality-1))
					OM.forward_maxthrust = LINEAR_SCALE(save_forward, allocated, incremental_power_threshold, incremental_value)
					OM.backward_maxthrust = LINEAR_SCALE(save_backward, allocated, incremental_power_threshold, incremental_value)
					OM.side_maxthrust = LINEAR_SCALE(save_side, allocated, incremental_power_threshold, incremental_value)
					OM.max_angular_acceleration = LINEAR_SCALE(save_max_angular, allocated, incremental_power_threshold, incremental_value)

			return

	else if(!on && OM?.mass == intended_mass)
		OM.forward_maxthrust = save_forward
		OM.backward_maxthrust = save_backward
		OM.side_maxthrust = save_side
		OM.max_angular_acceleration = save_max_angular
		return

/obj/machinery/relativity_modifier/proc/update_visuals()
	if(panel_open)
		icon_state = "beacon-open"
	else if(on)
		icon_state = "beacon-active"
	else
		icon_state = "beacon-inactive"

/obj/machinery/relativity_modifier/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RelativityModifier")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/relativity_modifier/ui_data(mob/user)
	var/list/data = list()
	data["on"] = on
	data["override_safeties"] = override_safeties
	data["power_allocation"] = power_allocation
	if(!override_safeties)
		data["max_power_allocation"] = max_power_allocation
	else
		data["max_power_allocation"] = max_possible_allocation

	data["saved_forward"] = save_forward
	data["saved_backward"] = save_backward
	data["saved_side"] = save_side
	data["saved_max_angular"] = save_max_angular

	data["forward_maxthrust"] = OM.forward_maxthrust
	data["backward_maxthrust"] = OM.backward_maxthrust
	data["side_maxthrust"] = OM.side_maxthrust
	data["max_angular_acceleration"] = OM.max_angular_acceleration

	data["available_power"] = 0
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(attached)
		if(attached.powernet)
			data["available_power"] = attached.surplus()

	return data

/obj/machinery/relativity_modifier/ui_act(action, params)
	if(..())
		return
	var/adjust = text2num(params["adjust"])
	if(action == "power_allocation")
		if(isnum(adjust))
			power_allocation = adjust
			if(power_allocation > max_power_allocation && !override_safeties)
				power_allocation = max_power_allocation
				return

			else if(power_allocation > max_possible_allocation)
				power_allocation = max_possible_allocation
				return

			if(power_allocation < 0)
				power_allocation = 0
				return

	switch(action)
		if("toggle_machine")
			toggle_machine()
			return TRUE
		if("override_safety")
			var/obj/item/card/id/id_card = usr.get_idcard(hand_first = TRUE)
			if(!check_access(id_card))
				to_chat(usr, "<span class='notice'>Access Denied, insufficient access on [id_card].</span>")
				return FALSE
			else
				if(override_safeties)
					to_chat(usr, "<span class='notice'>Power Allocator Limiter re-engaged</span>")
				else
					to_chat(usr, "<span class='warning'>Overriding Power Allocator Limiter, additional power allocation unlocked</span>")
				override_safeties = !override_safeties
				return TRUE
	return FALSE

/obj/machinery/relativity_modifier/proc/toggle_machine()
	var/turf/T = get_turf(src)
	attached = T.get_cable_node()
	if(on || attached?.surplus() > power_allocation)
		on = !on
		update_visuals()

/obj/machinery/relativity_modifier/screwdriver_act(mob/user, obj/item/tool)
	if(..())
		return TRUE
	if(on)
		to_chat(user, "<span class='notice'>You must turn off [src] before opening the panel.</span>")
		return FALSE
	panel_open = !panel_open
	tool.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [panel_open?"open":"close"] the panel on [src].</span>")
	update_visuals()
	return TRUE

/obj/machinery/relativity_modifier/crowbar_act(mob/user, obj/item/tool)
	default_deconstruction_crowbar(tool)
	return TRUE

/* Techwebs

/datum/design/board/relativity_modifier
	name = "Machine Design (Relativity Field Generator Board)"
	desc = "The circuit board for an inertial dampener."
	id = "mass_breaker"
	build_path = /obj/item/circuitboard/machine/relativity_modifier
	category = list("Engineering Machinery")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/techweb_node/relativity_modifier
	id = "mass_breaker"
	display_name = "Relativity Breaker"
	description = "Researches the possibility of breaking all known laws against Speeding."
	prereq_ids = list("practical_bluespace","high_efficiency", "adv_power")
	design_ids = list("mass_breaker")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	export_price = 5000

*/
#undef LINEAR_SCALE
