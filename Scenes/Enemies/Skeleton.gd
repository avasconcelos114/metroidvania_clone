extends BaseEnemy

func _ready():
	$HealthComponent.DiedEvent.connect(handle_death)
	$HurtboxComponent.ReceivedHit.connect(receive_hit)

func handle_death():
	$AutoattackHitbox.should_autoattack = false
	Global.show_damage_flash($AnimatedSprite2D)
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	await get_tree().create_timer(2).timeout
	queue_free()

func receive_hit(_direction):
	Global.show_damage_flash($AnimatedSprite2D)
