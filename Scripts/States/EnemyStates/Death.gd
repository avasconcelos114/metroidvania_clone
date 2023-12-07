extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D

var animation_finished = false

func enter_state():
	Global.show_damage_flash(sprite)
	sprite.play("death")
	sprite.animation_finished.connect(set_finished)

func physics_update(delta):
	enemy.velocity = Vector2.ZERO
	if not animation_finished:
		sprite.play("death")

func set_finished():
	animation_finished = true
