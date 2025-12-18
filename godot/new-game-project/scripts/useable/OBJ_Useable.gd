class_name OBJ_Useable
extends Node2D

@export_group('Configuration')
@export var ability_config: RES_AbilityConfig
@export var deactivate_ability_config: RES_AbilityConfig
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

		_activated = true
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
			
		_activated = false
		deactivate(body)
		return
	
	# not deactivated on proximity, so remove the tooltip
	if count == 0 and _tooltip != null:
		_tooltip.queue_free()
		_tooltip = null

func activate(used_by: Node2D):
	_activated = true
	if ability_config == null:
		push_error('obj_useable: no ability configured at ' + str(get_path()))
		return
	
	if _animation_player != null:
		_animation_player.play('activated')
	ability_config.activate(used_by, self)
	
func deactivate(used_by: Node2D):
	_activated = false
	
	if deactivate_ability_config == null:
		push_error('obj_useable: no ability configured at ' + str(get_path()))
		return
		
	if _animation_player != null:
		_animation_player.play('deactivated')
	deactivate_ability_config.activate(used_by, self)
	pass

func use(used_by: Node2D):
	if is_toggle:
		if not _activated:
			activate(used_by)
		else:
			deactivate(used_by)
	else:
		activate(used_by)
		
