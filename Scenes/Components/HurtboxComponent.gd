extends Area2D
class_name HurtboxComponent

signal ReceivedHit

@export var health_component: HealthComponent
@export var armor_stats: ArmorStats

var hit_direction = 0

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	if area is HitboxComponent:
		hit_direction = global_position - area.global_position
		if area.should_autoattack:
			receive_hit(area.damage_stats.base_damage)
		else:
			area.SendAttack.connect(receive_hit)

func _on_area_exited(area):
	if area is HitboxComponent:
		area.SendAttack.disconnect(receive_hit)

func receive_hit(damage):
	if health_component.has_health_remaining():
		health_component.take_damage(damage)
		emit_signal("ReceivedHit", hit_direction)
