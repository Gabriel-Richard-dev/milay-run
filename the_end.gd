extends Control

func _on_button_pressed() -> void:
	call_deferred("load_next_scene")

func load_next_scene():
	Game.reset()
	get_tree().change_scene_to_file("res://initial_page.tscn")
