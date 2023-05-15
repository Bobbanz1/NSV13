/**
 * Toy Ship Battles
 * For when the bridge officers are bored
 */

/// Toy ship special attack types
#define SPECIAL_ATTACK_HEAL 1
#define SPECIAL_ATTACK_DAMAGE 2
#define SPECIAL_ATTACK_UTILITY 3
#define SPECIAL_ATTACK_OTHER 4

/// Max length of a ship battle
#define MAX_BATTLE_LENGTH 50

/obj/item/lore/model_ship
	name = "Non-Specific Model Ship"
	desc = null
	icon = 'nsv13/icons/obj/lore/model_ships.dmi'
	icon_state = "ship"
	w_class = WEIGHT_CLASS_SMALL
	var/shipsound = 'sound/machines/click.ogg'
	var/combat_sound = 'sound/machines/click.ogg'
	/// Timer when it'll be off cooldown
	var/timer = 0
	/// Cooldown between play sessions
	var/cooldown = 1.5 SECONDS
	/// Cooldown multiplier after a battle (by default: battle cooldowns are 30 seconds)
	var/cooldown_multiplier = 20
	/// If it makes noise when played with
	var/quiet = FALSE
	/// TRUE = Offering battle to someone || FALSE = Not offering battle
	var/wants_to_battle = FALSE
	//// TRUE = in combat currently || FALSE = Not in combat
	var/in_combat = FALSE
	/// The ships health in battle
	var/combat_health = 0
	/// The ships max combat health
	var/max_combat_health = 0
	/// TRUE = the special attack is charged || FALSE = not charged
	var/special_attack_charged = FALSE
	/// What type of special attack they use - SPECIAL_ATTACK_DAMAGE, SPECIAL_ATTACK_HEAL, SPECIAL_ATTACK_UTILITY, SPECIAL_ATTACK_OTHER
	var/special_attack_type = 0
	/// What message their special move gets on examining
	var/special_attack_type_message = ""
	/// The battlecry when using the special attack
	var/special_attack_cry = "*flip"
	/// Current cooldown of their special attack
	var/special_attack_cooldown = 0
	/// This ships win count in combat
	var/wins = 0
	/// ...And their loss count in combat
	var/losses = 0

/obj/item/lore/model_ship/Initialize(mapload)
	. = ..()
	desc = "[desc]! Attack your friends or another model ship with one to initiate an epic space battle!"
	combat_health = max_combat_health
	switch(special_attack_type)
		if(SPECIAL_ATTACK_DAMAGE)
			special_attack_type_message = "an aggressive move, which deals bonus damage."
		if(SPECIAL_ATTACK_HEAL)
			special_attack_type_message = "a defensive move, which grants bonus healing."
		if(SPECIAL_ATTACK_UTILITY)
			special_attack_type_message = "a utility move, which heals the user and damages the opponent."
		if(SPECIAL_ATTACK_OTHER)
			special_attack_type_message = "a special move, which [special_attack_type_message]"
		else
			special_attack_type_message = "a mystery move, even I don't know."

/**
  * this proc combines "sleep" while also checking for if the battle should continue
  *
  * this goes through some of the checks - the model ships need to be next to each other to fight!
  * if it's player vs themself: They need to be able to "control" both ships (either must be adjacent or using TK)
  * if it's player vs player: Both players need to be able to "control" their ships (either must be adjacent or using TK)
  * if it's player vs ship (suicide): the ship needs to be in range of the player
  * if all the checks are TRUE, it does the sleeps, and returns TRUE. Otherwise, it returns FALSE.
  * Arguments:
  * * delay - the amount of time the sleep at the end of the check will sleep for
  * * attacker - the attacking model ship in the battle.
  * * attacker_controller - the controller of the attacking model ship. there should ALWAYS be an attacker_controller
  * * opponent - (optional) the defender controller in the battle, for PvP
  */
/obj/item/lore/model_ship/proc/combat_sleep(var/delay, obj/item/lore/model_ship/attacker, mob/living/carbon/attacker_controller, mob/living/carbon/opponent)
	if(!attacker_controller)
		return FALSE

	if(!attacker) //if there's no attacker, then attacker_controller IS the attacker
		if(!in_range(src, attacker_controller))
			attacker_controller.visible_message("<span class='suicide'>[attacker_controller] is running from [src]! The coward!</span>")
			return FALSE
	else // if there's an attacker, we can procede as normal
		if(!in_range(src, attacker)) //and the two model ships aren't next to each other, the battle ends
			attacker_controller.visible_message("<span class='notice'> [attacker] and [src] separate, ending the battle. </span>", \
								"<span class='notice'> [attacker] and [src] separate, ending the battle. </span>")
			return FALSE

		//dead men tell no tales, incapacitated men fight no fights
		if(attacker_controller.incapacitated())
			return FALSE
		//if the attacker_controller isn't next to the attacking model ship (and doesn't have telekinesis), the battle ends
		if(!in_range(attacker, attacker_controller) && !(attacker_controller.dna.check_mutation(TK)))
			attacker_controller.visible_message("<span class='notice'> [attacker_controller.name] seperates from [attacker], ending the battle.</span>", \
								"<span class='notice'> You separate from [attacker], ending the battle. </span>")
			return FALSE

		//if it's PVP and the opponent is not next to the defending(src) model ship (and doesn't have telekinesis), the battle ends
		if(opponent)
			if(opponent.incapacitated())
				return FALSE
			if(!in_range(src, opponent) && !(opponent.dna.check_mutation(TK)))
				opponent.visible_message("<span class='notice'> [opponent.name] seperates from [src], ending the battle.</span>", \
							"<span class='notice'> You separate from [src], ending the battle. </span>")
				return FALSE
		//if it's not PVP and the attacker_controller isn't next to the defending model ship (and doesn't have telekinesis), the battle ends
		else
			if (!in_range(src, attacker_controller) && !(attacker_controller.dna.check_mutation(TK)))
				attacker_controller.visible_message("<span class='notice'> [attacker_controller.name] seperates from [src] and [attacker], ending the battle.</span>", \
									"<span class='notice'> You separate [attacker] and [src], ending the battle. </span>")
				return FALSE

	//if all that is good, then we can sleep peacefully
	sleep(delay)
	return TRUE

//all credit to skasi for toy mech fun ideas
///NSV13 - Using their code for model ship to model ship combat
/obj/item/lore/model_ship/attack_self(mob/user)
	if(timer < world.time)
		timer = world.time + 50
		playsound(user, shipsound, 20, TRUE)
	else
		. = ..()

/obj/item/lore/model_ship/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(loc == user)
		attack_self(user)

/**
 * If you attack a model ship with a model ship, initiate combat between them
 */
/obj/item/lore/model_ship/attackby(obj/item/lore/user_ship, mob/living/user)
	if(istype(user_ship, /obj/item/lore/model_ship))
		var/obj/item/lore/model_ship/P = user_ship
		if(check_battle_start(user, P))
			ship_brawl(P, user)
	..()

/**
  * Attack is called from the user's model ship, aimed at target(another human), checking for target's model ship.
  */
/obj/item/lore/model_ship/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(target == user)
		to_chat(user, "<span class='notice'>Target another model ship if you want to start a battle with yourself.</span>")
		return
	else if(user.a_intent != INTENT_HARM)
		if(wants_to_battle) //prevent spamming someone with offers
			to_chat(user, "<span class='notice'>You already are offering battle to someone!</span>")
			return
		if(!check_battle_start(user)) //if the user's ship isn't ready, don't bother checking
			return

		for(var/obj/item/I in target.held_items)
			if(istype(I, /obj/item/lore/model_ship)) //if you attack someone with a ship who's also holding a ship, offer to battle them
				var/obj/item/lore/model_ship/P = I
				if(!P.check_battle_start(target, null, user)) //check if the attacker ship is ready
					break

				//slap them with the metaphorical white glove
				if(P.wants_to_battle) //if the target ship wants to battle, initiate the battle from their POV
					ship_brawl(P, target, user) //P = defender's ship / SRC = attacker's ship / target = defender / user = attacker
					P.wants_to_battle = FALSE
					return

		//extend the offer of battle to the other model ship
		to_chat(user, "<span class='notice'>You offer battle to [target.name]!</span>")
		to_chat(target, "<span class='notice'><b>[user.name] wants to battle with [user.p_their()] [name]!</b> <i>Attack them with a model ship to initiate combat.</i></span>")
		wants_to_battle = TRUE
		addtimer(CALLBACK(src, PROC_REF(withdraw_offer), user), 6 SECONDS)
		return

	..()

/**
  * Overrides attack_tk - Sorry, you have to be face to face to initiate a battle, it's good sportsmanship
  */
/obj/item/lore/model_ship/attack_tk(mob/user)
	if(timer < world.time)
		timer = world.time + 50
		playsound(user, shipsound, 20, TRUE)

/**
  * Resets the request for battle.
  *
  * For use in a timer, this proc resets the wants_to_battle variable after a short period.
  * Arguments:
  * * user - the user wanting to do battle
  */
/obj/item/lore/model_ship/proc/withdraw_offer(mob/living/carbon/user)
	if(wants_to_battle)
		wants_to_battle = FALSE
		to_chat(user, "<span class='notice'>You get the feeling they don't want to battle.</span>")

/**
  * Starts a battle, model ship vs player. Player... doesn't win.
  */
/obj/item/lore/model_ship/suicide_act(mob/living/carbon/user)
	if(in_combat)
		to_chat(user, "<span class='notice'>[src] is in battle, let it finish first.</span>")
		return

	user.visible_message("<span class='suicide'>[user] begins a fight [user.p_they()] can't win with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")

	in_combat = TRUE
	sleep(1.5 SECONDS)
	for(var/i in 1 to 4)
		switch(i)
			if(1, 3)
				SpinAnimation(5, 0)
				playsound(src, combat_sound, 15, TRUE)
				user.adjustBruteLoss(25)
				user.adjustStaminaLoss(50)
			if(2)
				user.SpinAnimation(5, 0)
				playsound(user, 'nsv13/sound/effects/ship/damage/consolehit3.ogg', 10, TRUE)
				combat_health-- //we scratched it!
			if(4)
				say(special_attack_cry + "!!")
				user.adjustStaminaLoss(25)

		if(!combat_sleep(1 SECONDS, null, user))
			say("PATHETIC.")
			combat_health = max_combat_health
			in_combat = FALSE
			return SHAME

	sleep(0.5 SECONDS)
	user.adjustBruteLoss(450)

	in_combat = FALSE
	say("AN EASY WIN. OUR POWER INCREASES.") // steal a soul, become swole
	add_atom_colour(rgb(255, 115, 115), ADMIN_COLOUR_PRIORITY)
	max_combat_health = round(max_combat_health*1.5 + 0.1)
	combat_health = max_combat_health
	wins++
	return BRUTELOSS

/obj/item/lore/model_ship/examine()
	. = ..()
	. += "<span class='notice'>This model ship's special attack is [special_attack_cry], [special_attack_type_message] </span>"
	if(in_combat)
		. += "<span class='notice'>This model ship has a maximum health of [max_combat_health]. Currently, it's [combat_health].</span>"
		. += "<span class='notice'>Its special move light is [special_attack_cooldown? "flashing red." : "green and is ready!"]</span>"
	else
		. += "<span class='notice'>This model ship has a maximum health of [max_combat_health].</span>"

	if(wins || losses)
		. += "<span class='notice'>This model ship has [wins] wins, and [losses] losses.</span>"

/**
  * The 'master' proc of the ship battle. Processes the entire battle's events and makes sure it start and finishes correctly.
  *
  * src is the defending ship, and the battle proc is called on it to begin the battle.
  * After going through a few checks at the beginning to ensure the battle can start properly, the battle begins a loop that lasts
  * until either ship has no more health. During this loop, it also ensures the mechs stay in combat range of each other.
  * It will then randomly decide attacks for each ship, occasionally making one or the other use their special attack.
  * When either mech has no more health, the loop ends, and it displays the victor and the loser while updating their stats and resetting them.
  * Arguments:
  * * attacker - the attacking ship, the ship in the attacker_controller's hands
  * * attacker_controller - the user, the one who is holding the ships / controlling the fight
  * * opponent - optional arg used in Mech PvP battles: the other person who is taking part in the fight (controls src)
  */
/obj/item/lore/model_ship/proc/ship_brawl(obj/item/lore/model_ship/attacker, mob/living/carbon/attacker_controller, mob/living/carbon/opponent)
	//A GOOD DAY FOR A SWELL BATTLE!
	attacker_controller.visible_message("<span class='danger'> [attacker_controller.name] collides [attacker] with [src]! Looks like they're preparing for a ship to ship brawl! </span>", \
						"<span class='danger'> You ram [attacker] into [src], sparking a fierce battle! </span>", \
						"<span class='hear'> You hear hard plastic smacking into hard plastic.</span>", COMBAT_MESSAGE_RANGE)

	/// Who's in control of the defender (src)?
	var/mob/living/carbon/src_controller = (opponent)? opponent : attacker_controller
	/// How long has the battle been going?
	var/battle_length = 0

	in_combat = TRUE
	attacker.in_combat = TRUE

	//1.5 second cooldown * 20 = 30 second cooldown after a fight
	timer = world.time + cooldown*cooldown_multiplier
	attacker.timer = world.time + attacker.cooldown*attacker.cooldown_multiplier

	sleep(1 SECONDS)
	//--THE BATTLE BEGINS--
	while(combat_health > 0 && attacker.combat_health > 0 && battle_length < MAX_BATTLE_LENGTH)
		if(!combat_sleep(0.5 SECONDS, attacker, attacker_controller, opponent)) //combat_sleep checks everything we need to have checked for combat to continue
			break

		//before we do anything - deal with charged attacks
		if(special_attack_charged)
			src_controller.visible_message("<span class='danger'> [src] unleashes its special attack!! </span>", \
							"<span class='danger'> You unleash [src]'s special attack! </span>")
			special_attack_move(attacker)
		else if(attacker.special_attack_charged)

			attacker_controller.visible_message("<span class='danger'> [attacker] unleashes its special attack!! </span>", \
								"<span class='danger'> You unleash [attacker]'s special attack! </span>")
			attacker.special_attack_move(src)
		else
			//process the cooldowns
			if(special_attack_cooldown > 0)
				special_attack_cooldown--
			if(attacker.special_attack_cooldown > 0)
				attacker.special_attack_cooldown--

			//combat commences
			switch(rand(1,8))
				if(1 to 3) //attacker wins
					if(attacker.special_attack_cooldown == 0 && attacker.combat_health <= round(attacker.max_combat_health/3)) //if health is less than 1/3 and special off CD, use it
						attacker.special_attack_charged = TRUE
						attacker_controller.visible_message("<span class='danger'> [attacker] begins charging its special attack!! </span>", \
											"<span class='danger'> You begin charging [attacker]'s special attack! </span>")
					else //just attack
						attacker.SpinAnimation(5, 0)
						playsound(attacker, combat_sound, 30, TRUE)
						combat_health--
						attacker_controller.visible_message("<span class='danger'> [attacker] devastates [src]! </span>", \
											"<span class='danger'> You ram [attacker] into [src]! </span>", \
											"<span class='hear'> You hear hard plastic smacking hard plastic.</span>", COMBAT_MESSAGE_RANGE)
						if(prob(5))
							combat_health--
							playsound(src, 'sound/effects/meteorimpact.ogg', 20, TRUE)
							attacker_controller.visible_message("<span class='boldwarning'> ...and lands a CRIPPLING BLOW! </span>", \
												"<span class='boldwarning'> ...and you land a CRIPPLING blow on [src]! </span>", null, COMBAT_MESSAGE_RANGE)

				if(4) //both lose
					attacker.SpinAnimation(5, 0)
					SpinAnimation(5, 0)
					combat_health--
					attacker.combat_health--
					do_sparks(2, FALSE, src)
					do_sparks(2, FALSE, attacker)
					if(prob(50))
						attacker_controller.visible_message("<span class='danger'> [attacker] and [src] battles dramatically, causing sparks to fly from impacts! </span>", \
											"<span class='danger'> [attacker] and [src] battles dramatically, causing sparks to fly from impacts! </span>", \
											"<span class='hear'> You hear hard plastic hitting hard plastic.</span>", COMBAT_MESSAGE_RANGE)
					else
						src_controller.visible_message("<span class='danger'> [src] and [attacker] exchanges gunfire dramatically, causing sparks to fly! </span>", \
										"<span class='danger'> [src] and [attacker] exchanges gunfire dramatically, causing sparks to fly! </span>", \
										"<span class='hear'> You hear hard plastic hitting hard plastic.</span>", COMBAT_MESSAGE_RANGE)
				if(5) //both win
					playsound(attacker, 'sound/weapons/parry.ogg', 20, TRUE)
					if(prob(50))
						attacker_controller.visible_message("<span class='danger'> [src]'s attack deflects off of [attacker]. </span>", \
											"<span class='danger'> [src]'s attack deflects off of [attacker]. </span>", \
											"<span class='hear'> You hear hard plastic bouncing off hard plastic.</span>", COMBAT_MESSAGE_RANGE)
					else
						src_controller.visible_message("<span class='danger'> [attacker]'s attack deflects off of [src]. </span>", \
										"<span class='danger'> [attacker]'s attack deflects off of [src]. </span>", \
										"<span class='hear'> You hear hard plastic bouncing off hard plastic.</span>", COMBAT_MESSAGE_RANGE)

				if(6 to 8) //defender wins
					if(special_attack_cooldown == 0 && combat_health <= round(max_combat_health/3)) //if health is less than 1/3 and special off CD, use it
						special_attack_charged = TRUE
						src_controller.visible_message("<span class='danger'> [src] begins charging its special attack!! </span>", \
										"<span class='danger'> You begin charging [src]'s special attack! </span>")
					else //just attack
						SpinAnimation(5, 0)
						playsound(src, combat_sound, 30, TRUE)
						attacker.combat_health--
						src_controller.visible_message("<span class='danger'> [src] rams into [attacker]! </span>", \
										"<span class='danger'> You ram [src] into [attacker]! </span>", \
										"<span class='hear'> You hear hard plastic ramming into hard plastic.</span>", COMBAT_MESSAGE_RANGE)
						if(prob(5))
							attacker.combat_health--
							playsound(attacker, 'nsv13/sound/effects/ship/damage/consolehit3.ogg', 20, TRUE)
							src_controller.visible_message("<span class='boldwarning'> ...and lands a CRIPPLING HIT! </span>", \
											"<span class='boldwarning'> ...and you land a CRIPPLING HIT on [attacker]! </span>", null, COMBAT_MESSAGE_RANGE)
				else
					attacker_controller.visible_message("<span class='notice'> [src] and [attacker] fly around awkwardly.</span>", \
										"<span class='notice'> You don't know what to do next.</span>")

		battle_length++
		sleep(0.5 SECONDS)

	/// Lines chosen for the winning ship
	var/list/winlines = list("VICTORY!", "WE YIELD TO NONE!", "GLORY IS OURS!", "AN EASY BATTLE.", "YOU SHOULD HAVE NEVER FACED US.")

	if(attacker.combat_health <= 0 && combat_health <= 0) //both lose
		playsound(src, 'sound/machines/warning-buzzer.ogg', 20, TRUE)
		attacker_controller.visible_message("<span class='boldnotice'> MUTUALLY ASSURED DESTRUCTION!! [src] and [attacker] both end up destroyed!</span>", \
							"<span class='boldnotice'> Both [src] and [attacker] are destroyed!</span>")
	else if(attacker.combat_health <= 0) //src wins
		wins++
		attacker.losses++
		playsound(attacker, 'sound/effects/light_flicker.ogg', 20, TRUE)
		attacker_controller.visible_message("<span class='notice'> [attacker] falls apart!</span>", \
							"<span class='notice'> [attacker] falls apart!</span>", null, COMBAT_MESSAGE_RANGE)
		say("[pick(winlines)]")
		src_controller.visible_message("<span class='notice'> [src] shatters the hull of [attacker] and flies away victorious!</span>", \
						"<span class='notice'> You raise up [src] victoriously over [attacker]!</span>")
	else if (combat_health <= 0) //attacker wins
		attacker.wins++
		losses++
		playsound(src, 'sound/effects/light_flicker.ogg', 20, TRUE)
		src_controller.visible_message("<span class='notice'> [src] collapses!</span>", \
						"<span class='notice'> [src] collapses!</span>", null, COMBAT_MESSAGE_RANGE)
		attacker.say("[pick(winlines)]")
		attacker_controller.visible_message("<span class='notice'> [attacker] shatters the hull of [src] and flies away victorious!</span>", \
							"<span class='notice'> You raise up [attacker] proudly over [src]</span>!")
	else //both win?
		say("NEXT TIME.")
		//don't want to make this a one sided conversation
		quiet? attacker.say("WE WENT EASY ON YOU.") : attacker.say("OF COURSE.")

	in_combat = FALSE
	attacker.in_combat = FALSE

	combat_health = max_combat_health
	attacker.combat_health = attacker.max_combat_health

	return

/**
  * This proc checks if a battle can be initiated between src and attacker.
  *
  * Both SRC and attacker (if attacker is included) timers are checked if they're on cooldown, and
  * both SRC and attacker (if attacker is included) are checked if they are in combat already.
  * If any of the above are true, the proc returns FALSE and sends a message to user (and target, if included) otherwise, it returns TRUE
  * Arguments:
  * * user: the user who is initiating the battle
  * * attacker: optional arg for checking two ships at once
  * * target: optional arg used in Ship PvP battles (if used, attacker is target's model ship)
  */
/obj/item/lore/model_ship/proc/check_battle_start(mob/living/carbon/user, obj/item/lore/model_ship/attacker, mob/living/carbon/target)
	if(attacker && attacker.in_combat)
		to_chat(user, "<span class='notice'>[target?target.p_their() : "Your" ] [attacker.name] is in combat.</span>")
		to_chat(target, "<span class='notice'>Your [attacker.name] is in combat.</span>")
		return FALSE
	if(in_combat)
		to_chat(user, "<span class='notice'>Your [name] is in combat.</span>")
		to_chat(target, "<span class='notice'>[target.p_their()] [name] is in combat.</span>")
		return FALSE
	if(attacker && attacker.timer > world.time)
		to_chat(user, "<span class='notice'>[target?target.p_their() : "Your" ] [attacker.name] isn't ready for battle.</span>")
		to_chat(target, "<span class='notice'>Your [attacker.name] isn't ready for battle.</span>")
		return FALSE
	if(timer > world.time)
		to_chat(user, "<span class='notice'>Your [name] isn't ready for battle.</span>")
		to_chat(target, "<span class='notice'>[target.p_their()] [name] isn't ready for battle.</span>")
		return FALSE

	return TRUE

/**
  * Processes any special attack moves that happen in the battle (called in the shipBattle proc).
  *
  * Makes the ships shout their special attack cry and updates its cooldown. Then, does the special attack.
  * Arguments:
  * * victim - the ships being hit by the special move
  */
/obj/item/lore/model_ship/proc/special_attack_move(obj/item/lore/model_ship/victim)
	say(special_attack_cry + "!!")

	special_attack_charged = FALSE
	special_attack_cooldown = 3

	switch(special_attack_type)
		if(SPECIAL_ATTACK_DAMAGE) //+2 damage
			victim.combat_health-=2
			playsound(src, 'nsv13/sound/effects/ship/nukehit.ogg', 20, TRUE)
		if(SPECIAL_ATTACK_HEAL) //+2 healing
			combat_health+=2
			playsound(src, 'nsv13/sound/effects/ship/damage/shield_hit2.ogg', 20, TRUE)
		if(SPECIAL_ATTACK_UTILITY) //+1 heal, +1 damage
			victim.combat_health--
			combat_health++
			playsound(src, 'nsv13/sound/effects/ship/warp_exit.ogg', 30, TRUE)
		if(SPECIAL_ATTACK_OTHER) //other
			super_special_attack(victim)
		else
			say("I FORGOT MY SPECIAL ATTACK...")

/**
  * Base proc for 'other' special attack moves.
  *
  * This one is only for inheritance, each mech with an 'other' type move has their procs below.
  * Arguments:
  * * victim - the model ship being hit by the super special move (doesn't necessarily need to be used)
  */
/obj/item/lore/model_ship/proc/super_special_attack(obj/item/lore/model_ship/victim)
	visible_message("<span class='notice'> [src] does an awesome loop.</span>")

/// Whiterapids Model Ships
/obj/item/lore/model_ship/whiterapids
	name = "Whiterapids Model Ship"
	desc = "A Whiterapids model ship"
	shipsound = 'nsv13/sound/effects/ship/mac_fire.ogg'

/obj/item/lore/model_ship/whiterapids/atlas
	name = "NSV Atlas Model Ship"
	max_combat_health = 4 //200 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "SURPRISE TORPEDO"
	shipsound = 'nsv13/sound/effects/ship/50cal.ogg'
	combat_sound = 'nsv13/sound/effects/ship/mac_fire.ogg'

/obj/item/lore/model_ship/whiterapids/tycoon
	name = "NSV Tycoon Model Ship"
	max_combat_health = 5 //250 integrity
	special_attack_type = SPECIAL_ATTACK_UTILITY
	special_attack_cry = "FIGHTER SWARM"
	shipsound = 'nsv13/sound/effects/ship/fighter_launch.ogg'
	combat_sound = 'nsv13/sound/effects/ship/mac_fire.ogg'

/obj/item/lore/model_ship/whiterapids/eclipse
	name = "NSV Eclipse Model Ship"
	max_combat_health = 3 //150 integrity
	special_attack_type = SPECIAL_ATTACK_HEAL
	special_attack_cry = "SILVER TAPE REPAIRS"
	combat_sound = 'nsv13/sound/effects/ship/gauss.ogg'

/obj/item/lore/model_ship/whiterapids/galactica
	name = "NSV Galactica Model Ship"
	max_combat_health = 6 //300 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "BLUESPACE ARTILLERY"
	shipsound = 'nsv13/sound/weapons/bsa_select.ogg'
	combat_sound = 'nsv13/sound/weapons/bsa_fire.ogg'

/obj/item/lore/model_ship/whiterapids/gladius
	name = "NSV Gladius Model Ship"
	max_combat_health = 5 //250 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "DECK BARRAGE"
	shipsound = 'nsv13/sound/effects/ship/torpedo.ogg'
	combat_sound = 'nsv13/sound/effects/ship/battleship_gun2.ogg'

/obj/item/lore/model_ship/whiterapids/hammerhead
	name = "NSV Hammerhead Model Ship"
	max_combat_health = 4 //200 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "RAMMING SPEED"
	shipsound = 'nsv13/sound/effects/ship/damage/shiphit4.ogg'
	combat_sound = 'nsv13/sound/effects/ship/broadside.ogg'

/obj/item/lore/model_ship/whiterapids/shrike
	name = "NSV Shrike Model Ship"
	max_combat_health = 4 //200 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "RAILGUNS"
	shipsound = 'nsv13/sound/effects/ship/gauss.ogg'
	combat_sound = 'nsv13/sound/effects/ship/railgun_fire.ogg'

/obj/item/lore/model_ship/whiterapids/snake
	name = "NSV Snake Model Ship"
	max_combat_health = 4 //200 integrity
	special_attack_type = SPECIAL_ATTACK_UTILITY
	special_attack_cry = "FIRE EVERYTHING"
	combat_sound = 'nsv13/sound/effects/ship/broadside.ogg'

/// Dominion Model Ships
/obj/item/lore/model_ship/dominion
	name = "Dominion of Light Model Ship"
	desc = "A Dominion of Light model ship"
	shipsound = 'nsv13/sound/effects/ship/plasma_gun_fire.ogg'

/obj/item/lore/model_ship/dominion/serendipity
	name = "DLV Serendipity Model Ship"
	max_combat_health = 2 //100 integrity
	special_attack_type = SPECIAL_ATTACK_HEAL
	special_attack_cry = "EMERGENCY REPAIRS"
	shipsound = 'nsv13/sound/effects/ship/plasma.ogg'
	combat_sound = 'nsv13/sound/effects/ship/plasma_gun_fire.ogg'

/// Draconic Empire Model Ships - Not implemented currently but for future stuff
/obj/item/lore/model_ship/draconic
	name = "Draconic Empire Model Ship"
	desc = "A Draconic Empire model ship"
	shipsound = 'nsv13/sound/effects/ship/battleship_gun2.ogg'

/// SolGov Model Ships
/obj/item/lore/model_ship/solgov
	name = "SolGov Model Ship"
	desc = "A SolGov model ship"
	shipsound = 'nsv13/sound/effects/ship/phaser.ogg'

/obj/item/lore/model_ship/solgov/aetherwhisp
	name = "SGV Aetherwhisp Model Ship"
	max_combat_health = 6 //300 integrity
	special_attack_type = SPECIAL_ATTACK_DAMAGE
	special_attack_cry = "FIRE PHASERS"
	combat_sound = 'nsv13/sound/effects/ship/burst_phaser2.ogg'

/// Syndicate Model Ships - Future Implementation

/// Pirate Model Ships - Future Implementation

#undef SPECIAL_ATTACK_HEAL
#undef SPECIAL_ATTACK_DAMAGE
#undef SPECIAL_ATTACK_UTILITY
#undef SPECIAL_ATTACK_OTHER
#undef MAX_BATTLE_LENGTH
