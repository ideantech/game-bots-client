class_name Abl_DamageTaker
extends Ability


func run():
	print('Abl_DamageTaker:run(T)')
	auto_finish = false
	
	index().signals.damaged.connect(_on_damaged)
	#await get_tree().create_timer(0.1).timeout
	#index().signals.on2('damaged', _on_damaged)
	

func _on_damaged(config: Utl_DamageConfig):
	print('damaged')
	config.override_amount = true
	config.amount = 99

func _on_killed(config: Utl_DamageConfig):
	pass
