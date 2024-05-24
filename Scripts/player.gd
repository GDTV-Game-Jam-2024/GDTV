extends Node2D

@export var speed=250

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize at center of screen
	position = Vector2(640,360)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
# movement
	var move_vector=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += move_vector.normalized()*speed*delta
	
# face cursor	
	var angle = (get_viewport().get_mouse_position()-position).angle()
	set_rotation(angle)
