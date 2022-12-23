extends Node2D

signal paused
signal unpaused

export var main_menu_scene: PackedScene
var _main_menu: MainMenu

func _ready():
	modulate = Color.transparent

func _input(event):
	if event.is_action_pressed("quit"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func pause():
	get_tree().paused = true
	_main_menu = main_menu_scene.instance()
	_main_menu.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(_main_menu)
	
	_main_menu.activate_pause_menu()
	_main_menu.connect("resume_pressed", self, "resume")
	emit_signal("paused")

func resume():
	get_tree().paused = false
	_main_menu.fade_out()
	
	emit_signal("unpaused")

func game_over():
	set_process_input(false)
