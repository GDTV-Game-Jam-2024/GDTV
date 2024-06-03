class_name UI
extends CanvasLayer

@onready var minimap : ColorRect = $Control/Minimap/MarginContainer/Map as ColorRect
@onready var manaText : Label = $Control/WeaponBar/Mana/ManaText as Label
@onready var weapon1 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var weapon2 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var weapon3 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var weapon4 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var weapon5 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var weapon6 : TextureRect = $Control/WeaponBar/Weapons/Weapon1 as TextureRect
@onready var timeLabel : Label = $Control/Timer as Label

var time : float = 0
var minutes : int = 0
var seconds : int = 0
var minimapSize : Vector2 = Vector2(1.0, 1.0)
var minimapUnits : Dictionary = {}
enum ENTITIES {PLAYER, ENEMY, PICKUP, SPAWNER}


func _physics_process(delta : float):
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	timeLabel.text = "%02d : %02d" % [minutes, seconds]


func _process(delta : float) -> void:
	for unit in minimapUnits:
		var markerPosition : Vector2 = unit.position * minimapSize
		minimapUnits[unit].position = markerPosition


func set_mana(value : int) -> void:
	manaText.text = str(value)


func set_minimap_dimension(valueX : float, valueY : float) -> void:
	var x : float = 1.0 / valueX
	var y : float = 1.0 / valueY
	minimapSize = Vector2(x, y)


func add_unit_to_minimap(unit : CharacterBody2D, type : ENTITIES) -> void:
	minimapUnits[unit] = type
	var marker : ColorRect = ColorRect.new()
	match type:
		ENTITIES.PLAYER:
			marker.color = Color.GREEN
		ENTITIES.ENEMY:
			marker.color = Color.RED
		ENTITIES.PICKUP:
			marker.color = Color.WHITE_SMOKE
		ENTITIES.SPAWNER:
			marker.color = Color.PURPLE
	minimap.add_child(marker)
	marker.size = Vector2(2, 2)
	minimapUnits[unit] = marker


func remove_unit_from_minimap(unit : CharacterBody2D) -> void:
	minimapUnits[unit].queue_free()
	minimapUnits.erase(unit)
