/datum/artifact_fault/warp
	name = "Warping Fault"
	trigger_chance = 12
	visible_message = "warps space sending everyone away."
	var/list/warp_areas = list()

	research_value = 250

	weight = ARTIFACT_UNCOMMON

/datum/artifact_fault/warp/on_trigger()
	if(!length(warp_areas))
		warp_areas = GLOB.the_station_areas
	var/turf/safe_turf = get_safe_random_station_turf(warp_areas)
	var/center_turf = get_turf(our_artifact.parent)

	if(!center_turf)
		CRASH("[src] had attempted to trigger, but failed to find the center turf!")

	for(var/mob/living/living in range(rand(3, 5), center_turf))
		living.forceMove(safe_turf)
		to_chat(living, span_warning("You feel woozy after being warped around."))
