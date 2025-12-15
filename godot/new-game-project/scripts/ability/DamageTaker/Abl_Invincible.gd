class_name Abl_Invincible
extends Ability

func run():
	index().signals.damaged.connect(_on_damaged)
	
func _on_damaged(config: Utl_DamageConfig):
	config.override_amount = true
	config.amount = 0
