extends Label

@export var y_offset := 25
@export var animation_duration := 0.8

func animate_label(damage: float):
	if damage:
		text = str(damage)
	else:
		text = 'Miss'

	var tween = get_tree().create_tween()
	tween.parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	var new_position = position
	new_position.y -= y_offset
	tween.tween_property(self, "position", new_position, animation_duration)
	tween.tween_property(self, "modulate", Color(1, 1, 0, 0), animation_duration)
	tween.tween_callback(self.queue_free)
