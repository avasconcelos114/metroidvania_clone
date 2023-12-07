extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var navigation_agent: NavigationAgent2D
@export var patrol_timer: Timer

var move_direction : float
var is_moving = false

func enter_state():
	# Randomize patrol duration by 1 sec
	patrol_timer.start()
	patrol_timer.timeout.connect(patrol_cycle)
	navigation_agent.velocity_computed.connect(set_enemy_velocity)
	enemy.health_component.DiedEvent.connect(transition_to_death)

func exit_state():
	patrol_timer.stop()
	navigation_agent.velocity_computed.disconnect(set_enemy_velocity)

func transition_to_death():
	Transitioned.emit(self, "death")

func physics_update(delta):
	handle_movement()

func handle_movement():
	if is_moving and not navigation_agent.is_navigation_finished():
		var new_position = navigation_agent.get_next_path_position()
		var direction = new_position - enemy.global_position
		direction = direction.normalized()
		if navigation_agent.is_target_reachable():
			# Only move if the target can be reached
			move_direction = direction.x
			enemy.velocity = direction * 50
			sprite.set_flip_h(move_direction < 0)
			sprite.play("walk")
			enemy.move_and_slide()
			return
	sprite.play("default")

func set_enemy_velocity(new_velocity):
	enemy.velocity = new_velocity

func patrol_cycle(): 
	# Get a random target location to move into if moving
	if is_moving:
		var new_position = enemy.global_position
		new_position.y = enemy.global_position.y
		new_position.x = new_position.x + randf_range(-enemy.movement_distance, enemy.movement_distance)
		if enemy.is_airborne:
			new_position.y = new_position.y + randf_range(-enemy.movement_distance, enemy.movement_distance)
		navigation_agent.set_target_position(new_position)
	is_moving = !is_moving
