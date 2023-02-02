//body bluids
/datum/reagent/consumable/semen
	name = "Semen"
	description = "Sperm from some animal. Useless for anything but insemination, really."
	taste_description = "something salty"
	taste_mult = 2 //Not very overpowering flavor
	data = list("donor"=null,"viruses"=null,"donor_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null)
	reagent_state = LIQUID
	color = "#FFFFFF" // rgb: 255, 255, 255
	nutriment_factor = 0.5 * REAGENTS_METABOLISM
	var/decal_path = /obj/effect/decal/cleanable/semen

/datum/reagent/consumable/semen/reaction_turf(turf/T, reac_volume)
	..()
	if(!istype(T))
		return
	if(reac_volume < 10)
		return

	var/obj/effect/decal/cleanable/semen/S = locate() in T
	if(!S)
		S = new decal_path(T)
	if(data["blood_DNA"])
		S.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/obj/effect/decal/cleanable/semen
	name = "semen"
	desc = null
	gender = PLURAL
	density = 0
	layer = ABOVE_NORMAL_TURF_LAYER
	icon = 'icons/obj/genitals/effects.dmi'
	icon_state = "semen1"
	random_icon_states = list("semen1", "semen2", "semen3", "semen4")

/obj/effect/decal/cleanable/semen/Initialize(mapload)
	. = ..()
	dir = GLOB.cardinals
	add_blood_DNA(list("Non-human DNA" = "A+"))

/obj/effect/decal/cleanable/semen/replace_decal(obj/effect/decal/cleanable/semen/S)
	return ..()

/datum/reagent/consumable/semen/femcum
	name = "Female Ejaculate"
	description = "Vaginal lubricant found in most mammals and other animals of similar nature. Where you found this is your own business."
	taste_description = "something with a tang" // wew coders who haven't eaten out a girl.
	color = "#AAAAAA77"
	decal_path = /obj/effect/decal/cleanable/semen/femcum

/obj/effect/decal/cleanable/semen/femcum
	name = "female ejaculate"
	icon_state = "fem1"
	random_icon_states = list("fem1", "fem2", "fem3", "fem4")
	blood_state = null
	bloodiness = null

