extends Camera2D


func shake(amount : float):
	$Tween.interpolate_method(self, "_shake_amount", amount, 0, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()

func _shake_amount(amount : float):
	offset = Vector2.RIGHT.rotated(randf() * PI * 2) * amount
