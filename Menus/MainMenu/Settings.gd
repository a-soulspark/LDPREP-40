extends Button

func _on_CheckBox_item_selected(index):
	if index == 0:
		OS.window_borderless = false
		OS.window_maximized = false
		OS.window_fullscreen = false
	if index == 1:
		OS.window_borderless = true
		OS.window_maximized = true
		OS.window_fullscreen = false
	if index == 2:
		OS.window_borderless = false
		OS.window_fullscreen = true

