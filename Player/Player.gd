extends KinematicBody2D

export var SPEED: int = 10000
export var walk_animation_name = "walk"
export var idle_animation_name = "idle"
onready var animations: AnimatedSprite =  $Animations

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
	
	if velocity.x == 0:
		animations.play(idle_animation_name)
	else:
		animations.play(walk_animation_name)
	
	velocity = velocity.normalized() * SPEED * delta
	
	move_and_slide(velocity)


export var slime_scene: PackedScene = null
var slime_list = []

func spawn_slime():
	var slime = slime_scene.instance()
	slime_list.append(slime)
	slime.position = position
	slime.player = self
	slime.follow_delay *= len(slime_list)
	get_parent().add_child(slime)

func _ready():
	animations.play()
