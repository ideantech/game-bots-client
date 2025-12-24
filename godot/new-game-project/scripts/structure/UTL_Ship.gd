class_name UTL_Ship
extends Node


static var GROUP_POWER_DISTRIBUTION: String = 'group-power-distribution'
static var GROUP_NETWORKS: String = 'group-networks'
static var GROUP_ROOMS: String = 'group-rooms'

static var NETWORK_MEMBER: String = 'network-member-'
static var POWER_DISTRIBUTION_MEMBER: String = 'power-distribution-member-'

static var NETWORK_INSTANCE: String = 'network-'
static var ROOM_INSTANCE: String = 'room-'
static var POWER_DISTRIBUTION_INSTANCE: String = 'power-distribution-'

#region registration

static func register_structure(obj: Node):
	if not 'structure' in obj:
		return
		
	var str: SCR_Structure = obj.structure
	
	if str == null:
		return
	
	str.structure_object = obj
	
	if str.structure_type == SCR_Structure.STRUCTURE_TYPE.ROOM:
		obj.add_to_group(GROUP_ROOMS)
		obj.add_to_group(NETWORK_MEMBER + str.network_get_name())
		obj.add_to_group(ROOM_INSTANCE + str.structure_name)
		obj.add_to_group(POWER_DISTRIBUTION_MEMBER + str.power_distribution_get_name())
	
	elif str.structure_type == SCR_Structure.STRUCTURE_TYPE.NETWORK:
		obj.add_to_group(GROUP_NETWORKS)
		obj.add_to_group(NETWORK_INSTANCE + str.structure_name)
		obj.add_to_group(POWER_DISTRIBUTION_MEMBER + str.power_distribution_get_name())

	elif str.structure_type == SCR_Structure.STRUCTURE_TYPE.POWER_DISTRIBUTION:
		obj.add_to_group(GROUP_POWER_DISTRIBUTION)
		obj.add_to_group(NETWORK_MEMBER + str.network_get_name())
		obj.add_to_group(POWER_DISTRIBUTION_INSTANCE + str.structure_name)

#endregion

#region enumeration

static func get_all_rooms(t: SceneTree) -> Array:
	return t.get_nodes_in_group(GROUP_ROOMS)

static func get_all_networks(t: SceneTree) -> Array:
	return t.get_nodes_in_group(GROUP_NETWORKS)
	
static func get_all_network_names(t: SceneTree, have_power: bool = true) -> Array:
	var res: Array = []
	for node in get_all_networks(t):
		if not have_power or (have_power and node.structure.has_power()):
			res.push_back(node.structure.structure_name)
	return res

static func get_all_power_distribution(t: SceneTree) -> Array:
	return t.get_nodes_in_group(GROUP_POWER_DISTRIBUTION)

static func get_objects_in_network(n: OBJ_Network):
	return n.get_tree().get_nodes_in_group(NETWORK_MEMBER + n.structure.structure_name)

static func get_objects_in_power_distribution(p: OBJ_PowerDistribution):
	return p.get_tree().get_nodes_in_group(POWER_DISTRIBUTION_MEMBER + p.structure.structure_name)

static func get_names_in_network(n: OBJ_Network) -> Array:
	var nodes = UTL_Ship.get_objects_in_network(n)
	var res: Array = []
	for node in nodes:
		res.push_back(node.structure.structure_name)
	return res

static func get_names_in_power_distribution(p: OBJ_PowerDistribution) -> Array:
	var nodes = UTL_Ship.get_objects_in_power_distribution(p)
	var res: Array = []
	for node in nodes:
		res.push_back(node.structure.structure_name)
	return res

#endregion

#region search

static func get_network(t: SceneTree, name: String) -> OBJ_Network:
	return t.get_first_node_in_group(NETWORK_INSTANCE + name)
	
static func get_room(t: SceneTree, name: String) -> LightingRoom:
	return t.get_first_node_in_group(ROOM_INSTANCE + name)
	
static func get_power_distribution(t: SceneTree, name: String) -> OBJ_PowerDistribution:
	return t.get_first_node_in_group(POWER_DISTRIBUTION_INSTANCE + name)

static func get_object_in_network(n: OBJ_Network, name: String) -> Node2D:
	var nodes = UTL_Ship.get_objects_in_network(n)
	for node in nodes:
		if node.structure.structure_name == name:
			return node
	return null

static func get_object_in_power_distribution(p: OBJ_PowerDistribution, name: String) -> Node2D:
	var nodes = UTL_Ship.get_objects_in_power_distribution(p)
	for node in nodes:
		if node.structure.structure_name == name:
			return node
	return null

#endregion
