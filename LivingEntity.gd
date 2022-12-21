class_name LivingEntity
extends Area2D

export var health : int = 10
export var invincibility_duration : float = 1
export var is_hostile : bool = true
onready var tween = $GetBigger
export var death_size_multiplier = 3

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

var is_dying = false
func die():
		if is_dying: return
		else: is_dying = true
		get_tree().paused = true
		var parent = get_parent()
		parent.animations.playing = false
		
		tween.interpolate_property(
				parent,
				"scale",
				parent.scale,
				parent.scale * death_size_multiplier,
				2,
				Tween.TRANS_BOUNCE,
				Tween.EASE_IN_OUT
		)
		tween.start()


func _on_GetBigger_tween_all_completed():
	get_parent().queue_free()

