extends Node3D

const MAIN = preload("uid://o4p3bjwyo7r2")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

func _on_button_pressed() -> void:
	animation_player.play("FadeIn")
	audio_stream_player_2.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeIn":
		get_tree().change_scene_to_packed(MAIN)
