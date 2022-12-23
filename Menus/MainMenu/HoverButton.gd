extends Button

var tween
var start_rect_width

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	$HoverSound.play()
	if not start_rect_width:
		start_rect_width = rect_size.x
	
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(self, "_set_width", rect_size.x, start_rect_width + 30, 0.2)

func _on_mouse_exited():
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_method(self, "_set_width", rect_size.x, start_rect_width, 0.2)

func _set_width(value):
	rect_size.x = value

func _pressed():
	$ClickSound.play()
