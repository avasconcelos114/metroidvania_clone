extends Node2D

var screens = {
	'title': preload("res://GUI/TitleScreen.tscn"),
	'gameover': preload("res://GUI/GameOverScreen.tscn"),
	'ingame_overlay': preload("res://GUI/IngameOverlay.tscn"),
}

var current_screen

func _ready():
	render_ui('title')
	#Global.LevelChangedSignal.connect(change_level)
	Global.StartGameSignal.connect(start_game)
	LevelManager.LevelLoadedSignal.connect(initialize_ui)

func start_game():
	LevelManager.set_current_level('dungeon')

func initialize_ui():
	render_ui('ingame_overlay')
	if not PlayerManager.PlayerDied.is_connected(display_game_over_screen):
		PlayerManager.PlayerDied.connect(display_game_over_screen)

func display_game_over_screen():
	render_ui('gameover')

## UI Rendering
func render_ui(screen_name: String):
	if not screen_name in screens:
		return

	if current_screen:
		current_screen.queue_free()

	current_screen = screens[screen_name].instantiate()
	$GUI.add_child(current_screen)
