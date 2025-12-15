extends Camera2D

@export var target: Node2D

func _process(delta):
	position = target.position
	
