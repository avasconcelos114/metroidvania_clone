extends Control

signal StartButtonPressed
signal QuitButtonPressed

func _on_start_button_on_pressed():
	StartButtonPressed.emit()

func _on_quit_button_on_pressed():
	QuitButtonPressed.emit()
