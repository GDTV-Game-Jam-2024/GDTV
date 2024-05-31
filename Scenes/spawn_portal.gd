extends CharacterBody2D

@export var spawn_timer_max = 7  # how often it spawns enemies
@export var spawn_timer = 7  # how much time left until next spawn
@export var spawn_power = 10  # how many enemies get spawned per cycle
@export var spawn_counter = 0  # how many enemies were spawned this cycle
@export var health = 20  # how much damage it can take
@export var isAlive = true


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
		spawn()


# spawn new set of units every cycle
func spawn():
	print($"."," spawned units.")
	
	# TODO: spawn enemies
	# following are placeholder values for testing. Actual balancing still needed
	# print functions should be replaced with actual spawn logic
	if spawn_power < 20 : 
		while spawn_counter < spawn_power : 
			print("spawning a goblin")
			spawn_counter += 2
	elif spawn_power < 50 :
		while spawn_counter < spawn_power : 
			print("spawning a goblin")
			spawn_counter += 2
			print("spawning an archer")
			spawn_counter += 4
	elif spawn_power < 100 : 
		while spawn_counter < spawn_power :
			print("spawning a goblin")
			spawn_counter += 2
			print("spawning a goblin")
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

# called when isAlive is set to false
func kill():
	print("killed", $".")
	pass
