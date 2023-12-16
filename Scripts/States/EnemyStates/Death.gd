extends BaseState

@export var enemy: BaseEnemy
@export var sprite: AnimatedSprite2D

var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_finished = false

func enter_state():
	Global.show_damage_flash(sprite)
	sprite.play("death")
	sprite.animation_finished.connect(set_finished)

func physics_update(delta):
	enemy.velocity.x = 0
	enemy.velocity.y += gravity_value * delta
	enemy.move_and_slide()

func set_finished():
	animation_finished = true
