class_name SCR_RoomConsoleCommand
extends ConsoleCommandHandler


func run(command: String):
	var parts = command.split(" ")
	
	if parts.size() == 1:
		console.add_output('room module v1.0')
	elif parts.size() >= 2:
		var name = parts[1]
		var r = Utl_Management.find_room(console.get_tree(), name)
		if r == null:
			console.add_output('error: room not found')
		else:
			if parts.size() == 2:
				if r.is_lights_on():
					console.add_output('lights: on')
				else:
					console.add_output('lights: off')
			elif parts.size() == 3:
				if parts[2] == 'lights_off':
					console.add_output('issuing command')
				elif parts[2] == 'lights_on':
					console.add_output('issuing command')
				else:
					console.add_output('error in command')
			else:
				console.add_output('error in command')
				
	else:
		console.add_output('error in command')
		
	console.finish_command()
