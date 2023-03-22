/*
/datum/ai_behavior/microwave

/datum/ai_behavior/microwave/perform(delta_time, datum/ai_controller/controller, target_key, food_path)
	. = ..()
	var/mob/living/living_pawn = controller.pawn

	var/list/to_microwave = list()
	for(var/food in controller.blackboard[target_key])
		if(istype(food, food_path))
			var/obj/item/reagent_containers/food/snacks/S = food
			to_microwave += S
		else
			controller.blackboard[target_key] -= food

	if(!to_microwave.len)
		finish_action(controller, FALSE)

	finish_action(controller, TRUE)
*/

/datum/ai_behavior/microwave
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/microwave/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/datum/weakref/target_ref = controller.blackboard[target_key]
	set_movement_target(controller, target_ref?.resolve())

/datum/ai_behavior/microwave/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.blackboard[target_key] = null
	controller.blackboard[BB_HOLOCHEF_MICROWAVING] = FALSE

/datum/ai_behavior/microwave/perform(delta_time, datum/ai_controller/controller, target_key, food_path)
	. = ..()

//	if(controller.blackboard[])
