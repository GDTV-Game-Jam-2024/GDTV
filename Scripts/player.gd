extends CharacterBody2D

@export var movementSpeed : float = 250.0
@export var healthMax : int = 100
@export var healthCurrent : int = 100
@export var isAlive : bool = true
@export var isWalking : bool = false

var team : String = "Player"
var move_vector : Vector2 = Vector2.ZERO
enum CARDINAL_DIRECTION {N, NE, E, SE, S, SW, W, NW}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# initialize at center of screen
	position = Vector2(640,360)
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	# receive move input
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if isAlive:
		# check if walking
		if move_vector == Vector2.ZERO:
			isWalking = false
		else:
			isWalking = true

		# sprite faces cursor
		var angle : float = (get_viewport().get_mouse_position() - position).angle()
		
		# set animation
		animate_sprite(angle, isWalking)

	# kill if isAlive is set to false
	else:
		kill()


# Like _process, but called every physics frame (60fps)
func _physics_process(delta : float) -> void:
	if isAlive:
		# movement
		position += move_vector.normalized() * movementSpeed * delta


func get_team() -> String:
	return team


# Reduce health
func damage(amount : int) -> void:
	healthCurrent = healthCurrent - amount
	update_health_bar()
	# check if dead
	if healthCurrent <= 0:
		isAlive = false


# Increase health
func heal(amount : int) -> void:
	healthCurrent = healthCurrent + amount
	update_health_bar()
	# prevent overheal
	if healthCurrent > healthMax:
		healthCurrent = healthMax


func update_health_bar() -> void:
	$Health_bar.max_value = healthMax
	$Health_bar.value = healthCurrent


# Called when character dies
func kill() -> void:
	print($".", "has died.")
	# TODO: call end screen?


# convert radian to one of 8 cardinal directions
func angle_to_direction(angle : float):
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
func animate_sprite(angle : float, isWalking : bool) -> void:
	var direction = angle_to_direction(angle)
	var walk_state : String = ""
	var enum_to_string_dict : Dictionary = {
		0: "N", 1: "NE", 2: "E", 3: "SE",
		4: "S", 5: "SW", 6: "W", 7: "NW"
	}
	
	if isWalking:
		walk_state = "Walk"
	else:
		walk_state = "Idle"
	var animation_name : String = walk_state + "_" + enum_to_string_dict[direction]
	$AnimatedSprite2D.play(animation_name)
	
