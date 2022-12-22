extends Node2D

export var bullet : PackedScene
export var target_path : NodePath

export var clock_rate : float
export var clock_noise : float

export var burst_rate : float
export var burst_noise : float

export var spread_arc : float
export var spread_noise : float
export var spread_power : float

export var pressure : float
export var pressure_noise : float

var clock_timer = 0
var burst_timer = 0

onready var target = get_node(target_path)

func _process(delta):
	clock_timer += delta
	if clock_timer > clock_rate:
		shoot()

func shoot():
	for i in range(spread_power):
		var rotation_offset = i * spread_arc / (spread_power - 1) - spread_arc / 2
		
		shoot_bullet(rotation_offset)

func shoot_bullet(rotation_offset : float):
	var vector = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized()
	var bullet: EnemyBullet = bullet.instance()
	
	bullet.position = position
	bullet.vector = vector
	bullet.rotation = rotation
	get_parent().add_child(bullet)

