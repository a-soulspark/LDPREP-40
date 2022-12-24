extends Node

signal game_end
signal shake_camera
signal boss_spawned(boss)

func end_game():
	emit_signal("game_end")

func shake_camera(amount : float):
	emit_signal("shake_camera", amount)

func notify_boss_spawned(boss):
	emit_signal("boss_spawned", boss)
