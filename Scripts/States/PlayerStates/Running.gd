extends PlayerState

func physics_update(delta):
	player.gravity(delta)
	player_movement()
	
	if player.attack_input:
		player.sprite.stop()
		Transitioned.emit(self, "attacking")
	if player.movement_input == 0:
		Transitioned.emit(self, "idle")
	if player.jump_input_actuation:
		Transitioned.emit(self, "jumping")
	#if Player.velocity.y >0:
	#	Transitioned.emit(self, "falling")
	if player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func enter_state():
	player.sprite.play("run")
	super.enter_state()
