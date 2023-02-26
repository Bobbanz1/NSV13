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

/**
 * Exponential Scaling function
 *
 * Params:
 *
 * * B: Base value
 * * P: Inputted Power value
 * * S: Factor Scale Value
 */
#define EXPONENTIAL_SCALE(B, P, S) (B + log(P) * S)

/obj/machinery/relativity_modifier
	name = "Higgs Reduction Field Generator"
	desc = "A device that generates a field capable of breaking all known laws against Speeding onboard the vessel it's activated."
	icon = 'icons/obj/machines/NavBeacon.dmi'
	icon_state = "beacon-inactive"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 50
	active_power_usage = 0
	req_one_access = list(ACCESS_CE, ACCESS_CAPTAIN)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/on = FALSE // Whether or not the machine is on
	var/override_safeties = FALSE // Whether or not we are overriding the power draw limit

	var/obj/structure/overmap/OM // local reference to the overmap vessel
	var/intended_mass = MASS_MEDIUM_LARGE // What ship mass this version is meant for

	/// MANEUVERABILITY VARIABLES ///
	var/thrust_normality = 5 MW // How much power we need to reach the normal maneuverability of the ship
	var/incremental_value = 0.05 // Value we use to increment the speed/maneuverability of the ship
	var/save_forward // The original maximum forward thrust of the ship
	var/save_backward // The original maximum backward thrust of the ship
	var/save_side // The original maximum side thrust of the ship
	var/save_max_angular // The original maximum angular acceleration of the ship

	/// POWER VARIABLES ///
	var/obj/structure/cable/attached // The attached cable
	var/incremental_power_threshold = 50 MW // Power threshold we use to increment the speed/maneuverability of the ship
	var/power_allocation = 0 // How much power we are pumping into the system
	var/max_power_allocation = 5 MW // Total maximum power allocation we can devour without CE authorization
	var/max_possible_allocation = 60 MW // 400 MW is the complete maximum this thing can draw if you override the safeties

/obj/machinery/relativity_modifier/dreadnought
	intended_mass = MASS_LARGE
	thrust_normality = 10 MW
	incremental_value = 0.05
	incremental_power_threshold = 5 MW
	max_power_allocation = 10 MW

/obj/machinery/relativity_modifier/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/relativity_modifier/LateInitialize()
	. = ..()
	OM = get_overmap()
	addtimer(CALLBACK(src, .proc/collect_ship_stats), 30 SECONDS)

/obj/machinery/relativity_modifier/Destroy()
	. = ..()
	attached = null
	if(OM) //If destroyed, then return the vessel back to its original maneuverability, potentially
		OM.forward_maxthrust = save_forward
		OM.backward_maxthrust = save_backward
		OM.side_maxthrust = save_side
		OM.max_angular_acceleration = save_max_angular
		OM = null

/obj/machinery/relativity_modifier/process()
	if(on && OM)
		handle_power_allocation()

		if(!try_use_power(power_allocation))
			on = FALSE // If we can't draw power, then turn off the machine
			handle_mass_reduction(power_allocation) // Hopefully returns the ship to its original maneuverability
			update_visuals()
			return FALSE

		if(is_operational)
			// If we can draw power, then start messing with the ship's maneuverability
			handle_mass_reduction(power_allocation)
			update_visuals()
			return TRUE

/**
 * Collects the overmap vessel's original movement variables before we start messing with them
 * This is so we can return the ship to its original maneuverability if we turn off the machine
 * Only runs once, 30 seconds after the machine is initialized in order to give time for the overmap to initialize
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

/**
 * Handles the mass reduction of the vessel
 * Uses a linear scale to determine how maneuverable the ship is
 *
 * Params:
 * * allocated: How much power we are pumping into the system
 */
/obj/machinery/relativity_modifier/proc/handle_mass_reduction(var/allocated)
	if(on)
		if(OM?.mass == intended_mass)
			if(allocated == 0)
				OM.forward_maxthrust = 0
				OM.backward_maxthrust = 0
				OM.side_maxthrust = 0
				OM.max_angular_acceleration = 0
				return

			if((allocated > 0) && (allocated <= thrust_normality))
				OM.forward_maxthrust = linear_calculation(max_possible_allocation, thrust_normality, incremental_power_threshold, 3 MW, input_power = allocated, original_thrust = save_forward)
				OM.backward_maxthrust = linear_calculation(max_possible_allocation, thrust_normality, incremental_power_threshold, 3 MW, input_power = allocated, original_thrust = save_backward)
				OM.side_maxthrust = linear_calculation(max_possible_allocation, thrust_normality, incremental_power_threshold, 3 MW, input_power = allocated, original_thrust = save_side)
				OM.max_angular_acceleration = linear_calculation(max_possible_allocation, thrust_normality, incremental_power_threshold, 3 MW, input_power = allocated, original_thrust = save_max_angular)
				return
			//switch(allocated)
				/*
				if(thrust_normality)
					OM.forward_maxthrust = save_forward
					OM.backward_maxthrust = save_backward
					OM.side_maxthrust = save_side
					OM.max_angular_acceleration = save_max_angular
					return
				if((thrust_normality+1) to max_possible_allocation)
					OM.forward_maxthrust = (save_forward + (allocated / incremental_power_threshold) * incremental_value)
					OM.backward_maxthrust = (save_backward + (allocated / incremental_power_threshold) * incremental_value)
					OM.side_maxthrust = (save_side + (allocated / incremental_power_threshold) * incremental_value)
					OM.max_angular_acceleration = (save_max_angular + (allocated / incremental_power_threshold) * incremental_value)
					return
				*/

			return

	else
		//Hopefully this will prevent the ship from being stuck in a state where it can't move if the device is turned off
		//Knowing my luck, it probably won't
		OM?.forward_maxthrust = save_forward
		OM?.backward_maxthrust = save_backward
		OM?.side_maxthrust = save_side
		OM?.max_angular_acceleration = save_max_angular
		return

/obj/machinery/relativity_modifier/proc/update_visuals()
	if(on)
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
		handle_mass_reduction()
		update_visuals()

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

/obj/machinery/power/rtg/abductor/debug
	power_gen = 20000000

#undef LINEAR_SCALE
#undef EXPONENTIAL_SCALE
