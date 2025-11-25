@tool
class_name AnimatorNode
extends Node2D


signal animation_event(e: String)


@export var uses_vertical_facing: bool = true
@export var uses_horizontal_facing: bool = true
@export_file('*.tscn') var animation_tree_scene: String
@export var animation_tree: AnimationTreeInterface
@export_file('*.tscn') var animation_player_scene: String
@export var animation_player: AnimationPlayerInterface

@export_group('Animation State')
@export var is_walking: bool = false
@export var is_running: bool = false
@export var is_damaged: bool = false
@export var is_facing_left: bool = false:
	get:
		return is_facing_left
	set(value):
		is_facing_left = value
		if animation_player != null:
			animation_player.facing_left = value
@export var is_facing_up: bool = false
@export_tool_button("Damaged", "Callable") var damaged_action = trigger_damaged


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
		
	if not animation_player_scene.is_empty() and animation_player == null:
		var packed: PackedScene = load(animation_player_scene)
		var inst: AnimationPlayerInterface = packed.instantiate()
		animation_player = inst
		
		add_child(inst)
		
	if not animation_tree_scene.is_empty() and animation_tree == null:
		var packed: PackedScene = load(animation_tree_scene)
		var inst: AnimationTreeInterface = packed.instantiate()
		
		add_child(inst)
		
		inst.advance_expression_base_node = inst.get_path_to(self)
		inst.anim_player = inst.get_path_to(animation_player.animation_player)

	animation_tree['parameters/Damaged/blend_position'] = -1.0
	animation_tree['parameters/Idle/blend_position'] = -1.0
	animation_tree["parameters/Movement/Run/blend_position"] = -1.0
	animation_tree["parameters/Movement/Walk/blend_position"] = -1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func emit_animation_event(s: String):
	if Engine.is_editor_hint():
		return
	animation_event.emit(s)

#region "Animation State"

func trigger_damaged():
	is_damaged = true
	if Engine.is_editor_hint():
		notify_property_list_changed()
	await get_tree().create_timer(0.05)
	is_damaged = false
	if Engine.is_editor_hint():
		notify_property_list_changed()

#endregion
	
