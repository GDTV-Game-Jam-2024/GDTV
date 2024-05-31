class_name Projectile
extends Node2D

# Basic Stats
var team : String = ""
var damage : int = 5
var speed : float = 500
var lifetime : float = 2.5
var penetrationNumber : int = 0

var projectileOwner : CharacterBody2D = null
var targetsHit : Array[CharacterBody2D] = []
var velocity : Vector2 = Vector2.ZERO

func _ready() -> void:
	$Timer.wait_time = lifetime
	$Timer.start()


func _physics_process(delta : float) -> void:
	velocity = transform.x * speed
	position += velocity * delta


func _on_collision_area_body_entered(body : CharacterBody2D) -> void:
	# If target is teamless or on the same team return early
	if !body.has_method("get_team") or body.get_team() == team :
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	if penetrationNumber > 0:
		penetrationNumber -= 1
	else:
		expire()


func set_team(teamName : String) -> void:
	team = teamName


func expire() -> void:
	queue_free()


func _on_timer_timeout():
	expire()
