extends PlayerState

@export var hitbox_component: HitboxComponent
@export var attack_sound: AudioStreamPlayer
var attack_in_progress = true

func physics_update(delta):
	player.gravity(delta)
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION)
	if not attack_in_progress:
		Transitioned.emit(self, "idle")
	if player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func exit_state():
	if player.sprite.frame_changed.is_connected(process_attack):
		player.sprite.frame_changed.disconnect(process_attack)

	if player.sprite.animation_finished.is_connected(complete_attack):
		player.sprite.animation_finished.disconnect(complete_attack)

func enter_state():
	attack_in_progress = true
	begin_attack()
	super.enter_state()

func begin_attack():
	player.sprite.play("attack")
	if not player.sprite.frame_changed.is_connected(process_attack):
		player.sprite.frame_changed.connect(process_attack)

	if not player.sprite.animation_finished.is_connected(complete_attack):
		player.sprite.animation_finished.connect(complete_attack)

func process_attack():
	if player.sprite.frame == 2:
		attack_sound.play()
		hitbox_component.attack()

func complete_attack():
	attack_in_progress = false
