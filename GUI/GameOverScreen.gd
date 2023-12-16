extends Control
class_name GameOverScreen

func _on_button_pressed():
	Global.StartGameSignal.emit()
