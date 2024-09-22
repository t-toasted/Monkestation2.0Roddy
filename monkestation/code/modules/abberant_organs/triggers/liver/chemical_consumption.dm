/datum/organ_trigger/chemical_consume
	name = "Chemical Consumption Trigger"
	desc = "Triggers when a specific chemical is consumed"

	trigger_flags = ORGAN_LIVER
	var/datum/reagent/consumed_chemical

/datum/organ_trigger/chemical_consume/New(atom/parent)
	. = ..()
	consumed_chemical = /datum/reagent/water

/datum/organ_trigger/chemical_consume/set_host(atom/parent, atom/movable/incoming)
	. = ..()
	if(!incoming.reagents)
		return
	RegisterSignal(incoming.reagents, COMSIG_DRANK_REAGENT, PROC_REF(check_trigger))

/datum/organ_trigger/chemical_consume/remove_host()
	var/mob/living/resolved = host.resolve()
	if(resolved?.reagents)
		UnregisterSignal(resolved.reagents, COMSIG_REAGENTS_ADD_REAGENT)
	. = ..()

/datum/organ_trigger/chemical_consume/proc/check_trigger(datum/source, datum/reagents/reagent, amount)
	for(var/datum/reagent/listed as anything in reagent.reagent_list)
		if(listed.type == consumed_chemical)
			trigger(amount / length(reagent.reagent_list), list("reagent" = consumed_chemical))
