class_name LightingNode
extends Node2D

enum LightingType {
	RoomBlocker,
	Ambient,
	Light,
	Indicator,
	None,
	Detector
}

enum TransitionStyle {
	Standard,
	Instant,
	Flicker
}

static var INDICATOR_Z_INDEX: int = 1
static var AMBIENT_Z_INDEX: int = 2
static var LIGHT_Z_INDEX: int = 3
static var ROOM_BLOCKER_Z_INDEX: int = 4

static var DEFAULT_AMBIENT_OFF = 0.9
static var DEFAULT_AMBIENT_ON = 0.3
static var DEFAULT_TRANSITION_TIME = 0.5


@export var lighting_type: LightingType = LightingType.None
@export_group("Lighting")
@export var override_ambient_off: float = -1.0
@export var override_ambient_on: float = -1.0
@export var override_ambient_transition: float = -1.0
@export var transition_on_style: TransitionStyle = TransitionStyle.Standard
@export var transition_off_style: TransitionStyle = TransitionStyle.Standard


func _ready():
	if lighting_type == LightingType.RoomBlocker:
		z_as_relative = false
		z_index = ROOM_BLOCKER_Z_INDEX
		visible = true
	elif lighting_type == LightingType.Ambient:
		z_as_relative = false
		z_index = AMBIENT_Z_INDEX
		visible = true
	elif lighting_type == LightingType.Light:
		z_as_relative = false
		z_index = LIGHT_Z_INDEX
	elif lighting_type == LightingType.Indicator:
		z_as_relative = false
		z_index = INDICATOR_Z_INDEX
		
func turn_on_lighting():
	if lighting_type != LightingType.Ambient: return
	
	if transition_on_style == TransitionStyle.Standard:
		var tween := get_tree().create_tween()
		tween.tween_property(self, 'modulate:a', DEFAULT_AMBIENT_ON, DEFAULT_TRANSITION_TIME)
	elif transition_on_style == TransitionStyle.Instant:
		modulate.a = DEFAULT_AMBIENT_ON
	elif transition_on_style == TransitionStyle.Flicker:
		pass
	
func turn_off_lighting():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', DEFAULT_AMBIENT_OFF, DEFAULT_TRANSITION_TIME)
	pass
	
func hide_lighting():
	pass
	
func show_lighting():
	if lighting_type == LightingType.RoomBlocker:
		if transition_on_style == TransitionStyle.Standard:
			var tween := get_tree().create_tween()
			tween.tween_property(self, 'modulate:a', 0.0, 0.1)
		else:
			modulate.a = 0.0
	
