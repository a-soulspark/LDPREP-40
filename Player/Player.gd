extends KinematicBody2D

signal pull_slimes

export var SPEED: int = 10000
export var slime_count: int = 1
export var pull_duration: float = 1
export var walk_animation_name = "walk"
export var walk_forward_animation_name = "walk_forward"
export var walk_up_animation_name = "walk_up"
export var idle_animation_name = "idle"
onready var animations: AnimatedSprite = $Animations

var jumping = false
var is_aiming = false
var is_pulling = false
var pull_tween : SceneTreeTween

func _ready():
	for _i in range(slime_count):
		call_deferred("spawn_slime")

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		animations.flip_h = false
	
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
		animations.flip_h = true
	
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if Input.is_action_just_pressed("debug_spawn"):
		spawn_slime()
	
	if Input.is_action_just_pressed("throw"):
		if len(slime_list) > 0:
			start_aim_slime()
		else:
			start_pull_slimes()
	
	if Input.is_action_just_released("throw"):
		if is_aiming:
			throw_slime()
		else:
			cancel_pull_slimes()
	
	if is_aiming:
		$Line2D/RayCast2D.look_at(get_global_mouse_position())
		$Line2D/RayCast2D.force_raycast_update()
		var hit_pos = $Line2D/RayCast2D.get_collision_point()
		$Line2D.set_point_position(1, hit_pos - $Line2D.global_position)
	
	if jumping:
		var progress = float(animations.frame) / animations.frames.get_frame_count(animations.animation)
		animations.position.y = -abs(sin(progress * PI)) * 2
	
	if velocity.length() == 0:
		if jumping and animations.frame == 0:
			jumping = false
			animations.speed_scale = 0.75
	else:
		if not jumping:
			jumping = true
			animations.frame = 0
			animations.speed_scale = 1
			play_walk_animation(velocity)
		else:
			var frame = animations.frame
			play_walk_animation(velocity)
			animations.frame = frame
	
	velocity = velocity.normalized() * SPEED * delta
	if is_pulling:
		velocity *= 0.2
	
	move_and_slide(velocity)

func play_walk_animation(input):
	if input.y == 0: animations.play(walk_animation_name)
	elif input.y > 0: animations.play(walk_forward_animation_name)
	else: animations.play(walk_up_animation_name)

export var slime_scene: PackedScene = null
var slime_list = []

func spawn_slime():
	var slime = slime_scene.instance()
	slime.position = position
	slime.player = self
	slime.follow_index = len(slime_list)
	slime.connect("slime_hurt", $LivingEntity, "_on_area_entered")
	connect("pull_slimes", slime, "pull")
	
	slime_list.append(slime)
	get_parent().add_child(slime)
	get_parent().move_child(slime, get_position_in_parent())

var is_throwing = false

func start_aim_slime():
	is_aiming = true
	$Line2D.visible = true

func throw_slime():
	if len(slime_list) == 0: return
	if is_throwing: return
	is_throwing = true

	is_aiming = false
	$Line2D.visible = false
	
	var slime_to_throw = slime_list.pop_front()
	
	for i in range(len(slime_list)):
		slime_list[i].follow_index = i
	
	slime_to_throw.throw(get_global_mouse_position())
	slime_to_throw.connect("slime_returned", self, "_on_slime_hit", [slime_to_throw], CONNECT_ONESHOT)
	yield(get_tree().create_timer(0.5), "timeout")
	is_throwing = false

func _on_slime_hit(slime):
	slime.follow_index = len(slime_list)
	slime_list.append(slime)
	#is_throwing = false

func start_pull_slimes():
	pull_tween = get_tree().create_tween()
	pull_tween.tween_callback(self, "finish_pull_slimes").set_delay(pull_duration)
	is_pulling = true

func finish_pull_slimes():
	emit_signal("pull_slimes")
	spawn_slime()
	is_pulling = false

func cancel_pull_slimes():
	if is_pulling:
		pull_tween.stop()
		is_pulling = false
