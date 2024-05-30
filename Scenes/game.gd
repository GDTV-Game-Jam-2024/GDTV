extends Node2D

@onready var projectileManager : Node2D = $ProjectileManager

var currentMana : int = 0

func _on_characterbody_2d_projectile_shot(projectileName : Projectile):
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = $characterbody2d


func _on_characterbody_2d_mana_changed(newMana):
	currentMana = newMana # Change mana in ui


func _on_characterbody_2d_no_mana():
	pass # Make it change UI (some flashing effect)
