class_name UI_Terminal
extends Control


signal terminal_closed()


var structure: SCR_Structure = SCR_Structure.new()


func open():
	visible = true
	
func close():
	visible = false
	terminal_closed.emit()
