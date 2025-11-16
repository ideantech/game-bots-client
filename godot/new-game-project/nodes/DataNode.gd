class_name DataNode
extends Node

@export var definition: DataRoot
var data: DataRoot

func _ready() -> void:
	data = definition.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	data.initialize_resource()
	print(data.attributes[0].value)
