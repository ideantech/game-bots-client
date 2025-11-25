class_name AnimationPlayerInterface
extends Node2D

@export var animation_player: AnimationPlayer
@export var facing_node: Node2D

@export var facing_left: bool:
	get:
		return facing_left
	set(value):
		facing_left = value
		if facing_node != null:
			facing_node.scale.x = -1.0 if facing_left else 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
