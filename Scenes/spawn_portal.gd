extends CharacterBody2D

@export var spawn_timer_max = 10  # how often it spawns enemies
@export var spawn_timer = 10  # how much time left until next spawn
@export var spawn_power = 10  # how many enemies get spawned per cycle
@export var health = 20  # how much damage it can take
@export var isAlive = true


# allows initialization with custom parameters
func init():
	spawn_timer = 10
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


func spawn():
	print("just spawned")
	# TODO: spawn enemies

	# TODO: raise power?

	# resetting spawn timer
	spawn_timer = spawn_timer+spawn_timer_max	

# called when isAlive is set to false
func kill():
	print("killed", $".")
	pass
