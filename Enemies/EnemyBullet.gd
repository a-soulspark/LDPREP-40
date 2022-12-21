class_name EnemyBullet
extends KinematicBody2D

export var vector: Vector2
export var bullet_speed = 3000.0
export var time_until_deletion: int

var timer = 0.0
func _physics_process(delta):
	move_and_slide(vector * bullet_speed * delta)
	timer += delta
	
	if timer > time_until_deletion:
		self.queue_free()
	
