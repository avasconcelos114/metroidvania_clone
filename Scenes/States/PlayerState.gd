extends BaseState
class_name PlayerState

@export var player: Player

func player_movement():
	# Normal movement
	player.velocity.x = move_toward(player.velocity.x, player.movement_input * player.SPEED, player.ACCELERATION)
	if player.movement_input != 0:
		player.last_direction = player.movement_input
