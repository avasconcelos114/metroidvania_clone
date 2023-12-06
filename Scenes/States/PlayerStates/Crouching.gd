extends PlayerState

@export var slipthrough_timer: Timer

func _ready():
	slipthrough_timer.timeout.connect(enable_slipthrough_collision)

func physics_update(delta):
	player.gravity(delta)
	if player.jump_input_actuation:
		disable_slipthrough_collision()
		slipthrough_timer.start()
	if not player.crouch_input:
		Transitioned.emit(self, "idle")

func enter_state():
	player.sprite.play("crouch")

func disable_slipthrough_collision():
	player.set_collision_layer_value(4, false)
	player.set_collision_mask_value(4, false)

func enable_slipthrough_collision():
	player.set_collision_layer_value(4, true)
	player.set_collision_mask_value(4, true)
