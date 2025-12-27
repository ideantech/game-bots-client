class_name IndexNode
extends Node


@export var body: CharacterBody2D
@export var animator: AnimatorNode
@export var movement: MovementNode
@export var definition: DataRoot
@export var useable_user: SCR_UseableUser
@export var controller: Node

var data: DataRoot
@onready var signals: Utl_Signals = Utl_Signals.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

	# data management
	if definition != null:
		data = definition.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
		data.signals = signals
		data.initialize_resource()

	# testing for player
	var packed: PackedScene = load('res://scripts/ability/weapon-test/weapon_test.tscn')
	var inst = packed.instantiate()
	inst.user = self
	self.add_child(inst)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#region convenience wrappers

func get_attribute(name: String) -> Attribute:
	return data.find_attribute(name)
	
func get_attribute_value(name: String, def: Variant) -> Variant:
	return data.get_attribute_value(name, def)

#endregion
