class_name NPC
extends CharacterBody2D

signal projectile_shot(projectile_name, projectileOwner)

@onready var characterAI : AI = $AI
@onready var stateInfo : Label = $StateDebugInfo

@export_enum ("Player", "Enemy") var team : String = "Enemy"

@export_group("Stats", "stat")
@export var statMovementSpeed : float = 300.0
@export var statMaxHP : int = 100

@export_group("Melee Stats", "melee")
@export var meleeAttackDamage : int = 10
@export var meleeAttackCooldown : float = 0.8
@export var meleeChargeHealthThreshold : int = 10
@export var meleeChanceForCharge : int = 100
@export var meleeChargeDamage : int = 30
@export var meleeChargeSpeed : float = 600.0

@export_group("Ranged Stats", "ranged")
@export var rangedWeapon : PackedScene
@export var rangedChanceForSmart : int = 50

@export_group("Allowed Behaviors", "State")
@export var State_ATTACK_RANGE : bool = true
@export var State_ATTACK_RANGE_SMART : bool = true
@export var State_ATTACK_MELEE : bool = true
@export var State_ATTACK_MELEE_CHARGE : bool = true
@export var State_APPROACH_ENEMY : bool = true
@export var State_GO_TO_DEFAULT_TARGET : bool = true

var currentSpeed : float = 0
var canAttackMelee : bool = true
var currentHP : int = 1
var loadedWeapon : Wand = null
var meleeTarget : CharacterBody2D = null
var isAlive : bool = true

func _ready() -> void:
	characterAI.initialize_ai(self)
	currentSpeed = statMovementSpeed
	currentHP = statMaxHP
	prepare_weapon()
	$MeleeAttackCooldown.wait_time = meleeAttackCooldown


func get_team() -> String:
	return team


func get_hp() -> int:
	return currentHP


func damage(amount: int) -> void:
	currentHP = currentHP - amount
	if currentHP <= 0:
		die()


func die() -> void:
	isAlive = false
	queue_free()


func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * currentSpeed


func charge_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * meleeChargeSpeed


func stop_moving() -> Vector2:
	return Vector2.ZERO


func set_target(location : Vector2) -> void:
	loadedWeapon.target = location


func prepare_weapon() -> void:
	if !rangedWeapon == null:
		loadedWeapon = rangedWeapon.instantiate() as Wand
		add_child(loadedWeapon)
		loadedWeapon.connect("shotProjectile", _on_shot_projectile)
		loadedWeapon.ownedByPlayer = false


func set_target_melee(targetMelee : CharacterBody2D) -> void:
	meleeTarget = targetMelee


func attack_melee() -> void:
	if canAttackMelee:
		if meleeTarget.has_method("damage"):
			meleeTarget.damage(meleeAttackDamage)
			canAttackMelee = false
			$MeleeAttackCooldown.start()


func attack_charge() -> void:
	if canAttackMelee:
		if meleeTarget.has_method("damage"):
			meleeTarget.damage(meleeChargeDamage)
			canAttackMelee = false
			$MeleeAttackCooldown.start()


func attack_ranged() -> void:
	if loadedWeapon.canShoot:
		loadedWeapon.shoot()


func set_debug_state_info(newText : String) -> void:
	stateInfo.text = newText


func _on_melee_attack_cooldown_timeout() -> void:
	canAttackMelee = true


func _on_shot_projectile(projectile : Projectile) -> void:
	projectile_shot.emit(projectile, self)
