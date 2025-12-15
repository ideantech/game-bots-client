class_name PlayerMovementController
extends Node

@export_group("Configuration")
@export var body: CharacterBody2D
@export var movement: MovementNode
@export var data: DataNode
@export var animator: AnimatorNode

@export_group("Control")
@export var enabled: bool = true
@export var face_mouse: bool = false

var _weapon_raised: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled:
		return
	
	var raise = Input.is_action_pressed('ui_raise_weapon')
	if raise and not _weapon_raised:
		_weapon_raised = true
		var parent: IndexNode = get_parent()
		#parent.signals.emit('weapon-raised')
		parent.signals.weapon_raised.emit()
		
	elif not raise and _weapon_raised:
		_weapon_raised = false
		var parent: IndexNode = get_parent()
		#parent.signals.emit('weapon-lowered')
		parent.signals.weapon_lowered.emit()
	
	var x = 0
	var y = 0
	if Input.is_action_pressed('ui_left'): x -= 1.0
	if Input.is_action_pressed('ui_right'): x += 1.0
	if Input.is_action_pressed('ui_up'): y -= 1.0
	if Input.is_action_pressed('ui_down'): y += 1.0
	
	if not _weapon_raised:
		if Input.is_action_pressed('ui_shift'):
			movement.is_running = true
		else:
			movement.is_running = false
	else:
		movement.is_running = false
		
		if Input.is_action_just_pressed('ui_fire'):
			var parent: IndexNode = get_parent()
			#parent.signals.emit('weapon-fired')
			parent.signals.weapon_fired.emit()
	
	if not face_mouse:
		if x < 0:
			animator.is_facing_left = true
		elif x > 0:
			animator.is_facing_left = false
	else:
		pass
	
	movement.direction.x = x
	movement.direction.y = y
