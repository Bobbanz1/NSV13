GLOBAL_LIST_INIT(miner_callouts, list(
	/obj/item/stack/sheet/mineral/gold = list("We're rich!"),
	/obj/item/stack/ore/gold = list("Gold!", "There is gold here!", "There is gold!", "I found a gold vein!"),
	/obj/item/stack/sheet/mineral/diamond = list("Diamonds!", "Diamonds here!", "Diamonds over here!"),
	/obj/item/stack/ore/diamond = list("Diamonds!", "Diamonds here!", "Diamonds over here!"),
	/obj/item/stack/sheet/mineral/plasma = list("Plasma!", "Plasma here!", "Plasma over here!"),
	/obj/item/stack/ore/plasma = list("PURPLE GOLD!!", "Found a plasma vein!"),
	/obj/structure/flora/ash/leaf_shroom = list("Mushroom!"),
	/obj/structure/flora/ash/cap_shroom = list("Mushroom!"),
	/obj/structure/flora/ash/stem_shroom = list("Mushroom!"),
	/obj/structure/closet/crate/secure/loot = list("Abandoned crate here!", "Found a crate with a codelock over here!"),
	/obj/structure/closet/crate/necropolis = list("Spooky chest here, someone got a key?", "Necropolis chest here!"),
	/obj/structure/spawner/lavaland = list("Tendril spotted!", "Got a tendril here!", "Found a tendril!"),
	/obj/structure/geyser = list("Got a geyser here, those chemists'll be pleased!", "Found a geyser!", "Geyser here!"),
	/mob/living/simple_animal/hostile/asteroid/basilisk = list("Basilisk, watch out!", "Spotted a Basilisk!", "Look out for that Basilisk!"),
	/mob/living/simple_animal/hostile/asteroid/goldgrub = list("Goldgrub here!", "Spotted a Goldgrub!", "Lootbug here!"),
	/mob/living/simple_animal/hostile/asteroid/goliath = list("Watch out for that Goliath!", "Found a Goliath!", "There's a goliath here, don't get hit by the tendrils!"),
	/mob/living/simple_animal/hostile/asteroid/hivelord = list("Hivelord here!", "Spotted a Hivelord!", "Hivelord!"),
	/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner = list("CRAZY MINER SPOTTED, WATCH OUT!", "THAT MINER'S GONE BLOOD DRUNK, BE CAREFUL!", "WATCH OUT FOR THAT BLOOD DRUNK MINER!"),
	/mob/living/simple_animal/hostile/megafauna/bubblegum = list("BUBBLEGUM SPOTTED!", "WATCH OUT, BUBBLEGUM!", "LOOK OUT FOR BUBBLEGUM!"),
	/mob/living/simple_animal/hostile/megafauna/colossus = list("COLOSSUS!!!", "COLOSSUS IS HERE!!!", "WATCH OUT FOR THE COLOSSUS!!!"),
	/mob/living/simple_animal/hostile/megafauna/dragon = list("ASH DRAKE, WATCH THE SKIES!", "LOOK OUT FOR THAT ASH DRAKE!", "ASH DRAKE SPOTTED!"),
	/mob/living/simple_animal/hostile/megafauna/hierophant = list("FOUND THE HIEROPHANT!", "FOUND A HIEROPHANT, GET READY TO DANCE!", "HIEROPHANT SPOTTED, AND HE'S ON RHYTHM!"),
	/mob/living/simple_animal/hostile/megafauna/legion = list("LEGION'S WOKEN UP!", "LOOKS LIKE LEGION WOKE UP!", "WATCH OUT FOR THE GIANT SKULL, LEGION!"),
	/obj/item/storage/firstaid/fire = list("Use this if you've got a burn wound!", "NEED A BURN KIT, STAT!", "NEED TO PATCH THESE BURN WOUNDS!!"),
	/obj/item/storage/firstaid/brute = list("Use this if you've got a bruise!", "NEED A MEDIKIT!", "NEED TO PATCH THESE WOUNDS OR I'M DEAD!!"),
))

/datum/job/shaft_miner/after_spawn(mob/living/spawned, client/player_client)
	..()
	RegisterSignal(spawned, COMSIG_MOB_POINTED, .proc/point_speech)

/datum/job/shaft_miner/proc/point_speech(mob/pointing_miner, atom/movable/object_of_interest)
	SIGNAL_HANDLER
	if(object_of_interest.type in GLOB.miner_callouts)
		var/list/lines = GLOB.miner_callouts[object_of_interest.type]
		pointing_miner.say(":Q " + pick(lines), forced = "Miner Pointing Callouts")
