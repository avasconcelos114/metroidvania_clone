extends AnimatedSprite2D

var is_forwards = true
var should_flip_sprite = false

func _ready():
	if is_forwards:
		play("dash_fowards")
	else:
		play("dash_backwards")

	set_flip_h(should_flip_sprite)

	# Animate fading
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)
