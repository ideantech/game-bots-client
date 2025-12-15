class_name LightingDetector
extends Area2D


@export var enabled: bool = true


func _ready():
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
func _body_entered(body: Node2D):
	(get_parent() as LightingRoom).set_shown(LightingRoom.SHOWN_PRESENCE, true)
	
func _body_exited(body: Node2D):
	var count := get_overlapping_bodies().size() + get_overlapping_areas().size()
	if count > 0: return
	
	var room := (get_parent() as LightingRoom)
	room.set_shown(LightingRoom.SHOWN_PRESENCE, false)
	
