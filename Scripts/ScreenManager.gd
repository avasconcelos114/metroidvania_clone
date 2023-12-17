extends Node

var screens = {
	'title': preload("res://GUI/TitleScreen.tscn"),
	'gameover': preload("res://GUI/GameOverScreen.tscn"),
	'ingame_overlay': preload("res://GUI/IngameOverlay.tscn"),
	'vanquished': preload("res://GUI/EvilVanquishedScreen.tscn"),
}

var current_screen

func _ready():
	render_ui('title')

func render_ui(screen_name: String):
	if not screen_name in screens:
		return

	if current_screen:
		current_screen.queue_free()

	current_screen = screens[screen_name].instantiate()
	var canvas = get_tree().get_first_node_in_group("CanvasLayer")
	if canvas:
		canvas.add_child(current_screen)
