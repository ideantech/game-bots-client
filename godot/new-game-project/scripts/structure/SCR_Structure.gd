@tool
class_name SCR_Structure
extends Resource

enum STRUCTURE_TYPE {
	ROOM = 0,
	NETWORK = 1,
	POWER_DISTRIBUTION = 2,
	CONSOLE = 3,
	DOOR = 4
}

enum UseableState {
	ON,
	OFF,
	DISABLED,
	NA
}

signal property_updated(node: Node, name: String, v: Variant)

@export var structure_name: String = ''
@export var structure_type: STRUCTURE_TYPE = STRUCTURE_TYPE.ROOM
@export var structure_properties: Dictionary = {}

@export_tool_button('Add Properties') var default_properties_action := add_default_properties

#region editor support

func ensure_property(name: String, v: Variant):
	if not structure_properties.has(name):
		structure_properties.set(name, v)

func add_default_properties():
	if structure_type == STRUCTURE_TYPE.ROOM:
		ensure_property('network', '')
		ensure_property('power-distribution', '')
		ensure_property('lights-on-commanded', true)
		ensure_property('lights-on', true)
		
	elif structure_type == STRUCTURE_TYPE.DOOR:
		ensure_property('network', '')
		ensure_property('power-distribution', '')
		ensure_property('on-power-loss', 'open')
		
	elif structure_type == STRUCTURE_TYPE.NETWORK:
		ensure_property('power-distribution', '')
	
	elif structure_type == STRUCTURE_TYPE.POWER_DISTRIBUTION:
		ensure_property('network', '')
		ensure_property('power-state', 'on')
	
	notify_property_list_changed()
	
var structure_object: Node2D = null

#endregion

#region static methods

static func connect_to_property_update(target: Node, callable: Callable) -> bool:
	if has_structure(target):
		(target.structure as SCR_Structure).property_updated.connect(callable)
	return false

static func has_structure(target: Node) -> bool:
	if target != null and 'structure' in target and target.structure != null and target.structure is SCR_Structure:
		return true
	return false

#endregion

#region base property management

func set_property_no_signal(name: String, v: Variant):
	structure_properties.set(name, v)

func set_property(name: String, v: Variant):
	if not structure_properties.has(name) or \
		structure_properties[name] != v:
		structure_properties.set(name, v)
		property_updated.emit(structure_object, name, v)
		
func get_property(name: String, def: Variant) -> Variant:
	if not structure_properties.has(name): return def
	return structure_properties.get(name)

#endregion

#region door properties

func door_is_open_on_power_loss() -> bool:
	return get_property('on-power-loss', '') == 'open'

func door_is_close_on_power_loss() -> bool:
	return get_property('on-power-loss', '') == 'closed'


#endregion

#region power properties

func power_check_for_console() -> int:
	return OK if has_power() else FAILED

func power_distribution_get_name() -> String:
	return get_property('power-distribution', '')

func connect_to_power_property_update(callable: Callable) -> bool:
	var power := get_power_distribution()
	if power != null:
		power.structure.property_updated.connect(callable)
		return true
	return false

func get_power_distribution() -> OBJ_PowerDistribution:
	var name: String = get_property('power-distribution', '')
	if not name.is_empty():
		return UTL_Ship.get_power_distribution(structure_object.get_tree(), name)
	return null

func has_power() -> bool:
	var pd := get_power_distribution()
	if pd != null and pd.structure.power_is_on():
		return true
	return false

func power_is_on() -> bool:
	return get_property('power-state', '') == 'on'
	
func power_is_off() -> bool:
	return get_property('power-state', '') == 'off'
	
func power_is_brownout() -> bool:
	return get_property('power-state', '') == 'brownout'

func power_set_on(): set_property('power-state', 'on')

func power_set_off(): set_property('power-state', 'off')

func power_set_brownout(): set_property('power-state', 'brownout')

#endregion

#region network properties

func network_get_name() -> String:
	return get_property('network', '')

func get_network() -> OBJ_Network:
	var name: String = get_property('network', '')
	if not name.is_empty():
		return UTL_Ship.get_network(structure_object.get_tree(), name)
	return null

func has_network() -> bool:
	var network := get_network()
	if network != null and network.structure.has_power():
		return true
	return false

#endregion

#region useable properties

func is_useable_on() -> bool: return get_property('useable', UseableState.OFF) == UseableState.ON

func is_useable_off() -> bool: return get_property('useable', UseableState.ON) == UseableState.OFF

func is_useable_disabled() -> bool: return get_property('useable', UseableState.OFF) == UseableState.DISABLED

func set_useable_on(): set_property('useable', UseableState.ON)

func set_useable_off(): set_property('useable', UseableState.OFF)

func set_useable_disabled(): set_property('useable', UseableState.DISABLED)

#endregion

#region room properties

func is_lights_on() -> bool:
	return get_property('lights-on', false)
	
func is_lights_on_commanded() -> bool:
	return get_property('lights-on-commanded', false)

func set_lights_on(v: bool):
	set_property('lights-on', v)

func set_lights_on_commanded(v: bool):
	set_property('lights-on-commanded', v)

#endregion
