extends CharacterBody2D
class_name Player

@export var SPEED = 180.0
@export var DASH_SPEED = 1000
@export var JUMP_VELOCITY = -300.0
@export var DASH_DURATION = 0.2
@export var ACCELERATION = 50.0
@export var DASH_ACCELERATION = 20.0
@export var HIT_KNOCKBACK = 40
@export var hurt_sounds: Array[AudioStream]

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

# Components
@onready var sprite = $AnimatedSprite2D
@onready var health_component = $HealthComponent

# Movement skills config
var dash_unlocked = false
var wall_slide_unlocked = false
var double_jump_unlocked = false

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

func _ready():
	apply_powerups()
	PlayerManager.PowerupCollected.connect(apply_powerups)
	
	$Timers/DashCooldownTimer.timeout.connect(enable_dashing)
	$HurtboxComponent.ReceivedHit.connect(receive_hit_effect)
	$HealthComponent.DiedEvent.connect(handle_player_death)
	
	# Setting first state after other components initialized
	$StateMachine.set_initial_state($StateMachine/Idle)

func receive_hit_effect(direction, _damage):
	if $HealthComponent.has_health_remaining():
		play_hurt_audio()
		$BloodSplatter.emitting = true
		$BloodSplatter.process_material.set("direction", direction)
		velocity.x = HIT_KNOCKBACK if direction.x > 0 else -HIT_KNOCKBACK
		Global.show_damage_flash($AnimatedSprite2D)
		await get_tree().create_timer(0.2).timeout
		$BloodSplatter.emitting = false

func handle_player_death():
	$DeathSound.play()
	$BloodSplatter.emitting = true
	$BloodSplatter.position.y = 20
	$BloodSplatter.process_material.set("direction", Vector2(1, -40))
	Global.show_damage_flash($AnimatedSprite2D)
	$AnimatedSprite2D.play("death")
	PlayerManager.PlayerDied.emit()

func _physics_process(_delta):
	if not $HealthComponent.has_died:
		player_input()
		$WallSlideParticles.emitting = is_wall_sliding
		handle_character_direction()
	else:
		velocity.x = 0
	move_and_slide()

func gravity(delta):
	if not is_on_floor():
		velocity.y += gravity_value * delta

func enable_dashing():
	can_dash = true

func disable_dashing():
	can_dash = false

func apply_powerups():
	for powerup in PlayerManager.collected_powerups:
		if powerup.powerup_id == 'dash':
			dash_unlocked = true
			enable_dashing()

		if powerup.powerup_id == 'doublejump':
			double_jump_unlocked = true
		
		if powerup.powerup_id == 'wallslide':
			wall_slide_unlocked = true

func handle_character_direction():
	if last_direction < 0:
		$AnimatedSprite2D.set_flip_h(true)
		$WallSlideParticles.position.x = -12
		$HitboxComponent.position.x = -29
	else:
		$AnimatedSprite2D.set_flip_h(false)
		$WallSlideParticles.position.x = 12
		$HitboxComponent.position.x = 29

func play_hurt_audio():
	if hurt_sounds.size() > 0:
		var stream = hurt_sounds[randi_range(0, hurt_sounds.size() - 1)];
		var audio = AudioStreamPlayer.new()
		audio.stream = stream
		audio.finished.connect(audio.queue_free)
		add_child(audio)
		audio.play()

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
