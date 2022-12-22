extends Node2D

onready var buttons_animation = $ButtonAnimations
onready var title_animation = $TitleAnimation
onready var hover_sound = $HoverSound
onready var click_sound = $ClickSound

func _ready():
	title_animation.play("FloatingTitle")

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


func _on_Start_mouse_entered():
	buttons_animation.play("StartHoverAnimations")
	hover_sound.play()



func _on_Start_mouse_exited():
	buttons_animation.play_backwards("StartHoverAnimations")


func _on_Settings_mouse_entered():
	hover_sound.play()


func _on_Exit_mouse_entered():
	hover_sound.play()


func _on_Settings_pressed():
	click_sound.play()


