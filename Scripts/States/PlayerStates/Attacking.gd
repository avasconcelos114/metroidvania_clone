extends PlayerState

@export var hitbox_component: HitboxComponent

var attack_in_progress = true

func physics_update(delta):
	player.gravity(delta)
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, 5)
	if not attack_in_progress:
		Transitioned.emit(self, "idle")
	if player.dash_input_actuation and player.dash_unlocked and player.can_dash:
		Transitioned.emit(self, "dashing")

func enter_state():
	attack_in_progress = true
	handle_attack()
	super.enter_state()

func handle_attack():
	var sprite = player.sprite as AnimatedSprite2D
	# check if we have a valid queued attack
	sprite.play("attack_1")
	hitbox_component.attack()
	await sprite.animation_finished
	attack_in_progress = false
