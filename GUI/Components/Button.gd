extends CenterContainer

signal OnPressed

@export var text := 'Text'

func _ready():
	$MarginContainer/Label.text = text

func _on_button_element_pressed():
	OnPressed.emit()
