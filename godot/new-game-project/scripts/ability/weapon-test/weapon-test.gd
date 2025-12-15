class_name WeaponTest
extends Ability

var sig_weapon_raised := SignalRegistration.new()
var sig_weapon_lowered := SignalRegistration.new()

@onready var attachment := $Attachment
@onready var raycast: RayCast2D = $Attachment/RayCast2D
@onready var audio := $AudioStreamPlayer2D
@onready var audio_hit := $AudioHit

func run():
	auto_finish = false
	
	var index := (user as Node) as IndexNode
	var animator = index.animator
	attach_to(animator.get_node('Weapon'), attachment)
	
	#index.signals.on2('weapon-raised', _weapon_raised)
	#index.signals.on2('weapon-lowered', _weapon_lowered)
	#index.signals.on2('weapon-fired', _weapon_fire)
	index.signals.weapon_raised.connect(_weapon_raised)
	index.signals.weapon_lowered.connect(_weapon_lowered)
	index.signals.weapon_fired.connect(_weapon_fire)
	
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
	audio.play()
	
	if raycast.is_colliding():
		audio_hit.play()
		var hit = raycast.get_collider()
		Utl_Damage.damage(index(), hit, 1, raycast.get_collision_point())


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
