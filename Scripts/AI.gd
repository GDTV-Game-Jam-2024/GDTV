class_name AI
extends Node2D

var debugON : bool = true

# Values set at the start
var entity : NPC = null
var defaultTargetLocation : Vector2

# Stuff related to local game state
var nearbyEnemies : Array[CharacterBody2D] = []
var enemiesInMeleeRange : Array[CharacterBody2D] = []
var enemiesInRangedRange : Array[CharacterBody2D] = []
var closestEnemy : CharacterBody2D = null
var attackTarget : CharacterBody2D
var attackLocation : Vector2 = Vector2.ZERO

var velocity : Vector2 = Vector2.ZERO

# Stuff for state machine
enum State {
	PASSIVE,
	ATTACK_RANGE,
	ATTACK_RANGE_SMART,
	ATTACK_MELEE,
	ATTACK_MELEE_CHARGE,
	APPROACH_ENEMY,
	GO_TO_DEFAULT_TARGET
}

var currentState : int = State.PASSIVE
var canChangeState : bool = true


func _physics_process(delta : float) -> void:
	execute_state()
	move_entity_to_target(delta)
	if debugON:
		var currState : String = ""
		match currentState:
			State.PASSIVE:
				currState = "PASSIVE"
			State.ATTACK_RANGE:
				currState = "ATTACK_RANGE"
			State.ATTACK_RANGE_SMART:
				currState = "ATTACK_RANGE_SMART"
			State.ATTACK_MELEE:
				currState = "ATTACK_MELEE"
			State.ATTACK_MELEE_CHARGE:
				currState = "ATTACK_MELEE_CHARGE"
			State.APPROACH_ENEMY:
				currState = "APPROACH_ENEMY"
			State.GO_TO_DEFAULT_TARGET:
				currState = "GO_TO_DEFAULT_TARGET"
		entity.set_debug_state_info(currState)


func initialize_ai(entityID : NPC) -> void:
	entity = entityID


func set_default_target_location(targetLocation : Vector2) -> void:
	defaultTargetLocation = targetLocation


func set_nearby_enemy(targetID : CharacterBody2D) -> void:
	closestEnemy = targetID


func get_closest_enemy() -> CharacterBody2D:
	var closest_enemy : CharacterBody2D = null
	var dist : float = -1
	for enemy : CharacterBody2D in nearbyEnemies:
		if !is_instance_valid(enemy):
			continue
		var d : float = global_transform.origin.distance_squared_to(enemy.global_transform.origin)
		if dist < 0.0 or d < dist:
			dist = d
			closest_enemy = enemy
	return closest_enemy


func move_entity_to_target(delta : float) -> void:
	entity.global_position += entity.currentSpeed * delta * velocity.normalized()


#region State Machine
func set_state(newState : int) -> void:
	if newState == currentState:
		return
	currentState = newState


func block_state_change(value : bool) -> void:
	canChangeState = value


func choose_state() -> void:
	var chanceRollCharge : int = randi_range(1, 101)
	var chanceRollSmartRange : int = randi_range(1, 101)
	# No enemies = go to the portal if can move
	if nearbyEnemies.is_empty() and entity.State_GO_TO_DEFAULT_TARGET:
		set_state(State.GO_TO_DEFAULT_TARGET)
		return
	# Enemy in melee range = melee
	if not enemiesInMeleeRange.is_empty() and entity.State_ATTACK_MELEE:
		attackTarget = get_closest_enemy()
		set_state(State.ATTACK_MELEE)
	elif not enemiesInRangedRange.is_empty():
		# Charge shares its range with ranged attacks
		# Try to charge
		if entity.State_ATTACK_MELEE_CHARGE and entity.meleeChanceForCharge < chanceRollCharge:
			attackLocation = get_closest_enemy().global_position
			set_state(State.ATTACK_MELEE_CHARGE)
		# Try to shoot in the place enemy will stand
		elif entity.State_ATTACK_RANGE_SMART and entity.rangedChanceForSmart < chanceRollSmartRange:
			set_state(State.ATTACK_RANGE_SMART)
		# Just shoot
		elif entity.State_ATTACK_RANGE:
			set_state(State.ATTACK_RANGE)
	# If out of range but close to enemy come closer
	elif entity.State_APPROACH_ENEMY:
		set_state(State.APPROACH_ENEMY)
	# Do nothing if all fails
	else:
		set_state(State.PASSIVE)


func execute_state() -> void:
	match currentState:
		State.PASSIVE:
			pass
		State.ATTACK_RANGE:
			if closestEnemy != null:
				velocity = entity.stop_moving()
				entity.set_target(closestEnemy.global_position)
				entity.attack_ranged()
		State.ATTACK_RANGE_SMART:
			if closestEnemy != null:
				velocity = entity.stop_moving()
				entity.set_target(closestEnemy.global_position)
				entity.attack_ranged()
		State.ATTACK_MELEE:
			if closestEnemy != null:
				velocity = entity.stop_moving()
				entity.set_target_melee(get_closest_enemy())
				entity.attack_melee()
		State.ATTACK_MELEE_CHARGE:
			if closestEnemy != null:
				canChangeState = false
				# Force charge to completion
				velocity = entity.charge_toward(attackLocation)
				var distanceToChargeLocation : float = global_position.distance_squared_to(attackLocation)
				var minimalDistance : float = 10.0
				# Stop charge close to end location
				if distanceToChargeLocation < minimalDistance:
					# Deal charge damage to closest enemy
					if !nearbyEnemies.is_empty():
						entity.set_target_melee(get_closest_enemy())
						entity.attack_charge()
					canChangeState = true
					choose_state()
		State.APPROACH_ENEMY:
			if closestEnemy != null:
				velocity = entity.velocity_toward(closestEnemy.global_position)
				entity.set_target(closestEnemy.global_position)
				entity.move_and_slide()
				choose_state()
#endregion


func _on_character_detection_body_entered(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		nearbyEnemies.append(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()


func _on_character_detection_body_exited(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		nearbyEnemies.erase(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()



func _on_melee_range_body_entered(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		enemiesInMeleeRange.append(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()


func _on_melee_range_body_exited(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		enemiesInMeleeRange.erase(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()


func _on_ranged_range_body_entered(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		enemiesInRangedRange.append(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()


func _on_ranged_range_body_exited(body : CharacterBody2D) -> void:
	if body == self:
		pass
	if body.has_method("get_team") and body.get_team() != entity.team:
		enemiesInRangedRange.erase(body)
		closestEnemy = get_closest_enemy()
		if canChangeState:
			choose_state()
