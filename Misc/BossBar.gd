extends ProgressBar

var entity : LivingEntity

func _init():
	GameEvents.connect("boss_spawned", self, "_on_boss_spawned")

func _on_boss_spawned(boss):
	entity = boss.get_node("LivingEntity")
	
	entity.connect("entity_hurt", self, "_on_entity_hurt")
	max_value = entity.maximum_health
	value = entity.health
	show()

func _on_entity_hurt():
	value = entity.health
