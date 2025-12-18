class_name Utl_Management
extends Node


static func find_room(t: SceneTree, name: String) -> LightingRoom:
	var nodes = t.get_nodes_in_group(Utl_Constants.GROUP_ROOMS)
	for node in nodes:
		var r := node as LightingRoom
		if r.room_name == name:
			return r
	return null
	
static func find_network(t: SceneTree, name: String) -> Node2D:
	return t.get_first_node_in_group(Utl_Constants.NETWORK_NAME(name))
		
