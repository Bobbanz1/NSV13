//NSV13 - Mail Changes - Start
/obj/item/delivery
	icon = 'icons/obj/storage.dmi'
	var/base_icon_state
	var/giftwrapped = 0
	var/sort_tag = 0

/obj/item/delivery/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, .proc/disposal_handling)

/**
 * Initial check if manually unwrapping
 */
/obj/item/delivery/proc/attempt_pre_unwrap_contents(mob/user)
	to_chat(user, "<span class='notice'>You start to unwrap the package...</span>")
	return do_after(user, 15, target = user)

/**
 * Signals for unwrapping.
 */
/obj/item/delivery/proc/unwrap_contents()
	for(var/atom/movable/movable_content as anything in contents)
		SEND_SIGNAL(movable_content, COMSIG_ITEM_UNWRAPPED)

/**
 * Effects after completing unwrapping
 */
/obj/item/delivery/proc/post_unwrap_contents(mob/user)
	var/turf/turf_loc = get_turf(user || src)
	playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)

	for(var/atom/movable/movable_content as anything in contents)
		movable_content.forceMove(turf_loc)

	qdel(src)

/obj/item/delivery/contents_explosion(severity, target)
	//NSV13 - Mail Changes - Stop
	for(var/thing in contents)
		switch(severity)
			if(EXPLODE_DEVASTATE)
				SSexplosions.high_mov_atom += thing
			if(EXPLODE_HEAVY)
				SSexplosions.med_mov_atom += thing
			if(EXPLODE_LIGHT)
				SSexplosions.low_mov_atom += thing

//NSV13 - Mail Changes - Start
/obj/item/delivery/deconstruct(disassembled)
	unwrap_contents()
	post_unwrap_contents()
	return ..()

/obj/item/delivery/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/obj/item/delivery/examine(mob/user)
	. = ..()
	if(sort_tag)
		. += "There's a sorting tag with the destination set to [GLOB.TAGGERLOCATIONS[sort_tag]]."

/obj/item/delivery/relay_container_resist(mob/living/user, obj/object)
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc //can't unwrap the wrapped container if it's inside something.
		movable_loc.relay_container_resist(user, object)
		return
	to_chat(user, "<span class='notice'>You lean on the back of [object] and start pushing to rip the wrapping around it.</span>")
	if(do_after(user, 50, target = object))
		if(!user || user.stat != CONSCIOUS || user.loc != object || object.loc != src )
			return
		to_chat(user, "<span class='notice'>You successfully removed [object]'s wrapping !</span>")
		object.forceMove(loc)
		unwrap_contents()
		post_unwrap_contents(user)
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, "<span class='warning'>You fail to remove [object]'s wrapping!</span>")

/obj/item/delivery/update_icon_state()
	. = ..()
	icon_state = giftwrapped ? "gift[base_icon_state]" : base_icon_state

/obj/item/delivery/update_overlays()
	. = ..()
	if(sort_tag)
		. += "[base_icon_state]_sort"

/obj/item/delivery/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/dest_tagger = item

		if(sort_tag != dest_tagger.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[dest_tagger.currTag])
			to_chat(user, "<span class='notice'>*[tag]*</span>")
			sort_tag = dest_tagger.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', 100, 1)
			update_appearance()

	else if(istype(item, /obj/item/pen))
		//NSV13 - Mail Changes - Stop
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>You scribble illegibly on the side of [src]!</span>")
			return
		var/str = stripped_input(user, "Label text?", "Set label", "", MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, "<span class='warning'>Invalid text!</span>")
			return
		user.visible_message("[user] labels [src] as [str].")
		name = "[name] ([str])"

	//NSV13 - Mail Changes - Start
	else if(istype(item, /obj/item/stack/wrapping_paper) && !giftwrapped)
		var/obj/item/stack/wrapping_paper/wrapping_paper = item
		if(wrapping_paper.use(3))
			user.visible_message("[user] wraps the package in festive paper!")
			giftwrapped = TRUE
			update_appearance()
			//NSV13 - Mail Changes - Stop
		else
			to_chat(user, "<span class='warning'>You need more paper!</span>")
	else
		return ..()

//NSV13 - Mail Changes - Start
/**
 * # Wrapped up crates and lockers - too big to carry.
 */
/obj/item/delivery/big
	name = "large parcel"
	desc = "A large delivery parcel."
	icon_state = "deliverycloset"
	density = TRUE
	interaction_flags_item = 0 // Disable the ability to pick it up. Wow!
	layer = BELOW_OBJ_LAYER
	pass_flags_self = PASSSTRUCTURE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND

/obj/item/delivery/big/interact(mob/user)
	if(!attempt_pre_unwrap_contents(user))
		return
	unwrap_contents()
	post_unwrap_contents(user)

/**
 * # Wrapped up items small enough to carry.
 */
/obj/item/delivery/small
	name = "parcel"
	desc = "A brown paper delivery parcel."
	icon_state = "deliverypackage3"

/obj/item/delivery/small/attack_self(mob/user)
	if(!attempt_pre_unwrap_contents(user))
		return
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	for(var/atom/movable/movable_content as anything in contents)
		user.put_in_hands(movable_content)
	post_unwrap_contents(user)

/obj/item/delivery/small/attack_self_tk(mob/user)
	if(ismob(loc))
		var/mob/M = loc
		M.temporarilyRemoveItemFromInventory(src, TRUE)
		for(var/atom/movable/movable_content as anything in contents)
			M.put_in_hands(movable_content)
	else
		for(var/atom/movable/movable_content as anything in contents)
			movable_content.forceMove(loc)

	unwrap_contents()
	post_unwrap_contents()
	return COMPONENT_CANCEL_ATTACK_CHAIN
//NSV13 - Mail Changes - Stop

/obj/item/dest_tagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/device.dmi'
	icon_state = "cargotagger"
	var/currTag = 0 //Destinations are stored in code\globalvars\lists\flavor_misc.dm
	var/locked_destination = FALSE //if true, users can't open the destination tag window to prevent changing the tagger's current destination
	w_class = WEIGHT_CLASS_TINY
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT

/obj/item/dest_tagger/borg
	name = "cyborg destination tagger"
	desc = "Used to fool the disposal mail network into thinking that you're a harmless parcel. Does actually work as a regular destination tagger as well."

/obj/item/dest_tagger/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins tagging [user.p_their()] final destination!  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if (islizard(user))
		to_chat(user, "<span class='notice'>*HELL*</span>")//lizard nerf
	else
		to_chat(user, "<span class='notice'>*HEAVEN*</span>")
	playsound(src, 'sound/machines/twobeep_high.ogg', 100, 1)
	return BRUTELOSS

//NSV13 - TGUI Interface - Start
/** Standard TGUI actions */
/obj/item/dest_tagger/ui_interact(mob/user, datum/tgui/ui)
	add_fingerprint(user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestinationTagger", name)
		ui.open()

/** If the user dropped the tagger */
/obj/item/dest_tagger/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/dest_tagger/attack_self(mob/user)
	if(!locked_destination)
		ui_interact(user)
		return

/** Data sent to TGUI window */
/obj/item/dest_tagger/ui_data(mob/user)
	var/list/data = list()
	data["locations"] = GLOB.TAGGERLOCATIONS
	data["currentTag"] = currTag
	return data

/** User clicks a button on the tagger */
/obj/item/dest_tagger/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("change")
			var/new_tag = round(text2num(params["index"]))
			if(new_tag == currTag || new_tag < 1 || new_tag > length(GLOB.TAGGERLOCATIONS))
				return
			currTag = new_tag
	return TRUE
//NSV13 - TGUI Interface - Stop
