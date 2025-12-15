class_name Vfx_Simple
extends Node2D

@export_group("Startup")
@export var auto_start_children: bool = true

@export_group("Finish")
@export var free_on_finished: bool = true


var _started_count := 0


func start_children():
	for child in get_children():
		if child is GPUParticles2D:
			(child as GPUParticles2D).restart()
			_started_count += 1
			
			if free_on_finished:
				(child as GPUParticles2D).finished.connect(_on_child_finished, CONNECT_ONE_SHOT)

func _on_child_finished():
	_started_count -= 1
	
	if _started_count == 0:
		print('freeing')
		queue_free()

func _ready():
	if auto_start_children:
		start_children()
	
	
