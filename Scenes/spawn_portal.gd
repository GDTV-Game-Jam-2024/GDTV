class_name Spawner
extends CharacterBody2D

signal spawnedEnemy(enemy)

@export var spawnTimerMax : float = 7  # how often it spawns enemies
@export var spawnTimer : float = 7  # how much time left until next spawn
@export var spawnPower : int = 10  # how many enemies get spawned per cycle
@export var spawnCounter : int = 0  # how many enemies were spawned this cycle
@export var health : int = 20  # how much damage it can take
@export var isAlive : bool = true

var goblin : PackedScene = load("res://Scenes/Entities/Goblin.tscn")

# allows initialization with coordinates
func init(coordinates : Vector2) -> void:
	global_position = coordinates
	spawnTimer = 3
	spawnPower = 10
	health = 20
	isAlive = true

func _ready() -> void:
	pass


func _process(delta : float) -> void:
	$AnimationPlayer.play("default", -1, -3, true)
	if health <= 0 : isAlive = false


func _physics_process(delta : float) -> void:
	if isAlive:
		spawnTimer -= delta
	else:
		kill()
	
	if spawnTimer < 0:
		spawnCycle()


# spawn new set of units every cycle
func spawnCycle() -> void:
	print($"."," spawned units.")
	
	# TODO: spawn enemies
	# following are placeholder values for testing. Actual balancing still needed
	# print functions should be replaced with actual spawn logic
	if spawnPower < 20 : 
		while spawnCounter < spawnPower: 
			spawn_enemy()
			spawnCounter += 2
	elif spawnPower < 50:
		while spawnCounter < spawnPower: 
			spawn_enemy()
			spawnCounter += 2
			print("spawning an archer")
			spawnCounter += 4
	elif spawnPower < 100: 
		while spawnCounter < spawnPower:
			spawn_enemy()
			spawnCounter += 2
			spawn_enemy()
			spawnCounter += 2
			print("spawning an archer")
			spawnCounter += 4
			print("spawning a giant")
			spawnCounter += 10
	
	# reset spawn_counter
	spawnCounter = 0

	# raise power after every summon
	spawnPower += 10

	# reset spawn timer
	spawnTimer = spawnTimer + spawnTimerMax	


func spawn_enemy() -> void:
	var spawn_location : PathFollow2D = $SummonPath/PathFollow2D as PathFollow2D
	spawn_location.progress_ratio = randf()
	print("Spawn Location set to ", spawn_location.position)
	
	var newEnemy : NPC = goblin.instantiate() as NPC
	spawnedEnemy.emit(newEnemy)
	newEnemy.global_position = spawn_location.global_position
	print(newEnemy," was created.")


# called when isAlive is set to false
func kill() -> void:
	print("killed", $".")
	pass
