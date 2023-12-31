extends BaseEnemy

@onready var hurtbox_component = $HurtboxComponent
@onready var autoattack_hitbox = $AutoattackHitbox
@onready var hitbox_component = $HitboxComponent
@onready var sprite = $AnimatedSprite2D
@onready var hit_sound = $HitSound
@onready var state_machine = $StateMachine

func _ready():
	health_component.DiedEvent.connect(handle_death)
	hurtbox_component.ReceivedHit.connect(receive_hit)

func _physics_process(delta):
	super.gravity(delta)
	if health_component.has_died:
		return
	handle_character_direction()
	move_and_slide()

func handle_death():
	autoattack_hitbox.should_autoattack = false
	await get_tree().create_timer(5).timeout
	queue_free()

func receive_hit(direction, damage):
	# Stun and knockback enemy
	if not health_component.has_died:
		var state = state_machine.get_current_state()
		state.Transitioned.emit(state, 'stunned')
		velocity.x = move_toward(velocity.x, direction.x * hit_knockback, knockback_acceleration)
	
	# Show audiovisual feedback
	hit_sound.play()
	Global.show_damage_flash(sprite)
	super.receive_hit(direction, damage)
	$BloodSplatter.emitting = true
	$BloodSplatter.process_material.set("direction", direction)
	
	# Cleanup feedback
	await get_tree().create_timer(0.2).timeout
	$BloodSplatter.emitting = false

func handle_character_direction():
	if last_direction < 0:
		hitbox_component.position.x = -25
		sprite.set_flip_h(true)
	else:
		hitbox_component.position.x = 25
		sprite.set_flip_h(false)
