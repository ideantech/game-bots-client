class_name SCR_UseableUser
extends Area2D


var target: OBJ_Useable = null

var _area2d: Area2D = null

func _ready():
	area_entered.connect(_on_entered)
	area_exited.connect(_on_exited)
	
func _on_entered(node: Node2D):
	if _area2d != null:
		return

	if node is OBJ_Useable:
		_area2d = node
		target = node
	elif node is OBJ_Area2D and node.proxy_to is OBJ_Useable:
		_area2d = node
		target = node.proxy_to	
	
func _on_exited(node: Node2D):
	if node == _area2d:
		target = null
		_area2d = null

func has_target() -> bool:
	return _area2d != null
	
func get_target() -> Node2D:
	return target

func use(used_by: Node2D):
	if not has_target():
		return
		
	target.use(used_by)
