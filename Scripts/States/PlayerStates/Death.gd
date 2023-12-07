extends PlayerState

func enter_state():
	Global.show_damage_flash(player.sprite)
	player.sprite.play("death")

func physics_update(_delta):
	player.velocity = Vector2.ZERO
