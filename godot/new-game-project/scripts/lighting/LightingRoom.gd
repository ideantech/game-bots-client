class_name LightingRoom
extends Node2D


static var SHOWN_OFF: int = 0x0
static var SHOWN_PRESENCE: int = 0x1
static var SHOWN_PORTAL: int = 0x2
static var SHOWN_FORCE: int = 0x4

@export var default_shown: bool = false
@export var default_on: bool = false
@export var disable_lighting: bool = false
@export var structure: SCR_Structure

var _shown: int = false

func _ready():
	UTL_Ship.register_structure(self)
	
	for child in get_children():
		if child is LightingAmbient:
			child.z_index = 199
		elif child is LightingBlocker:
			child.z_index = 3000
	
	if disable_lighting:
		for child in get_children():
			if child is LightingAmbient:
				child.visible = false
			if child is LightingBlocker:
				child.visible = false
		return
	
	await get_tree().create_timer(1.0).timeout
	
	if structure: structure.connect_to_power_property_update(on_power_property_update)
	
	refresh()

func is_lights_on():
	return structure.is_lights_on()

func set_lighting(on: bool):
	structure.set_lights_on_commanded(on)
	refresh()

func set_shown(flag: int, s: bool):
	if (s and _shown & flag != 0) or (not s and _shown & flag == 0): return
	var prev := _shown
	
	if s:
		_shown |= flag
	else:
		_shown &= ~flag
	
	if (prev == 0 and _shown == 0): return
	if (prev > 0 and _shown > 0): return
	
	for child in get_children():
		if not child is LightingBlocker: continue
		
		if _shown > 0:
			(child as LightingBlocker).hide_blocker()
		elif _shown == 0:
			(child as LightingBlocker).show_blocker()

func turn_on():
	structure.set_lights_on(true)
	
	for child in get_children():
		if child is LightingAmbient:
			child.turn_on()
			
func turn_off():
	structure.set_lights_on(false)
	
	for child in get_children():
		if child is LightingAmbient:
			child.turn_off()

func brown_out():
	structure.set_lights_on(false)
	
	for child in get_children():
		if not child is LightingAmbient:
			continue
			
		child.brown_out()

func on_power_property_update(node: Node, name: String, v: Variant):
	if name != 'power-state': return
	
	refresh()
	
func refresh():
	if structure == null: return
	
	var power := structure.get_power_distribution()
	if structure.is_lights_on_commanded() and structure.has_power():
		structure.set_useable_on()
		if not structure.is_lights_on():
			turn_on()
	
	elif power.structure.power_is_brownout():
		structure.set_useable_on()
		if structure.is_lights_on():
			brown_out()
	
	elif not structure.has_power():
		structure.set_useable_disabled()
		if structure.is_lights_on():
			turn_off()
	
	elif not structure.is_lights_on_commanded():
		structure.set_lights_on(false)
		structure.set_useable_off()
		turn_off()

#region console handling

func on_command(console: UI_Console, command: Array) -> int:
	if command[0] == 'turn-off':
		structure.set_lights_on_commanded(false)
		refresh()
	elif command[0] == 'turn-on':
		structure.set_lights_on_commanded(true)
		refresh()
		
	return OK

#endregion
