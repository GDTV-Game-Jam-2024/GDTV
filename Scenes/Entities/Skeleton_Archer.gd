extends NPC


func _process(delta : float) -> void:
	if rangedWeapon==null:
		pass
	elif loadedWeapon.canShoot:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("attack")
