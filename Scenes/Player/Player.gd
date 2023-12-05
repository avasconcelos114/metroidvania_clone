extends CharacterBody2D
class_name Player

@export var SPEED = 180.0
@export var DASH_SPEED = 1000
@export var JUMP_VELOCITY = -300.0
@export var DASH_DURATION = 0.2
const ACCELERATION = 20.0

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# Components
@onready var dash = $Skills/Dash
@onready var sprite = $AnimatedSprite2D

# Movement skills config
@export var can_dash = false
@export var can_wall_hug = false

# Movement related variables
var movement_input = 0
var last_direction = 0
var jump_input = false
var jump_input_actuation = false
var dash_input = false
var crouch_input = false
var is_double_jumping = false
var is_wall_hugging = false

# Attack related variables
var attack_input = false

# States
var current_state = null
var prev_state = null

func _physics_process(_delta):
	# Apply wall hug effect
	#if is_on_wall_only() and not is_on_floor() and velocity.y > 0:
	#	is_wall_hugging = true
	#else:
	#	is_wall_hugging = false

	# Handle jumping and double jumping
	#if Input.is_action_just_pressed("jump") and not is_double_jumping:
	#	velocity.y = JUMP_VELOCITY
	#	if not is_on_floor():
	#		is_double_jumping = true

	# Dash multipliers
	#var speed = SPEED
	#if dash.is_dashing():
	#	speed = DASH_SPEED
	#	velocity.y = 0

	# Define movement and direction
	#movement_input = Input.get_axis("left", "right")
	#var strength = Input.get_action_strength("left")

	# Listen for basic attack inputs
	#handle_basic_attack()

	# Handle direction character faces
	#handle_character_direction()

	#is_crouched = Input.is_action_pressed("down")

	#if can_dash:
	#	handle_dash()
	
	#if can_wall_hug:
	#	handle_wall_hug()

	# Handle animations to be player
	#if is_attacking:
	#	pass
	#elif is_crouched:
	#	$AnimatedSprite2D.play("crouch")
	#	movement_input = Vector2.ZERO
	#elif dash.is_dashing():
	#	if movement_input:
	#		$AnimatedSprite2D.play("dash_fowards")
	#	else:
	#		$AnimatedSprite2D.play("dash_backwards")
	#elif is_wall_hugging:
	#	$AnimatedSprite2D.play("dash_fowards")
	#elif movement_input and is_on_floor():
	#	$AnimatedSprite2D.play("default")
	#elif movement_input and is_on_floor():
	#	$AnimatedSprite2D.play("run")
	#elif not is_on_floor():
	#	$AnimatedSprite2D.play("jump")

	# Process movement
	#velocity.x = move_toward(velocity.x, movement_input * speed, ACCELERATION)
	player_input()
	handle_character_direction()
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func handle_character_direction():
	if last_direction < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$WallHugParticles.position.x = -12
		$HitboxComponent.position.x = -20
	else:
		$AnimatedSprite2D.set_flip_h(false)
		$WallHugParticles.position.x = 12
		$HitboxComponent.position.x = 20

func handle_wall_hug():
		# Handle wall hug mechanics
	if is_wall_hugging:
		velocity.y = gravity_value * Global.time * 2
		$WallHugParticles.emitting = true
	else:
		$WallHugParticles.emitting = false

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
	if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
		dash.start_dash(movement_input, movement_input == 1, DASH_DURATION)
