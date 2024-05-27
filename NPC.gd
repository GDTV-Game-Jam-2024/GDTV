class_name NPC
extends CharacterBody2D

@onready var characterAI : AI = $AI
@onready var stateInfo : Label = $StateDebugInfo

@export_enum ("Player", "Enemy") var team : String = "Enemy"

@export_group("Stats", "stat")
@export var statMovementSpeed : float = 300.0
@export var statMaxHP : int = 100

@export_group("Melee Stats", "melee")
@export var meleeAttackDamage : int = 10
@export var meleeChargeHealthThreshold : int = 10
@export var meleeChanceForCharge : int = 100
@export var meleeChargeDamage : int = 15

@export_group("Ranged Stats", "ranged")
@export var rangedProjectile : PackedScene
@export var rangedChanceForSmart : int = 50

@export_group("Allowed Behaviors", "State")
@export var State_ATTACK_RANGE : bool = true
@export var State_ATTACK_RANGE_SMART : bool = true
@export var State_ATTACK_MELEE : bool = true
@export var State_ATTACK_MELEE_CHARGE : bool = true
@export var State_APPROACH_ENEMY : bool = true
@export var State_GO_TO_DEFAULT_TARGET : bool = true

var currentSpeed : float = 0
var canAttack : bool = true
var currentHP : int = 1


func _ready() -> void:
	characterAI.initialize_ai(self)
	currentSpeed = statMovementSpeed
	currentHP = statMaxHP


func get_team() -> String:
	return team


func get_hp() -> int:
	return currentHP


func velocity_toward(location: Vector2):
	return global_position.direction_to(location) * currentSpeed


func stop_moving() -> Vector2:
	return Vector2.ZERO


#TODO Make actual attacks
func attack_melee() -> void:
	if canAttack:
		canAttack = false


func attack_charge() -> void:
	if canAttack:
		canAttack = false


func attack_ranged() -> void:
	if canAttack:
		canAttack = false


func set_debug_state_info(newText : String) -> void:
	stateInfo.text = newText
