extends Node

# Player Signals
signal PlayerDied
signal PlayerReceivedDamage

# Game Signals
signal GameOverSignal
signal RestartFromCheckpointSignal

# Variables
enum Levels {
	Level1,
	Level2,
	Level3,
}

var time = 0
var is_paused = false

var current_level: Levels
var camera: Camera2D
var player: Player

# Methods

func _physics_process(delta):
	if is_paused:
		time = 0
	else:
		time = delta

	# Toggle pause state only when a level is active
	if current_level != null and Input.is_action_just_pressed("pause"):
		is_paused = !is_paused

func set_pause_game(new_is_paused):
	is_paused = new_is_paused

func set_player(new_player: Player):
	player = new_player

func set_camera(new_camera: Camera2D):
	camera = new_camera

func set_level(new_level: Levels):
	current_level = new_level
