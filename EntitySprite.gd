extends Node2D

var tween : Tween

func _ready():
	tween = Tween.new()
	add_child(tween)


func _flash_amount(amount : float):
	(material as ShaderMaterial).set_shader_param("flash_amount", amount)

func _on_entity_hurt():
	tween.interpolate_method(self, "_flash_amount", 1, 0, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
