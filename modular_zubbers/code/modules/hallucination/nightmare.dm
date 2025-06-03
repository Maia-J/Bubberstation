/// Your mother appears to scold you.
/datum/hallucination/nightmare
	hallucination_tier = HALLUCINATION_TIER_NEVER

	var/obj/effect/client_image_holder/hallucination/nightmare/faker

/datum/hallucination/nightmare/start()
	var/list/spawn_locs = list()
	for(var/turf/open/floor in oview(hallucinator, 2))
		if(floor.is_blocked_turf(exclude_mobs = TRUE))
			continue
		spawn_locs += floor

	if(!length(spawn_locs))
		return FALSE
	var/turf/spawn_loc = pick(spawn_locs)
	faker = new(spawn_loc, list(hallucinator), src)
	var/sound/new_sound = sound('sound/effects/nightmare_reappear.ogg', repeat = 0, wait = 0, volume = 50)
	SEND_SOUND(hallucinator, new_sound)
	to_chat(hallucinator, span_boldwarning("[faker] emerges from the darkness!"))
	faker.AddComponent(/datum/component/leash, owner = hallucinator, distance = 1)
	addtimer(CALLBACK(src, PROC_REF(attack)), 1.5 SECONDS)
	return TRUE

/datum/hallucination/nightmare/proc/attack(atom/target)
	var/obj/item/light_eater/eater = new()
	faker.do_attack_animation(hallucinator, null, eater)
	hallucinator.create_splatter(get_dir(faker, hallucinator))
	hallucinator.Paralyze(2 SECONDS)
	to_chat(hallucinator, span_boldwarning("[faker] gores [hallucinator] with [eater], ripping into them!"))
	to_chat(hallucinator, span_boldwarning("[hallucinator]'s chest sprays chips of bone and develops a nasty looking bruise!"))
	var/sound/new_sound = sound('sound/effects/wounds/crackandbleed.ogg', repeat = 0, wait = 0, volume = 100)
	SEND_SOUND(hallucinator, new_sound)
	qdel(eater)
	addtimer(CALLBACK(src, PROC_REF(exit)), 1 SECONDS)

/datum/hallucination/nightmare/proc/exit()
	var/sound/new_sound = sound('sound/effects/nightmare_poof.ogg', repeat = 0, wait = 0, volume = 50)
	SEND_SOUND(hallucinator, new_sound)
	to_chat(hallucinator, span_boldwarning("[faker] melts into the shadows!"))
	QDEL_NULL(faker)
	qdel(src)

/obj/effect/client_image_holder/hallucination/nightmare
	gender = MALE
	image_icon = 'icons/mob/simple/simple_human.dmi'
	name = ""
	desc = ""
	image_state = ""

/obj/effect/client_image_holder/hallucination/nightmare/Initialize(mapload, list/mobs_which_see_us, datum/hallucination/parent)
	var/mob/living/hallucinator = parent.hallucinator
	if (ishuman(hallucinator))
		image_icon = getFlatIcon(get_dynamic_human_appearance(null, /datum/species/shadow/nightmare))
		name = pick(GLOB.nightmare_names)
		return ..()

	image_icon = hallucinator.icon
	image_state = hallucinator.icon_state
	image_pixel_x = hallucinator.pixel_x
	image_pixel_y = hallucinator.pixel_y
	return ..()
