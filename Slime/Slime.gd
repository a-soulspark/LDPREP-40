extends KinematicBody2D

onready var animations = $Animations
func _ready():
	animations.play("idle")
