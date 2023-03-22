/datum/ai_behavior/find_and_set/food

/datum/ai_behavior/find_and_set/food/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/food_candidates = list()
	for(var/obj/item/local_candidate in oview(search_range, controller.pawn))
		if(!isfood(local_candidate))
			continue
		food_candidates += local_candidate
	if(!food_candidates.len)
		finish_action(controller, FALSE)
	if(food_candidates.len)
		return food_candidates

/// Helper proc to ensure consistency in setting the source of the movement target
/datum/ai_behavior/proc/set_movement_target(datum/ai_controller/controller, atom/target, datum/ai_movement/new_movement)
	controller.set_movement_target(type, target, new_movement)

/datum/ai_behavior/use_on_machine
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT

/datum/ai_behavior/use_on_machine/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/datum/weakref/target_ref = controller.blackboard[target_key]
	var/target = target_ref?.resolve()
	if(!target)
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/use_on_machine/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/obj/item/held_item = pawn.get_item_by_slot(pawn.get_active_hand())
	var/datum/weakref/target_ref = controller.blackboard[target_key]
	var/atom/target = target_ref?.resolve()

	if(!target || !pawn.CanReach(target))
		finish_action(controller, FALSE)
		return

	pawn.a_intent = INTENT_HELP
	if(held_item)
		held_item.melee_attack_chain(pawn, target)
	else
		pawn.UnarmedAttack(target, TRUE)

	finish_action(controller, TRUE)

/datum/ai_behavior/find_nearby

/datum/ai_behavior/find_nearby/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()

	var/list/possible_targets = list()
	for(var/atom/thing in view(5, controller.pawn))
		if(!thing.mouse_opacity)
			continue
		if(thing.IsObscured())
			continue
		possible_targets += thing
	if(!possible_targets.len)
		finish_action(controller, FALSE)
	controller.blackboard[target_key] = WEAKREF(pick(possible_targets))
	finish_action(controller, TRUE)

/datum/ai_behavior/find_nearby_food

/datum/ai_behavior/find_nearby_food/perform(delta_time, datum/ai_controller/controller, target_key, locate_path, search_range)
	. = ..()

	var/list/food_candidates = list()
	for(var/obj/item/local_candidate in oview(search_range, controller.pawn))
		if(!local_candidate.mouse_opacity)
			continue
		if(local_candidate.IsObscured())
			continue
		if(!isfood(local_candidate))
			continue
		food_candidates += local_candidate
	if(!food_candidates.len)
		finish_action(controller, FALSE)
	controller.blackboard[target_key] = food_candidates
	finish_action(controller, TRUE)
