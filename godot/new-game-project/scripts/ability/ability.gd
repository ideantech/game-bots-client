class_name Ability
extends Node


@export var user: Node2D
@export var target: Node2D
@export var direction: Vector2

signal finished()
signal cancelled()


@export var auto_finish: bool = true
@export var auto_start: bool = true

var is_cancelled: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if auto_start:
		start()

func cancel():
	is_cancelled = true
	cancelled.emit()
	queue_free()
	on_dispose()

func start():
	on_start()
	await run()
	if auto_finish and not is_cancelled:
		finished.emit()
		queue_free()
	
func on_start():
	pass
	
func on_dispose():
	pass
	
func run():
	print('Ability:run(T)')
	await get_tree().create_timer(1.0).timeout
	print('Ability:run(B)')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
