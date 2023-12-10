extends CharacterBody2D
class_name BaseEnemy

@export var is_airborne := false
@export var movement_distance := 100
@export var health_component: HealthComponent
@export var aggro_distance := 150
@export var attack_range := 50
@export var speed := 50
@export var attack_frame := 1

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

var last_direction: float

func _init():
	self.last_direction = last_direction

func gravity(delta):
	if not is_on_floor() and not is_airborne:
		velocity.y = gravity_value * 0.3
