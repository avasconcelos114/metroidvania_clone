extends CharacterBody2D
class_name Player

@export var SPEED = 180.0
@export var DASH_SPEED = 1000
@export var JUMP_VELOCITY = -300.0
@export var DASH_DURATION = 0.2
const ACCELERATION = 20.0

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# Components
@onready var sprite = $AnimatedSprite2D

# Movement skills config
@export var dash_unlocked = false
@export var wall_slide_unlocked = false

# Input detection vars
var movement_input = 0
var last_direction = -1
var jump_input = false
var jump_input_actuation = false
var dash_input_actuation = false
var crouch_input = false

# Movement vars
var is_double_jumping = false
var is_wall_sliding = false
var can_dash = false

# Attack related variables
var attack_input = false

# States
var current_state = null
var prev_state = null

func _ready():
	if dash_unlocked:
		enable_dashing()
	$Timers/DashCooldownTimer.timeout.connect(enable_dashing)

func _physics_process(_delta):
	$WallHugParticles.emitting = is_wall_sliding
	player_input()
	handle_character_direction()
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func enable_dashing():
	can_dash = true

func disable_dashing():
	can_dash = false

func handle_character_direction():
	if last_direction < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$WallHugParticles.position.x = -12
		$HitboxComponent.position.x = -20
	else:
		$AnimatedSprite2D.set_flip_h(false)
		$WallHugParticles.position.x = 12
		$HitboxComponent.position.x = 20

func player_input():
	# Attacks
	attack_input = Input.is_action_just_pressed("attack")

	# Movement
	movement_input = Input.get_axis("left", "right")
	
	# Crouching
	crouch_input = Input.is_action_pressed("down")

	# jumps
	jump_input = Input.is_action_pressed("jump")
	jump_input_actuation =  Input.is_action_just_pressed("jump")

	#dash
	dash_input_actuation = Input.is_action_just_pressed("dash")
