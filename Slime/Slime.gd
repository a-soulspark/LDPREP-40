extends Area2D

signal slime_hurt
signal slime_returned

class PositionSnapshot:
	var time : float
	var position : Vector2
	
	func _init(time, position):
		self.time = time
		self.position = position

export var player_path : NodePath
export var follow_delay : float
export var throw_speed : float = 1000

onready var player : KinematicBody2D = get_node(player_path)

var target_position : Vector2
var follow_index : int
var positions : Array = []

var is_stuck = false
var is_thrown = false
var throw_direction : Vector2
var throw_momentum : float

onready var original_parent = get_parent()

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("area_entered", self, "_on_body_entered")
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
	
	if is_thrown:
		translate(throw_direction * throw_momentum * delta)
	elif not is_stuck:
		# Follow Player
		position = lerp(position, target_position, 0.3)
		$Animations.flip_h = position.x > target_position.x

func throw(target):
	is_thrown = true
	
	throw_direction = (target - global_position).normalized()
	look_at(target)
	rotate(PI / 2)
	
	# momentum
	$Tween.stop(self, "throw_momentum")
	$Tween.interpolate_property(self, "throw_momentum", throw_speed * 2, throw_speed * 0.2, 5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
	
	monitoring = true
	$Attack.set_deferred("monitorable", true)
	$Hitbox.monitoring = false
	$Animations.play("throw")
	$VulnerableTimer.stop()

func _on_body_entered(body):
	if not is_thrown: return
	
	call_deferred("stick_to_body", body)

func stick_to_body(body):
	if is_stuck: return
	
	var transf = global_transform
	get_parent().remove_child(self)
	body.add_child(self)
	global_transform = transf
	scale /= 2
	z_index = 2
	
	is_stuck = true
	is_thrown = false
	# get normal of collision perhaps
	rotation = 0
	# play other animation perhaps
	$Animations.play("stick")
	$Attack.monitorable = false
	monitoring = false

func pull():
	if not is_stuck: return

	var transf = global_transform
	get_parent().remove_child(self)
	original_parent.add_child(self)
	global_transform = transf
	scale *= 2
	z_index = 0
	
	rotation = 0
	is_stuck = false
	# Set $Hitbox.monitoring = true with a 1s delay
	$VulnerableTimer.start()
	$Animations.play("idle")
	emit_signal("slime_returned")

func _on_hitbox_entered(area):
	emit_signal("slime_hurt", area)
