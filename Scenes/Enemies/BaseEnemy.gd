extends CharacterBody2D
class_name BaseEnemy

@export var is_airborne := false
@export var movement_distance := 100

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	gravity(delta)
	move_and_slide()

func gravity(delta):
	if not is_on_floor() and not is_airborne:
		velocity.y += gravity_value * delta
