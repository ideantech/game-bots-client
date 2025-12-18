class_name UI_Console
extends Control


@onready var _txtInput := %txtInput
@onready var _cntOutput := %cntOutput
@onready var _cntPrompt := %cntPrompt
@onready var _cntScroll := %cntScroll
@onready var _lblPrompt := %lblPrompt


var _connection: Array[Node2D] = []


func _ready():
	_txtInput.keep_editing_on_text_submit = true
	_cntScroll.get_v_scroll_bar().changed.connect(_on_v_scrollbar_changed)	

func reset():
	for child in _cntOutput.get_children():
		child.queue_free()
	_connection.clear()
	_txtInput.text = ''

func _on_v_scrollbar_changed():
	var max = _cntScroll.get_v_scroll_bar().max_value
	_cntScroll.scroll_vertical = max

func simple_progress(header: String, delay: float = 0.5, count: int = 6):
	var label := add_output(header)
	for i in range(0, count):
		await get_tree().create_timer(delay).timeout
		label.text = label.text + '.'

func simple_list_group(name: String):
	var nodes = get_tree().get_nodes_in_group(name)
	add_output(str(nodes.size()) + ' network(s) found')
	for node in nodes:
		var n = node.console_get_name()
		add_output(n)
		
func simple_find_in_group(group: String, name: String) -> Node2D:
	var nodes = get_tree().get_nodes_in_group(group)
	for node in nodes:
		if node.console_get_name() == name:
			return node
	return null

func _on_line_edit_text_submitted(new_text: String) -> void:
	var force_local := false
	
	new_text = new_text.strip_edges()
	add_output(_lblPrompt.text + new_text)
	_txtInput.text = ''

	if new_text.length() == 0:
		return
		
	if new_text.begins_with('@'):
		force_local = true
		new_text = new_text.substr(1)
		
	var parts = new_text.split(' ')
	start_command()
	if _connection.size() == 0 or force_local:
		await on_command(self, parts)
	else:
		await _connection.back().on_command(self, parts)
	finish_command()

func on_command(console: UI_Console, command: Array[String]) -> int:
	if command[0] == 'scan':
		await simple_progress('scanning')
		simple_list_group(Utl_Constants.GROUP_NETWORKS)
		
	elif command[0] == 'connect' and command.size() > 1:
		var network = Utl_Management.find_network(get_tree(), command[1])
		if network != null:
			var result = network.on_command(self, ['connection-request'])
			if result == OK:
				_connection.push_back(network)
				console.add_output('connected')
			else:
				console.add_output('error: failed to connect to network')
		else:
			console.add_output('error: network not found')
	elif command[0] == 'connections':
		if _connection.size() == 0:
			console.add_output('error: no connections')
		else:
			console.add_output('connection path')
			for con in _connection:
				console.add_output(con.console_get_name())
	elif command[0] == 'disconnect':
		if _connection.size() == 0:
			console.add_output('error: no connections')
		elif command.size() > 1 and command[1] == '-all':
			_connection.clear()
		else:
			var n = _connection.pop_back()
			add_output('disconnected from: ' + n.console_get_name())
			
	else:
		console.add_output('error: unrecognized or invalid command')
	return OK
	
func update_prompt():
	if _connection.size() == 0:
		_lblPrompt.text = '>'
	else:
		_lblPrompt.text = _connection.back().console_get_name() + ' >'
	pass
	
func start_command():
	_cntPrompt.visible = false

func finish_command():
	update_prompt()
	_cntPrompt.visible = true
	_txtInput.grab_focus()

func add_output(text: String) -> Label:
	var cls = preload('res://prefabs/ui/console/UI_ConsoleLabel.tscn')
	var inst := cls.instantiate() as Label
	_cntOutput.add_child(inst)
	inst.text = text
	
	return inst
