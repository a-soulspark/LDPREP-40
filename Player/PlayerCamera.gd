extends Camera2D

func _ready():
	GameEvents.connect("shake_camera", self, "shake")

func shake(amount : float):
	$Tween.interpolate_method(self, "_shake_amount", amount, 0, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()

func _shake_amount(amount : float):
	offset = Vector2.RIGHT.rotated(randf() * PI * 2) * amount

func _on_entity_free():
	var parent = get_parent()
	var transf = global_transform
	parent.remove_child(self)
	parent.get_parent().add_child(self)
	global_transform = transf
