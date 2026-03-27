extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var voice: AudioStreamPlayer = $Voice
@onready var ui_anim: AnimationPlayer = $UIAnim
@onready var subtitles: RichTextLabel = $CanvasLayer/Subtitles
@onready var next_arrow: Sprite2D = $CanvasLayer/Subtitles/NextArrow
@onready var schro: Node3D = $Schro
@onready var guy_2: Sprite2D = $UIAnim/Guy2

@onready var choice_1: Button = $CanvasLayer/Choice1
@onready var choice_2: Button = $CanvasLayer/Choice2
@onready var sub_viewport: SubViewport = $Choices/HBoxContainer/SubViewportContainer/SubViewport
@onready var sub_viewport_2: SubViewport = $Choices/HBoxContainer/SubViewportContainer2/SubViewport2
@onready var h_box_container: HBoxContainer = $Choices/HBoxContainer
@onready var main_viewport: SubViewport = $MainScene/MainViewport
const RESTAURANT = preload("uid://b08tic88yythe")
const END = preload("uid://njg2h23wadxi")

const RESTAURANT_SAVE = preload("uid://bild6g6wgujop")
const RESTAURANT_BEAT_UP = preload("uid://5qecpng4qhe")
@onready var guy: Sprite2D = $UIAnim/Guy

var gameStart = false
var canContinue = false
var firstChoiceMade = false
var secondChoiceMade = false
var choice = true
var savedLan = false
var goEnd = false
var endinf = false

func saved():
	savedLan = true

func fighted():
	savedLan = false

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
	if anim_name == "FadeFromBlack":
		if !gameStart:
			gameStart = true
			
			animation_player.play("Intro")
		elif endinf:
			if savedLan:
				animation_player.play("savedEnd")
			else:
				print("JEOIDOEIDEd")
				animation_player.play("FightEnd")
	
	elif anim_name == "FadeToBlack":
		if goEnd:
			get_tree().change_scene_to_packed(END)
		else:
			if savedLan:
				for child in main_viewport.get_children():
					child.queue_free()
				main_viewport.add_child(RESTAURANT.instantiate())
				schro.position = Vector3(-3.975, 0.774, -7.21)
				schro.rotation = Vector3.ZERO
				goEnd = true
				animation_player.play("FadeFromBlack")
			else:
				for child in main_viewport.get_children():
					child.queue_free()
				main_viewport.add_child(RESTAURANT.instantiate())
				schro.hide()
				guy_2.show()
				goEnd = true
				animation_player.play("FadeFromBlack")
	
	elif anim_name == "SaveChoice":
		animation_player.play("FadeToBlack")
		endinf = true
		savedLan = true
	elif anim_name == "FightChoice":
		animation_player.play("FadeToBlack")
		endinf = true
		savedLan = false
		
	elif anim_name == "CoffeeChoice" or anim_name == "TeaChoice":
		animation_player.play("Burger")
	elif anim_name == "Burger":
		animation_player.play("Contradictions")
	elif anim_name == "Contradictions":
		animation_player.play("Fight1")
	elif anim_name == "Fight1":
		sub_viewport.get_child(0).queue_free()
		sub_viewport_2.get_child(0).queue_free()
		
		sub_viewport.add_child(RESTAURANT_BEAT_UP.instantiate())
		sub_viewport_2.add_child(RESTAURANT_SAVE.instantiate())
		
		ui_anim.play("CloseEyes")
		
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
	if anim_name == "CloseEyes" and !firstChoiceMade and !secondChoiceMade:
		animation_player.play("QSExplain")
	elif anim_name == "OpenEyes" and !firstChoiceMade and !secondChoiceMade:
		if choice:
			choice1()
		else:
			choice2()
	elif anim_name == "SchroFall":
		ui_anim.play("Bounce")
	elif anim_name == "CloseEyes" and firstChoiceMade and !secondChoiceMade:
		guy.hide()
		animation_player.play("Fight2")
	elif anim_name == "OpenEyes" and firstChoiceMade and !secondChoiceMade:
		if choice:
			choice1()
		else:
			choice2()

func choice1():
	setCanContinue(false)
	if !firstChoiceMade:
		firstChoiceMade = true
		animation_player.play("CoffeeChoice")
	else:
		secondChoiceMade = true
		animation_player.play("FightChoice")

func choice2():
	setCanContinue(false)
	if !firstChoiceMade:
		firstChoiceMade = true
		animation_player.play("TeaChoice")
	else:
		secondChoiceMade = true
		animation_player.play("SaveChoice")
	
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
