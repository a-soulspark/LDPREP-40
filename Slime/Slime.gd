extends Area2D

signal slime_hurt
signal slime_returned

class PositionSnapshot:
	var time : float
	var position : Vector2
	
	func _init(time, position):
		self.time = time
		self.position = position

const DUST_SCENE = preload("res://Slime/Dust.tscn")

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
var last_global_transform
var vulnerable_timer

onready var original_parent = get_parent()

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("area_entered", self, "_on_body_entered")
	target_position = player.position

func _physics_process(delta):
	var current_time = Time.get_ticks_msec()

	if is_instance_valid(player):
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
	
	if is_inside_tree():
		last_global_transform = global_transform

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
	
	var dust = DUST_SCENE.instance()
	get_parent().add_child(dust)
	
	dust.global_position = global_position
	dust.rotation = rotation
	dust.move_local_y(5)
	
func _on_body_entered(body):
	if not is_thrown: return
	
	call_deferred("stick_to_body", body)

func stick_to_body(body):
	if is_stuck: return
	
	reparent_to(body)
	z_index = 2
	
	translate(throw_direction)
	
	if not body.is_connected("tree_exiting", self, "pull"):
		body.connect("tree_exiting", self, "pull")
	
	is_stuck = true
	is_thrown = false
	# get normal of collision perhaps
	rotation = 0
	# play other animation perhaps
	$Animations.play("stick")
	$Attack.monitorable = false
	monitoring = false

func pull():
	if not is_stuck or not is_inside_tree(): return

	if get_parent().is_connected("tree_exiting", self, "pull"):
		get_parent().disconnect("tree_exiting", self, "pull")
	
	reparent_to(original_parent)
	z_index = 0
	
	rotation = 0
	is_stuck = false
	
	# Set $Hitbox.monitoring = true with a 1s delay
	$VulnerableTimer.start()
	$Animations.play("idle")
	emit_signal("slime_returned")

func reparent_to(node):
	if not node.is_inside_tree() or is_queued_for_deletion(): return
	
	get_parent().remove_child(self)
	node.add_child(self)
	global_transform = last_global_transform
	global_scale = Vector2.ONE

func _on_hitbox_entered(area):
	emit_signal("slime_hurt", area)
