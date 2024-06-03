class_name Spawner
extends CharacterBody2D

signal spawnedEnemy(enemy)


@export var spawnTimerMax : float = 7  # how often it spawns enemies
@export var spawnTimer : float = 7  # how much time left until next spawn
@export var spawnPower : int = 10  # how many enemies get spawned per cycle
@export var spawnCounter : int = 0  # how many enemies were spawned this cycle
@export var health : float = 3.0  # how much damage it can take (takes 1 damage per second)
@export var isAlive : bool = true
@export var summoningActive : bool = true  # set to false if player nearby
# TODO: check for player proximity

var goblin : PackedScene = load("res://Scenes/Entities/Goblin.tscn") as PackedScene
var skeletonArcher : PackedScene = load("res://Scenes/Entities/Skeleton_Archer.tscn") as PackedScene
var giant : PackedScene = load("res://Scenes/Entities/Giant.tscn") as PackedScene
var boar : PackedScene = load("res://Scenes/Entities/Boar.tscn") as PackedScene

# allows initialization with coordinates
func init(coordinates : Vector2) -> void:
	global_position = coordinates
	spawnTimer = 1
	spawnPower = 20
	health = 3000
	isAlive = true


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	$AnimationPlayer.play("default", -1, -3, true)
	if health <= 0 : isAlive = false


func _physics_process(delta : float) -> void:
	
	
	if isAlive:
		if summoningActive:
			spawnTimer -= delta
		else:
			health -= delta
			if health<=0:
				isAlive=false
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
			spawn_enemy(goblin)
			spawnCounter += 5
			# TODO: move power value for spawnCounter into NPC as an export
	elif spawnPower < 50:
		while spawnCounter < spawnPower: 
			spawn_enemy(goblin)
			spawnCounter += 5
			spawn_enemy(skeletonArcher)
			spawnCounter += 10
			spawn_enemy(boar)
			spawnCounter += 10
	elif spawnPower < 100: 
		while spawnCounter < spawnPower:
			spawn_enemy(goblin)
			spawnCounter += 5
			spawn_enemy(goblin)
			spawnCounter += 5
			spawn_enemy(skeletonArcher)
			spawnCounter += 10
			spawn_enemy(skeletonArcher)
			spawnCounter += 10
			spawn_enemy(boar)
			spawnCounter += 10
	
	# reset spawn_counter
	spawnCounter = 0

	# raise power after every summon
	spawnPower += 5

	# reset spawn timer
	spawnTimer = spawnTimer + spawnTimerMax	


func spawn_enemy(enemyType: PackedScene) -> void:
	var spawn_location : PathFollow2D = $SummonPath/PathFollow2D as PathFollow2D
	spawn_location.progress_ratio = randf()
	print("Spawn Location set to ", spawn_location.position)
	
	var newEnemy : NPC = enemyType.instantiate() as NPC
	spawnedEnemy.emit(newEnemy)
	newEnemy.global_position = spawn_location.global_position
	print(newEnemy," was created.")


# called when isAlive is set to false
func kill() -> void:
	print("killed", $".")
	queue_free()
