class_name Wand
extends Node2D

signal outOfMana
signal shotProjectile(bullet, mana)
signal canSwap

@export var cooldown : float = 0.3
@export var manaCost : int = 20
@export var numberOfShots : int = 1
# Spread in degrees
@export var spread : int = 0
@export var projectile : PackedScene
@export_enum ("Player", "Enemy") var team : String = "Enemy"

var currentMana : int = 100
var canShoot : bool = true


func _ready() -> void:
	$Timer.wait_time = cooldown


func _process(delta : float) -> void:
	var mousePos = get_global_mouse_position()
	look_at(mousePos)
	if Input.is_action_pressed("shoot"):
		if canShoot and currentMana >= manaCost:
			shoot()
		elif currentMana < manaCost:
			outOfMana.emit()


func shoot() -> void:
	create_projectile()
	set_mana(currentMana - manaCost)
	canShoot = false
	$Timer.start()


func create_projectile() -> void:
	var newProjectile : Node2D = projectile.instantiate() as Node2D
	newProjectile.global_position = $Sprite2D/Marker2D.global_position
	newProjectile.rotation_degrees = rotation_degrees + randf_range(-spread, spread)
	shotProjectile.emit(newProjectile, currentMana)
	newProjectile.set_team(team)


func set_team(teamName : String) -> void:
	team = teamName


func set_mana(newMana : int) -> void:
	currentMana = newMana


func _on_timer_timeout() -> void:
	canShoot = true
	canSwap.emit()
