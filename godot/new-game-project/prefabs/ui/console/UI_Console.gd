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
	
	await get_tree().create_timer(0.5).timeout
	
	var pds = UTL_Ship.get_all_power_distribution(get_tree())
	for pd in pds:
		(pd as OBJ_PowerDistribution).structure.property_updated.connect(on_power_updated)
	
func on_power_updated(n: Node, name: String, v: Variant):
	if name != 'power-state': return
	
	var pd := (n as OBJ_PowerDistribution)
	var is_disconnect := (pd.structure.power_is_off() or pd.structure.power_is_brownout())
	var disc := false
	for node in _connection:
		if not node.structure.has_power():
			disc = true
			break
	if disc:
		add_output('connection terminated')
		_connection.clear()
		finish_command()

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
	#add_output(str(nodes.size()) + ' entries found')
	for node in nodes:
		var n = node.structure.structure_name
		if not n.structure.has_power():
			continue
		add_output(n)
		
func simple_list_names(names: Array):
	add_output(str(names.size()) + ' entries found')
	for n in names:
		add_output(n)
		
func simple_find_in_group(group: String, name: String) -> Node2D:
	var nodes = get_tree().get_nodes_in_group(group)
	for node in nodes:
		if node.structure.structure_name == name:
			return node
	return null

func push_connection(n: Node2D):
	_connection.push_back(n)
	pass
	
func try_connection_request(target: Node2D):
	if target != null:
		var result = await target.on_command(self, ['connection-request'])
		if result == OK:
			_connection.push_back(target)
			add_output('connected')
		else:
			add_output('error: failed to connect')
	else:
		add_output('error: not found')

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

#region console interface

func on_command(console: UI_Console, command: Array[String]) -> int:
	if command[0] == 'scan':
		await simple_progress('scanning')
		simple_list_names(UTL_Ship.get_all_network_names(get_tree()))
	
	elif command[0] == 'shutdown':
		var pds = UTL_Ship.get_all_power_distribution(get_tree())
		for pd in pds:
			pd.on_command(self, ['shutdown'])
			
	elif command[0] == 'startup':
		var pds = UTL_Ship.get_all_power_distribution(get_tree())
		for pd in pds:
			pd.on_command(self, ['startup'])
	
	elif command[0] == 'connect' and command.size() > 1:
		var network = UTL_Ship.get_network(get_tree(), command[1])
		try_connection_request(network)

	elif command[0] == 'connections':
		if _connection.size() == 0:
			console.add_output('error: no connections')
		else:
			console.add_output('connection path')
			for con in _connection:
				console.add_output(con.structure.structure_name)
	elif command[0] == 'disconnect':
		if _connection.size() == 0:
			console.add_output('error: no connections')
		elif command.size() > 1 and command[1] == '-all':
			_connection.clear()
		else:
			var n = _connection.pop_back()
			add_output('disconnected from: ' + n.structure.structure_name)
			
	else:
		console.add_output('error: unrecognized or invalid command')
	return OK

#endregion
	
func update_prompt():
	if _connection.size() == 0:
		_lblPrompt.text = '>'
	else:
		_lblPrompt.text = _connection.back().structure.structure_name + ' >'
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
