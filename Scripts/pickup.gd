class_name Pickup
extends Node2D

@export var restoreHP : int = 0
@export var restoreMana : int = 0
@export var addWand : bool = false
@export var lifetime : float = 6

@onready var timer : Timer = $Timer as Timer


func _ready() -> void:
	timer.wait_time = lifetime
	timer.start()


func _on_area_2d_body_entered(body : CharacterBody2D) -> void:
	var addedWand : int = 0
	if addWand:
		addedWand = randi_range(1,5)
	if body is Player:
		body.add_wand(addedWand)
		body.heal(restoreHP)
		body.mana_gain(restoreMana)
	disapperar()


func _on_timer_timeout() -> void:
	disapperar()


func disapperar() -> void:
	queue_free()
