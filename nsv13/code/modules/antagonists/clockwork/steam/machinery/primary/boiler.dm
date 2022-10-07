/obj/machinery/steam_clock/steam/machine/primary/boiler
	icon = 'nsv13/icons/obj/clockwork/steam/machines/boiler.dmi'
	icon_state = "plasma_refinery"

	name = "temporary boiler"
	desc = "A boiler capable of producing steam to power our ship"

	max_integrity = 800
	density = TRUE
	layer = ABOVE_WINDOW_LAYER
	pipe_flags = PIPING_ONE_PER_TURF

	var/boiling_temperature = 673.15 // 400 Deg Celsius
	var/boiling_mol = MOLES_CELLSTANDARD * 5

/obj/machinery/steam_clock/steam/machine/primary/boiler/process_steam()
	boil_water()

/obj/machinery/steam_clock/steam/machine/primary/boiler/proc/boil_water(delta_time = 2)
	var/datum/gas_mixture/steam = steams[1]
	var/datum/gas_mixture/boiling = new
	boiling.set_moles(GAS_STEAM, boiling_mol * delta_time)
	boiling.set_temperature(boiling_temperature)
	boiling.transfer_ratio_to(steam, boiling.return_volume())

	update_parents()
	return TRUE
