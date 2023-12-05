extends Node2D
class_name Dash

@export var dash_delay = 0.4
@export var ghost_timer_duration = 0.04
@export var player: Player

@onready var dash_timer = $DashTimer
@onready var ghost_timer = $GhostTimer
@onready var dash_ghost = load("res://Scenes/Skills/Dash/DashGhost.tscn")

var can_dash = true
var is_forwards = true
var flip_sprite = false

func _ready():
	ghost_timer.timeout.connect(instantiate_ghost)

func start_dash(is_forwards, flip_sprite, duration):
	self.is_forwards = is_forwards
	self.flip_sprite = flip_sprite
	# Set timer settings
	ghost_timer.wait_time = ghost_timer_duration
	dash_timer.wait_time = duration
	
	# Rig ghost instancing
	instantiate_ghost()
	
	# Begin timers
	dash_timer.start()
	ghost_timer.start()

func instantiate_ghost():
	var ghost = dash_ghost.instantiate()
	ghost.global_position = player.global_position
	ghost.is_forwards = is_forwards
	ghost.should_flip_sprite = flip_sprite
	get_tree().root.add_child(ghost)

func is_dashing():
	return !dash_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	can_dash = false
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true

func _on_dash_timer_timeout():
	end_dash()
