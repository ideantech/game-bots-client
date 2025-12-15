class_name UI_Console
extends Control


@onready var _txtOutput := %txtOutput


func _on_line_edit_text_submitted(new_text: String) -> void:
	pass

func add_output(text: String):
	_txtOutput.append_text(text)
