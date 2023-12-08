extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var attack_cooldown: Timer
@export var hitbox: HitboxComponent

var attack_in_progress = false

func enter_state():
	await get_tree().create_timer(0.2).timeout
	begin_attack()

	if not enemy.health_component.DiedEvent.is_connected(transition_to_death):
		enemy.health_component.DiedEvent.connect(transition_to_death)

	if not attack_cooldown.timeout.is_connected(begin_attack):
		attack_cooldown.timeout.connect(begin_attack)

func transition_to_death():
	Transitioned.emit(self, "death")

func exit_state():
	if sprite.animation_finished.is_connected(perform_attack):
		sprite.animation_finished.disconnect(perform_attack)

	if attack_cooldown.timeout.is_connected(begin_attack):
		attack_cooldown.timeout.disconnect(begin_attack)
	sprite.stop()
	attack_cooldown.stop()
	attack_in_progress = false

func physics_update(delta):
	enemy.velocity = Vector2.ZERO

	var distance = Global.player.global_position - enemy.global_position
	if distance.length() > enemy.attack_range and not attack_in_progress:
		Transitioned.emit(self, "chase")

func begin_attack():
	attack_in_progress = true
	# Preventing enemy from attacking if it somehow died just as it entered
	# its attack state
	if enemy.health_component.has_died:
		return
	sprite.play("attack")
	if not sprite.animation_finished.is_connected(perform_attack):
		sprite.animation_finished.connect(perform_attack)

func perform_attack():
	hitbox.attack()
	if not enemy.health_component.has_died:
		attack_in_progress = false
		# Begin another attack cycle if enemy is still alive
		sprite.play("default")
		attack_cooldown.start()
