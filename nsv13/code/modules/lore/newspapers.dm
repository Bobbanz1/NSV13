/obj/item/lore/newspaper
	name = "Stellar Newspaper"
	desc = "An issue of Stellar News."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	lefthand_file = 'icons/mob/inhands/misc/books_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/books_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bapped")
	resistance_flags = FLAMMABLE
	/// The amount of articles in this magazine
	var/list/articles = list()
	/// Whether the newspaper is currently being read.
	var/reading = FALSE
	/// The time it takes to read a page
	var/reading_time = 5 SECONDS
	/// How many pages there is in this newspaper
	var/amount_of_articles = 3
	/// The sounds played as the user's reading the newspaper
	var/list/newspaper_sounds = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg',
	)
	/// List of all the various categories you can find in this newspaper
	var/list/categories = list(
		"mundane",
		"military",
		"economy",
	)

/obj/item/lore/newspaper/Initialize(mapload)
	. = ..()
	/// Goes through the entire category list and picks from the entries
	for(var/entry in categories)
		articles += pick_list(NEWSPAPER_FILE, entry)

/obj/item/lore/newspaper/attack_self(mob/living/user)
	if(reading)
		to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(!on_reading_start(user))
		return
	reading = TRUE
	for(var/i=1, i<=amount_of_articles, i++)
		if(!turn_page(user))
			on_reading_stopped()
			reading = FALSE
			return
	if(do_after(user, reading_time, user))
		on_reading_finished(user)
		reading = FALSE
	return TRUE

/obj/item/lore/newspaper/proc/turn_page(mob/living/user)
	playsound(user, pick(newspaper_sounds), 30, TRUE)

	if(!do_after(user, reading_time, src))
		return FALSE

	/**
	 * Todo
	 *
	 * * Make the articles not repeat themselves
	 * * Possibly make it pick an article and then put that article into a list
	 * * Make the article list reset afterwards...or make the new list purge itself?
	 */
	to_chat(user, "<span class='notice'>[length(articles) ? pick(articles) : "You keep reading..."]</span>")
	return TRUE

/obj/item/lore/newspaper/proc/on_reading_start(mob/living/user)
	to_chat(user, "<span class='notice'>You start reading [name]...</span>")

/obj/item/lore/newspaper/proc/on_reading_stopped(mob/living/user)
	to_chat(user, "<span class='notice'>You stop reading...</span>")

/obj/item/lore/newspaper/proc/on_reading_finished(mob/living/user)
	to_chat(user, "<span class='notice'>You finish reading [name]!</span>")

/obj/machinery/newspaper
	name = "\improper Newspaper Stand"
	desc = "Vends the latest issues of Stellar News for only 5 credits"
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	light_color = LIGHT_COLOR_ORANGE
	/// The price for a newspaper
	var/price = 5
	/// The amount of credits currently inside this machine
	var/internal_account = 0

/obj/machinery/newspaper/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The machines change counter is at [internal_account] credits</span>"
	. += "<span class='notice'>Alt-click [src] to retrieve exact change.</span>"

/obj/machinery/newspaper/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/holochip)) /// Only accepts holochips/credits for now.
		var/obj/item/holochip/money = I
		if(!user.temporarilyRemoveItemFromInventory(money))
			return
		to_chat(user, "<span class='notice'>You insert [money.credits] holocredits into [src]'s slot!</span>")
		internal_account += money.credits
		qdel(money)
	else
		to_chat(user, "<span class='warning'>The machine smartly refuses [I] as it only accepts holocredits!</span>")
		return ..()

/obj/machinery/newspaper/attack_hand(mob/living/user)
	if(internal_account >= price) // Todo, make this thing return the extra money paid
		var/obj/item/dispensed = new /obj/item/lore/newspaper(get_turf(src))
		internal_account -= price
		if(user.put_in_hands(dispensed))
			to_chat(user, "<span class='notice'>You grab an issue of Stellar News, maybe there's something interesting in this issue?</span>")
		else
			to_chat(user, "<span class='warning'>[capitalize(dispensed)] falls onto the floor!</span>")
	else
		return ..()

/obj/machinery/newspaper/AltClick(mob/user)
	if(!user.canUseTopic(src, !issilicon(user)))
		return
	if(internal_account >= price)
		var/obj/item/holochip/holo = new /obj/item/holochip(loc, internal_account)
		internal_account = 0
		if(user.put_in_hands(holo))
			to_chat(user, "<span class='notice'>You grab the dispensed holochip</span>")
		else
			to_chat(user, "<span class='warning'>[capitalize(holo)] falls onto the floor!</span>")
