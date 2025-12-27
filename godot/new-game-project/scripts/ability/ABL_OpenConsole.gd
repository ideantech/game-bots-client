class_name ABL_OpenConsole
extends Ability

func run():
	auto_finish = false
	
	await get_tree().create_timer(0.1).timeout
	
	var console: UI_ConsoleContainer = get_tree().get_first_node_in_group('UI_ConsoleContainer')
	var index := ((user as Node) as IndexNode)
	var movement := index.movement
	var controller := index.controller
	
	movement.disable()
	controller.disable()
	
	console.open()	
	await console.console_closed
	
	movement.enable()
	controller.enable()
	
	pass
