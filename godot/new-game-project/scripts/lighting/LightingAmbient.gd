class_name LightingAmbient
extends Node2D


static var DEFAULT_TRANSITION_TIME: float = 0.5
static var DEFAULT_AMBIENT_OFF: float = 0.92
static var DEFAULT_AMBIENT_ON: float = 0.4

@export var animation_player: AnimationPlayer


func _ready():
	modulate.a = DEFAULT_AMBIENT_OFF
	visible = true
	add_to_group(Utl_Constants.GROUP_AMBIENT_LIGHTS)
	
func turn_on():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', 0.0, 0.1)
	tween.chain().tween_property(self, 'modulate:a', 0.5, 0.1)
	tween.chain().tween_property(self, 'modulate:a', 0.0, 0.7)
	
func brown_out():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', 0.4, 0.5)
	tween.chain().tween_property(self, 'modulate:a', 0.3, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.4, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.3, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.4, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.3, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.4, 0.75)
	tween.chain().tween_property(self, 'modulate:a', 0.3, 0.25)
	tween.chain().tween_property(self, 'modulate:a', 1.0, 0.1)
	
func turn_off():
	var tween := get_tree().create_tween()
	tween.tween_property(self, 'modulate:a', DEFAULT_AMBIENT_OFF, DEFAULT_TRANSITION_TIME)
