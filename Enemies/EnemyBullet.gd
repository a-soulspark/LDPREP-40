class_name EnemyBullet
extends Node2D

export var vector: Vector2
export var bullet_speed = 3000.0
export var time_until_deletion: int

var timer = 0.0

func _physics_process(delta):
	translate(vector * bullet_speed * delta)
	timer += delta
	
	if timer > time_until_deletion:
		self.queue_free()


func _on_slime_hit_timer_timeout():
	$Attack.collision_mask |= 2
