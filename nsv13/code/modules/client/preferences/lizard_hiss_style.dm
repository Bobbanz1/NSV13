/datum/preference/choiced/lizard_hiss
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	db_key = "lizard_hiss_style"
	preference_type = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/lizard_hiss/init_possible_values()
	return list(LIZARD_HISS_EXPANDED, LIZARD_HISS_LEGACY)

/datum/preference/choiced/lizard_hiss/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/lizard_hiss/create_default_value()
	return LIZARD_HISS_EXPANDED
