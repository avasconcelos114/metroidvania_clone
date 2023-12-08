extends PlayerState

@export var slipthrough_timer: Timer
@export var standing_hurtbox: HurtboxComponent
@export var crouching_hurtbox: HurtboxComponent
@export var standing_collision: CollisionShape2D
@export var crouching_collision: CollisionShape2D

func _ready():
	slipthrough_timer.timeout.connect(enable_slipthrough_collision)

func physics_update(delta):
	player.gravity(delta)
	player_movement()
	player.velocity.x = player.velocity.x / 2
	if player.jump_input_actuation:
		disable_slipthrough_collision()
		slipthrough_timer.start()
	if not player.crouch_input:
		Transitioned.emit(self, "idle")

func enter_state():
	standing_hurtbox.is_enabled = false
	standing_collision.disabled = true
	crouching_hurtbox.is_enabled = true
	crouching_collision.disabled = false
	player.sprite.play("crouch")
	super.enter_state()

func exit_state():
	standing_hurtbox.is_enabled = true
	standing_collision.disabled = false
	crouching_hurtbox.is_enabled = false
	crouching_collision.disabled = true

func disable_slipthrough_collision():
	player.set_collision_layer_value(4, false)
	player.set_collision_mask_value(4, false)

func enable_slipthrough_collision():
	player.set_collision_layer_value(4, true)
	player.set_collision_mask_value(4, true)
