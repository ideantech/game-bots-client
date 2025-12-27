class_name LightingPortal
extends Node2D

enum OverrideBoolean {
	NotApplicable,
	True,
	False
}

@export_group('Binding')
@export var room1: LightingRoom
@export var room2: LightingRoom
@export var detector: Area2D
@export var animation_player: AnimationPlayer
@export var structure: SCR_Structure

@export_group('Configuration')
@export var can_close: bool = true
@export var can_open: bool = true
@export var proximity_detection: bool = true

@export_group('Overrides')
@export var override_powered: OverrideBoolean = OverrideBoolean.NotApplicable
@export var override_opened: OverrideBoolean = OverrideBoolean.NotApplicable

#var useable: SCR_Useable = SCR_Useable.new()

var _is_open: bool = false
var _commanded_open: bool = false


func _ready():
	UTL_Ship.register_structure(self)

	configure_startup()
	structure.set_useable_off()
	
	await get_tree().create_timer(0.5).timeout
	structure.connect_to_power_property_update(property_updated)

func property_updated(node: Node, name: String, v: Variant):
	if name != 'power-state': return
	
	var pd := structure.get_power_distribution()
	if pd.structure.power_is_off():
		_commanded_open = _is_open
		if structure.door_is_open_on_power_loss():
			try_open()
		elif structure.door_is_close_on_power_loss():
			try_close()
		
		structure.set_useable_disabled()
		
	elif pd.structure.power_is_on() or pd.structure.power_is_brownout():
		if _commanded_open:
			structure.set_useable_on()
			try_open()
		else:
			structure.set_useable_off()
			try_close()
		pass

func try_open():
	if not can_open:
		return
	if not is_powered():
		return
	if _is_open:
		return
	if override_opened == OverrideBoolean.True:
		return
		
	if room1:
		room1.set_shown(LightingRoom.SHOWN_PORTAL, true)
	if room2:
		room2.set_shown(LightingRoom.SHOWN_PORTAL, true)
	
	if not _is_open and animation_player != null:
		animation_player.play('open')
		_is_open = true
			
	#useable.set_state(self, SCR_Useable.UseableState.ON)
	structure.set_useable_on()

func try_close():
	if not can_close:
		return
	if not is_powered():
		return
	if not _is_open:
		return
	if override_opened == OverrideBoolean.True:
		return
		
	var count = detector.get_overlapping_areas().size() + detector.get_overlapping_bodies().size()
	if count > 0: return
	
	if room1: room1.set_shown(LightingRoom.SHOWN_PORTAL, false)
	if room2: room2.set_shown(LightingRoom.SHOWN_PORTAL, false)
	
	if _is_open && animation_player != null:
		animation_player.play_backwards('open')
		_is_open = false
		
	structure.set_useable_off()

func is_powered() -> bool:
	if override_powered != OverrideBoolean.NotApplicable:
		return override_powered == OverrideBoolean.True
	return true

func is_open() -> bool:
	return _is_open

func configure_startup():
	
	if override_powered == OverrideBoolean.True:
		animation_player.play('powered')
	elif override_powered == OverrideBoolean.False:
		animation_player.play('unpowered')
	
	if  override_opened == OverrideBoolean.True:
		animation_player.play('open', -1, 1.0, true)
		_is_open = true
