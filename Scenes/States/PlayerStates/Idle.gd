extends PlayerState

func update(delta):
	player.gravity(delta)
	player_movement()

	if player.attack_input:
		Transitioned.emit(self, "attacking")
	if player.movement_input != 0:
		Transitioned.emit(self, "running")
	if player.jump_input_actuation:
		Transitioned.emit(self, "jumping")
	if player.crouch_input:
		Transitioned.emit(self, "crouching")
	#if Player.velocity.y >0:
	#	Transitioned.emit(self, "falling")
	#if player.dash_input and player.can_dash:
	#	Transitioned.emit(self, "dashing")
	return null

func enter_state():
	call_deferred("run_animation")

func run_animation():
	player.sprite.play("default")
