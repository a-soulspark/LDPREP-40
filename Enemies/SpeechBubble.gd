class_name SpeechBubble
extends Node2D

signal ended

export var time = 0.0
export var text = ""

onready var text_node = $Text
onready var timer = $Timer

func _ready():
	text_node.text = text
	timer.start(time)
	return self
