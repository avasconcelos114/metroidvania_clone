extends Area2D

@export var notification_text := ''
@export var duration := 3
@onready var label = $CanvasLayer/CenterContainer/Label

func _on_body_entered(body):
	if body is Player:
		label.set_text(notification_text.replace("\\n", "\n"))
		label.label_settings.font_color = Color(1,1,1,1)
		label.visible = true
		var tween = create_tween()
		tween.tween_property(label, "label_settings:font_color", Color(1, 1, 1, 0), duration)
		tween.tween_callback(self.queue_free)
