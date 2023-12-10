extends Node

# Player Signals
signal PlayerDied
signal PlayerReceivedDamage

# Game Signals
signal GameOverSignal
signal RestartFromCheckpointSignal
signal LevelChangedSignal

# Variables

var time = 0
var is_paused = false
var player: Player

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

func set_player(new_player: Player):
	player = new_player

func show_damage_flash(sprite: AnimatedSprite2D):
	var material = sprite.material
	if material.has_method("set_shader_parameter"):
		material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.08).timeout
		material.set_shader_parameter("active", false)
