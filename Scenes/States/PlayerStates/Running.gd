extends PlayerState

func update(delta):
	player.gravity(delta)
	player_movement()
	
	if player.movement_input == 0:
		Transitioned.emit(self, "idle")
	if player.jump_input_actuation:
		Transitioned.emit(self, "jumping")
	#if Player.velocity.y >0:
	#	Transitioned.emit(self, "falling")
	#if player.dash_input and player.can_dash:
	#	Transitioned.emit(self, "dashing")
	return null

func enter_state():
	player.sprite.play("run")
