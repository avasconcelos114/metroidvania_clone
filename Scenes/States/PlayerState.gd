extends BaseState
class_name PlayerState

@export var player: Player

func player_movement():
	var speed = player.DASH_SPEED if player.dash.is_dashing() else player.SPEED
	# Normal movement
	if player.movement_input != 0:
		player.last_direction = player.movement_input
		player.velocity.x = move_toward(player.velocity.x, player.movement_input * speed, player.ACCELERATION)
	# backwards dash
	elif player.dash.is_dashing():
			player.velocity.x = move_toward(player.velocity.x, -player.last_direction * speed, player.ACCELERATION)
	else:
	# stand still
		player.velocity.x = move_toward(player.velocity.x, player.movement_input * speed, player.ACCELERATION)
