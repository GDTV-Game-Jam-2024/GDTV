extends NPC

func _process(delta):
	if canAttackMelee:
		$AnimatedSprite2D.play("move",2)
	else:
		$AnimatedSprite2D.play("attack",1)
