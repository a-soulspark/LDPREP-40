extends KinematicBody2D

export var speed = 50
export var shooting_speed = 1
export var player_position: Vector2 = Vector2(100, 100)

var _velocity: Vector2 = Vector2.ZERO
func follow_player():
	_velocity = (player_position - position)
	if _velocity.length() < 2:
		_velocity = Vector2.ZERO
		return
	
	_velocity = _velocity.normalized() * speed
	look_at(player_position)

func _physics_process(delta):
	get_player_position()
	follow_player()
	attack(delta)
	move_and_slide(_velocity)

var _timer = 0
func attack(delta):
	if _timer >= shooting_speed:
		spawn_bullet()
		_timer = 0
	_timer += delta

export var enemy_bullet_scene: PackedScene
func spawn_bullet():
	if _velocity == Vector2.ZERO:
		return

	var direction = _velocity.angle()
	var vector = Vector2.RIGHT.rotated(direction).normalized()
	
	var bullet: EnemyBullet = enemy_bullet_scene.instance()
	bullet.position = position
	bullet.vector = vector
	bullet.rotation = rotation
	get_parent().add_child(bullet)

func get_player_position():
	player_position = $"../Player".position
