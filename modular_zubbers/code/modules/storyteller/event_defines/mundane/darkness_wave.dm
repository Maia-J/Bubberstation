/datum/round_event_control/darkness_wave
	name = "Maintenance Darkness Wave"
	typepath = /datum/round_event/darkness_wave
	weight = 5
	max_occurrences = 2
	min_players = 1
	description = "A random maintenance area gets hit by a wave of malevolent dark energy, causing certain events around those who enter."

/datum/round_event/darkness_wave
	announce_chance = 0
	fakeable = FALSE

/datum/round_event/darkness_wave/start()
	var/area/station/maintenance/target_area = get_random_maintenance_area()
	target_area.AddComponent(/datum/component/dark_area)
