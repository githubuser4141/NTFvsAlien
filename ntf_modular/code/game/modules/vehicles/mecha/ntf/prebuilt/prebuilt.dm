/obj/vehicle/sealed/mecha/ntf/prebuilt/proc/attach_components()
	if(body)
		body.is_attached = TRUE
		body.chassis = src
	if(head)
		head.is_attached = TRUE
		head.chassis = src
	if(legs)
		legs.is_attached = TRUE
		legs.chassis = src
	if(arms)
		arms.is_attached = TRUE
		arms.chassis = src
