class_name SCR_ListConsoleCommand
extends ConsoleCommandHandler

func run(command: String):
	var parts = command.split(" ")
	
	if parts.size() == 1:
		console.add_output('list module v1.0')
	elif parts.size() >= 2 and parts[1] == 'rooms':
		var label := await console.add_output('querying rooms')
		for i in range(0, 5):
			await console.get_tree().create_timer(0.25).timeout
			label.text = label.text + '.'
		label.text = label.text + 'done'
		
		var nodes = console.get_tree().get_nodes_in_group(Utl_Constants.GROUP_ROOMS)
		for node in nodes:
			var room := node as LightingRoom
			console.add_output('  ' + room.room_name)
		
	console.finish_command()
		
