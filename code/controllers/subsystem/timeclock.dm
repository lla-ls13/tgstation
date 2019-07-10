SUBSYSTEM_DEF(timeclock)
	name = "Time Clock"
	wait = 600
	flags = SS_NO_TICK_CHECK

	var/time_limit
	var/overtime_limit

	var/shift_over = FALSE

/datum/controller/subsystem/timeclock/Initialize()
	time_limit = CONFIG_GET(number/round_time_limit)
	overtime_limit = CONFIG_GET(number/overtime_time_limit)
	if(!time_limit)
		can_fire = FALSE
	return ..()

/datum/controller/subsystem/timeclock/fire(resumed = FALSE)
	if(world.time - SSticker.round_start_time < time_limit)
		return
	if(!shift_over)
		conclude_shift()

/datum/controller/subsystem/timeclock/proc/conclude_shift()
	SSshuttle.emergencyNoRecall = TRUE
	SSshuttle.ShiftEndEvac("Crew, your shift is concluding soon! Please quickly complete unfinished projects and prepare for evacuation", overtime_limit)
	shift_over = TRUE
	//note to future me, check shuttle time coeficient