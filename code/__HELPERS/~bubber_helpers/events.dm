/proc/get_random_maintenance_area(on_station = TRUE)
	var/static/list/searched_areas = typecacheof(typesof(/area/station/maintenance))
	var/list/areas = list()
	for(var/area/iterating_area in GLOB.areas)
		if(on_station && !is_station_level(iterating_area.z))
			continue
		if(!is_type_in_typecache(iterating_area, searched_areas))
			continue
		areas += iterating_area
	return pick(areas)
