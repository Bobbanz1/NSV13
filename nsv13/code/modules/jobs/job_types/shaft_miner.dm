GLOBAL_LIST_INIT(miner_callouts, list(
	/obj/item/stack/sheet/mineral/gold = list(":Q We're rich!"),
	/obj/item/stack/ore/gold = list(":Q Gold!", ":Q There is gold here!", ":Q There is gold!", ":Q I found a gold vein!"),
	/obj/structure/flora/ash/leaf_shroom = list(":Q Mushroom!"),
	/obj/structure/flora/ash/cap_shroom = list(":Q Mushroom!"),
	/obj/structure/flora/ash/stem_shroom = list(":Q Mushroom!"),
	/obj/structure/closet/crate/secure/loot = list(":Q Abandoned crate here!", ":Q Found a crate with a codelock over here!"),
	/obj/structure/closet/crate/necropolis = list(":Q Spooky chest here, someone got a key?", ":Q Necropolis chest here!"),
	/obj/structure/spawner/lavaland = list(":Q Tendril spotted!", ":Q Got a tendril here!", ":Q Found a tendril!"),
	/obj/structure/geyser = list(":Q Got a geyser here, those chemists'll be pleased!", ":Q Found a geyser!", ":Q Geyser here!"),
	/mob/living/simple_animal/hostile/asteroid/basilisk = list(":Q Basilisk, watch out!", ":Q Spotted a Basilisk!", ":Q Look out for that Basilisk!"),
	/mob/living/simple_animal/hostile/asteroid/goldgrub = list(":Q Goldgrub here!", ":Q Spotted a Goldgrub!", ":Q Lootbug here!"),
	/mob/living/simple_animal/hostile/asteroid/goliath = list(":Q Watch out for that Goliath!", ":Q Found a Goliath!", ":Q There's a goliath here, don't get hit by the tendrils!"),
	/mob/living/simple_animal/hostile/asteroid/hivelord = list(":Q Hivelord here!", ":Q Spotted a Hivelord!", ":Q Hivelord!"),
	/mob/living/simple_animal/hostile/megafauna/blood_drunk_miner = list(":Q CRAZY MINER SPOTTED, WATCH OUT!", ":Q THAT MINER'S GONE BLOOD DRUNK, BE CAREFUL!", ":Q WATCH OUT FOR THAT BLOOD DRUNK MINER!"),
	/mob/living/simple_animal/hostile/megafauna/bubblegum = list(":Q BUBBLEGUM SPOTTED!", ":Q WATCH OUT, BUBBLEGUM!", ":Q LOOK OUT FOR BUBBLEGUM!"),
	/mob/living/simple_animal/hostile/megafauna/colossus = list(":Q COLOSSUS!!!", ":Q COLOSSUS IS HERE!!!", ":Q WATCH OUT FOR THE COLOSSUS!!!"),
	/mob/living/simple_animal/hostile/megafauna/dragon = list(":Q ASH DRAKE, WATCH THE SKIES!", ":Q LOOK OUT FOR THAT ASH DRAKE!", ":Q ASH DRAKE SPOTTED!"),
	/mob/living/simple_animal/hostile/megafauna/hierophant = list(":Q FOUND THE HIEROPHANT!", ":Q FOUND A HIEROPHANT, GET READY TO DANCE!", ":Q HIEROPHANT SPOTTED, AND HE'S ON RHYTHM!"),
	/mob/living/simple_animal/hostile/megafauna/legion = list(":Q LEGION'S WOKEN UP!", ":Q LOOKS LIKE LEGION WOKE UP!", ":Q WATCH OUT FOR THE GIANT SKULL, LEGION!"),
))

/datum/job/shaft_miner/after_spawn(mob/living/spawned, client/player_client)
	..()
	RegisterSignal(spawned, COMSIG_MOB_POINTED, .proc/point_speech)

/datum/job/shaft_miner/proc/point_speech(mob/pointing_miner, atom/movable/object_of_interest)
	SIGNAL_HANDLER
	if(object_of_interest.type in GLOB.miner_callouts)
		var/list/lines = GLOB.miner_callouts[object_of_interest.type]
		pointing_miner.say(pick(lines), forced = "Miner Pointing Callouts")
