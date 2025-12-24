class_name SCR_StructureRoom
extends SCR_Structure

@export var network: String
@export var power_distribution: String
@export var lights_on: bool = true

func get_network() -> OBJ_Network:
	return UTL_Ship.get_network(structure_object.get_tree(), network)
	
func get_power_distribution() -> OBJ_PowerDistribution:
	return UTL_Ship.get_power_distribution(structure_object.get_tree(), power_distribution)
