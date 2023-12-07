extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var attack_cooldown: Timer
@export var hitbox: HitboxComponent

func _ready():
	attack_cooldown.timeout.connect(attack)

func enter_state():
	sprite.play("default")
	attack_cooldown.start()
	if not enemy.health_component.DiedEvent.is_connected(transition_to_death):
		enemy.health_component.DiedEvent.connect(transition_to_death)

func transition_to_death():
	attack_cooldown.stop()
	sprite.stop()
	Transitioned.emit(self, "death")

func exit_state():
	attack_cooldown.stop()

func physics_update(delta):
	enemy.velocity = Vector2.ZERO

	var distance = Global.player.global_position - enemy.global_position
	if distance.length() > enemy.attack_range:
		Transitioned.emit(self, "chase")

func attack():
	sprite.play("attack")
	await sprite.animation_finished
	hitbox.attack()
	sprite.play("default")
