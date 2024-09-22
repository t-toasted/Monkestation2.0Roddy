/obj/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack communist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	panel_type = "panel6"
	light_mask = "sec-light-mask"
	req_access = list(ACCESS_SECURITY)
	products = list(
		/obj/item/restraints/handcuffs = 8,
		/obj/item/restraints/handcuffs/cable/zipties = 10,
		/obj/item/grenade/flashbang = 4,
		/obj/item/assembly/flash/handheld = 5,
		/obj/item/food/donut/plain = 12,
		/obj/item/storage/box/evidence = 6,
		/obj/item/flashlight/seclite = 4,
		/obj/item/restraints/legcuffs/bola/energy = 7,
		/obj/item/ammo_box/magazine/m35/rubber = 15, //monkestation edit: Paco sec
		/obj/item/clothing/mask/gas/sechailer = 6, ////monkestation edit
		/obj/item/bodycam_upgrade = 10, //monkestation edit: Security Liability Act
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/storage/fancy/donut_box = 2,
	)
	premium = list(
		/obj/item/storage/belt/security/webbing = 5,
		/obj/item/coin/antagtoken = 1,
		/obj/item/clothing/head/helmet/blueshirt = 1,
		/obj/item/clothing/suit/armor/vest/blueshirt = 1,
		/obj/item/clothing/gloves/tackler = 5,
		/obj/item/grenade/stingbang = 1,
		/obj/item/watertank/pepperspray = 2,
		/obj/item/storage/belt/holster/energy = 4,
		/obj/item/clothing/head/helmet/civilprotection_helmet = 1, //monkestation edit
		/obj/item/clothing/suit/armor/civilprotection_vest = 1, //monkestation edit
		/obj/item/clothing/head/helmet/guardmanhelmet = 1, //monkestation edit: Guardman
		/obj/item/clothing/under/guardmanuniform = 1, //monkestation edit: Guardman
		/obj/item/clothing/suit/armor/guardmanvest = 1, //monkestation edit: Guardman
		/obj/item/citationinator = 3 // monkestation edit: security assistants
	)
	refill_canister = /obj/item/vending_refill/security
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_SEC

/obj/machinery/vending/security/pre_throw(obj/item/I)
	if(isgrenade(I))
		var/obj/item/grenade/G = I
		G.arm_grenade()
	else if(istype(I, /obj/item/flashlight))
		var/obj/item/flashlight/F = I
		F.on = TRUE
		F.update_brightness()

/obj/item/vending_refill/security
	icon_state = "refill_sec"
