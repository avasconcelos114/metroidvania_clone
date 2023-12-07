extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D

func enter_state():
	Global.show_damage_flash(sprite)
	sprite.play("death")

func physics_update(delta):
	enemy.velocity = Vector2.ZERO
