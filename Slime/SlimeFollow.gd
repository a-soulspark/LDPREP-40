extends KinematicBody2D

class PositionSnapshot:
	var time : float
	var position : Vector2
	
	func _init(time, position):
		self.time = time
		self.position = position

export var player_path : NodePath
export var follow_delay : float

onready var player : KinematicBody2D = get_node(player_path)

var positions : Array = []
var target_position

func _ready():
	add_collision_exception_with(player)
	target_position = player.position

func _process(delta):
	if Input.is_action_pressed("ui_select"): return
	
	var current_time = Time.get_ticks_msec()
	positions.append(PositionSnapshot.new(current_time, player.position))
	
	for p in positions:
		if current_time > p.time + int(follow_delay * 1000):
			positions.erase(p)
			target_position = p.position
		else:
			break
	position = lerp(position, target_position, 0.075)
	look_at(target_position)

