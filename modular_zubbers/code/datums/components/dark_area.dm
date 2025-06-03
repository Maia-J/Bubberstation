/datum/component/dark_area
	/// How many more times will we pick a new victim to target with our effect
	var/remaining_charges = 3

/datum/component/dark_area/Initialize(charges = 3)
	if(!isarea(parent))
		return COMPONENT_INCOMPATIBLE
	remaining_charges = charges

/datum/component/dark_area/RegisterWithParent()
	RegisterSignal(parent, COMSIG_AREA_ENTERED, PROC_REF(get_victim))

/datum/component/dark_area/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_AREA_ENTERED)

/datum/component/dark_area/proc/apply_effect_to_victim(mob/living/carbon/human/victim)
	if(prob(5)) // Just a small chance we can actually tell something is wrong
		to_chat(victim, span_warning("A shiver runs down your spine..."))
	var/delay = rand(2,5) SECONDS
	if(prob(75))
		addtimer(CALLBACK(src, PROC_REF(blindness_pulse), victim), delay)
	else
		addtimer(CALLBACK(src, PROC_REF(nightmare_attack), victim), delay)

/datum/component/dark_area/proc/blindness_pulse(mob/living/carbon/human/victim)
	if(isnull(victim))
		return
	victim.adjust_temp_blindness(10 SECONDS) // About 3 secs less than the sound effect we play
	var/sound/new_sound = sound('sound/music/antag/bloodcult/ghost_whisper.ogg', repeat = 0, wait = 0, volume = 100)
	SEND_SOUND(victim, new_sound)
	lower_charge()

/datum/component/dark_area/proc/nightmare_attack(mob/living/carbon/human/victim)
	if(isnull(victim))
		return
	victim.cause_hallucination(/datum/hallucination/nightmare, "Dark area component")
	lower_charge()

/datum/component/dark_area/proc/get_victim(datum/source, mob/living/carbon/human/enterer)
	if(!istype(enterer))
		return
	if(isnull(enterer.client) || enterer.stat >= UNCONSCIOUS)
		return
	if(remaining_charges > 0 && prob(20))
		apply_effect_to_victim(enterer)

/datum/component/dark_area/proc/lower_charge()
	if(--remaining_charges <= 0)
		qdel(src)
