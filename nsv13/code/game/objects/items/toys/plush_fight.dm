/obj/item/toy/plush/ship
	/// Timer when it'll be off cooldown
	var/timer = 0
	/// Cooldown between play sessions
	var/cooldown = 1.5 SECONDS
	/// TRUE = In combat currently || FALSE = Not in combat
	var/in_combat = FALSE
	/// The health of the plushie whilst in battle.
	var/combat_health = 0
	/// The maximum combat health the plushie has. (Currently handling it as 1 = 50 Integrity, 2 = 100 Integrity, set this to match the max_integrity of the small craft, round it downwards if the value is not capable of being divided by 50)
	var/max_combat_health = 0
	/// How many battles we have won.
	var/wins = 0
	/// How many times this plushie has lost in battle.
	var/losses = 0

/obj/item/toy/plush/ship/examine()
	. = ..()
	if(in_combat)
		. += "<span class='notice'>This plushie has a maximum health of [max_combat_health]. Currently, it's [combat_health].</span>"
	else
		. += "<span class='notice'>This plushie has a maximum health of [max_combat_health].</span>"

	if(wins || losses)
		. += "<span class='notice'>This plushie has won [wins] battles, and lost [losses] battles</span>"

/obj/item/toy/plush/ship/attackby(obj/item/plushie, mob/living/user)
	if(istype(plushie, /obj/item/plush/ship))
		var/obj/item/plush/ship/P = plushie
		if(check_battle_start(user, P))
			space_battle(P, user)
	else
		..()

/obj/item/toy/plush/ship/proc/space_battle(obj/item/toy/plush/ship/attacker, mob/living/carbon/attacker_controller, mob/living/carbon/opponent)


/obj/item/toy/plush/ship/proc/check_battle_start(mob/living/carbon/user, obj/item/plush/ship/attacker, mob/living/carbon/target)
	if(attacker?.in_combat)
		to_chat(user, "<span class='notice'>[target?target.p_their() : "Your" ] [attacker.name] is in combat.</span>")
		to_chat(target, "<span class='notice'>Your [attacker.name] is in combat.</span>")
		return FALSE
	if(in_combat)
		to_chat(user, "<span class='notice'>Your [name] is in combat.</span>")
		to_chat(target, "<span class='notice>[user.p_their()] [name] is in combat.</span>")
		return FALSE
	if(attacker && attacker.timer > world.time)
		to_chat(user, "<span class='notice'>[target?target.p_their() : "Your" ] [attacker.name] isn't ready for battle.</span>")
		to_chat(target, "<span class='notice'>Your [attacker.name] isn't ready for battle.</span>")
		return FALSE
	if(timer > world.time)
		to_chat(user, "<span class='notice'>Your [name] isn't ready for battle.</span>")
		to_chat(target, "<span class='notice'>[user.p_their()] [name] isn't ready for battle.</span>")
		return FALSE

	return TRUE
