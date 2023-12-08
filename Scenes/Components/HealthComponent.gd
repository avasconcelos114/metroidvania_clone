extends Node2D
class_name HealthComponent

signal HealthChangedEvent
signal DiedEvent

@export var max_health := 100
var current_health
var has_died = false

func _ready():
	current_health = max_health

func has_health_remaining():
	return current_health > 0

func current_health_percent():
	return (current_health / max_health * 100) if has_health_remaining() else 0

func heal(health):
	take_damage(-health)

func take_damage(damage: float):
	if current_health - damage < 0:
		current_health = 0
	else:
		current_health -= damage
	emit_signal("HealthChangedEvent", current_health)

	if not has_health_remaining() and not has_died:
		has_died = true
		DiedEvent.emit()
