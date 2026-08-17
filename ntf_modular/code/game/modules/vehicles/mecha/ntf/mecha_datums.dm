GLOBAL_DATUM_INIT(default_exo_sensors, /datum/exo_sensors/none, new)

/datum/looping_sound/exosuit_engine_fuel/sound_loop
	start_sound = null
	start_length = 0
	mid_sounds = list('sound/mecha/engine/engine_running.ogg'=1)
	mid_length = 2.5 SECONDS // 2.5
	end_sound = null
	volume = 12

/datum/looping_sound/exosuit_engine_electric/sound_loop
	start_sound = null
	start_length = 0
	mid_sounds = list('sound/mecha/engine/engine_electric.ogg'=1)
	mid_length = 4 SECONDS // 4
	end_sound = null
	volume = 3

/datum/looping_sound/exosuit_engine_fuel_high/sound_loop
	start_sound = null
	start_length = 0
	mid_sounds = list('sound/mecha/engine/engine_high.ogg'=1)
	mid_length = 1.8 SECONDS // 1.8
	end_sound = null
	volume = 20

// Sensor profiles

/datum/exo_sensors
	var/accuracy_mod
	var/rof_mod
	var/damage_mod
	var/max_range_mod

/datum/exo_sensors/none
	accuracy_mod = 0.1 // variance - lower is better
	rof_mod = 0.1 // delay - lower is better
	damage_mod = 0.85
	max_range_mod = 0.8

/datum/exo_sensors/basic
	accuracy_mod = 1.1
	rof_mod = 1
	damage_mod = 0.9
	max_range_mod = 1.2

/datum/exo_sensors/adv
	accuracy_mod = 0.85
	rof_mod = 0.9
	damage_mod = 1.1
	max_range_mod = 1.35

/datum/exo_sensors/ultra
	accuracy_mod = 0.7
	rof_mod = 0.85
	damage_mod = 1.15
	max_range_mod = 1.5

// Armor for wrecked parts

/datum/wrecked_body
	var/soft_armor = list()

/datum/wrecked_body/light
	soft_armor = list(MELEE = 15, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 5)

/datum/wrecked_body/medium
	soft_armor = list(MELEE = 20, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 5, ACID = 10)

/datum/wrecked_body/heavy
	soft_armor = list(MELEE = 25, BULLET = 10, LASER = 5, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 10, ACID = 10)
