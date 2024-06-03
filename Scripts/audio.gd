extends Node

@onready var mainMusic : AudioStreamPlayer = $MainTheme as AudioStreamPlayer
@onready var playerShot : AudioStreamPlayer = $PlayerShot as AudioStreamPlayer
@onready var playerShotStrong : AudioStreamPlayer = $PlayerShotStrong as AudioStreamPlayer
@onready var playerHurt : AudioStreamPlayer = $PlayerHurt as AudioStreamPlayer
@onready var enemyDead : AudioStreamPlayer = $EnemyDead as AudioStreamPlayer
@onready var enemyHurt : AudioStreamPlayer = $EnemyHurt as AudioStreamPlayer
@onready var enemyMelee : AudioStreamPlayer = $EnemyMelee as AudioStreamPlayer
@onready var enemyShot : AudioStreamPlayer = $EnemyShot as AudioStreamPlayer
@onready var explosion : AudioStreamPlayer = $Explosion as AudioStreamPlayer

func _ready():
	play(mainMusic)


func play(sound : AudioStreamPlayer) -> void:
	sound.play()


func _on_main_theme_finished():
	play(mainMusic)
