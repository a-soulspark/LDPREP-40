extends Button

export var animation_weight = 0.5
export var out_of_sight_position_y = -2000

var _node_positions = []
func _ready():
	for child in self.get_children():
		_node_positions.append(child.rect_position)
		child.rect_position.y = out_of_sight_position_y

var _should_play_cool_animation = false
func _on_Settings_pressed():
	if self.get_child(0).rect_position.y >= _node_positions[0].y - 0.1:
		_should_play_cool_animation = false
		_current_node = 0
		for child in self.get_children():
			child.rect_position.y = out_of_sight_position_y
	else:
		_should_play_cool_animation = true
	
	
	

var _current_node = 0
func cool_animation():
	var _index = 0
	for child in self.get_children():
		if _index == _current_node:
			child.rect_position = lerp(child.rect_position, _node_positions[_current_node], animation_weight)
			if child.rect_position.y >= _node_positions[_current_node].y - 0.1: # Floats
				_current_node += 1
			return
		_index += 1
	_should_play_cool_animation = false
	_current_node = 0

func _process(delta):
	if _should_play_cool_animation:
		cool_animation()


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

