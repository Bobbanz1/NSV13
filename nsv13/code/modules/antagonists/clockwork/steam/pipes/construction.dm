/obj/item/brass_pipe
	name = "brass pipe"
	desc = "A brass pipe"
	var/pipe_type
	var/pipename
	force = 7
	throwforce = 8
	icon = 'nsv13/icons/obj/clockwork/steam/pipes/pipes.dmi'
	icon_state = "steam_pipe"
	w_class = WEIGHT_CLASS_NORMAL
	level = 2
	var/BPD_type

/obj/item/brass_pipe/directional
	BPD_type = PIPE_UNARY
/obj/item/brass_pipe/binary
	BPD_type = PIPE_STRAIGHT
/obj/item/brass_pipe/binary/bendable
	BPD_type = PIPE_BENDABLE
/obj/item/brass_pipe/trinary
	BPD_type = PIPE_TRINARY
/obj/item/brass_pipe/trinary/flippable
	BPD_type = PIPE_TRIN_M
	var/flipped = FALSE
/obj/item/brass_pipe/quaternary
	BPD_type = PIPE_ONEDIR

/obj/item/brass_pipe/ComponentInitialize()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE)

/obj/item/brass_pipe/Initialize(mapload, _pipe_type, _dir, obj/machinery/steam_clock/steam/make_from)
	if(make_from)
		make_from_existing(make_from)
	else
		pipe_type = _pipe_type
		setDir(_dir)

	update()
	pixel_x += rand(-5, 5)
	pixel_y += rand(-5, 5)
	return ..()

/obj/item/brass_pipe/proc/make_from_existing(obj/machinery/steam_clock/steam/make_from)
	setDir(make_from.dir)
	pipename = make_from.name
	pipe_type = make_from.type

/obj/item/brass_pipe/proc/update()
	var/obj/machinery/steam_clock/steam/fakeS = pipe_type
	name = "[initial(fakeS.name)] fitting"
	icon_state = initial(fakeS.pipe_state)

/obj/item/brass_pipe/verb/flip()
	set category = "Object"
	set name = "Flip Brass Pipe"
	set src in view(1)

	if(usr.incapacitated() || !isliving(usr))
		return

	do_a_flip()

/obj/item/brass_pipe/proc/do_a_flip()
	setDir(turn(dir, -180))

/obj/item/brass_pipe/trinary/flippable/do_a_flip()
	setDir(turn(dir, flipped ? 45 : -45))
	flipped = !flipped

/obj/item/brass_pipe/Move()
	var/old_dir = dir
	..()
	setDir(old_dir)

/obj/item/brass_pipe/proc/fixed_dir()
	return dir

/obj/item/brass_pipe/binary/fixed_dir()
	. = dir
	if(dir == SOUTH)
		. = NORTH
	else if(dir == WEST)
		. = EAST

/obj/item/brass_pipe/trinary/flippable/fixed_dir()
	. = dir
	if(dir in GLOB.diagonals)
		. = turn(dir, 45)

/obj/item/brass_pipe/attack_self(mob/user)
	setDir(turn(dir, -90))

/obj/item/brass_pipe/wrench_act(mob/living/user, obj/item/wrench/W)
	if(!isturf(loc))
		return TRUE

	add_fingerprint(user)

	var/obj/machinery/steam_clock/steam/fakeS = pipe_type
	var/flags = initial(fakeS.pipe_flags)
	for(var/obj/machinery/steam_clock/steam/M in loc)
		if((M.pipe_flags & flags & PIPING_ONE_PER_TURF)) //Only one dense/requires density object per tile.
			to_chat(user, "<span class='warning'>Something is hogging the tile!</span>")
			return TRUE
		if(M.GetInitDirections() & SSsteam.get_init_dirs(pipe_type, fixed_dir())) // matches at least one direction on either type of pipe
			to_chat(user, "<span class='warning'>There is already a pipe at that location!</span>")
			return TRUE

	var/obj/machinery/steam_clock/steam/S = new pipe_type(loc)
	build_pipe(S)
	transfer_fingerprints_to(S)

	W.play_tool_sound(src)
	user.visible_message( \
		"[user] fastens \the [src].", \
		"<span class='notice'>You fasten \the [src].</span>", \
		"<span class='italics'>You hear ratcheting.</span>")

	qdel(src)


/obj/item/brass_pipe/proc/build_pipe(obj/machinery/steam_clock/steam/S)
	S.setDir(fixed_dir())
	S.SetInitDirections()

	if(pipename)
		S.name = pipename
	if(S.on)
		S.on = FALSE
