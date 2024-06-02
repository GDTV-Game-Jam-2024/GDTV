class_name Wand
extends Node2D

signal outOfMana
signal shotProjectile(bullet)
signal manaChanged
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
var target : Vector2 = Vector2.ZERO
var ownedByPlayer : bool = true
var projectileSpeed : float = 0.0


func _ready() -> void:
	$Timer.wait_time = cooldown


func _process(delta : float) -> void:
	look_at(target)
	if ownedByPlayer:
		target = get_global_mouse_position()
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
	for shot in numberOfShots:
		var newProjectile : Projectile = projectile.instantiate() as Projectile
		
		newProjectile.global_position = $Sprite2D/Marker2D.global_position
		newProjectile.rotation_degrees = rotation_degrees + randf_range(-spread, spread)
		shotProjectile.emit(newProjectile)
		newProjectile.set_team(team)


func set_team(teamName : String) -> void:
	team = teamName


func set_mana(newMana : int) -> void:
	currentMana = newMana
	manaChanged.emit(newMana)


func _on_timer_timeout() -> void:
	canShoot = true
	canSwap.emit()
