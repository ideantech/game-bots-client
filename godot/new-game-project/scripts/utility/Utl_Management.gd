class_name Utl_Management
extends Node


static func find_room(t: SceneTree, name: String) -> LightingRoom:
	var nodes = t.get_nodes_in_group(Utl_Constants.GROUP_ROOMS)
	for node in nodes:
		var r := node as LightingRoom
		if r.room_name == name:
			return r
	return null
	
static func get_all_rooms(t: SceneTree) -> Array:
	return t.get_nodes_in_group(Utl_Constants.GROUP_ROOMS)
	
static func get_all_networks(t: SceneTree) -> Array:
	return t.get_nodes_in_group(Utl_Constants.GROUP_NETWORKS)
	
static func find_network(t: SceneTree, name: String) -> Node2D:
	return t.get_first_node_in_group(Utl_Constants.NETWORK_NAME(name))
		
static func find_console_object(t: SceneTree, group: String, name) -> Node:
	for node in t.get_nodes_in_group(group):
		if node.console_get_name(name):
			return node
	return null

static func find_console_objects(t: SceneTree, group: String) -> Array:
	return t.get_nodes_in_group(group)
