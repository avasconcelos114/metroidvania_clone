extends Area2D
class_name HurtboxComponent

signal ReceivedHit
signal InvulnerabilityTimerStarted

@export var health_component: HealthComponent
@export var armor_stats: ArmorStats
@export var is_enabled := true
@export var invulnerability_duration := 0.1
@onready var invulnerability_timer = $InvulnerabilityTimer

var hit_direction = 0

func _ready():
	invulnerability_timer.wait_time = invulnerability_duration
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	invulnerability_timer.timeout.connect(enable_hurtbox)
	InvulnerabilityTimerStarted.connect(disable_hurtbox)

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

func enable_hurtbox():
	is_enabled = true

func disable_hurtbox():
	is_enabled = false

func receive_hit(damage):
	var should_hit = randi_range(0, 99) >= armor_stats.evade
	if health_component.has_health_remaining() and is_enabled and should_hit:
		health_component.take_damage(damage - armor_stats.armor)
		emit_signal("ReceivedHit", hit_direction)
		invulnerability_timer.start()
		InvulnerabilityTimerStarted.emit()
	elif not should_hit:
		print("Miss")
