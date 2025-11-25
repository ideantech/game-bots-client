class_name PlayerController
extends Node


@export var movement: MovementNode

var priority_ability: Ability = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func process_movement():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if priority_ability == null:
		process_movement()
		return
	
	if Input.is_action_just_pressed('ui_accept') and priority_ability == null:
		priority_ability = Ability.new()
		add_child(priority_ability)
		
		priority_ability.finished.connect(func():
			priority_ability = null
		)
		
		priority_ability.cancelled.connect(func():
			priority_ability = null
		)
