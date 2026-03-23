extends Node3D

const MAIN = preload("uid://o4p3bjwyo7r2")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)
