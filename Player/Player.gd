extends KinematicBody2D

const SPEED = 3000.0
const WALK_ANIMATION_NAME = "walk"
onready var animations: AnimatedSprite =  $Animations

func _ready():
	animations.play()

func _input(event):
	if event.is_action_pressed("move_left"):
		animations.flip_h = true
	if event.is_action_pressed("move_right"):
		animations.flip_h = false

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED * delta
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED * delta
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED * delta
	
	if Input.is_action_pressed("move_down"):
		velocity.y += SPEED * delta
	
	if velocity == Vector2.ZERO:
		animations.play("idle")
	else:
		animations.play("walk")
	
	
	move_and_slide(velocity)
