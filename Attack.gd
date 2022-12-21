class_name Attack
extends Area2D

export var damage : int = 1
export var is_hostile : bool = false

func on_hit():
	queue_free()
