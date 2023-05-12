/obj/item/lore/model_ship
	name = "Non-Specific Model Ship"
	desc = null
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"
	var/cooldown = 0
	var/shipsound = 'sound/machines/click.ogg'

/obj/item/lore/model_ship/attack_self(mob/user as mob)
	if(cooldown <= world.time)
		cooldown = world.time + 50
		playsound(user, shipsound, 20, 1)

/obj/item/lore/model_ship/dominion
	name = "Dominion of Light Model Ship"
	desc = "A model ship from the Dominion"
	shipsound = 'nsv13/sound/effects/ship/plasma_gun_fire.ogg'

/obj/item/lore/model_ship/draconic
	name = "Draconic Empire Model Ship"
	desc = "A model ship from the Draconic Empire"
	shipsound = 'nsv13/sound/effects/ship/battleship_gun2.ogg'

/obj/item/lore/model_ship/nanotrasen
	name = "NanoTrasen Model Ship"
	desc = "A model ship from NanoTrasen"
	shipsound = 'nsv13/sound/effects/ship/mac_fire.ogg'

/obj/item/lore/model_ship/solgov
	name = "SolGov Model Ship"
	desc = "A model ship from SolGov"
	shipsound = 'nsv13/sound/effects/ship/phaser.ogg'
