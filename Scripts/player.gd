extends CharacterBody2D

signal projectile_shot(projectileName)
signal mana_changed(newMana)
signal no_mana
signal dead(who)

@export var movementSpeed : float = 300.0
@export var healthMax : int = 100
@export var healthCurrent : int = 100
@export var manaMax : int = 500.0
@export var manaCurrent : float = 300.0
@export var manaRegen : float = 100.0
@export var isAlive : bool = true
@export var isWalking : bool = false

@onready var weaponManager : Node2D = $WeaponManager as Node2D
@onready var manaBar : ProgressBar = $Mana_bar as ProgressBar

var team : String = "Player"
var moveVector : Vector2 = Vector2.ZERO
enum CARDINAL_DIRECTION {N, NE, E, SE, S, SW, W, NW}

# Wands that you have (index the same as in WeaponManager node)
var currentWands : Array[bool] = [false, false, false, false, false, false]
var selectedWand : int = 0
var canChangeWand : bool = true # Unable to change on wand cooldown to avoid exploits
enum WANDS {BASIC_WAND, FAST_WAND, SHOT_WAND, FIREBALL_WAND, SUPER_WAND, BFW}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#region wand init
	# Connect signals from all wands
	for wand in weaponManager.get_children():
		wand.connect("shotProjectile", _on_projectile_shot)
		wand.connect("outOfMana", _on_out_of_mana)
		wand.connect("canSwap", _on_can_swap)
		wand.connect("manaChanged", _on_mana_changed)
	# Remove all wands and add the basic wand
	for wand in currentWands.size():
		hide_wand(wand)
	add_wand(WANDS.BASIC_WAND)
	select_wand(WANDS.BASIC_WAND)
#endregion
	# initialize at center of screen
	position = Vector2(1280*1.5,720*1.5)
	update_mana_bar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	# receive move input
	if isAlive:
		moveVector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		# check if walking
		if moveVector == Vector2.ZERO:
			isWalking = false
		else:
			isWalking = true

		# sprite faces cursor
		var angle : float = (get_viewport().get_mouse_position() - position).angle()
		# set animation
		animate_sprite(angle, isWalking)


# Like _process, but called every physics frame (60fps)
func _physics_process(delta : float) -> void:
	if isAlive:
		# movement
		position += moveVector.normalized() * movementSpeed * delta
		
		# mana regen
		mana_gain(manaRegen*delta)


func _unhandled_input(event : InputEvent) -> void:
	# Choosing a wand by pressing 1-6 or scroll up/down.
	choose_wand_by_key(event)
	choose_wand_by_scroll(event)


func get_team() -> String:
	return team


#region Weapon functions
func choose_wand_by_key(event : InputEvent) -> void:
	var currentWand : WANDS = WANDS.BASIC_WAND
	match event:
		"wand1":
			currentWand = WANDS.BASIC_WAND
		"wand2":
			currentWand = WANDS.FAST_WAND
		"wand3":
			currentWand = WANDS.SHOT_WAND
		"wand4":
			currentWand = WANDS.FIREBALL_WAND
		"wand5":
			currentWand = WANDS.SUPER_WAND
		"wand6":
			currentWand = WANDS.BFW
	# If can swap and wand exists select it
	if currentWands[currentWand] and canChangeWand:
		select_wand(currentWand)
		selectedWand = currentWand


func choose_wand_by_scroll(event : InputEvent) -> void:
	var currentWand : WANDS = selectedWand
	# Limitation no looping from best to worst wand and in reverse
	if event.is_action_pressed("scrollUP"):
		# Check how many better wands there are
		var possibleBetterWands : int = currentWands.size() - selectedWand
		for index in possibleBetterWands:
			# Select first better wand
			if currentWands[selectedWand + index]:
				select_wand(selectedWand + index)
				return
	if event.is_action_pressed("scrollDOWN"):
		# Check how many better wands there are
		var possibleWorseWands : int = selectedWand
		for index in possibleWorseWands:
			# Select first worse wand
			if currentWands[selectedWand - index]:
				select_wand(selectedWand - index)
				return


func add_wand(wandNumber : WANDS) -> void:
	if !currentWands[wandNumber]:
		currentWands[wandNumber] = true


func select_wand(wandNumber : WANDS) -> void:
	hide_wand(selectedWand)
	unhide_wand(wandNumber)
	selectedWand = wandNumber
	# On selection refresh mana for the wand
	var weapon = weaponManager.get_child(wandNumber) as Wand
	weapon.set_mana(manaCurrent)


func hide_wand(wandNumber : WANDS) -> void:
	# Make wand invisible and stop all processing
	var modifiedWand : Wand = weaponManager.get_child(wandNumber)
	modifiedWand.visible = false
	modifiedWand.set_process(false)


func unhide_wand(wandNumber : WANDS) -> void:
	var modifiedWand : Wand = weaponManager.get_child(wandNumber)
	modifiedWand.visible = true
	modifiedWand.set_process(true)


func _on_projectile_shot(value : Projectile) -> void:
	canChangeWand = false
	projectile_shot.emit(value)


func _on_mana_changed(newMana : int) -> void:
	mana_spend(manaCurrent - newMana)
	mana_changed.emit(newMana)


func _on_out_of_mana() -> void:
	no_mana.emit()


func _on_can_swap() -> void:
	canChangeWand = true
#endregion


# Reduce health
func damage(amount : int) -> void:
	healthCurrent = healthCurrent - amount
	update_health_bar()
	Audio.play(Audio.playerHurt)
	# check if dead
	if healthCurrent <= 0:
		die()


# Increase health
func heal(amount : int) -> void:
	healthCurrent += amount
	update_health_bar()
	# prevent overheal
	if healthCurrent > healthMax:
		healthCurrent = healthMax


func die() -> void:
	isAlive = false
	dead.emit(self)


# send healthMax and healthCurrent to $Health_bar
func update_health_bar() -> void:
	$Health_bar.max_value = healthMax
	$Health_bar.value = healthCurrent


# gain mana
func mana_gain(amount : int) -> void:
	manaCurrent += amount
	# prevent overcap, just set to max
	if manaCurrent > manaMax:
		manaCurrent = manaMax
	var weapon : Wand = weaponManager.get_child(selectedWand) as Wand
	weapon.set_mana(manaCurrent)
	update_mana_bar()


# Reduce mana and update mana bar
func mana_spend(amount : int):
	manaCurrent -= amount
	update_mana_bar()


# send manaMax and manaCurrent to $Mana_bar
func update_mana_bar() -> void:
	manaBar.max_value = manaMax
	manaBar.value = manaCurrent



# convert radian to one of 8 cardinal directions
func angle_to_direction(angle : float):
	if abs(angle)<PI/8:
		return CARDINAL_DIRECTION.E
	if abs(angle)>PI*7/8:
		return CARDINAL_DIRECTION.W
	if angle>0:
		if angle<PI*3/8:
			return CARDINAL_DIRECTION.SE
		if angle<PI*5/8:
			return CARDINAL_DIRECTION.S
		if angle<PI*7/8:
			return CARDINAL_DIRECTION.SW
	else:
		if angle>PI*-3/8:
			return CARDINAL_DIRECTION.NE
		if angle>PI*-5/8:
			return CARDINAL_DIRECTION.N
		if angle>PI*-7/8:
			return CARDINAL_DIRECTION.NW


# pick which animation to show based on angle and isWalking
func animate_sprite(angle : float, isWalking : bool) -> void:
	var direction = angle_to_direction(angle)
	var walk_state : String = ""
	var enum_to_string_dict : Dictionary = {
		0: "N", 1: "NE", 2: "E", 3: "SE",
		4: "S", 5: "SW", 6: "W", 7: "NW"
	}
	
	if isWalking:
		walk_state = "Walk"
	else:
		walk_state = "Idle"
	var animation_name : String = walk_state + "_" + enum_to_string_dict[direction]
	$AnimatedSprite2D.play(animation_name)
	
