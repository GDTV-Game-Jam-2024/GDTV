extends NPC


func _process(delta) -> void:
	if canAttackMelee:  # use attack anim if attack is put on cooldown
		$AnimatedSprite2D.play("Walk",2)
	else:
		$AnimatedSprite2D.play("Attack",2)
		
