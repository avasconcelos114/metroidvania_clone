extends CharacterBody2D
class_name BaseEnemy

@export var is_airborne := false
@export var movement_distance := 100
@export var health_component: HealthComponent
@export var aggro_distance := 150
@export var attack_range := 50
@export var speed := 50
@export var attack_frame := 1
@export var hit_knockback := 200
@export var knockback_acceleration := 50
@export var damage_label_position := Vector2(25, -25)

var damage_label_scn = preload("res://Scenes/Environmental/DamageLabel.tscn")

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_direction: float

func _init():
	self.last_direction = last_direction

func gravity(delta):
	if not is_on_floor() and not is_airborne:
		velocity.y = gravity_value * 0.3

func receive_hit(_direction, damage: float):
	var label = damage_label_scn.instantiate()
	label.position.x = global_position.x + damage_label_position.x
	label.position.y = global_position.y + damage_label_position.y
	get_tree().root.add_child(label)
	label.animate_label(damage)
