extends "res://Enemies/Enemy.gd"

func _ready():
	._ready()
	GameEvents.notify_boss_spawned(self)
