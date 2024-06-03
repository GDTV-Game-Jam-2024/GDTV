extends Control


func _on_button_press_play() -> void:
	go_to_scene("res://Scenes/game.tscn")


func go_to_scene(scene : String) -> void:
	get_tree().change_scene_to_file(scene)


func _on_button_pressed_options() -> void:
	print("Options button pressed")
	pass # Replace with function body.


func _on_button_pressed_credits() -> void:
	go_to_scene("res://Scenes/credits.tscn")
	pass # Replace with function body.
