extends Node2D

export var bullet : PackedScene
export var target_path : NodePath

export var clock_rate : float
export var clock_noise : float

export var burst_rate : float
export var burst_noise : float
export var burst_power : float

export var spread_arc : float
export var spread_noise : float
export var spread_power : float

export var pressure : float
export var pressure_noise : float

var clock_timer = 0
var burst_timer = 0
var burst_counter = 0

var is_in_burst = false

onready var target = get_node(target_path)

func _process(delta):
	if is_in_burst:
		if burst_counter > burst_power:
			burst_counter = 0
			is_in_burst = false
		
		burst_timer += delta
		if burst_timer > burst_timer:
			shoot()
			burst_counter += 1
	
	clock_timer += delta
	if clock_timer > clock_rate:
		shoot()
		clock_timer = 0
		burst_counter = 1
		is_in_burst = true

func shoot():
	for i in range(spread_power):
		var rotation_offset = i * spread_arc / (spread_power - 1) - spread_arc / 2 if spread_power != 1 else 0
		shoot_bullet(rotation_offset)

func shoot_bullet(rotation_offset : float):
	var vector = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized()
	var new_bullet : EnemyBullet = bullet.instance()
	
	new_bullet.position = global_position
	new_bullet.vector = vector
	new_bullet.rotation = rotation
	get_parent().get_parent().add_child(new_bullet)

