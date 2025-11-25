class_name IndexNode
extends Node


@export var body: CharacterBody2D
@export var data: DataNode
@export var animator: AnimatorNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

	var packed: PackedScene = load('res://scripts/ability/weapon-test/weapon_test.tscn')
	var inst = packed.instantiate()
	inst.user = self
	self.add_child(inst)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
