extends Control

signal ReloadLevelPressed

func _on_button_on_pressed():
	ReloadLevelPressed.emit()
