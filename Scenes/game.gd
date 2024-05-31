extends Node2D

@onready var projectileManager : Node2D = $ProjectileManager

var currentMana : int = 0
var spawner = load("res://Scenes/spawn_portal.tscn")


func _on_characterbody_2d_projectile_shot(projectileName : Projectile):
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = $characterbody2d


func _on_characterbody_2d_mana_changed(newMana):
	currentMana = newMana # Change mana in ui



func _on_characterbody_2d_no_mana():
	pass # Make it change UI (some flashing effect)

@export var game_timer = 0  # how much time has elapsed since starting game
@export var spawn_timer = 30  # how much time is remaining since next spawner
@export var isRunning = true  # whether game is running or paused

var spawner = load("res://Scenes/spawn_portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_spawner()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isRunning:
		game_timer += delta
	pass

func _physics_process(delta):
	spawn_timer -= delta
	if spawn_timer<=0:
		spawn_timer += 10
		spawn_spawner()
	pass


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

