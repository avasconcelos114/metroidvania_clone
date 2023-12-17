extends Control

func _ready():
	$ReturnToTitleTimer.timeout.connect(return_to_title)

func return_to_title():
	PlayerManager.reset_player()
	LevelManager.offload_level()
	ScreenManager.render_ui('title')
