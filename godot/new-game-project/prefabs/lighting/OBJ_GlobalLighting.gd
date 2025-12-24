class_name OBJ_GlobalLighting
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func power_loss():
	for light in get_tree().get_nodes_in_group(Utl_Constants.GROUP_AMBIENT_LIGHTS):
		var l := light as LightingAmbient
		
		
	pass
