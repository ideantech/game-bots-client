class_name OBJ_PowerDistribution
extends Node2D


static var POWER_SHUTOFF: int = 0
static var POWER_ON: int = 1
static var POWER_BROWNOUT: int = 2

@export var structure: SCR_Structure


# Called when the node enters the scene tree for the first time.
func _ready():
	UTL_Ship.register_structure(self)

#region console handling

func on_command(console: UI_Console, command: Array) -> int:
	if command[0] == 'connection-request':
		return OK
		
	elif command[0] == 'shutdown':
		if not structure.power_is_off():
			structure.power_set_off()
		return OK
	
	elif command[0] == 'startup':
		if structure.power_is_off():
			structure.power_set_on()
		return OK
		
	elif command[0] == 'brownout':
		if structure.power_is_on():
			structure.power_set_brownout()
			turn_off(5.0)
		return OK
		
	console.add_output('error: unrecognized command')
	return FAILED

func turn_off(delay: float):
	await get_tree().create_timer(delay).timeout
	structure.power_set_off()
#endregion
