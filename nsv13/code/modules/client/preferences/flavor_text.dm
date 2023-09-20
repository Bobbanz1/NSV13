#define MAX_FLAVOR_LEN 4096

/// Character Flavor Text
/datum/preference/text/flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	preference_type = PREFERENCE_CHARACTER
	db_key = "flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.flavour_text = value

/// Silicon Flavor Text
/datum/preference/text/silicon_flavor_text
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	preference_type = PREFERENCE_CHARACTER
	db_key = "silicon_flavor_text"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/silicon_flavor_text/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/// Character General Records
/datum/preference/text/general_record
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	preference_type = PREFERENCE_CHARACTER
	db_key = "general_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/general_record/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/// Character Medical Records
/datum/preference/text/medical_record
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	preference_type = PREFERENCE_CHARACTER
	db_key = "medical_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/medical_record/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/// Character Security Records
/datum/preference/text/security_record
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	preference_type = PREFERENCE_CHARACTER
	db_key = "security_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/security_record/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

#undef MAX_FLAVOR_LEN
