extends PlayerState

@export var ghost_timer: Timer
@export var dash_timer: Timer
@export var cooldown_timer: Timer

@onready var dash_ghost = load("res://Scenes/Effects/DashGhost.tscn")
@onready var dash_texture_forward = load("res://Assets/Sprites/Character/DashForward.png")
@onready var dash_texture_backward = load("res://Assets/Sprites/Character/DashBackward.png")

func _ready():
	ghost_timer.timeout.connect(instantiate_ghost)
	dash_timer.timeout.connect(transition_to_idle)

func enter_state():
	ghost_timer.start()
	dash_timer.start()
	player.disable_dashing()
	super.enter_state()

func physics_update(_delta):
	if player.movement_input != 0:
		player.sprite.play("dash_forwards")
		player.velocity.x = move_toward(player.velocity.x, player.movement_input * player.DASH_SPEED, player.ACCELERATION)
	else:
		player.sprite.play("dash_backwards")
		player.velocity.x = move_toward(player.velocity.x, -player.last_direction * player.DASH_SPEED, player.ACCELERATION * 1.3)
	player.velocity.y = 0

func exit_state():
	cooldown_timer.start()
	dash_timer.stop()
	ghost_timer.stop()

func transition_to_idle():
	Transitioned.emit(self, "idle")

func instantiate_ghost():
	var is_forwads_dash = player.movement_input != 0
	var ghost = dash_ghost.instantiate() as Sprite2D
	ghost.texture = dash_texture_forward if is_forwads_dash else dash_texture_backward
	ghost.set_flip_h(player.last_direction < 0)
	ghost.global_position = player.global_position
	get_tree().root.add_child(ghost)
