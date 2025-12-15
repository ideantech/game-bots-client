class_name Utl_Damage
extends Node

static var _config := Utl_DamageConfig.new()

static var TYPE_PHYSICAL = 0

static func damage(source: IndexNode, target: IndexNode, amount: int, location: Vector2, type: int = 0) -> bool:
	_config.source = source
	_config.target = target
	_config.amount = amount
	_config.override_amount = false
	_config.override_apply = false
	_config.type = type
	_config.hit_location = location
	_config.override_killed = false
	_config.override_vfx = false

	target.signals.damaged.emit(_config)
	
	if not _config.override_apply:
		var health = target.get_attribute('stats/health/current')
		
		if not _config.override_amount:
			amount = adjust_damage(target, amount, type)
		else:
			amount = _config.amount
			
		var new_health = health.base_value - amount
		if new_health <= 0:
			_config.override_killed = false

			target.signals.killed.emit(_config)
			
			if not _config.override_killed:
				var abl = Abl_Killed.new()
				abl.user = target
				abl.target = target
				target.add_child(abl)
		else:
			health.base_value = new_health
			health.update()
			print('health', health.value)
		
		if not _config.override_vfx:
			var vfx: PackedScene = load("res://scripts/vfx/blood/Vfx_BloodExplosionSmall.tscn")
			var inst := vfx.instantiate() as Node2D
			target.get_tree().root.add_child(inst)
			inst.global_position = location
		
	return true
	
static func adjust_damage(target: IndexNode, amount: int, type: int = 0) -> int:
	var flat_resist := 0
	var flat_resist_percent := 0.0
	
	if type == TYPE_PHYSICAL:
		flat_resist = target.get_attribute_value('stats/resist/physicalflat', 0)
		flat_resist_percent = target.get_attribute_value('stats/resist/physical', 0.0)
	
	amount = amount - flat_resist
	if amount < 0: amount = 0
	amount = amount - (amount * flat_resist_percent)
	
	return amount
