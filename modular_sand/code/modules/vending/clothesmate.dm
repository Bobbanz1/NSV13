/obj/machinery/vending/clothing/Initialize(mapload)
	for(var/P in typesof(/datum/gear/sandstorm/underwear))
		var/datum/gear/G = P
		products[initial(G.id)] = 5
	for(var/P in typesof(/datum/gear/sandstorm/shirt))
		var/datum/gear/G = P
		products[initial(G.id)] = 5
	for(var/P in typesof(/datum/gear/sandstorm/socks))
		var/datum/gear/G = P
		products[initial(G.id)] = 5
	. = ..()
