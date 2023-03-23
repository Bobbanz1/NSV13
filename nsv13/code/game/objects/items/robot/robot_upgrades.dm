// robot_upgrades.dm
// Contains NSV13 exclusive borg upgrades.
/*
/obj/item/borg/upgrade/exp_welder
	name = "Experimental cyborg welder"
	desc = "A experimental welder replacement for the engieborg's standard welder."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = /obj/item/robot_module/engineering

/obj/item/borg/upgrade/exp_welder/action(mob/living/silicon/robot/R)
	. = ..()
	if(.)
		for(var/obj/item/weldingtool/largetank/cyborg/WT in R.module.modules)
			R.module.remove_module(WT, TRUE)

		var/obj/item/weldingtool/experimental/cyborg/EWT = new /obj/item/weldingtool/experimental/cyborg(R.module)
		R.module.basic_modules += EWT
		R.module.add_module(EWT, FALSE, TRUE)

/obj/item/borg/upgrade/exp_welder/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/weldingtool/experimental/cyborg/EWT in R.module.modules)
			R.module.remove_module(EWT, TRUE)

		var/obj/item/weldingtool/largetank/cyborg/WT = new (R.module)
		R.module.basic_modules += WT
		R.module.add_module(WT, FALSE, TRUE)
*/
/obj/item/borg/upgrade/surgerytools
	name = "medical cyborg advanced surgery tools"
	desc = "An upgrade to the Medical module cyborg's surgery loadout, replacing non-advanced tools with their advanced counterpart."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = list(/obj/item/robot_module/medical)
	module_flags = BORG_MODULE_MEDICAL

/obj/item/borg/upgrade/surgerytools/action(mob/living/silicon/robot/borg)
	. = ..()
	if(.)
		for(var/obj/item/retractor/RT in borg.module.modules)
			borg.module.remove_module(RT, TRUE)
		for(var/obj/item/hemostat/HS in borg.module.modules)
			borg.module.remove_module(HS, TRUE)
		for(var/obj/item/cautery/CT in borg.module.modules)
			borg.module.remove_module(CT, TRUE)
		for(var/obj/item/surgicaldrill/SD in borg.module.modules)
			borg.module.remove_module(SD, TRUE)
		for(var/obj/item/scalpel/SP in borg.module.modules)
			borg.module.remove_module(SP, TRUE)
		for(var/obj/item/circular_saw/CS in borg.module.modules)
			borg.module.remove_module(CS, TRUE)
		for(var/obj/item/healthanalyzer/HA in borg.module.modules)
			borg.module.remove_module(HA, TRUE)

		var/obj/item/scalpel/advanced/AS = new /obj/item/scalpel/advanced(borg.module)
		borg.module.basic_modules += AS
		borg.module.add_module(AS, FALSE, TRUE)
		var/obj/item/retractor/advanced/AR = new /obj/item/retractor/advanced(borg.module)
		borg.module.basic_modules += AR
		borg.module.add_module(AR, FALSE, TRUE)
		var/obj/item/surgicaldrill/advanced/AC = new /obj/item/surgicaldrill/advanced(borg.module)
		borg.module.basic_modules += AC
		borg.module.add_module(AC, FALSE, TRUE)
		var/obj/item/healthanalyzer/advanced/AHA = new /obj/item/healthanalyzer/advanced(borg.module)
		borg.module.basic_modules += AHA
		borg.module.add_module(AHA, FALSE, TRUE)

/obj/item/borg/upgrade/surgerytools/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/scalpel/advanced/AS in borg.module.modules)
			borg.module.remove_module(AS, TRUE)
		for(var/obj/item/retractor/advanced/AR in borg.module.modules)
			borg.module.remove_module(AR, TRUE)
		for(var/obj/item/surgicaldrill/advanced/AC in borg.module.modules)
			borg.module.remove_module(AC, TRUE)
		for(var/obj/item/healthanalyzer/advanced/AHA in borg.module.modules)
			borg.module.remove_module(AHA, TRUE)

		var/obj/item/retractor/RT = new (borg.module)
		borg.module.basic_modules += RT
		borg.module.add_module(RT, FALSE, TRUE)
		var/obj/item/hemostat/HS = new (borg.module)
		borg.module.basic_modules += HS
		borg.module.add_module(HS, FALSE, TRUE)
		var/obj/item/cautery/CT = new (borg.module)
		borg.module.basic_modules += CT
		borg.module.add_module(CT, FALSE, TRUE)
		var/obj/item/surgicaldrill/SD = new (borg.module)
		borg.module.basic_modules += SD
		borg.module.add_module(SD, FALSE, TRUE)
		var/obj/item/scalpel/SP = new (borg.module)
		borg.module.basic_modules += SP
		borg.module.add_module(SP, FALSE, TRUE)
		var/obj/item/circular_saw/CS = new (borg.module)
		borg.module.basic_modules += CS
		borg.module.add_module(CS, FALSE, TRUE)
		var/obj/item/healthanalyzer/HA = new (borg.module)
		borg.module.basic_modules += HA
		borg.module.add_module(HA, FALSE, TRUE)
