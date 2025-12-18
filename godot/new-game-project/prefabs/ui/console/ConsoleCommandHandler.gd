class_name ConsoleCommandHandler
extends RefCounted

var console: UI_Console

func delay(timeout: float):
	await console.get_tree().create_timer(timeout).timeout

func run(command: String):
	await delay(0.25)
	console.finish_command()
