extends PlayerState

func update(delta):
	player.gravity(delta)
	if not player.crouch_input:
		Transitioned.emit(self, "idle")

func enter_state():
	player.sprite.play("crouch")
