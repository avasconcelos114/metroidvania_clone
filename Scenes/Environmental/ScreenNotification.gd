extends CanvasLayer
class_name ScreenNotification

signal ShowTextSignal

@export var label: Label

func _ready():
	ShowTextSignal.connect(show_text)
	$DurationTimer.timeout.connect(hide_text)

func show_text(text, duration):
	if not $DurationTimer.is_stopped():
		$DurationTimer.stop()
	label.set_text(text.replace("\\n", "\n"))
	label.label_settings.font_color = Color(1,1,1,1)
	$DurationTimer.wait_time = duration
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property($MarginContainer, "modulate:a", 1, 1.5)
	tween.tween_callback($DurationTimer.start)

func hide_text():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property($MarginContainer, "modulate:a", 0, 1.5)
