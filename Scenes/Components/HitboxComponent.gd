extends Area2D
class_name HitboxComponent

signal SendAttack

@export var damage_stats: DamageStats
@export var should_autoattack := false

func _ready():
	area_entered.connect(_on_area_entered)

func attack():
	var damage = calculate_damage()
	emit_signal("SendAttack", damage)

func _on_area_entered(area):
	if should_autoattack:
		attack()

func calculate_damage():
	var min = floor(damage_stats.base_damage - (damage_stats.base_damage * 0.2)) 
	var max = ceil(damage_stats.base_damage + (damage_stats.base_damage * 0.2)) 
	return randi_range(min, max)
