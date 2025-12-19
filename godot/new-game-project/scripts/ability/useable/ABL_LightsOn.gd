class_name ABL_LightsOn
extends Ability


func run():
	var room: LightingRoom = target as LightingRoom
	
	room.set_lighting(true)
