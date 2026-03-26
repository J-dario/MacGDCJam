extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var voice: AudioStreamPlayer = $Voice
@onready var ui_anim: AnimationPlayer = $UIAnim
@onready var subtitles: RichTextLabel = $CanvasLayer/Subtitles
@onready var next_arrow: Sprite2D = $CanvasLayer/Subtitles/NextArrow

var gameStart = false
var canContinue = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick"):
		animation_player.play()

func nextVoice(audio: AudioStream, text: String, color: Color, volume: float = 0.0) -> void:
	canContinue = false
	next_arrow.hide()
	
	voice.stream = audio
	voice.volume_db = volume
	voice.play()
	subtitles.show()
	subtitles.clear()
	subtitles.push_color(color)
	subtitles.add_text(text)
	subtitles.pop()

func endText():
	subtitles.hide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeFromBlack" and !gameStart:
		animation_player.play("Intro")
		gameStart = true
		
		animation_player.seek(25, true)

func _on_voice_finished() -> void:
	animation_player.pause()
	canContinue = true
	next_arrow.show()
	print(animation_player.current_animation_position)

func startChoice():
	ui_anim.play("CloseEyes")
