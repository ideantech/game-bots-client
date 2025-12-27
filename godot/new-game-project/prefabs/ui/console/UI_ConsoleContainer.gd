class_name UI_ConsoleContainer
extends VBoxContainer

signal console_closed()

@onready var _btnClose: Button = %UI_CloseConsole
@onready var _console: UI_Console = %UI_Console

func _ready():
	add_to_group('UI_ConsoleContainer')
	
	_btnClose.pressed.connect(on_close_pressed)

func open():
	visible = true
	_console.reset()

func close():
	visible = false

func on_close_pressed():
	close()
	console_closed.emit()
