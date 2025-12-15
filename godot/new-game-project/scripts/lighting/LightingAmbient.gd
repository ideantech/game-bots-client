class_name LightingAmbient
extends Node2D


static var DEFAULT_TRANSITION_TIME: float = 0.5
static var DEFAULT_AMBIENT_OFF: float = 0.92
static var DEFAULT_AMBIENT_ON: float = 0.4

@export var animation_player: AnimationPlayer


func _ready():
	modulate.a = DEFAULT_AMBIENT_OFF
	visible = true
	
func turn_on():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', DEFAULT_AMBIENT_ON, DEFAULT_TRANSITION_TIME)
	
func turn_off():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', DEFAULT_AMBIENT_OFF, DEFAULT_TRANSITION_TIME)
