extends CharacterBody2D

@export var speed=250
@export var health_max = 100
@export var health_current = 100
@export var isAlive = true


# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize at center of screen
	position = Vector2(640,360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isAlive:
		# movement
		var move_vector=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		position += move_vector.normalized()*speed*delta
		
		# sprite faces cursor
		var angle = (get_viewport().get_mouse_position()-position).angle()
		$Player_sprite.set_rotation(angle)
	else:
		kill()


# Reduce health
func damage(amount):
	health_current = health_current-amount
	update_health_bar()
	# check if dead
	if health_current <= 0:
		isAlive=false


# Increase health
func heal(amount):
	health_current = health_current+amount
	update_health_bar()
	# prevent overheal
	if health_current > health_max:
		health_current = health_max


func update_health_bar():
	$Health_bar.max_value=health_max
	$Health_bar.value=health_current


# Called when character dies
func kill():
	print($".", "has died.")
	# TODO: call end screen?
