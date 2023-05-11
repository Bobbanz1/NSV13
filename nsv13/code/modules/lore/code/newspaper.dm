/obj/item/lore/newspaper
	name = "newspaper"
	desc = "An issue of Stellar News."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bapped")
	resistance_flags = FLAMMABLE
	var/list/articles = list() //The articles in the newspaper
	var/reading = FALSE
	var/amount_of_articles = 3

/obj/item/lore/newspaper/Initialize(mapload)
	. = ..()
	articles += pick_list(NEWSPAPER_FILE, "mundane")
	articles += pick_list(NEWSPAPER_FILE, "military")
	articles += pick_list(NEWSPAPER_FILE, "economy")

/obj/item/lore/newspaper/attack_self(mob/user)
	if(reading)
		to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	if(!user.can_read(src))
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=amount_of_articles, i++)
		if(!turn_page(user))
			on_reading_stopped()
			reading = FALSE
			return
	if(do_after(user,50, user))
		on_reading_finished(user)
		reading = FALSE
	return TRUE

/obj/item/lore/newspaper/proc/turn_page(mob/user)
	playsound(user, pick('sound/effects/pageturn1.ogg','sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'), 30, 1)
	if(do_after(user,50, user))
		if(articles.len)
			to_chat(user, "<span class='notice'>[pick(articles)]</span>")
		else
			to_chat(user, "<span class='notice'>You keep reading...</span>")
		return TRUE
	return FALSE

/obj/item/lore/newspaper/proc/on_reading_start(mob/user)
	to_chat(user, "<span class='notice'>You start reading [name]...</span>")

/obj/item/lore/newspaper/proc/on_reading_stopped(mob/user)
	to_chat(user, "<span class='notice'>You stop reading...</span>")

/obj/item/lore/newspaper/proc/on_reading_finished(mob/user)
	to_chat(user, "<span class='notice'>You finish reading [name]!</span>")
