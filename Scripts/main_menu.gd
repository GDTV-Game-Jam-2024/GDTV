extends Control


func go_to_scene(scene : String) -> void:
	get_tree().change_scene_to_file(scene)


func _on_button_press_play() -> void:
	go_to_scene("res://Scenes/game.tscn")


func _on_button_pressed_options() -> void:
	go_to_scene("res://Scenes/UI/options.tscn")


func _on_button_pressed_credits() -> void:
	go_to_scene("res://Scenes/UI/credits.tscn")


func _on_exit_pressed():
	get_tree().quit()


func _on_about_pressed():
	go_to_scene("res://Scenes/UI/about.tscn")
