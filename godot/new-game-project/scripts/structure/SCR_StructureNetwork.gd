class_name SCR_StructureNetwork
extends SCR_Structure

@export var power_distribution: String = ''
@export var connections: Array[String]

func get_power_distribution() -> OBJ_PowerDistribution:
	return UTL_Ship.get_power_distribution(structure_object.get_tree(), power_distribution)

func has_power() -> bool:
	var pd = get_power_distribution()
	if pd and (pd.structure.is_on() or pd.structure.is_brownout()):
		return true
	
	return false
