extends Area2D
class_name HitboxComponent

signal SendAttack

@export var damage_stats: DamageStats
@export var should_autoattack := false

func _ready():
	area_entered.connect(_on_area_entered)

func attack():
	emit_signal("SendAttack", damage_stats.base_damage)

func _on_area_entered(area):
	if should_autoattack:
		attack()
