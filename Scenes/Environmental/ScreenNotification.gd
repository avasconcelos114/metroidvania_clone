extends CanvasLayer
class_name ScreenNotification

signal ShowTextSignal

@onready var label = $MarginContainer/VBoxContainer/PanelContainer/Label

func _ready():
	ShowTextSignal.connect(show_text)

func show_text(text, duration):
	label.set_text(text.replace("\\n", "\n"))
	label.label_settings.font_color = Color(1,1,1,1)
	visible = true
	await get_tree().create_timer(duration).timeout
	visible = false

