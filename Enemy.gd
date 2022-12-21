extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite

func _process(delta):
	animated_sprite.play("default")
	#animated_sprite.frames.set_animation_loop("default")
	pass
