extends BaseState
class_name PlayerState

@export var player: Player

func enter_state():
	if not player.health_component.DiedEvent.is_connected(transition_to_death):
		player.health_component.DiedEvent.connect(transition_to_death)

func transition_to_death():
	Transitioned.emit(self, "death")

func player_movement():
	# Normal movement
	player.velocity.x = move_toward(player.velocity.x, player.movement_input * player.SPEED, player.ACCELERATION)
	if player.movement_input != 0:
		player.last_direction = player.movement_input
