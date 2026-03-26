extends Node3D

const MAIN = preload("uid://o4p3bjwyo7r2")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_button_pressed() -> void:
	animation_player.play("FadeIn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeIn":
		get_tree().change_scene_to_packed(MAIN)
