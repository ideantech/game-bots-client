extends Node

func _ready():
	var tween = get_tree().create_tween()
	
	tween.set_loops()
	tween.tween_property(self, 'modulate:a', 0.1, 0.5)
	tween.chain().tween_property(self, 'modulate:a', 1.0, 0.5)
