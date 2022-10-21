/mob/living/silicon/robot/update_icons()
	icon = (module.cyborg_icon_override ? module.cyborg_icon_override : initial(icon))
	. = ..()
	update_unique_borg_icons()

/mob/living/silicon/robot/proc/update_unique_borg_icons()
	if(stat == DEAD && (R_TRAIT_UNIQUEWRECK in module.model_features))
		icon_state = "[module.cyborg_base_icon]-wreck"

	update_fire()
