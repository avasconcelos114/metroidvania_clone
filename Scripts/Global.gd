extends Node

# Game Signals
signal StartGameSignal
signal GameOverSignal
signal RestartFromCheckpointSignal

# Variables
var time = 0
var is_paused = false

# Methods
func _physics_process(delta):
	if is_paused:
		time = 0
	else:
		time = delta

	# Toggle pause state only when a level is active
	if Input.is_action_just_pressed("pause"):
		is_paused = !is_paused

func set_pause_game(new_is_paused):
	is_paused = new_is_paused

func show_damage_flash(sprite: AnimatedSprite2D):
	var material = sprite.material
	if material.has_method("set_shader_parameter"):
		material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.08).timeout
		material.set_shader_parameter("active", false)

func calculate_sine_wave(
	amplitude: float,
	time: float,
	period: float,
	vertical_shift: float):
	return amplitude * sin(time * period) + vertical_shift
