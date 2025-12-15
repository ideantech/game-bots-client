class_name RoomArea2D
extends Area2D

@onready var _ambient: Sprite2D = $Ambient
@onready var _shape: CollisionShape2D = $CollisionShape2D

static var LIGHT_ON: float = 0.9
static var LIGHT_OFF: float = 1.0

func _ready():
	_ambient.modulate.a = 1.0
	_ambient.visible = true
	
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	pass

func _body_entered(body: Node2D):
	print('entered')
	
	var tween := get_tree().create_tween()
	tween.tween_property(_ambient, 'modulate:a', LIGHT_ON, 0.5)
	
	pass
	
func _body_exited(body: Node2D):
	if get_overlapping_bodies().size() != 0:
		pass
		
	var tween := get_tree().create_tween()
	tween.tween_property(_ambient, 'modulate:a', LIGHT_OFF, 0.5)
	pass
