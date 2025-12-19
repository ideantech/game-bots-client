class_name ABL_LightsOff
extends Ability

func run():
	var room: LightingRoom = target as LightingRoom
	
	room.set_lighting(false)
