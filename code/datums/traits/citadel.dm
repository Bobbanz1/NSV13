/// NSV13 - God fucking Help Me
/datum/quirk/maso
	name = "Masochism"
	desc = "You are aroused by pain."
	value = 0
	mob_trait = TRAIT_MASO
	gain_text = "<span class='notice'>You desire to be hurt.</span>"
	lose_text = "<span class='notice'>Pain has become less exciting for you.</span>"
/datum/quirk/libido
	name = "Nymphomaniac"
	desc = "You are much more sensitive to arousal."
	value = 0
	mob_trait = TRAIT_NYMPHO
	gain_text = "<span class='notice'>You are feeling extra wild.</span>"
	lose_text = "<span class='notice'>You don't feel that burning sensation anymore.</span>"

/datum/quirk/libido/add()
	var/mob/living/carbon/human/H = quirk_holder
	H.arousal_rate = 3 * initial(H.arousal_rate)

/datum/quirk/libido/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.arousal_rate = initial(H.arousal_rate)
