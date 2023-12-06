extends BaseState

@export var enemy: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var navigation_agent: NavigationAgent2D
@export var patrol_timer: Timer

var move_direction : Vector2
var is_moving = false

func enter_state():
	# Randomize patrol duration by 1 sec
	patrol_timer.start()
	patrol_timer.timeout.connect(patrol_cycle)
	navigation_agent.velocity_computed.connect(set_enemy_velocity)

func exit_state():
	patrol_timer.stop()
	navigation_agent.velocity_computed.disconnect(set_enemy_velocity)

func physics_update(delta):
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = enemy.global_position.direction_to(next_path_position) * 50
	navigation_agent.set_velocity(new_velocity)
	play_animation()

func play_animation():
	if not navigation_agent.is_navigation_finished():
		sprite.play("walk")
	else:
		sprite.play("default")

func set_enemy_velocity(new_velocity):
	enemy.velocity = new_velocity

func patrol_cycle(): 
	# Get a random target location to move into if moving
	if is_moving:
		var new_position = enemy.global_position
		new_position.x = new_position.x + randf_range(-enemy.movement_distance, enemy.movement_distance)
		if enemy.is_airborne:
			new_position.y = new_position.y + randf_range(-enemy.movement_distance, enemy.movement_distance)
		navigation_agent.set_target_position(new_position)

	# Flip moving status so that the next turn the enemy either moves or stands still
	is_moving = !is_moving
