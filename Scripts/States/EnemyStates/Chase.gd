extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var navigation_agent: NavigationAgent2D

func enter_state():
	sprite.play("walk")

func exit_state():
	sprite.stop()

func physics_update(delta):
	var distance = Global.player.global_position - enemy.global_position
	if distance.length() > enemy.aggro_distance:
		Transitioned.emit(self, "idle")

	if distance.length() < enemy.attack_range:
		Transitioned.emit(self, "attack")

	navigation_agent.target_position = Global.player.global_position
	var new_position = navigation_agent.get_next_path_position()
	var direction = new_position - enemy.global_position
	direction = direction.normalized()

	if direction.x != 0:
		enemy.last_direction = direction.x

	enemy.velocity = direction * enemy.speed
