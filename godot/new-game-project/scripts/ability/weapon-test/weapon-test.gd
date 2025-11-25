class_name WeaponTest
extends Ability

var sig_weapon_raised := SignalRegistration.new()
var sig_weapon_lowered := SignalRegistration.new()
@onready var attachment := $Attachment

func run():
	auto_finish = false
	
	var index := (user as Node) as IndexNode
	var animator = index.animator
	attach_to(animator.get_node('Weapon'), attachment)
	
	index.data.data.on('weapon-raised', _weapon_raised)
	index.data.data.on('weapon-lowered', _weapon_lowered)
	
	attachment.modulate.a = 0.0

func _weapon_raised():
	print('raised')
	attachment.modulate.a = 1.0
	pass
	
func _weapon_lowered():
	print('lowered')
	attachment.modulate.a = 0.0
	pass
	
func _weapon_fire():
	print('fired')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var attach_pos := (attachment as Node2D).global_position
	var angle := attach_pos.angle_to_point(mouse_pos)
	(attachment as Node2D).rotation = angle
	pass


func attach_to(target: Node, to_attach: Node):
	to_attach.get_parent().remove_child(to_attach)
	target.add_child(to_attach)
