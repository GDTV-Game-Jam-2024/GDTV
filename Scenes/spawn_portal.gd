extends CharacterBody2D

@export var spawn_timer_max = 7  # how often it spawns enemies
@export var spawn_timer = 7  # how much time left until next spawn
@export var spawn_power = 10  # how many enemies get spawned per cycle
@export var spawn_counter = 0  # how many enemies were spawned this cycle
@export var health = 20  # how much damage it can take
@export var isAlive = true

var goblin = load("res://Scenes/Mob/goblin_torch.tscn")

# allows initialization with coordinates
func init(coordinates):
	position = coordinates
	spawn_timer = 3
	spawn_power = 10
	health = 20
	isAlive = true

func _onready():
	pass


func _process(delta):
	$AnimationPlayer.play("default", -1, -3, true)
	if health <= 0 : isAlive = false


func _physics_process(delta):
	if isAlive:
		spawn_timer = spawn_timer - delta
	else:
		kill()
	
	if spawn_timer<0:
		spawnCycle()


# spawn new set of units every cycle
func spawnCycle():
	print($"."," spawned units.")
	
	# TODO: spawn enemies
	# following are placeholder values for testing. Actual balancing still needed
	# print functions should be replaced with actual spawn logic
	if spawn_power < 20 : 
		while spawn_counter < spawn_power : 
			spawn_goblin()
			spawn_counter += 2
	elif spawn_power < 50 :
		while spawn_counter < spawn_power : 
			spawn_goblin()
			spawn_counter += 2
			print("spawning an archer")
			spawn_counter += 4
	elif spawn_power < 100 : 
		while spawn_counter < spawn_power :
			spawn_goblin()
			spawn_counter += 2
			spawn_goblin()
			spawn_counter += 2
			print("spawning an archer")
			spawn_counter += 4
			print("spawning a giant")
			spawn_counter += 10
	
	# reset spawn_counter
	spawn_counter = 0

	# raise power after every summon
	spawn_power += 10

	# reset spawn timer
	spawn_timer = spawn_timer+spawn_timer_max	


# TODO: does this bind the goblin to the spawn portal?
func spawn_goblin():
	var spawn_location = $SummonPath/PathFollow2D
	spawn_location.progress_ratio = randf()
	print("Spawn Location set to ", spawn_location.position)
	
	var new_goblin = goblin.instantiate()
	new_goblin.init(spawn_location.position)
	add_child(new_goblin)
	print(new_goblin," was created.")


# called when isAlive is set to false
func kill():
	print("killed", $".")
	pass
