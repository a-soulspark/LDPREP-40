extends Control

onready var window = $VBoxContainer/Window/CheckBox
onready var settings_container = $VBoxContainer

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func appear():
	self.visible = true
	self.mouse_filter = Control.MOUSE_FILTER_STOP

func change_position_to(position):
	settings_container.rect_global_position = position

func _on_CheckBox_item_selected(index):
	if index == 0:
		OS.window_borderless = false
		OS.window_maximized = false
		OS.window_resizable = true
		OS.window_fullscreen = false
	if index == 1:
		OS.window_borderless = true
		OS.window_maximized = true
		OS.window_resizable = false	
		OS.window_fullscreen = false
	if index == 2:
		OS.window_borderless = false
		OS.window_fullscreen = true
