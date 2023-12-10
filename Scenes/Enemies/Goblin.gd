extends BaseEnemy

@onready var hurtbox_component = $HurtboxComponent
@onready var autoattack_hitbox = $AutoattackHitbox
@onready var hitbox_component = $HitboxComponent
@onready var sprite = $AnimatedSprite2D
@onready var hit_sound = $HitSound

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

func receive_hit(direction):
	hit_sound.play()
	$BloodSplatter.emitting = true
	$BloodSplatter.process_material.set("direction", direction)
	Global.show_damage_flash(sprite)
	await get_tree().create_timer(0.2).timeout
	$BloodSplatter.emitting = false

func handle_character_direction():
	if last_direction < 0:
		hitbox_component.position.x = -25
		sprite.set_flip_h(true)
	else:
		hitbox_component.position.x = 25
		sprite.set_flip_h(false)
