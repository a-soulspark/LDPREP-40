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

func _physics_process(delta):
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
		# Throw animation
		throw_timer -= delta
		rotation = (global_position - target_position).angle()
		rotate(PI / 2)
		
		if throw_timer / throw_duration < 0.5:
			throw_start = target_position
			$Animations.play("throw", true)
		
		position = lerp(throw_start, throw_target, ease(sin((1 - throw_timer / throw_duration) * PI), 0.75))
		if throw_timer <= 0:
			$VulnerableTimer.start(	)
			$Attack.monitorable = false
			rotation = 0
			$Animations.play("idle")
			emit_signal("slime_returned")
	else:
		# Follow Player
		position = lerp(position, target_position, 0.3)
		$Animations.flip_h = position.x > target_position.x

func throw(target):
	throw_timer = throw_duration
	throw_start = position
	throw_target = target
	look_at(throw_target)
	rotate(PI / 2)
	$Attack.monitorable = true
	monitoring = false
	$Animations.play("throw")
	$VulnerableTimer.stop()
