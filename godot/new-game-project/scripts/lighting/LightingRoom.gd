class_name LightingRoom
extends Node2D


static var SHOWN_OFF: int = 0x0
static var SHOWN_PRESENCE: int = 0x1
static var SHOWN_PORTAL: int = 0x2
static var SHOWN_FORCE: int = 0x4

@export var default_shown: bool = false
@export var default_on: bool = false
@export var disable_lighting: bool = false
@export var room_name: String = ''


var _shown: int = false
var _lights_on: bool = false


func _ready():
	if disable_lighting:
		for child in get_children():
			if child is LightingAmbient:
				child.visible = false
			if child is LightingBlocker:
				child.visible = false
		return
	
	await get_tree().create_timer(1.0).timeout
	
	if default_shown:
		set_shown(SHOWN_FORCE, true)
	
	if default_on:
		set_lighting(true)
		


func set_lighting(on: bool):
	if _lights_on == on: return
	
	_lights_on = on
	
	for child in get_children():
		if not child is LightingAmbient: continue
		
		if on:
			(child as LightingAmbient).turn_on()
		else:
			(child as LightingAmbient).turn_off()

func set_shown(flag: int, s: bool):
	if (s and _shown & flag != 0) or (not s and _shown & flag == 0): return
	var prev := _shown
	
	if s:
		_shown |= flag
	else:
		_shown &= ~flag
	
	if (prev == 0 and _shown == 0): return
	if (prev > 0 and _shown > 0): return
	
	for child in get_children():
		if not child is LightingBlocker: continue
		
		if _shown > 0:
			(child as LightingBlocker).hide_blocker()
		elif _shown == 0:
			(child as LightingBlocker).show_blocker()
