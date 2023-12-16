extends PlayerState

@export var hitbox_component: HitboxComponent
@export var attack_sound: AudioStreamPlayer
@export var attack_grunt_sounds: Array[AudioStream]
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
	if player.crouch_input:
		player.sprite.play("crouch_attack")
	else:
		player.sprite.play("attack")
	if not player.sprite.frame_changed.is_connected(process_attack):
		player.sprite.frame_changed.connect(process_attack)

	if not player.sprite.animation_finished.is_connected(complete_attack):
		player.sprite.animation_finished.connect(complete_attack)

func process_attack():
	if player.sprite.frame == 2:
		attack_sound.play()

		if randi_range(0, 10) >= 6:
			play_random_grunt()
			
		hitbox_component.attack()

func complete_attack():
	attack_in_progress = false

func play_random_grunt():
	var stream = attack_grunt_sounds[randi_range(0, attack_grunt_sounds.size() - 1)];
	var audio = AudioStreamPlayer.new()
	audio.stream = stream
	audio.finished.connect(audio.queue_free)
	add_child(audio)
	audio.play()
