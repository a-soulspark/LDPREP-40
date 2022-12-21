extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite
func _ready():
	pass

var animation_ended = true

func _process(delta):
	if !animation_ended:
		return

