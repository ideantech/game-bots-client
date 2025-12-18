class_name RES_AbilityConfig
extends Resource

@export_file_path('*.tscn', '*.gd') var ability_path: String
@export var target_user: bool = false
@export var target: NodePath

func activate(used_by: Node2D, activated_by: Node) -> Ability:
	if used_by == null or ability_path == '':
		push_error('res_abilityconfig: misconfigured')
		return null
		
	var cls = load(ability_path)
	if ability_path.ends_with('.gd'):
		var inst = cls.new() as Ability
		inst.user = used_by
		if target_user:
			inst.target = used_by
		else:
			var t = activated_by.get_node(target)
			inst.target = t
		used_by.add_child(inst)
		return inst
	elif ability_path.ends_with('.tscn'):
		pass
	else:
		push_error('unable to handle ability path: ' + ability_path)

	return null
