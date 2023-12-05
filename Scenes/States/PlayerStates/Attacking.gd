extends PlayerState

@export var attack_reset_timer: Timer

var can_chain_attack = false
var attack_in_progress = false
var current_attack_animation = 0
var attack_animations = [
	"attack_1",
	"attack_2",
	"attack_3",
	"attack_4",
]

func update(delta):
	player.gravity(delta)
	player_movement()

	if player.attack_input:
		handle_attack()

func enter_state():
	current_attack_animation = 0
	attack_reset_timer.timeout.connect(transition_to_idle)

func exit_state():
	attack_reset_timer.stop()

func handle_attack():
	if attack_in_progress:
		return

	# check if we have a valid queued attack
	if attack_animations.size() > current_attack_animation:
		attack_in_progress = true
		attack_reset_timer.stop()
		# Begin attack sequence
		player.sprite.play(attack_animations[current_attack_animation])
		current_attack_animation += 1
	else:
		transition_to_idle()
	await player.sprite.animation_finished
	attack_in_progress = false
	attack_reset_timer.start()

func transition_to_idle():
	Transitioned.emit(self, "idle")