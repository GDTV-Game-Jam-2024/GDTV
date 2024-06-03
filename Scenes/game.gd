extends Node2D

@export var gameTimer : float = 0  # how much time has elapsed since starting game
@export var spawnTimer : float = 30  # how much time is remaining since next spawner
@export var spawnFrequency : float = 30  # how much time between spawners spawn
@export var isRunning : bool = true  # whether game is running or paused


@onready var projectileManager : Node2D = $ProjectileManager
@onready var creatureManager : Node2D = $CreatureManager
@onready var player : CharacterBody2D = $player
@onready var ui : UI = $UI as UI

var spawner : PackedScene = load("res://Scenes/spawn_portal.tscn")
var currentMana : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_spawner()
	# Connect signals
	player.connect("projectile_shot", _on_projectile_shot)
	player.connect("mana_changed", _on_mana_changed)
	player.connect("no_mana", _on_no_mana)
	player.connect("dead", _on_entity_dead)
	ui.set_minimap_dimension(24, 13.5)
	ui.add_unit_to_minimap(player, UI.ENTITIES.PLAYER)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if isRunning:
		gameTimer += delta
	pass


func _physics_process(delta : float) -> void:
	spawnTimer -= delta
	if spawnTimer <= 0:  # reset spawn_timer and spanws a timer
		spawnTimer += spawnFrequency

		spawn_spawner()
	pass


# called to create a spawn_portal
# TODO: change spawn location to area within the zone, rather than along the path
func spawn_spawner() -> void:
	# determine spawn location based on the path
	var spawn_location : PathFollow2D = $SpawnerPath/SpawnerSpawnLocation as PathFollow2D
	spawn_location.progress_ratio = randf()
	print("Spawn Location set to ", spawn_location.position)
	
	# create new spawner with the generated location
	var new_spawner : Spawner = spawner.instantiate() as Spawner
	new_spawner.init(spawn_location.position)
	creatureManager.add_child(new_spawner)
	new_spawner.connect("spawnedEnemy", _on_enemy_created)
	print(new_spawner," was created.")


func _on_enemy_created(enemy : NPC) -> void:
	creatureManager.add_child(enemy)
	ui.add_unit_to_minimap(enemy, ui.ENTITIES.ENEMY)
	enemy.connect("projectile_shot", _on_npc_projectile_shot)
	enemy.connect("dead", _on_entity_dead)


func _on_entity_dead(actor : CharacterBody2D) -> void:
	ui.remove_unit_from_minimap(actor)


func _on_projectile_shot(projectileName : Projectile) -> void:
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = $player


func _on_npc_projectile_shot(projectileName : Projectile, projectileOwner : NPC) -> void:
	projectileManager.add_child(projectileName)
	projectileName.projectileOwner = projectileOwner


func _on_mana_changed(newMana : int) -> void:
	currentMana = newMana
	ui.set_mana(currentMana) # Change mana in ui


func _on_no_mana() -> void:
	pass # Make it change UI (some flashing effect)
