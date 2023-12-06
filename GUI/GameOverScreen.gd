extends Control

signal ReloadLevelPressed

func _on_texture_button_pressed():
	ReloadLevelPressed.emit()
