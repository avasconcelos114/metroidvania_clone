extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D
@export var attack_cooldown: Timer
@export var hitbox: HitboxComponent

func _ready():
	attack_cooldown.timeout.connect(attack)

func enter_state():
	attack()
	attack_cooldown.start()

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
