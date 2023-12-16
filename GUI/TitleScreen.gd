extends Control
class_name TitleScreen

func _on_start_button_pressed():
	Global.StartGameSignal.emit()

func _on_quit_button_pressed():
	get_tree().quit()
