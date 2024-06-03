extends Control

var fullscreen : bool = false
var volumes : Dictionary = {"Master" : 1.0, "SFX" : 1.0, "Music" : 1.0}

@onready var MasterButP : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMaster/Button1P" as Button
@onready var MasterButM : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMaster/Button1M" as Button
@onready var SFXButP : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeSFX/Button2P" as Button
@onready var SFXButM : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeSFX/Button2M" as Button
@onready var MusicButP : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMusic/Button3P" as Button
@onready var MusicButM : Button = $"PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMusic/Button3M" as Button
@onready var MasterLabel : Label = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMaster/Label2 as Label
@onready var SFXLabel : Label = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeSFX/Label2 as Label
@onready var MusicLabel : Label = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/VolumeMusic/Label2 as Label

func set_text(value : float, selectedLabel : Label) -> void:
	var percentValue : float = value * 100
	var newText : String = str(percentValue) + "%"
	selectedLabel.text = newText



func _on_check_button_pressed():
	fullscreen = !fullscreen
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_volume_changed(value : float, audio : String):
	value = clampf(volumes[audio] + value, 0, 1.3)
	volumes[audio] = value
	var index : int = AudioServer.get_bus_index(audio)
	var volume : float = linear_to_db(value)
	AudioServer.set_bus_volume_db(index, volume)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func _on_button_1m_pressed():
	_on_volume_changed(-0.1, "Master")
	set_text(volumes["Master"], MasterLabel)


func _on_button_1p_pressed():
	_on_volume_changed(0.1, "Master")
	set_text(volumes["Master"], MasterLabel)


func _on_button_2m_pressed():
	_on_volume_changed(-0.1, "SFX")
	set_text(volumes["SFX"], SFXLabel)


func _on_button_2p_pressed():
	_on_volume_changed(0.1, "SFX")
	set_text(volumes["SFX"], SFXLabel)


func _on_button_3m_pressed():
	_on_volume_changed(-0.1, "Music")
	set_text(volumes["Music"], MusicLabel)


func _on_button_3p_pressed():
	_on_volume_changed(0.1, "Music")
	set_text(volumes["Music"], MusicLabel)
