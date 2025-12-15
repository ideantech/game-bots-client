class_name Abl_Killed
extends Ability

func run():
	auto_finish = false
	
	var index := index()
	
	if index.movement != null:
		index.movement.disable()
	
	index.animator.is_killed = true
	
	var event := ''
	while event != 'killed_end':
		event = await index.animator.animation_event
	
	var tween = get_tree().create_tween()
	tween.tween_property(target, 'modulate:a', 0.0, 1.0)
	await tween.finished
	
	target.queue_free()
