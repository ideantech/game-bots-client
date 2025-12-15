extends Node2D

var flash_on: bool = false

func update_flash():
	if flash_on:
		%PlayerLight.visible = false
		%FlashLight.visible = true
	else:
		%PlayerLight.visible = true
		%FlashLight.visible = false

func _process(_delta):
	if Input.is_action_just_pressed('ui_accept'):
		flash_on = not flash_on
		update_flash()
	
	#if Input.is_action_pressed('ui_left'): position.x -= 1
	#if Input.is_action_pressed('ui_right'): position.x += 1
	#if Input.is_action_pressed('ui_up'): position.y -= 1
	#if Input.is_action_pressed('ui_down'): position.y += 1
	
	%PlayerLight.global_position = %Character.global_position
	%FlashLight.global_position = %Character.global_position
	global_position =%Character.global_position
	#var angle = global_position.angle_to_point(get_global_mouse_position())
	#print(get_viewport().get_final_transform().basis_xform_inv(get_global_mouse_position()).x)
	#print(get_tree().root.get_mouse_position().x)
	#%PointLight2D.global_rotation = angle
	
	var mouse_pos = Vector2(0, 0)
	mouse_pos = get_tree().root.get_mouse_position()
	#mouse_pos = get_global_mouse_position()
	#mouse_pos = get_viewport().get_mouse_position()
	#var angle = %Pivot.global_rotation
	var angle = (%Character.global_position * 4.0).angle_to_point(mouse_pos)
	if Input.is_action_pressed('rotate_left'): angle -= 0.01
	if Input.is_action_pressed('rotate_right'): angle += 0.01
	%Pivot.rotation = angle
	%FlashLight.rotation = angle
	
	#print(mouse_pos)
	#print(global_position)
	#print(angle)
	
	pass
