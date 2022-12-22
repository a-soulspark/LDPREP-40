extends Control

onready var window = $VBoxContainer/Window/CheckBox
onready var settings_container = $VBoxContainer

func appear():
	self.visible = true
	self.mouse_filter = Control.MOUSE_FILTER_STOP

func change_position_to(position):
	settings_container.rect_global_position = position
