extends CharacterBody2D

@export var speed=2500
@export var health_max = 100
@export var health_current = 100
@export var isAlive = true
@export var isWalking = false

var move_vector
enum CARDINAL_DIRECTION {N, NE, E, SE, S, SW, W, NW}


# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize at center of screen
	position = Vector2(1280*1.5,720*1.5)
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# receive move input
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if isAlive:
		# check if walking
		if move_vector == Vector2(0,0): isWalking = false
		else: isWalking = true

		# sprite faces cursor
		var angle = (get_viewport().get_mouse_position()-position).angle()
		
		# set animation
		animate_sprite(angle, isWalking)

	# kill if isAlive is set to false
	else:
		kill()


# Like _process, but called every physics frame (60fps)
func _physics_process(delta):
	if isAlive:
		# movement
		position += move_vector.normalized() * speed * delta


# Reduce health
func damage(amount: int):
	health_current = health_current-amount
	update_health_bar()
	# check if dead
	if health_current <= 0:
		isAlive=false


# Increase health
func heal(amount: int):
	health_current = health_current + amount
	update_health_bar()
	# prevent overheal
	if health_current > health_max:
		health_current = health_max


func update_health_bar():
	$Health_bar.max_value = health_max
	$Health_bar.value = health_current


# Called when character dies
func kill():
	print($".", "has died.")
	# TODO: call end screen?


# convert radian to one of 8 cardinal directions
func angle_to_direction(angle: float):
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


# pick which animation to show based on angle and isWalking
func animate_sprite(angle: float, isWalking: bool):
	var direction=angle_to_direction(angle)
	var walk_state
	var enum_to_string_dict = {
		0: "N", 1: "NE", 2: "E", 3: "SE",
		4: "S", 5: "SW", 6: "W", 7: "NW"
	}
	
	if isWalking: walk_state="Walk"
	else: walk_state="Idle"
	var animation_name = walk_state+"_"+enum_to_string_dict[direction]
	$AnimatedSprite2D.play(animation_name)
	
