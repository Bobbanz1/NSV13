/datum/interaction/lewd/titgrope
	description = "Grope their breasts."
	require_user_hands = TRUE
	require_target_breasts = REQUIRES_ANY
	write_log_user = "groped"
	write_log_target = "was groped by"
	interaction_sound = null
	max_distance = 1

/datum/interaction/lewd/titgrope/display_interaction(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.a_intent == INTENT_HELP)
		user.visible_message(
				pick(span_lewd("\The <b>[user]</b> gently gropes \the <b>[target]</b>'s breast."),
					 span_lewd("\The <b>[user]</b> softly squeezes \the <b>[target]</b>'s breasts."),
					 span_lewd("\The <b>[user]</b> grips \the <b>[target]</b>'s breasts."),
					 span_lewd("\The <b>[user]</b> runs a few fingers over \the <b>[target]</b>'s breast."),
					 span_lewd("\The <b>[user]</b> delicately teases \the <b>[target]</b>'s nipple."),
					 span_lewd("\The <b>[user]</b> traces a touch across \the <b>[target]</b>'s breast.")))
	if(user.a_intent == INTENT_HARM)
		user.visible_message(
				pick(span_lewd("\The <b>[user]</b> aggressively gropes \the <b>[target]</b>'s breast."),
					 span_lewd("\The <b>[user]</b> grabs \the <b>[target]</b>'s breasts."),
					 span_lewd("\The <b>[user]</b> tightly squeezes \the <b>[target]</b>'s breasts."),
					 span_lewd("\The <b>[user]</b> slaps at \the <b>[target]</b>'s breasts."),
					 span_lewd("\The <b>[user]</b> gropes \the <b>[target]</b>'s breasts roughly.")))
	if(prob(5 + target.get_lust()))
		if(target.a_intent == INTENT_HELP)
			user.visible_message(
				pick(span_lewd("\The <b>[target]</b> shivers in arousal."),
					 span_lewd("\The <b>[target]</b> moans quietly."),
					 span_lewd("\The <b>[target]</b> breathes out a soft moan."),
					 span_lewd("\The <b>[target]</b> gasps."),
					 span_lewd("\The <b>[target]</b> shudders softly."),
					 span_lewd("\The <b>[target]</b> trembles as hands run across bare skin.")))
			if(target.get_lust() < 5)
				target.set_lust(5)
		if(target.a_intent == INTENT_DISARM)
			if (target.restrained())
				user.visible_message(
					pick(span_lewd("\The <b>[target]</b> twists playfully against the restraints."),
						 span_lewd("\The <b>[target]</b> squirms away from <b>[user]</b>'s hand."),
						 span_lewd("\The <b>[target]</b> slides back from <b>[user]</b>'s roaming hand."),
						 span_lewd("\The <b>[target]</b> thrusts bare breasts forward into <b>[user]</b>'s hands.")))
			else
				user.visible_message(
					pick(span_lewd("\The <b>[target]</b> playfully bats at <b>[user]</b>'s hand."),
						 span_lewd("\The <b>[target]</b> squirms away from <b>[user]</b>'s hand."),
						 span_lewd("\The <b>[target]</b> guides <b>[user]</b>'s hand across bare breasts."),
						 span_lewd("\The <b>[target]</b> teasingly laces a few fingers over <b>[user]</b>'s knuckles.")))
			if(target.get_lust() < 10)
				target.add_lust(1)
	if(target.a_intent == INTENT_GRAB)
		user.visible_message(
				pick(span_lewd("\The <b>[target]</b> grips <b>[user]</b>'s wrist tight."),
				 span_lewd("\The <b>[target]</b> digs nails into <b>[user]</b>'s arm."),
				 span_lewd("\The <b>[target]</b> grabs <b>[user]</b>'s wrist for a second.")))
	if(target.a_intent == INTENT_HARM)
		user.adjustBruteLoss(1)
		user.visible_message(
				pick(span_lewd("\The <b>[target]</b> pushes <b>[user]</b> roughly away."),
				 span_lewd("\The <b>[target]</b> digs nails angrily into <b>[user]</b>'s arm."),
				 span_lewd("\The <b>[target]</b> fiercely struggles against <b>[user]</b>."),
				 span_lewd("\The <b>[target]</b> claws <b>[user]</b>'s forearm, drawing blood."),
				 span_lewd("\The <b>[target]</b> slaps <b>[user]</b>'s hand away.")))
	return
