extends CharacterBody2D

@export var speed=250
@export var health_max = 100
@export var health_current = 100
@export var isAlive = true

var move_vector
enum CARDINAL_DIRECTION {N, NE, E, SE, S, SW, W, NW}

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize at center of screen
	position = Vector2(640,360)
	move_vector=Input.get_vector("ui_left","ui_right","ui_up","ui_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# receive move input
	move_vector=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if isAlive:
		# sprite faces cursor
		var angle = (get_viewport().get_mouse_position()-position).angle()
		$Player_sprite.set_rotation(angle)
				
	else:
		kill()

func _physics_process(delta):
	if isAlive:
		# movement
		position += move_vector.normalized()*speed*delta

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


# convert radian to one of 8 cardinal directions
func angle_to_direction(angle):
	if abs(angle)<PI/8:
		return CARDINAL_DIRECTION.E
	if abs(angle)>PI*7/8:
		return CARDINAL_DIRECTION.W
	if angle>0:
		if angle<PI*3/8:
			return CARDINAL_DIRECTION.SE
		if angle<PI*5/8:
			return CARDINAL_DIRECTION.S
		if angle<PI*7/8:
			return CARDINAL_DIRECTION.SW
	else:
		if angle>PI*-3/8:
			return CARDINAL_DIRECTION.NE
		if angle>PI*-5/8:
			return CARDINAL_DIRECTION.N
		if angle>PI*-7/8:
			return CARDINAL_DIRECTION.NW
