class_name UI_PowerTerminal1
extends UI_Terminal

@export var power_distribution: OBJ_PowerDistribution

@onready var lblStatus := %lblStatus
@onready var btnStartup := %btnStartup
@onready var btnShutdown := %btnShutdown
@onready var lblExecutionStatus := %lblExecutionStatus
@onready var btnExit := %btnExit

func _ready():
	btnExit.pressed.connect(on_btnExit_pressed)
	btnShutdown.pressed.connect(on_btnShutdown_pressed)
	btnStartup.pressed.connect(on_btnStartup_pressed)
	
	visible = false
	
func refresh():
	if power_distribution.structure.power_is_off():
		lblStatus.text = "OFFLINE"
		btnShutdown.disabled = true
		btnStartup.disabled = false
	else:
		lblStatus.text = "ONLINE"
		btnShutdown.disabled = false
		btnStartup.disabled = true
		
	lblExecutionStatus.text = ''
		
func open():
	refresh()	
	super.open()
	
func on_btnExit_pressed():
	close()
	
func delay(a: float):
	await get_tree().create_timer(a).timeout
	
func status(text: String, d: float = 0.0):
	lblExecutionStatus.text = text
	if d > 0.0:
		await delay(d)
	
func on_btnShutdown_pressed():
	btnShutdown.disabled = true
	btnStartup.disabled = true
	await status('connecting', 2.0)
	await status('beginning shutting down', 1.0)
	power_distribution.on_command(null, ['shutdown'])
	await status('shutdown complete', 1.0)
	refresh()
	
func on_btnStartup_pressed():
	btnShutdown.disabled = true
	btnStartup.disabled = true
	await status('beginning startup process', 1.0)
	power_distribution.on_command(null, ['startup'])
	await status('startup complete', 1.0)
	refresh()
