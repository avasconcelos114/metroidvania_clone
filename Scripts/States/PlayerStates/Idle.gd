extends PlayerState

func physics_update(delta):
	player.gravity(delta)
	player_movement()

	if player.is_on_floor_only():
		player.is_double_jumping = false

	if player.attack_input:
		player.sprite.stop()
		Transitioned.emit(self, "attacking")
	elif player.movement_input != 0:
		Transitioned.emit(self, "running")
	elif player.jump_input_actuation:
		Transitioned.emit(self, "jumping")
	elif player.crouch_input:
		Transitioned.emit(self, "crouching")
	elif player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func enter_state():
	player.sprite.play("default")
	super.enter_state()
