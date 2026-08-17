#define NEEDS_WELD 1
#define NEEDS_MATS 2

/obj/item/mecha_parts/mecha_pieces
	icon = 'icons/mecha/mecha_pieces.dmi'
	icon_state = "body"
	var/repair_materials = list(STEEL = PRIMARY_REPAIR_AMT)
	var/repair_state = NONE
	var/is_attached = FALSE
	var/is_functional = TRUE
	var/suitable_mech = /obj/vehicle/sealed/mecha/ntf
	var/type_of_piece = MECHA_BODY
//	integrity_failure = 0.5
	destroy_sound = 'sound/effects/glassbr2.ogg'
	var/obj/vehicle/sealed/mecha/ntf/chassis
	var/datum/exo_sensors/sensors_profile
	var/extra_overlays = FALSE
	var/list/inserted_materials

	var/power_usage = 0

	var/hardpoints = list(HARDPOINT_RIGHT_SHOULDER, HARDPOINT_LEFT_SHOULDER, HARDPOINT_HEAD, HARDPOINT_BACK)

	integrity_failure

/obj/item/mecha_parts/mecha_pieces/proc/set_failure()
	integrity_failure = (max_integrity / 2)

/obj/item/mecha_parts/mecha_pieces/Initialize(mapload)
	.=..()
	if(sensors_profile)
		sensors_profile = new sensors_profile()
	RegisterSignal(src, COMSIG_MECH_PART_DESTROYED, PROC_REF(break_component), src)
	RegisterSignal(src, COMSIG_MECH_PART_DISABLED, PROC_REF(set_broken_states), src)
	set_failure()

/obj/item/mecha_parts/mecha_pieces/proc/start_repair(mob/user)
	if(is_functional || inserted_materials)
		return FALSE
	inserted_materials = list()
	for(var/mat in repair_materials)
		inserted_materials[mat] = 0
	to_chat(user, "<span class='notice'>You begin preparing [src] for repair.</span>")
	return TRUE

/obj/item/mecha_parts/mecha_pieces/attackby(obj/item/stack/sheet/S, mob/user, params)
	if(!istype(S) || obj_integrity >= max_integrity)
		return ..()
	if(!inserted_materials)
		start_repair(user)
	if(!(S.parent_type in repair_materials))
		to_chat(user, "<span class='warning'>[S] isn't used to prepare [src].</span>")
		return

	var/need = repair_materials[S.parent_type] - inserted_materials[S.parent_type]
	if(need <= 0)
		to_chat(user, "<span class='notice'>[src] doesn't need any more [S.name].</span>")
		return

	var/amt = min(S.amount, need)
	S.use(amt)
	inserted_materials[S.parent_type] += amt
	to_chat(user, "<span class='notice'>You insert [amt] [S.name] into [src]. ([inserted_materials[S.parent_type]]/[repair_materials[S.parent_type]])</span>")

	for(var/mat in repair_materials)
		if(inserted_materials[mat] < repair_materials[mat])
			return
	to_chat(user, "<span class='notice'>You finish preparing [src] for repair.</span>")
	repair_state = NEEDS_WELD

	if(istype(S, /obj/item/tool/weldingtool))
		if(repair_state == NEEDS_WELD)
			welder_act()

/obj/item/mecha_parts/mecha_pieces/welder_act(mob/living/user, obj/item/I)
	..()
	. = TRUE
	if(repair_state == NEEDS_WELD)
		if(welder_repair_act())
			is_functional = TRUE
			obj_integrity = max_integrity
			inserted_materials = null
			update_icon()
			repair_state = initial(repair_state)

/obj/item/mecha_parts/mecha_pieces/proc/set_broken_states() // sets -broken description and icon, when obj_break
	SIGNAL_HANDLER
	if(!base_icon_state)
		base_icon_state = icon_state
	icon_state = "[base_icon_state]-broken"
	is_functional = FALSE
	repair_state = NEEDS_MATS
	update_icon()
	if(is_attached)
		chassis.update_icon()

/obj/item/mecha_parts/mecha_pieces/proc/break_component() // when integrity reaches zero
	SIGNAL_HANDLER
	if(type_of_piece == MECHA_BODY && is_attached && chassis)
		chassis.Destroy()
		return
	if(is_attached && chassis)
		is_attached = FALSE
		var/turf/dropzone = get_turf(src)
		forceMove(dropzone)
		throw_at(dropzone)
		visible_message(span_warning("[src] is violently sheared off of the [chassis]!"))
		switch(type_of_piece)
			if(MECHA_HEAD)
				chassis.head = null
			if(MECHA_BODY)
				chassis.body = null
			if(MECHA_ARMS)
				chassis.arms = null
			if(MECHA_LEGS)
				chassis.legs = null
		for(var/obj/item/mecha_parts/mecha_equipment/equipment as anything in chassis.flat_equipment)
			if(equipment.slot == type_of_piece)
				equipment.detach()
		chassis.update_icon()
		chassis = null

/obj/item/mecha_parts/mecha_pieces/obj_break(damage_flag)
	if(chassis && is_functional)
		SEND_SIGNAL(src, COMSIG_MECH_PART_DISABLED, chassis)
	else
		if(!chassis)
			set_broken_states()

/obj/item/mecha_parts/mecha_pieces/deconstruct(disassembled = TRUE, mob/living/blame_mob)
	if(is_functional)
		return
	SEND_SIGNAL(src, COMSIG_MECH_PART_DESTROYED, chassis)

/obj/item/mecha_parts/mecha_pieces/examine(mob/user)
	. = ..()
	if(!is_functional)
		. += span_warning("It looks broken!")

#undef NEEDS_WELD
#undef NEEDS_MATS
