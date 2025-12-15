class_name LightingBlocker
extends Node2D


static var TRANSITION_TIME: float = 0.5


func _ready():
	modulate.a = 1.0
	visible = true

func show_blocker():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', 1.0, TRANSITION_TIME)
	
func hide_blocker():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', 0.0, TRANSITION_TIME)
