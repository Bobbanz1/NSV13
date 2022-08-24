/obj/machinery/replicator
	name = "replicator"
	icon = 'nsv13/icons/obj/machinery/replicator.dmi'
	icon_state = "replicator-off"
	desc = "It invariably produces something that's almost (but not quite) entirely unlike tea"
	var/power = 100
	var/power_cost = 10
	var/recharge_rate = 3
	anchored = TRUE
	density = TRUE

/obj/machinery/replicator/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/machinery/replicator/process()
	if(power < 100)
		power += recharge_rate
	else
		power = 100

/obj/machinery/replicator/attack_hand(mob/living/user)
	icon_state = "replicator-on"
	if(power < power_cost)
		to_chat(user, "<span class='warning'>[src]'s matter synthesisers are still recharging</span>")
		return FALSE
	if(ishuman(user))
		var/mode = alert("What kind of food would you like?",,"Burger", "Pizza", "Tea, earl grey", "Sandwich")
		var/temp = alert("How hot do you want it?",,"Cold", "Warm", "Hot")
		if(!mode || !temp)
			return FALSE
		user.say("[mode], [temp]")
		icon_state = "replicator-replicate"
		power -= power_cost
		switch(mode)
			if("Burger")
				var/obj/item/reagent_containers/food/snacks/burger/plain/thefood = new(src.loc)
				thefood.name = "[temp] [thefood.name]"
			if("Pizza")
				var/obj/item/reagent_containers/food/snacks/pizza/margherita/thefood = new(src.loc)
				thefood.name = "[temp] [thefood.name]"
			if("Tea, earl grey")
				var/obj/item/reagent_containers/food/drinks/mug/tea/thefood = new(src.loc)
				thefood.name = "[temp] [thefood.name]"
			if("Sandwich")
				var/obj/item/reagent_containers/food/snacks/sandwich/thefood = new(src.loc)
				thefood.name = "[temp] [thefood.name]"
	sleep(40)
	icon_state = "replicator-off"
