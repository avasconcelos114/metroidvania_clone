extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var attack_cooldown: Timer
@export var hitbox: HitboxComponent
@export var external_attack_animation: AnimatedSprite2D
@export var external_attack_trigger_frame := 1

var attack_in_progress = false
var player_direction = 0

func enter_state():
	sprite.play("default")
	await get_tree().create_timer(attack_cooldown.wait_time / 2).timeout
	begin_attack()

	if not enemy.health_component.DiedEvent.is_connected(transition_to_death):
		enemy.health_component.DiedEvent.connect(transition_to_death)

	if not attack_cooldown.timeout.is_connected(begin_attack):
		attack_cooldown.timeout.connect(begin_attack)

func transition_to_death():
	Transitioned.emit(self, "death")

func exit_state():
	if sprite.animation_finished.is_connected(complete_attack):
		sprite.animation_finished.disconnect(complete_attack)
	
	if sprite.frame_changed.is_connected(perform_attack):
		sprite.frame_changed.disconnect(perform_attack)

	if attack_cooldown.timeout.is_connected(begin_attack):
		attack_cooldown.timeout.disconnect(begin_attack)
	sprite.stop()
	attack_cooldown.stop()
	attack_in_progress = false

func physics_update(delta):
	enemy.velocity = Vector2.ZERO

	var distance = PlayerManager.player.global_position - enemy.global_position
	enemy.last_direction = distance.x

	if distance.length() > enemy.attack_range and not attack_in_progress:
		Transitioned.emit(self, "chase")

func begin_attack():
	attack_in_progress = true
	# Preventing enemy from attacking if it somehow died just as it entered
	# its attack state
	if enemy.health_component.has_died:
		return
	sprite.play("attack")
	if not sprite.frame_changed.is_connected(perform_attack):
		sprite.frame_changed.connect(perform_attack)
	if not sprite.animation_finished.is_connected(complete_attack):
		sprite.animation_finished.connect(complete_attack)

func perform_attack():
	if external_attack_animation != null and sprite.frame == external_attack_trigger_frame:
			print("setting fire animation to visible")
			external_attack_animation.visible = true
			external_attack_animation.play()
			print("Playing animation")
			if not external_attack_animation.animation_finished.is_connected(hide_external_animation):
				external_attack_animation.animation_finished.connect(hide_external_animation)

	if sprite.frame == enemy.attack_frame and not enemy.health_component.has_died:
		hitbox.attack()

func complete_attack():
	if not enemy.health_component.has_died:
		attack_in_progress = false
		# Begin another attack cycle if enemy is still alive
		sprite.play("default")
		attack_cooldown.start()

func hide_external_animation():
	if external_attack_animation:
		external_attack_animation.visible = false
