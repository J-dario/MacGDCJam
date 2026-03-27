extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var voice: AudioStreamPlayer = $Voice
@onready var ui_anim: AnimationPlayer = $UIAnim
@onready var subtitles: RichTextLabel = $CanvasLayer/Subtitles
@onready var next_arrow: Sprite2D = $CanvasLayer/Subtitles/NextArrow

@onready var choice_1: Button = $CanvasLayer/Choice1
@onready var choice_2: Button = $CanvasLayer/Choice2
@onready var sub_viewport: SubViewport = $Choices/HBoxContainer/SubViewportContainer/SubViewport
@onready var sub_viewport_2: SubViewport = $Choices/HBoxContainer/SubViewportContainer2/SubViewport2
@onready var h_box_container: HBoxContainer = $Choices/HBoxContainer
@onready var main_viewport: SubViewport = $MainScene/MainViewport

var gameStart = false
var canContinue = false
var firstChoiceMade = false
var choice = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftClick") and canContinue:
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
	subtitles.append_text(text)
	subtitles.pop()

func endText():
	subtitles.hide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeFromBlack" and !gameStart:
		gameStart = true
		#animation_player.play("Intro")
		
		animation_player.play("Contradictions")
		#animation_player.seek(25, true)
	elif anim_name == "CoffeeChoice" or anim_name == "TeaChoice":
		animation_player.play("Burger")
	elif anim_name == "Burger":
		animation_player.play("Contradictions")

func setCanContinue(state: bool):
	canContinue = state

func _on_voice_finished() -> void:
	animation_player.pause()
	canContinue = true
	next_arrow.show()
	print(animation_player.current_animation_position)

func startChoice():
	ui_anim.play("CloseEyes")

func _on_ui_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "CloseEyes" and !firstChoiceMade:
		animation_player.play("QSExplain")
	if anim_name == "OpenEyes" and !firstChoiceMade:
		if choice:
			choice1()
		else:
			choice2()

func choice1():
	firstChoiceMade = true
	animation_player.play("CoffeeChoice")

func choice2():
	firstChoiceMade = true
	animation_player.play("TeaChoice")
	
func _on_choice_1_pressed() -> void:
	animation_player.stop()
	choice_1.hide()
	choice_2.hide()
	choice = true
	
	for child in main_viewport.get_children():
		child.queue_free()
	
	var scene = sub_viewport.get_child(0).duplicate()
	main_viewport.add_child(scene)
	ui_anim.play("OpenEyes")

func _on_choice_2_pressed() -> void:
	animation_player.stop()
	choice_1.hide()
	choice_2.hide()
	choice = false
	
	for child in main_viewport.get_children():
		child.queue_free()
	
	var scene = sub_viewport_2.get_child(0).duplicate()
	main_viewport.add_child(scene)
	ui_anim.play("OpenEyes")
