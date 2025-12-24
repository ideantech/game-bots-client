class_name OBJ_Network
extends Node2D

@export var structure: SCR_Structure

func _ready():
	UTL_Ship.register_structure(self)

#region console interface

func on_command(console: UI_Console, parts: Array) -> int:
	if parts[0] == 'connection-request':
		return structure.power_check_for_console()

	elif parts[0] == 'scan':
		await console.simple_progress('scanning network')
		console.simple_list_names(UTL_Ship.get_names_in_network(self))

	elif parts[0] == 'connect' and parts.size() > 1:
		var node = UTL_Ship.get_object_in_network(self, parts[1])
		console.try_connection_request(node)
		
	else:
		console.add_output('network:error:unrecognized or invalid command')
		
	return FAILED

#endregion
