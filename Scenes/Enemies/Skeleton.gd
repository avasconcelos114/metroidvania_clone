extends BaseEnemy

func _ready():
	health_component.DiedEvent.connect(handle_death)
	$HurtboxComponent.ReceivedHit.connect(receive_hit)

func _physics_process(delta):
	super.gravity(delta)
	if health_component.has_died:
		return
	move_and_slide()

func handle_death():
	$AutoattackHitbox.should_autoattack = false
	await get_tree().create_timer(5).timeout
	queue_free()

func receive_hit(_direction):
	Global.show_damage_flash($AnimatedSprite2D)
