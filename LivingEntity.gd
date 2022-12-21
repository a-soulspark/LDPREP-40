class_name LivingEntity
extends Area2D

export var health : int = 10
export var invincibility_duration : float = 1
export var is_hostile : bool = true

var invincibility_timer = 0

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _process(delta):
	if invincibility_timer > 0:
		invincibility_timer -= delta

func _on_area_entered(area):
	if invincibility_timer > 0 or not area is Attack: return
	
	var attack = area as Attack
	if attack.is_hostile != is_hostile:
		hurt(area.damage)
		attack.on_hit()

func hurt(damage : int):
	health -= damage
	invincibility_timer = invincibility_duration
	
	if health <= 0:
		die()

func die():
	get_parent().queue_free()
