extends PlayerState

@export var attack_reset_timer: Timer
@export var hitbox_component: HitboxComponent

var attack_in_progress = false
var current_attack_animation = 0

## Names of the animations to trigger in attack combo
var attack_animations = [
	"attack_1",
	"attack_2",
	"attack_3",
	"attack_4",
]

func _ready():
	attack_reset_timer.timeout.connect(transition_to_idle)

func physics_update(delta):
	player.gravity(delta)
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, 5)
	if player.attack_input:
		handle_attack()

func enter_state():
	current_attack_animation = 0
	handle_attack()

func exit_state():
	attack_reset_timer.stop()

func handle_attack():
	var sprite = player.sprite as AnimatedSprite2D
	if attack_in_progress:
		return

	# check if we have a valid queued attack
	if attack_animations.size() > current_attack_animation:
		attack_in_progress = true
		attack_reset_timer.stop()
		# Begin attack sequence
		sprite.play(attack_animations[current_attack_animation])
		hitbox_component.attack()
		current_attack_animation += 1
	else:
		transition_to_idle()
	await sprite.animation_finished
	attack_in_progress = false
	attack_reset_timer.start()

func transition_to_idle():
	Transitioned.emit(self, "idle")
