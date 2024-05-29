extends Node2D

@export var game_timer = 0  # how much time has elapsed since starting game
@export var spawn_timer = 3  # how much time is remaining since next spawner
@export var isRunning = true  # whether game is running or paused

var spawner = load("res://Scenes/spawn_portal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
