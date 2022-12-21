class_name LivingEntity
extends Area2D

export var health : int = 10
export var is_hostile : bool = true

func _on_area_entered(area):
	if not area is Attack: return
	
	var attack = area as Attack
	if attack.is_hostile != is_hostile:
		hurt(area.damage)
		attack.on_hit()

func hurt(damage : int):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
