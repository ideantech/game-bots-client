class_name OBJ_Network
extends Node2D


@export var network_name: String = ''


func _ready():
	add_to_group(Utl_Constants.GROUP_NETWORKS)
	add_to_group(Utl_Constants.NETWORK_NAME(network_name))

func console_get_name() -> String:
	return network_name

func on_command(console: UI_Console, parts: Array) -> int:
	if parts[0] == 'connection-request':
		return OK
	else:
		console.add_output('network:error:unrecognized or invalid command')
	return FAILED
