extends Node2D

onready var title_animation = $TitleAnimation
onready var hover_sound = $HoverSound
onready var click_sound = $ClickSound
onready var option_animation = $ColorRect/CoolOptionsAnimation
onready var sound_option = $ColorRect/label2/SoundSlider
onready var sound_label = $ColorRect/label2/value

export var default_sound = 80

func _ready():
	title_animation.play("FloatingTitle")
	option_animation.play("RESET")
	sound_option.value = default_sound
	sound_label.text =  str(default_sound)

func _on_Start_pressed():
	click_sound.play()
	Transition.change_scene("res://Enemies/EnemyTest.tscn")


func _on_Exit_pressed():
	click_sound.play()
	get_tree().quit()

func _on_TitleAnimation_animation_finished(anim_name):
	if anim_name == "FloatingTitle":
		title_animation.play("FloatingTitleBackwards")
	else:
		title_animation.play("FloatingTitle")

onready var start_animation = $Control/MainContainer/Start/AnimationPlayer
func _on_Start_mouse_entered():
	hover_sound.play()
	start_animation.play("hover")

func _on_Start_mouse_exited():
	start_animation.play_backwards("hover")

onready var settings_animation = $Control/MainContainer/Settings/AnimationPlayer
func _on_Settings_mouse_entered():
	hover_sound.play()
	settings_animation.play("hover")
func _on_Settings_mouse_exited():
	settings_animation.play_backwards("hover")

onready var exit_animation = $Control/MainContainer/Exit/AnimationPlayer
func _on_Exit_mouse_entered():
	hover_sound.play()
	exit_animation.play("hover")

func _on_Exit_mouse_exited():
	exit_animation.play_backwards("hover")

var _options = false
func _on_Settings_pressed():
	click_sound.play()
	if _options:
		option_animation.play_backwards("cool_animation")
		_options = false
	else:
		option_animation.play("cool_animation")
		_options = true


func _on_SoundSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value - 100)
	sound_label.text = str(int(value))
