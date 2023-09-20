/// Which pilot role this person would want.
/datum/preference/choiced/pilot_role
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE
	preference_type = PREFERENCE_CHARACTER
	db_key = "preferred_pilot_role"

/datum/preference/choiced/pilot_role/deserialize(input, datum/preferences/preferences)
	if (!(input in GLOB.pilot_role_prefs))
		return PILOT_COMBAT
	return ..()

/datum/preference/choiced/pilot_role/init_possible_values()
	return GLOB.pilot_role_prefs

/datum/preference/choiced/pilot_role/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/pilot_role/create_default_value()
	return PILOT_COMBAT
