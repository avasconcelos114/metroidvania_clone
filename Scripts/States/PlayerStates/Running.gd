extends PlayerState

@export var WallSlideCooldown: Timer

func physics_update(delta):
	player.gravity(delta)
	player_movement()

	if player.attack_input:
		player.sprite.stop()
		Transitioned.emit(self, "attacking")
	elif player.is_on_wall_only() and player.velocity.y > 0 and player.wall_slide_unlocked and WallSlideCooldown.is_stopped():
		player.is_double_jumping = true
		Transitioned.emit(self, "wallslide")
	elif player.movement_input == 0:
		Transitioned.emit(self, "idle")
	elif player.jump_input_actuation:
		Transitioned.emit(self, "jumping")
	elif player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func enter_state():
	player.sprite.play("run")
	super.enter_state()
