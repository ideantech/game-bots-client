class_name UI_Tooltip
extends Control


@export var text: String = ''
@export var delay: float = 0.0


@onready var _lblTooltip := %lblTooltip


func _ready():
	_lblTooltip.text = text
	if delay > 0.0:
		trigger_delay()

func trigger_delay():
	await get_tree().create_timer(delay).timeout
	queue_free()
