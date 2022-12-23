extends Node2D

export var main_menu_scene: PackedScene
var _main_menu: MainMenu


func _input(event):
	if event.is_action_pressed("quit"):
		if !get_tree().paused:
			get_tree().paused = true
			_main_menu = main_menu_scene.instance()
			_main_menu.pause_mode = Node.PAUSE_MODE_PROCESS
			add_child(_main_menu)
		else:
			_main_menu.queue_free()
			get_tree().paused = false
