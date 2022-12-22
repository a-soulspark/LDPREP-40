extends Node2D

func _on_Start_pressed():
	Transition.change_scene("res://Enemies/EnemyTest.tscn")


func _on_Exit_pressed():
	get_tree().quit()

export var settings_position: Vector2
func _on_Options_pressed():
	Settings.appear()
	Settings.change_position_to(settings_position)
