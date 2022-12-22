extends Node2D

onready var title_animation = $TitleAnimation
func _ready():
	title_animation.play("FloatingTitle")

func _on_Start_pressed():
	Transition.change_scene("res://Enemies/EnemyTest.tscn")


func _on_Exit_pressed():
	get_tree().quit()

export var settings_position: Vector2
func _on_Options_pressed():
	Settings.appear()
	Settings.change_position_to(settings_position)

func _on_TitleAnimation_animation_finished(anim_name):
	if anim_name == "FloatingTitle":
		title_animation.play("FloatingTitleBackwards")
	else:
		title_animation.play("FloatingTitle")
