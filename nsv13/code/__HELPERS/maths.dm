/*
	This proc makes the input taper off above cap. But there's no absolute cutoff.
	Chunks of the input value above cap, are reduced more and more with each successive one and added to the output
	A higher input value always makes a higher output value. but the rate of growth slows
*/
/proc/soft_cap(var/input, var/cap = 0, var/groupsize = 1, var/groupmult = 0.9)

	//The cap is a ringfenced amount. If we're below that, just return the input
	if (input <= cap)
		return input

	var/output = 0
	var/buffer = 0
	var/power = 1//We increment this after each group, then apply it to the groupmult as a power

	//Ok its above, so the cap is a safe amount, we move that to the output
	input -= cap
	output += cap

	//Now we start moving groups from input to buffer


	while (input > 0)
		buffer = min(input, groupsize)	//We take the groupsize, or all the input has left if its less
		input -= buffer

		buffer *= groupmult**power //This reduces the group by the groupmult to the power of which index we're on.
		//This ensures that each successive group is reduced more than the previous one

		output += buffer
		power++ //Transfer to output, increment power, repeat until the input pile is all used

	return output



/proc/linear_calculation(var/max_power, var/basic_power, var/scale_increment, var/max_excess_power, var/base_v = 3.5, var/max_v = 5, var/input_power, var/original_thrust)
	var/increment = 0
	var/scale_factor = 0
	var/output = 0
	var/usable_power = (max_power - max_excess_power)
	var/linear_max_v = (max_v - base_v)
	var/power = input_power ? input_power : 0
	var/thrusty = original_thrust
	var/maxthrusty =
	var/linear_max_thrust = maxthrusty - thrusty

	increment = ((usable_power - basic_power)/scale_increment)
	scale_factor = (linear_max_v/increment)



	output = (base_v + ((power - basic_power)/scale_increment * scale_factor))

	return output
