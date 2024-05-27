extends Node2D

@export var timer = 0  # how much time has elapsed since starting game
@export var isRunning = true  # whether game is running or paused


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isRunning:
		timer += delta
	pass
