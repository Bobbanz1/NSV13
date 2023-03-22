/datum/ai_controller/holo_chef
	movement_delay = 0.4 SECONDS
	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/holo_chef_tree,
	)
	blackboard = list(
		BB_HOLOCHEF_FOOD = list(),
		BB_HOLOCHEF_MICROWAVING = FALSE,
	)

/datum/ai_controller/holo_chef/TryPossessPawn(atom/new_pawn)
	if(!isliving(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE

	var/mob/living/living_pawn = new_pawn
	movement_delay = living_pawn.cached_multiplicative_slowdown
	return ..()

/datum/ai_controller/proc/set_movement_target(source, atom/target, datum/ai_movement/new_movement)
	movement_target_source = source
	current_movement_target = target
	if(new_movement)
		change_ai_movement_type(new_movement)
