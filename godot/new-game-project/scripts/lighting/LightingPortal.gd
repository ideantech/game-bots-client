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

@export_group('Configuration')
@export var can_close: bool = true
@export var can_open: bool = true
@export var proximity_detection: bool = true

@export_group('Overrides')
@export var override_powered: OverrideBoolean = OverrideBoolean.NotApplicable
@export var override_opened: OverrideBoolean = OverrideBoolean.NotApplicable

var _is_open: bool = false

func _ready():
	if detector:
		detector.body_entered.connect(_body_entered)
		detector.body_exited.connect(_body_exited)

	configure_startup()

func _body_entered(body: Node2D):
	if not proximity_detection: return
	
	try_open()

func _body_exited(body: Node2D):
	if not proximity_detection: return
	
	try_close()

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
		#if not animation_player.is_playing():
			animation_player.play('open')
			_is_open = true

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
	
	room1.set_shown(LightingRoom.SHOWN_PORTAL, false)
	room2.set_shown(LightingRoom.SHOWN_PORTAL, false)
	
	if _is_open && animation_player != null:
		animation_player.play_backwards('open')
		_is_open = false

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
