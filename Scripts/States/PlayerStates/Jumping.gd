extends PlayerState

@export var WallSlideCooldown: Timer
@export var jump_sound: AudioStreamPlayer

func physics_update(delta):
	player.gravity(delta)
	player_movement()

	if player.attack_input:
		player.sprite.stop()
		Transitioned.emit(self, "attacking")
	elif player.is_on_floor():
		jump_sound.play()
		Transitioned.emit(self, "idle")
	elif player.is_on_wall_only() and player.velocity.y > 0 and player.wall_slide_unlocked and WallSlideCooldown.is_stopped():
		player.is_double_jumping = true
		Transitioned.emit(self, "wallslide")
	elif player.jump_input_actuation and not player.is_double_jumping:
		perform_jump()
		player.is_double_jumping = true
	elif player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func enter_state():
	player.sprite.play("jump")
	perform_jump()
	super.enter_state()

func perform_jump():
	player.velocity.y = player.JUMP_VELOCITY
