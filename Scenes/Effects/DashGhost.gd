extends Sprite2D

func _ready():
	# Animate fading
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_callback(queue_free)
