// Only Clients should have a panel for them, okay?
/mob/Login()
	. = ..()
	AddComponent(/datum/component/interaction_menu_granter)

/mob/Logout()
	qdel(GetComponent(/datum/component/interaction_menu_granter))
	. = ..()

