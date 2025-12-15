class_name DataNode
extends Node


static var ATTR_WALK_SPEED: String = 'stats/misc/walkspeed'
static var ATTR_RUN_SPEED: String = 'stats/misc/runspeed'


@export var definition: DataRoot
var data: DataRoot
var signals := Utl_Signals.new()

func _ready() -> void:
	data = definition.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	data.signals = signals
	data.initialize_resource()
	print(data.get_attribute_value('stats/basic/level', 0))
	print(data.get_attribute_value('stats/basic/attack', 0))
	print(data.get_attribute_value('stats/misc/walkspeed', 0))
	print(data.get_attribute_value('stats/misc/runspeed', 0))
