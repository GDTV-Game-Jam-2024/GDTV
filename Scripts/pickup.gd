class_name Pickup
extends Node2D

@export var restoreHP : int = 0
@export var restoreMana : int = 0
@export var addWand : int = 0
@export var lifetime : float = 6

@onready var timer : Timer = $Timer as Timer


func _ready():
	timer.wait_time = lifetime
	timer.start()


func _on_area_2d_body_entered(body : CharacterBody2D):
	if body is Player:
		body.add_wand(addWand)
		body.heal(restoreHP)
		body.mana_gain(restoreMana)


func _on_timer_timeout():
	queue_free()
