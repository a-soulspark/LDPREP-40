extends KinematicBody2D

export var SPEED: int = 10000
export var walk_animation_name = "walk"
export var walk_forward_animation_name = "walk_forward"
export var walk_up_animation_name = "walk_up"
export var idle_animation_name = "idle"
onready var animations: AnimatedSprite = $Animations

var jumping = false

func _input(event):
	pass

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
	
	if Input.is_action_just_pressed("ui_cancel"):
		spawn_slime()
	
	if Input.is_action_just_pressed("throw"):
		throw_slime()
	
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
	
	move_and_slide(velocity)

func play_walk_animation(input):
	if input.y == 0: animations.play(walk_animation_name)
	elif input.y > 0: animations.play(walk_forward_animation_name)
	else: animations.play(walk_up_animation_name)

export var slime_scene: PackedScene = null
var slime_list = []
var throwable_slimes = []

func spawn_slime():
	var slime = slime_scene.instance()
	slime_list.append(slime)
	throwable_slimes.append(slime)

	slime.position = position
	slime.player = self
	slime.follow_delay *= len(slime_list)
	slime.connect("area_entered", $LivingEntity, "_on_area_entered")
	get_parent().add_child(slime)

func throw_slime():
	if len(throwable_slimes) == 0: return
	
	var slime_to_throw = throwable_slimes.pop_back()
	
	slime_to_throw.throw(get_global_mouse_position())
	slime_to_throw.connect("hit", self, "_on_slime_hit", [slime_to_throw], CONNECT_ONESHOT)

func _on_slime_hit(slime):
	throwable_slimes.append(slime)
