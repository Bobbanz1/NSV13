/datum/ai_planning_subtree/holo_chef_tree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(length(controller.blackboard[BB_HOLOCHEF_FOOD]) == 0)
		controller.queue_behavior(/datum/ai_behavior/find_nearby_food, BB_HOLOCHEF_FOOD, /obj/item, 2)
		return

	if(!controller.blackboard[BB_HOLOCREW_CURRENT_PRESS_TARGET])
		controller.queue_behavior(/datum/ai_behavior/find_and_set, BB_HOLOCREW_CURRENT_PRESS_TARGET, /obj/machinery/microwave, 5)
	else
		if(prob(5))
			return SUBTREE_RETURN_FINISH_PLANNING
