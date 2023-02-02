//aphrodisiac & anaphrodisiac

/datum/reagent/drug/aphrodisiac
	name = "Crocin"
	description = "Naturally found in the crocus and gardenia flowers, this drug acts as a natural and safe aphrodisiac."
	taste_description = "strawberry roofies"
	taste_mult = 2 //Hide the roofies in stronger flavors
	color = "#FFADFF"//PINK, rgb(255, 173, 255)

/datum/reagent/drug/aphrodisiac/on_mob_life(mob/living/M)
	if(M && M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO))
		if((prob(min(current_cycle/2,5))))
			M.emote(pick("moan","blush"))
		if(prob(min(current_cycle/4,10)))
			var/aroused_message = pick("You feel frisky.", "You're having trouble suppressing your urges.", "You feel in the mood.")
			to_chat(M, "<span class='userlove'>[aroused_message]</span>")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/genits = H.adjust_arousal(current_cycle, "crocin", aphro = TRUE) // redundant but should still be here
			for(var/g in genits)
				var/obj/item/organ/genital/G = g
				to_chat(M, "<span class='userlove'>[G.arousal_verb]!</span>")
	..()

/datum/reagent/drug/aphrodisiacplus
	name = "Hexacrocin"
	description = "Chemically condensed form of basic crocin. This aphrodisiac is extremely powerful and addictive in most animals.\
					Addiction withdrawals can cause brain damage and shortness of breath. Overdosage can lead to brain damage and a \
					permanent increase in libido (commonly referred to as 'bimbofication')."
	taste_description = "liquid desire"
	color = "#FF2BFF"//dark pink
	addiction_threshold = 20
	overdose_threshold = 20

/datum/reagent/drug/aphrodisiacplus/on_mob_life(mob/living/M)
	if(M && M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO))
		if(prob(5))
			if(prob(current_cycle))
				M.say(pick("Hnnnnngghh...", "Ohh...", "Mmnnn..."))
			else
				M.emote(pick("moan","blush"))
		if(prob(5))
			var/aroused_message
			if(current_cycle>25)
				aroused_message = pick("You need to fuck someone!", "You're bursting with sexual tension!", "You can't get sex off your mind!")
			else
				aroused_message = pick("You feel a bit hot.", "You feel strong sexual urges.", "You feel in the mood.", "You're ready to go down on someone.")
			to_chat(M, "<span class='userlove'>[aroused_message]</span>")
			REMOVE_TRAIT(M,TRAIT_NEVERBONER,APHRO_TRAIT)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/genits = H.adjust_arousal(100, "hexacrocin", aphro = TRUE) // redundant but should still be here
			for(var/g in genits)
				var/obj/item/organ/genital/G = g
				to_chat(M, "<span class='userlove'>[G.arousal_verb]!</span>")
	..()

/datum/reagent/drug/aphrodisiacplus/addiction_act_stage2(mob/living/M)
	if(prob(30))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2)
	..()
/datum/reagent/drug/aphrodisiacplus/addiction_act_stage3(mob/living/M)
	if(prob(30))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3)

		..()
/datum/reagent/drug/aphrodisiacplus/addiction_act_stage4(mob/living/M)
	if(prob(30))
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4)
	..()

/datum/reagent/drug/aphrodisiacplus/overdose_process(mob/living/M)
	if(M && M.client?.prefs.arousable && !(M.client?.prefs.cit_toggles & NO_APHRO) && prob(33))
		if(prob(5) && ishuman(M) && M.has_dna() && (M.client?.prefs.cit_toggles & BIMBOFICATION))
			if(!HAS_TRAIT(M,TRAIT_PERMABONER))
				to_chat(M, "<span class='userlove'>Your libido is going haywire!</span>")
				ADD_TRAIT(M,TRAIT_PERMABONER,APHRO_TRAIT)
	..()

/datum/reagent/drug/anaphrodisiac
	name = "Camphor"
	description = "Naturally found in some species of evergreen trees, camphor is a waxy substance. When injested by most animals, it acts as an anaphrodisiac\
					, reducing libido and calming them. Non-habit forming and not addictive."
	taste_description = "dull bitterness"
	taste_mult = 2
	color = "#D9D9D9"//rgb(217, 217, 217)
	reagent_state = SOLID

/datum/reagent/drug/anaphrodisiac/on_mob_life(mob/living/M)
	if(M && M.client?.prefs.arousable && prob(16))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/genits = H.adjust_arousal(-100, "camphor", aphro = TRUE)
			if(genits.len)
				to_chat(M, "<span class='notice'>You no longer feel aroused.")
	..()

/datum/reagent/drug/anaphrodisiacplus
	name = "Hexacamphor"
	description = "Chemically condensed camphor. Causes an extreme reduction in libido and a permanent one if overdosed. Non-addictive."
	taste_description = "tranquil celibacy"
	color = "#D9D9D9"//rgb(217, 217, 217)
	reagent_state = SOLID
	overdose_threshold = 20

/datum/reagent/drug/anaphrodisiacplus/on_mob_life(mob/living/M)
	if(M && M.client?.prefs.arousable)
		REMOVE_TRAIT(M,TRAIT_PERMABONER,APHRO_TRAIT)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/genits = H.adjust_arousal(-100, "hexacamphor", aphro = TRUE)
			if(genits.len)
				to_chat(M, "<span class='notice'>You no longer feel aroused.")

	..()

/datum/reagent/drug/anaphrodisiacplus/overdose_process(mob/living/M)
	if(M && M.client?.prefs.arousable && prob(5))
		to_chat(M, "<span class='userlove'>You feel like you'll never feel aroused again...</span>")
		ADD_TRAIT(M,TRAIT_NEVERBONER,APHRO_TRAIT)
	..()
