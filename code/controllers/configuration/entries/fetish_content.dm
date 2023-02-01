/datum/config_entry/keyed_list/breasts_cups_prefs
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	config_entry_value = list("a", "b", "c", "d", "e") //keep these lowercase

/datum/config_entry/number/penis_min_inches_prefs
	config_entry_value = 1
	min_val = 0

/datum/config_entry/number/penis_max_inches_prefs
	config_entry_value = 20
	min_val = 0

/datum/config_entry/number/butt_min_size_prefs
	config_entry_value = 1
	min_val = 0
	max_val = BUTT_SIZE_MAX

/datum/config_entry/number/butt_max_size_prefs
	config_entry_value = BUTT_SIZE_MAX
	min_val = 0
	max_val = BUTT_SIZE_MAX

/datum/config_entry/keyed_list/safe_visibility_toggles
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	config_entry_value = list(GEN_VISIBLE_NO_CLOTHES, GEN_VISIBLE_NO_UNDIES, GEN_VISIBLE_NEVER) //refer to cit_helpers for all toggles.
