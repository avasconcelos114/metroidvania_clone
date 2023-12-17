extends Control
class_name TitleScreen

@onready var start_button = $ColorRect/CenterContainer/VBoxContainer/ButtonWrapper/StartButton 

func _ready():
	start_button.grab_focus()

func _on_start_button_pressed():
	var material = start_button.material as ShaderMaterial
	material.set_shader_parameter("active", true)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_method(set_shader_value, 0.0, 1.0, 0.18)
	$Sounds/StartGame.play()
	$Sounds/StartGame.finished.connect(start_game)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_start_button_focus_entered():
	$Sounds/ButtonFocus.play()

func _on_quit_button_focus_entered():
	$Sounds/ButtonFocus.play()

func start_game():
	$Sounds/BackgroundMusic.stop()
	var material = start_button.material as ShaderMaterial
	material.set_shader_parameter("active", false)
	material.set_shader_parameter("range_end", 0.0)
	Global.StartGameSignal.emit()
	$Sounds/StartGame.finished.disconnect(start_game)

func set_shader_value(value: float):
	var material = start_button.material as ShaderMaterial
	material.set_shader_parameter("range_end", value)
