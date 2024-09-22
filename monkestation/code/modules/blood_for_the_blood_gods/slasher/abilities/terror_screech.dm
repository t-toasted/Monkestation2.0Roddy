/datum/action/cooldown/slasher/terror
	name = "Screech of Terror"
	desc = "Inflict near paralyzing fear to those already scared of you."
	button_icon_state = "stagger_group"

	cooldown_time = 45 SECONDS


/datum/action/cooldown/slasher/terror/Activate(atom/target)
	. = ..()
	var/datum/antagonist/slasher/slasherdatum = owner.mind.has_antag_datum(/datum/antagonist/slasher)

	var/list/mobs = slasherdatum.return_feared_people(7, 50)

	playsound(owner, 'monkestation/sound/voice/terror.ogg', 100, falloff_exponent = 0, use_reverb = FALSE)
	for(var/mob/living/carbon/human/human in mobs)
		if(human == owner)
			continue
		human.overlay_fullscreen("terror", /atom/movable/screen/fullscreen/curse, 1)
		human.Shake(duration = 5 SECONDS)
		human.stamina.adjust(-60)
		human.emote("scream")
		human.SetParalyzed(1.5 SECONDS)
		var/fear_amount = (15 - get_dist(owner, human))
		slasherdatum.increase_fear(human, fear_amount)
		addtimer(CALLBACK(src, PROC_REF(remove_overlay), human), 5 SECONDS)

/datum/action/cooldown/slasher/terror/proc/remove_overlay(mob/living/carbon/human/remover)
	remover.clear_fullscreen("terror", 10)
