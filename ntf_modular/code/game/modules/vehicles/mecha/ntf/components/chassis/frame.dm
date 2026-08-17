#define STEP_SCREW
#define STEP_CROWBAR
#define STEP_WELD

/obj/item/mecha_parts/chassis/ntf
	name = "Mecha Chassis"
	icon_state = "backbone"

	var/is_ready = FALSE
	var/required_step = STEP_SCREW

	var/type_to_spawn = /obj/vehicle/sealed/mecha/ntf/exosuit

/obj/vehicle/sealed/mecha/ntf/exosuit
	name = "exosuit"
	desc = "An exosuit."
	icon = 'icons/mecha/mecha.dmi'
	icon_state = "backbone"
	obj_integrity = 200

#warn OK, so \
What'll happen here i guess is \
First you mount the body on the frame \
Then you do some steps and use some  tools \
Once that's done, the frame+body will turn into a real exosuit \
That inherits some of the body's names and stuff (spherical chassis > spherical exosuit) \
Once the body is mounted you can mount the other parts like arms, legs, head. \
You can also i guess get into a exosuit with just the body, why not..
