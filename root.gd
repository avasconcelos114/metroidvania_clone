extends Node2D

func _ready():
	ScreenManager.render_ui('title')
	
	if not Global.StartGameSignal.is_connected(start_game):
		Global.StartGameSignal.connect(start_game)
	
	if not Global.ReloadLevelSignal.is_connected(reload_level):
		Global.ReloadLevelSignal.connect(reload_level)
	
	if not LevelManager.LevelLoadedSignal.is_connected(initialize_ui):
		LevelManager.LevelLoadedSignal.connect(initialize_ui)

func start_game():
	LevelManager.set_current_level('tutorial')

func reload_level():
	LevelManager.set_current_level(LevelManager.current_level)

func initialize_ui():
	ScreenManager.render_ui('ingame_overlay')
	if not PlayerManager.PlayerDied.is_connected(display_game_over_screen):
		PlayerManager.PlayerDied.connect(display_game_over_screen)

func display_game_over_screen():
	ScreenManager.render_ui('gameover')
