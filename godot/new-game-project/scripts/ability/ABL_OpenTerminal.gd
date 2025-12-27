class_name ABL_OpenTerminal
extends Ability

func run():
	auto_finish = false
	
	await get_tree().create_timer(0.1).timeout
	
	var console: UI_Terminal = (target as Node ) as UI_Terminal
	var index := ((user as Node) as IndexNode)
	var movement := index.movement
	var controller := index.controller
	
	movement.disable()
	controller.disable()
	
	console.open()	
	await console.terminal_closed
	
	movement.enable()
	controller.enable()
