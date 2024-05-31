extends Node2D

@onready var projectileManager : Node2D = $ProjectileManager

<<<<<<< Updated upstream
var currentMana : int = 0
=======
@onready var projectileManager : Node2D = $ProjectileManager

var currentMana : int = 0
var spawner = load("res://Scenes/spawn_portal.tscn")
>>>>>>> Stashed changes

func _on_characterbody_2d_projectile_shot(projectileName : Projectile):
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = $characterbody2d


func _on_characterbody_2d_mana_changed(newMana):
	currentMana = newMana # Change mana in ui


<<<<<<< Updated upstream
func _on_characterbody_2d_no_mana():
	pass # Make it change UI (some flashing effect)
=======
# called to create a spawn_portal
# TODO: change spawn location to area within the zone, rather than along the path
func spawn_spawner():
	# determine spawn location based on the path
	var spawn_location = $SpawnerPath/SpawnerSpawnLocation
	spawn_location.progress_ratio = randf()
	print("Spawn Location set to ", spawn_location.position)
	
	# create new spawner with the generated location
	var new_spawner=spawner.instantiate()
	new_spawner.init(spawn_location.position)
	add_child(new_spawner)
	print(new_spawner," was created.")


func _on_player_mana_changed(newMana : int):
	currentMana = newMana


func _on_player_no_mana():
	pass # Make it change UI (some flashing effect)


func _on_player_projectile_shot(projectileName : Projectile):
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = $player
>>>>>>> Stashed changes
