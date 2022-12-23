class_name MainMenu
extends Node

signal pause_menu_activated
signal resume_pressed

var fade_tween

func activate_pause_menu():
	emit_signal("pause_menu_activated")
	fade_in()

func _on_Start_pressed():
	Transition.change_scene("res://Enemies/EnemyTest.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Resume_pressed():
	emit_signal("resume_pressed")

func fade_in():
	$MenuRoot.rect_position = Vector2(-1024, 0)
	$MenuRoot/BackgroundFG/BackgroundBG.rect_position = Vector2(-1024, 0)
	fade_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	fade_tween.tween_property($MenuRoot, "rect_position", Vector2(), 0.2)
	fade_tween.parallel().tween_property($MenuRoot/BackgroundFG/BackgroundBG, "rect_position", Vector2(), 0.4)

func fade_out():
	fade_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade_tween.tween_property($MenuRoot, "rect_position", Vector2(-1024, 0), 0.4)
	fade_tween.parallel().tween_property($MenuRoot/BackgroundFG/BackgroundBG, "rect_position", Vector2(-1024, 0), 0.2)
	fade_tween.tween_callback(self, "queue_free")


func _on_ReturnToMenu_pressed():
	Transition.change_scene("res://Menus/MainMenu/MainMenu.tscn")
