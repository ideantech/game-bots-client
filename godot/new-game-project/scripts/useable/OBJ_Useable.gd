class_name OBJ_Useable
extends Node2D


@export_group("Activation")
@export var target_user: bool = false
@export var target: Node = null
@export_file_path('*.tscn', '*.gd') var activate_ability: String
@export_file_path('*.tscn', '*.gd') var deactivate_ability: String

@export_group('Configuration')
@export var tooltip_location: Node2D
@export var detector: Area2D
@export var tooltip_text: String = ''
## Should the useable activate based on an entity entering the proximity area
@export var activate_on_proximity: bool = true
## Should the useable activate once and then no longer be activateable. Also disables deactivation
@export var activate_once: bool = false
## Should the useable activate once for each entity that enters the proximity area
@export var activate_for_each: bool = false
## Is the useable a toggle switch and switches between activate and deactivate
@export var is_toggle: bool = false


var _tooltip: UI_Tooltip = null
var _activated: bool = false
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	if detector:
		detector.body_entered.connect(_on_area_2d_body_entered)
		detector.body_exited.connect(_on_area_2d_body_exited)
		detector.area_entered.connect(_on_area_2d_body_entered)
		detector.area_exited.connect(_on_area_2d_body_exited)
	
	await get_tree().create_timer(0.1).timeout
	refresh_indication()
	
	SCR_Structure.connect_to_property_update(target, on_target_property_change)
	
func on_target_property_change(node: Node, name: String, v: Variant):
	if name == 'useable':
		refresh_indication()

func refresh_indication():
	if not SCR_Structure.has_structure(target): return
	if _animation_player == null: return
	
	var str: SCR_Structure = target.structure

	if str.is_useable_on():
		_animation_player.play('activated')
		_activated = true
	elif str.is_useable_off():
		print('deactivated')
		_animation_player.play('deactivated')
		_activated = false
	elif str.is_useable_disabled():
		print('disabled')
		_animation_player.play('disabled')
		_activated = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	var count = detector.get_overlapping_bodies().size()
	
	if body is Area2D:
		body = body.get_parent()
	
	# handle activation based on proximity
	if activate_on_proximity:
		if activate_once and _activated:
			return
		if not activate_for_each and count > 1:
			return

		#_activated = true
		activate(body)
		return
		
	# not activated on proximity, so display the tooltip
	if count == 0 and _tooltip == null:
		var cls = load("res://prefabs/ui/tooltip/UI_Tooltip.tscn")
		_tooltip = cls.instantiate()
		_tooltip.text = tooltip_text
		tooltip_location.add_child(_tooltip)

func _on_area_2d_body_exited(body: Node2D) -> void:
	var count = detector.get_overlapping_bodies().size()
	
	if body is Area2D:
		body = body.get_parent()
		
	if activate_on_proximity:
		if activate_once:
			return
		if not activate_for_each and count > 0:
			return
			
		#_activated = false
		deactivate(body)
		return
	
	# not deactivated on proximity, so remove the tooltip
	if count == 0 and _tooltip != null:
		_tooltip.queue_free()
		_tooltip = null

func try_run_ability(file: String, used_by: Node2D) -> Ability:
	var inst = null
	
	if file.ends_with('.gd'):
		var cls = load(file)
		inst = cls.new()

	elif file.ends_with('.tscn'):
		var pkg = load(file)
		inst = pkg.instantiate()

	if inst != null:
		inst.user = used_by
		inst.target = target
		used_by.add_child(inst)

	return inst

func activate(used_by: Node2D):
	try_run_ability(activate_ability, used_by)
	
func deactivate(used_by: Node2D):
	try_run_ability(deactivate_ability, used_by)
	
func use(used_by: Node2D):
	if not SCR_Structure.has_structure(target): 
		push_error('error: target is not a structure')
		return
	
	if (target.structure as SCR_Structure).is_useable_disabled():
		return
	
	if activate_once and _activated:
		return
	
	if is_toggle:
		if not _activated:
			activate(used_by)
		else:
			deactivate(used_by)
	else:
		activate(used_by)
		
