extends Area2D

signal slime_returned

class PositionSnapshot:
	var time : float
	var position : Vector2
	
	func _init(time, position):
		self.time = time
		self.position = position

export var player_path : NodePath
export var follow_delay : float
export var throw_duration : float = 1

onready var player : KinematicBody2D = get_node(player_path)

var follow_index : int
var positions : Array = []
var target_position
var throw_timer = 0
var throw_start : Vector2
var throw_target : Vector2

func _ready():
	target_position = player.position

func _process(delta):
	#modulate = Color.white * float($Attack.monitorable)

	var current_time = Time.get_ticks_msec()
	positions.append(PositionSnapshot.new(current_time, player.position))
	
	for p in positions:
		if current_time > p.time + int(follow_delay * (1 + follow_index) * 1000):
			positions.erase(p)
			target_position = p.position
		else:
			break
	
	if throw_timer > 0:
		throw_timer -= delta
		if throw_timer / throw_duration < 0.5:
			throw_start = target_position
			monitoring = false
		
		position = lerp(throw_start, throw_target, ease(sin((1 - throw_timer / throw_duration) * PI), 0.75))
		if throw_timer <= 0:
			monitoring = true
			$Attack.monitorable = false
			emit_signal("slime_returned")
	else:
		position = lerp(position, target_position, 0.075)
		look_at(target_position)

func throw(target):
	throw_timer = throw_duration
	throw_start = position
	throw_target = target
	$Attack.monitorable = true
