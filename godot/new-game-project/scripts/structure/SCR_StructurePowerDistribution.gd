class_name SCR_StructurePowerDistribution
extends SCR_Structure

enum PowerState {
	POWER_ON = 0,
	BROWN_OUT = 1,
	POWER_OFF = 2
}

@export var network: String = ''
@export var power_state: PowerState

func get_network() -> OBJ_Network:
	return UTL_Ship.get_network(structure_object.get_tree(), network)

func is_on() -> bool:
	return power_state == PowerState.POWER_ON
	
func is_off() -> bool:
	return power_state == PowerState.POWER_OFF
	
func is_brownout() -> bool:
	return power_state == PowerState.BROWN_OUT
