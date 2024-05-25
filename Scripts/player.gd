extends Node2D

# TODO: ask why use @export?
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


# Called upon taking damage (negative delta) or healing (positive delta)
func change_health(delta):
	#update health_current
	health_current = health_current+delta
	# prevent overheal
	if health_current > health_max:
		health_current = health_max
		
	# check if dead
	if health_current <= 0:
		isAlive=false

	# healthbar update
	$Health_bar.max_value=health_max
	$Health_bar.value=health_current


# Called when character dies
func kill():
	print($".", "has died.")
	# TODO: call end screen?
