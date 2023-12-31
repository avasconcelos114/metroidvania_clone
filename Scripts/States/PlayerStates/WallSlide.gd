extends PlayerState

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var WallSlideCooldown: Timer
@export var gravity_modifier := 1.5

func physics_update(delta):
	player.velocity.y = gravity_value * delta * gravity_modifier
	player_movement()

	if player.is_on_floor() or not player.is_on_wall_only():
		Transitioned.emit(self, "idle")

func enter_state():
	player.is_wall_sliding = true
	player.sprite.play("dash_forwards")
	super.enter_state()

func exit_state():
	player.is_wall_sliding = false
	WallSlideCooldown.start()
