extends Area2D
class_name HurtboxComponent

signal ReceivedHit

@export var health_component: HealthComponent
@export var armor_stats: ArmorStats
@export var is_enabled := true

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
	if area is HitboxComponent and area.SendAttack.is_connected(receive_hit):
		area.SendAttack.disconnect(receive_hit)

func receive_hit(damage):
	if health_component.has_health_remaining() and is_enabled:
		health_component.take_damage(damage - armor_stats.armor)
		emit_signal("ReceivedHit", hit_direction)
