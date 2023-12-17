extends BaseEnemy

@onready var hurtbox_component = $HurtboxComponent
@onready var autoattack_hitbox = $AutoattackHitbox
@onready var hitbox_component = $HitboxComponent
@onready var collision_box = $CollisionShape2D
@onready var sprite = $AnimatedSprite2D
@onready var attack_sprite = $FireBreathAnimation
@onready var hit_sound = $HitSound

@export var health_bar: ProgressBar

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
	fade_sprite()
	await get_tree().create_timer(5).timeout
	ScreenManager.render_ui('vanquished')
	queue_free()

func fade_sprite():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(set_shader_value, 0.0, 1.0, 5)

func set_shader_value(value: float):
	sprite.material.set_shader_parameter("progress", value)

func receive_hit(direction):
	hit_sound.play()
	$BloodSplatter.emitting = true
	$BloodSplatter.process_material.set("direction", direction)
	await get_tree().create_timer(0.2).timeout
	$BloodSplatter.emitting = false
	
	health_bar.value = health_component.current_health_percent()

func handle_character_direction():
	if last_direction < 0:
		hitbox_component.position.x = -70
		attack_sprite.position.x = -80
		sprite.set_flip_h(false)
		attack_sprite.set_flip_h(false)
	else:
		hitbox_component.position.x = 70
		attack_sprite.position.x = 80
		sprite.set_flip_h(true)
		attack_sprite.set_flip_h(true)
