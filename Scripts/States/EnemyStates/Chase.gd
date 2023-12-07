extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var navigation_agent: NavigationAgent2D

func enter_state():
	sprite.play("walk")

	if not enemy.health_component.DiedEvent.is_connected(transition_to_death):
		enemy.health_component.DiedEvent.connect(transition_to_death)
	if not navigation_agent.velocity_computed.is_connected(set_enemy_velocity):
		navigation_agent.velocity_computed.connect(set_enemy_velocity)

func exit_state():
	navigation_agent.velocity_computed.disconnect(set_enemy_velocity)

func transition_to_death():
	Transitioned.emit(self, "death")

func set_enemy_velocity(new_velocity):
	enemy.velocity = new_velocity

func physics_update(_delta):
	var distance = Global.player.global_position - enemy.global_position
	navigation_agent.set_target_position(Global.player.global_position)
	
	if distance.length() > enemy.aggro_distance:
		Transitioned.emit(self, "idle")
		return

	if distance.length() < enemy.attack_range:
		Transitioned.emit(self, "attack")
		return

	var new_position = navigation_agent.get_next_path_position()
	var direction = new_position - enemy.global_position
	direction = direction.normalized()
	if navigation_agent.is_target_reachable():
		# Only move if the target can be reached
		# enemy.velocity = direction * enemy.speed
		navigation_agent.set_velocity(direction * enemy.speed)
		if direction.x != 0:
			enemy.last_direction = direction.x
		sprite.play("walk")
	else:
		navigation_agent.set_velocity(Vector2.ZERO)
		sprite.play("default")
