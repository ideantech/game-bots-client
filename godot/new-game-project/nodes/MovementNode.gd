class_name MovementNode
extends Node


@export var character_body: CharacterBody2D
@export var data: DataNode
@export var direction: Vector2
@export var animator: AnimatorNode

@export_group("Control")
@export var is_running: bool = false

var _attr_walk_speed: Attribute
var _attr_run_speed: Attribute


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await data.ready
	_attr_walk_speed = data.data.find_attribute(DataNode.ATTR_WALK_SPEED)
	_attr_run_speed = data.data.find_attribute(DataNode.ATTR_RUN_SPEED)


func _physics_process(delta: float) -> void:
	if direction.length_squared() > 0:
		
		if not is_running:
			character_body.velocity = direction * _attr_walk_speed.value
			animator.is_walking = true
			animator.is_running = false
		else:
			character_body.velocity = direction * _attr_run_speed.value
			animator.is_walking = false
			animator.is_running = true
			
		character_body.move_and_slide()
	else:
		animator.is_walking = false
		animator.is_running = false
	pass
	
