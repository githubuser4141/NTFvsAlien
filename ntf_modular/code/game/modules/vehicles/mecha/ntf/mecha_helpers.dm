/obj/vehicle/sealed/mecha/ntf/use_power(amount)
	return use_engine_power(amount)

/obj/vehicle/sealed/mecha/ntf/has_charge(amount)
	return has_power(amount)

/obj/vehicle/sealed/mecha/ntf/get_charge()
	return has_charge()

/obj/vehicle/sealed/mecha/ntf/proc/use_engine_power(amount)
//	if(!istype(src, /obj/vehicle/sealed/mecha/ntf))
//		return TRUE
	if(!body?.engine)
		return FALSE
	if(!body.engine.is_running && power_status != IGNITION_AUX || !body.engine.is_functional)
		return FALSE
	visible_message("amount of power used: [amount] from src [src] and engine [body.engine]")
	return body.engine.use_power(amount)

/obj/vehicle/sealed/mecha/ntf/proc/has_power(amount)
	if(!isexosuit(src))
		return TRUE
	if(!body?.engine)
		return FALSE
	return body.engine.has_power(amount)

/obj/vehicle/sealed/mecha/ntf/proc/get_sensors()
	if(head?.is_functional && head?.sensors_profile && use_engine_power(head.power_usage))
		return head.sensors_profile
	if(body?.is_functional && body?.sensors_profile && use_engine_power(body.power_usage))
		return body.sensors_profile
	return GLOB.default_exo_sensors

/obj/vehicle/sealed/mecha/proc/check_power(power_status)
	if(!isexosuit(src))
		return TRUE
	if(isnull(power_status))
		power_status = src.power_status
	switch(power_status)
		if(IGNITION_OFF)
			turn_off_aux()
			return FALSE
		if(IGNITION_AUX, IGNITION_ENGINE)
			return power_status
		else
			return FALSE

/obj/vehicle/sealed/mecha/proc/turn_off_aux()
	if(mecha_flags & LIGHTS_ON)
		for(var/mob/mobee AS in occupant_actions)
			var/action = /datum/action/vehicle/sealed/mecha/mech_toggle_lights
			var/datum/action/vehicle/sealed/mecha/mech_toggle_lights/headlights = occupant_actions[mobee][action]
			if(!mobee)
				continue
			headlights.action_activate(NONE)
			break

	if(light_amplification)
		for(var/mob/mobee AS in occupant_actions)
			var/action = /datum/action/vehicle/sealed/mecha/light_amplification
			var/datum/action/vehicle/sealed/mecha/light_amplification/nvgs = occupant_actions[mobee][action]
			if(!mobee)
				continue
			nvgs.action_activate(NONE)
			break

/obj/vehicle/sealed/mecha/proc/force_lights_off(reason)
	if(!(mecha_flags & LIGHTS_ON))
		return
	mecha_flags &= ~LIGHTS_ON
	set_light_on(FALSE)
	playsound(src, 'sound/mecha/brass_skewer.ogg', 40, TRUE)
	log_message("Toggled lights off ([reason]).", LOG_MECHA)
	for(var/mob/mobee in occupant_actions)
		var/datum/action/vehicle/sealed/mecha/mech_toggle_lights/headlights = occupant_actions[mobee][/datum/action/vehicle/sealed/mecha/mech_toggle_lights]
		headlights?.sync_icon()

/datum/action/vehicle/sealed/mecha/mech_toggle_lights/proc/sync_icon()
	action_icon_state = (chassis.mecha_flags & LIGHTS_ON) ? "mech_lights_on" : "mech_lights_off"
	update_button_icon()
