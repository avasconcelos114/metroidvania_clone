extends PlayerState

func update(delta):
	player.gravity(delta)
	player_movement()

	if player.is_on_floor():
		player.is_double_jumping = false
		Transitioned.emit(self, "idle")
	elif player.jump_input_actuation and not player.is_double_jumping:
		perform_jump()
		player.is_double_jumping = true
	#if Player.velocity.y >0:
	#	return STATES.FALL
	#if player.dash_input and player.can_dash:
	#	Transitioned.emit(self, "dashing")

func enter_state():
	player.sprite.play("jump")
	perform_jump()

func perform_jump():
	player.velocity.y = player.JUMP_VELOCITY
