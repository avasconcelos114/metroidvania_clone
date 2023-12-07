extends CharacterBody2D
class_name BaseEnemy

@export var is_airborne := false
@export var movement_distance := 100
@export var health_component: HealthComponent

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

func gravity(delta):
	if not is_on_floor() and not is_airborne:
		velocity.y = gravity_value * 0.3
