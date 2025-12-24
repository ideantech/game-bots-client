class_name SCR_Useable
extends RefCounted

enum UseableState {
	ON,
	OFF,
	DISABLED,
	NA
}

signal state_updated(node: Node, state: UseableState)

var state: UseableState

static func connect_state_updated(node: Node, callable: Callable) -> bool:
	if node and 'useable' in node and node.useable != null and node.useable is SCR_Useable:
		node.useable.state_updated.connect(callable)
		return true
	return false

static func has_useable(node: Node) -> bool:
	if node and 'useable' in node and node.useable != null and node.useable is SCR_Useable:
		return true
	return false

func set_state(node: Node, s: UseableState):
	if s != state:
		state = s
		state_updated.emit(node, state)

func set_on(node: Node):
	set_state(node, UseableState.ON)

func set_off(node: Node):
	set_state(node, UseableState.OFF)

func set_disabled(node: Node):
	set_state(node, UseableState.DISABLED)

func is_on() -> bool:
	return state == UseableState.ON
	
func is_off() -> bool:
	return state == UseableState.OFF
	
func is_disabled() -> bool:
	return state == UseableState.DISABLED
