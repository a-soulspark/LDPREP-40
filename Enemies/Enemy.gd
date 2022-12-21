extends KinematicBody2D

export var bullet_speed = 10
export var attack_speed_secs = 2
export var attack0_number_bullets = 100
export var enemy_speed = 200.0

onready var animations = $AnimatedSprite
onready var tween = $Tween
func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		print(event.position)
		move_to(event.position, 1)

var attack_timer = attack_speed_secs
var bullets_timer = 0.0
var random_attack = null

func _process(delta):
	if attack_timer >= attack_speed_secs:
		random_attack = get_random_int(0,0)
		bullets_timer = 0.0
		attack_timer = 0.0
	
	if random_attack == 0 and attack_timer == 0.0:
		for bullet in range(0, attack0_number_bullets):
			var vector = Vector2.RIGHT.rotated(bullet * (360 / attack0_number_bullets)).normalized()
			var new_bullet = spawn_bullet(position, vector)
			new_bullet.rotation = bullet * (360 / attack0_number_bullets) + PI / 2
	
	attack_timer += delta
	
	

export var enemy_bullet_scene: PackedScene = null
 
func spawn_bullet(position, vector):
	var bullet: EnemyBullet = enemy_bullet_scene.instance()
	bullet.position = position
	bullet.vector = vector
	get_parent().add_child(bullet)
	return bullet

func get_random_int(low, high) -> int:
	var random = RandomNumberGenerator.new()
	random.randomize()
	return random.randi_range(low, high)

func move_to(move_to, time):
	tween.interpolate_property(
		self, 
		"position",
		position,
		move_to,
		time,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	tween.start()
