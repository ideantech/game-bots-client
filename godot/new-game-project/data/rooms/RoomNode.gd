class_name RoomNode
extends Node2D


@export var default_on: bool = false


func _ready():
	initialize_lighting()
	
	if default_on:
		turn_on_lighting()
		
func initialize_lighting():
	for child in get_children():
		print(child is LightingNode)

func turn_on_lighting():
	for child in get_children():
		if not child is LightingNode: continue
		
		var lighting := (child as LightingNode)
		lighting.show_lighting()
		lighting.turn_on_lighting()
