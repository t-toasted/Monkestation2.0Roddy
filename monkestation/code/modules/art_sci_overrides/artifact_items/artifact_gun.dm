/obj/item/ammo_casing/magic/artifact
	projectile_type = /obj/projectile/magic/artifact
	var/datum/artifact_effect/gun/stored_comp
/obj/item/ammo_casing/magic/artifact/ready_proj(atom/target, mob/living/user, quiet, zone_override = "", atom/fired_from)
	if(!loaded_projectile)
		return
	var/datum/component/artifact/component = fired_from.GetComponent(/datum/component/artifact)
	var/datum/artifact_effect/gun/gun
	if(!stored_comp)
		for(var/datum/artifact_effect/eff in component.artifact_effects)
			if(istype(eff,/datum/artifact_effect/gun))
				gun = eff
				stored_comp = gun
				break
	else
		gun = stored_comp
	if(!gun)
		return
	loaded_projectile.damage = gun.damage / pellets
	loaded_projectile.icon_state = gun.projectile_icon
	loaded_projectile.damage_type = gun.dam_type
	loaded_projectile.ricochets_max = gun.ricochets_max
	loaded_projectile.ricochet_chance = gun.ricochet_chance
	loaded_projectile.ricochet_auto_aim_range = gun.ricochet_auto_aim_range
	loaded_projectile.wound_bonus = gun.wound_bonus
	loaded_projectile.sharpness = gun.sharpness
	loaded_projectile.spread = gun.spread
	return ..()

/obj/projectile/magic/artifact
	name = "incomprehensible energy"
	antimagic_flags = null
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 0.9
	hitsound_wall = SFX_RICOCHET
	impact_effect_type = /obj/effect/temp_visual/impact_effect


/obj/item/gun/magic/artifact
	icon = 'icons/obj/artifacts.dmi'
	icon_state = "narnar-item-1"
	resistance_flags = LAVA_PROOF | ACID_PROOF | INDESTRUCTIBLE
	icon = 'icons/obj/artifacts.dmi'
	inhand_icon_state = "plasmashiv"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	ammo_type = /obj/item/ammo_casing/magic/artifact
	school = SCHOOL_UNSET
	max_charges = 8
	pinless = TRUE
	recharge_rate = 1
	antimagic_flags = null
	obj_flags = CAN_BE_HIT
	var/datum/component/artifact/assoc_comp = /datum/component/artifact

ARTIFACT_SETUP(/obj/item/gun/magic/artifact, SSobj, null, /datum/artifact_effect/gun, ARTIFACT_SIZE_SMALL)

/obj/item/gun/magic/artifact/attack_self(mob/user, modifiers)
	. = ..()
	to_chat(user,span_notice("You squeeze the [src] tightly."))
	on_artifact_touched(src,user,modifiers)

/obj/item/gun/magic/artifact/can_shoot()
	return assoc_comp.active

/obj/item/gun/magic/artifact/shoot_with_empty_chamber()
	return
