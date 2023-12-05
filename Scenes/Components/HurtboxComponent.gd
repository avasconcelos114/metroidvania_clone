extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func can_receive_attack():
	return health_component.has_health_remaining()

func _on_area_entered(area):
	if area is HitboxComponent:
		var damage = randf_range(area.min_damage, area.max_damage)
		health_component.take_damage(damage)
