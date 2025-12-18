class_name ABL_CloseDoor
extends Ability


func run():
	var door := target as LightingPortal
	
	door.try_close()
