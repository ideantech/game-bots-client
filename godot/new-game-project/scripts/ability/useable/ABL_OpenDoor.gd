class_name ABL_OpenDoor
extends Ability


func run():
	var door := target as LightingPortal
	
	door.try_open()
