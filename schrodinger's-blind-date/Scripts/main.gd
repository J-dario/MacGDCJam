extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var voice: AudioStreamPlayer2D = $Voice
@onready var subtitles: RichTextLabel = $Subtitles

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		animation_player.play("Intro")

func nextVoice(audio: AudioStream, text: String, color: Color) -> void:
	voice.stream = audio
	voice.play()
	subtitles.clear()
	subtitles.push_color(color)
	subtitles.add_text(text)
	subtitles.pop()
