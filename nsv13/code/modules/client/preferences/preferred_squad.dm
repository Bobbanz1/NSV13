/// Which squad is preferred
/datum/preference/choiced/preferred_squad
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	preference_type = PREFERENCE_CHARACTER
	db_key = "preferred_squad"

/datum/preference/choiced/preferred_squad/deserialize(input, datum/preferences/preferences)
	if (!(input in GLOB.squad_manager.squads))
		return "Able"
	return ..()

/datum/preference/choiced/preferred_squad/init_possible_values()
	return GLOB.squad_manager.squads

/datum/preference/choiced/preferred_squad/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/preferred_squad/create_default_value()
	return "Able"
